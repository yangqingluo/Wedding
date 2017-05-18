//
//  UserMessageVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserMessageVC.h"
#import "WEMessageReslutController.h"

#import "ImageViewCell.h"
#import "BlockAlertView.h"

@interface UserMessageVC ()<SWTableViewCellDelegate>{
    NSUInteger currentPage;
    NSUInteger m_total;
}

@property (nonatomic, assign) NSUInteger indextag;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation UserMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    //设置下拉刷新回调
    QKWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstPageData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNav {
    [self createNavWithTitle:@"我的消息" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self loadFirstPageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //update UI
        });
    });
}

- (void)loadFirstPageData{
    [self loadInfoData:1];
}


- (void)loadMoreData{
    [self loadInfoData:++currentPage];
}

- (void)loadInfoData:(NSUInteger)page{
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:@{@"myId":[AppPublic getInstance].userData.ID, @"page":@(page), @"size":@20} HeadParm:nil URLFooter:@"/mymessage/find" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                if (page == 1) {
                    [weakself.dataSource removeAllObjects];
                }
                currentPage = page;
                
                NSDictionary *data = responseBody[@"data"];
                if (data.count) {
                    [weakself.dataSource addObjectsFromArray:[UserMessageData mj_objectArrayWithKeyValuesArray:data[@"content"]]];
                    
                    m_total = [data[@"totalElements"] integerValue];
                    if (weakself.dataSource.count >= m_total) {
                        [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                
                [weakself.tableView reloadData];
            }
            else {
                [weakself showHint:responseBody[@"msg"]];
            }
        }
        else{
            [weakself showHint:@"网络出错"];
        }
        
    }];
}

- (void)endRefreshing{
    //记录刷新时间
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)removeMessageAtIndex:(NSUInteger)index{
    if (index < self.dataSource.count) {
        UserJudgementDate *userData = self.dataSource[index];
        
        [self showHudInView:self.view hint:nil];
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] Get:@{@"myId":[AppPublic getInstance].userData.ID, @"id":userData.ID} HeadParm:nil URLFooter:@"/mymessage/delete" completion:^(id responseBody, NSError *error){
            [weakself hideHud];
            
            if (!error) {
                if (isHttpSuccess([responseBody[@"success"] intValue])) {
                    [self.dataSource removeObjectAtIndex:index];
                    [weakself.tableView reloadData];
                }
                else {
                    [weakself showHint:responseBody[@"msg"]];
                }
            }
            else{
                [weakself showHint:@"网络出错"];
            }
            
        }];
    }
}

#pragma getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}

- (NSArray *)rightButtons{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    
    return [NSArray arrayWithArray:rightUtilityButtons];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeMiddle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"message_cell";
    ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        
        cell.showImageView.frame = CGRectMake(kEdgeMiddle, 10, 60.0, 60.0);
        [AppPublic roundCornerRadius:cell.showImageView];
        
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.titleLabel.frame = CGRectMake(0, cell.showImageView.bottom, cell.showImageView.width + 2 * kEdgeMiddle, 20);
        
        cell.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - kEdgeMiddle - 120, kEdgeSmall, 120, 15)];
        cell.timeLabel.font = [UIFont systemFontOfSize:12.0];
        cell.timeLabel.textColor = [UIColor grayColor];
        cell.timeLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:cell.timeLabel];
        
        cell.subTitleLabel.frame = CGRectMake(cell.titleLabel.right + kEdge, 0, screen_width -  kEdgeMiddle - (cell.titleLabel.right + kEdge), 100);
        cell.subTitleLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
    }
    
    UserMessageData *data = self.dataSource[indexPath.row];
    
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStringWithImagePath([NSString stringWithFormat:@"%@/%@", data.otherId, data.imgName])] placeholderImage:[UIImage imageNamed:downloadImagePlace]];
    cell.titleLabel.text = data.otherNickName;
    cell.subTitleLabel.text = data.content;
    cell.timeLabel.text = stringFromDate([NSDate dateWithTimeIntervalSince1970:0.001 * [data.msgTime doubleValue]], @"yyyy/MM/dd HH:mm:ss");
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WEMessageReslutController *vc = [[WEMessageReslutController alloc]init];
    
    UserMessageData *data = self.dataSource[indexPath.row];
    vc.dic = [data mj_keyValues];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    [cell hideUtilityButtonsAnimated:YES];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:{
            //删除
            QKWEAKSELF;
            BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定删除？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [weakself removeMessageAtIndex:indexPath.row];
                }
            }otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state{
    return state == 2;
}

@end
