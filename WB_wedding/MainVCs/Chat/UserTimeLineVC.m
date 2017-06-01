//
//  UserTimeLineVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/6/1.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserTimeLineVC.h"
#import "WEPostTimeLineController.h"
#import "WETimeLineDetailController.h"

#import "TimeLineCell.h"
#import "UDImageLabelButton.h"
#import "UIImage+Color.h"

@interface UserTimeLineVC (){
    NSUInteger currentPage;
    NSUInteger m_total;
}

@property (strong, nonatomic) UDImageLabelButton *headView;

@property (strong, nonatomic) UserTimeLineData *data;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation UserTimeLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.headView];
    [self setupNav];
    
    [self pullTimeEvent];
}

- (void)setupNav {
    [self createNavWithTitle:nil createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(navigationBarColor);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *i = [UIImage imageNamed:@"bottom_location"];
            [btn setImage:[i imageWithColor:navigationBarColor] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(screen_width - 64, 0, 64, 44)];
            [btn addTarget:self action:@selector(locateButtonAction) forControlEvents:UIControlEventTouchUpInside];
            
            return btn;
        }
        
        return nil;
    }];
    
    self.navigationBarView.backgroundColor = [UIColor clearColor];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locateButtonAction{
    
}

- (void)recordButtonAction{
    WEPostTimeLineController  *vc = [[WEPostTimeLineController alloc]init];
    vc.infoDic = [self.data mj_keyValues];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pullTimeEvent{
    NSDictionary *m_dic = @{@"myId" : [AppPublic getInstance].userData.ID,
                            @"hisOrHerId" : [AppPublic getInstance].userData.loverId
                            };
    
    [self showHudInView:self.view hint:nil];
    
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:m_dic HeadParm:nil URLFooter:@"/timeevent/find" completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                weakself.data = [UserTimeLineData mj_objectWithKeyValues:responseBody[@"data"]];
                [weakself refreshSubviews];
                [weakself refreshData];
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


- (void)refreshSubviews{
    self.tableView.frame = CGRectMake(0, self.headView.bottom, screen_width, screen_height - self.headView.bottom);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置下拉刷新回调
    QKWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstPageData];
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = KNaviBarTintColor;
    [btn setTitle:@"记录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(recordButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(KScreenWidth - 45, self.headView.bottom - 20, 40, 40);
    [AppPublic roundCornerRadius:btn];
    [self.view addSubview:btn];
    
    [self.headView.upImageView sd_setImageWithURL:imageURLWithPath([NSString stringWithFormat:@"tebg/%@", self.data.backgroundUrl]) placeholderImage:[UIImage imageNamed:downloadImagePlace]];
}

- (void)updateTableViewFooter{
    QKWEAKSELF;
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself loadMoreData];
        }];
    }
}

- (void)refreshData{
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadFirstPageData{
    [self loadInfoData:1];
}


- (void)loadMoreData{
    [self loadInfoData:++currentPage];
}

- (void)loadInfoData:(NSUInteger)page{
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:@{@"timeEventId" : self.data.ID, @"page" : @(page), @"size" : @20} HeadParm:nil URLFooter:@"/timeevent/findevent" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                if (page == 1) {
                    [weakself.dataSource removeAllObjects];
                }
                currentPage = page;
                
                NSDictionary *data = responseBody[@"data"];
                if (data.count) {
                    [weakself.dataSource addObjectsFromArray:[UserTimeLineEventData mj_objectArrayWithKeyValuesArray:data[@"content"]]];
                    
                    m_total = [data[@"totalElements"] integerValue];
                    if (weakself.dataSource.count >= m_total) {
                        [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    else {
                        [weakself updateTableViewFooter];
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

#pragma getter
- (UDImageLabelButton *)headView{
    if (!_headView) {
        _headView = [[UDImageLabelButton alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_width * 210.0 / 375.0)];
        _headView.upImageView.image = [UIImage imageNamed:downloadImagePlace];
        _headView.upImageView.frame = _headView.bounds;
    }
    
    return _headView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}

#pragma tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TimeLineCell tableView:tableView heightForRowAtIndexPath:indexPath withData:self.dataSource[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"timelineCell";
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[TimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.data = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WETimeLineDetailController *vc = [[WETimeLineDetailController alloc]init];
    
    NSDictionary *dic =  [self.dataSource[indexPath.row] mj_keyValues];
    vc.dic = dic;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
