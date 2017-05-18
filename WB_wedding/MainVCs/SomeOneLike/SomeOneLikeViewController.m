//
//  SomeOneLikeViewController.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "SomeOneLikeViewController.h"
#import "UserInfoVC.h"

#import "BlockAlertView.h"
#import "SomeOneLikeCell.h"

@interface SomeOneLikeViewController (){
    NSUInteger currentPage;
    NSUInteger m_total;
}

@property (nonatomic, assign) NSUInteger indextag;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSString *dateKey;

@end

@implementation SomeOneLikeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self becomeListed];
}

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
}

- (void)setupNav {
    [self createNavWithTitle:@"有人喜欢你" createMenuItem:^UIView *(int nIndex){
        
        return nil;
    }];
    
}

- (void)becomeListed{
    NSDate *lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (!self.dataSource.count || !lastRefreshTime || [lastRefreshTime timeIntervalSinceNow] < -appRefreshTime) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)becomeUnListed{
    
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
    [[QKNetworkSingleton sharedManager] Get:@{@"myId":[AppPublic getInstance].userData.ID, @"page":@(page), @"size":@20} HeadParm:nil URLFooter:@"/likeu/find" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                if (page == 1) {
                    [weakself.dataSource removeAllObjects];
                }
                currentPage = page;
                
                NSDictionary *data = responseBody[@"data"];
                if (data.count) {
                    [weakself.dataSource addObjectsFromArray:[AppUserData mj_objectArrayWithKeyValuesArray:data[@"content"]]];
                    
                    m_total = [data[@"totalElements"] integerValue];
                    if (weakself.dataSource.count >= m_total) {
                        [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                
                [weakself.tableView reloadData];
            }
            else {
                [weakself showHint:responseBody[@"Msg"]];
            }
        }
        else{
            [weakself showHint:@"网络出错"];
        }
        
    }];
}

- (void)endRefreshing{
    //记录刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)removeSomeoneAtIndex:(NSUInteger)index{
    if (index < self.dataSource.count) {
        AppUserData *userData = self.dataSource[index];
        
        [self showHudInView:self.view hint:nil];
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] Get:@{@"id":userData.ID} HeadParm:nil URLFooter:@"/likeu/delete" completion:^(id responseBody, NSError *error){
            [weakself hideHud];
            
            if (!error) {
                if (isHttpSuccess([responseBody[@"success"] intValue])) {
                    [self.dataSource removeObjectAtIndex:index];
                    [weakself.tableView reloadData];
                }
                else {
                    [weakself showHint:responseBody[@"Msg"]];
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

- (NSString *)dateKey{
    if (!_dateKey) {
        _dateKey = [NSString stringWithFormat:@"Message_dateKey_%d",(int)self.indextag];
    }
    
    return _dateKey;
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
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SomeOneLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:SomeOneLikeCellID];
    if (!cell) {
        cell = [SomeOneLikeCell appLoadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AppUserData *userData = self.dataSource[indexPath.row];
    
    if (userData.imgArray.count) {
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStringWithImagePath(userData.imgArray[0])] placeholderImage:[UIImage imageNamed:downloadImagePlace]];
    }
    else {
        cell.headImageView.image = [UIImage imageNamed:downloadImagePlace];
    }
    
    cell.nameLabel.text = userData.nickname;
    cell.addressLabel.text = userData.city;
    cell.sexAndAgeLabel.text = [NSString stringWithFormat:@"%@ %d", [userData showStringOfSex], userData.age];
    cell.matchLabel.text = [NSString stringWithFormat:@"匹配度%@%%", userData.matchDegree];
    cell.constellationLabel.text = userData.xingZuo;
    
    cell.statusLabel.text = [userData.status boolValue] ? @"名花有主" : @"可发展";
    cell.redPiont.hidden = [userData.isRecieverRead boolValue];
    
    [cell adjustSubviews];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppUserData *userData = self.dataSource[indexPath.row];
    if ([userData.status boolValue]) {
        [self showHint:@"ta已经有主了"];
    }
    else {
        UserInfoVC *vc = [UserInfoVC new];
        vc.infoType = UserInfoTypeLike;
        vc.userData = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        QKWEAKSELF;
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定删除？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakself removeSomeoneAtIndex:indexPath.row];
            }
        }otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

@end
