//
//  WalletDetailVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/29.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WalletDetailVC.h"

#import "TwiceDetailCell.h"

@interface WalletDetailVC (){
    NSUInteger currentPage;
    NSUInteger m_total;
}

@property (nonatomic, assign) NSUInteger indextag;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation WalletDetailVC

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
    [self createNavWithTitle:@"明细" createMenuItem:^UIView *(int nIndex){
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
    [self loadFirstPageData];
}

- (void)loadFirstPageData{
    [self loadInfoData:1];
}

- (void)loadMoreData{
    [self loadInfoData:++currentPage];
}

- (void)loadInfoData:(NSUInteger)page{
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:@{@"userId":[AppPublic getInstance].userData.ID, @"page":@(page), @"size":@20} HeadParm:nil URLFooter:@"/consume/finddetails" completion:^(id responseBody, NSError *error){
        [weakself endRefreshing];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                if (page == 1) {
                    [weakself.dataSource removeAllObjects];
                }
                currentPage = page;
                
                NSDictionary *data = responseBody[@"data"];
                if (data.count) {
                    [weakself.dataSource addObjectsFromArray:[UserWalletDetailData mj_objectArrayWithKeyValuesArray:data[@"content"]]];
                    
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

#pragma getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
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
    return [TwiceDetailCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"wallet_detail_cell";
    TwiceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[TwiceDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    UserWalletDetailData *data = self.dataSource[indexPath.row];
    
    cell.titleLabel.text = data.consumeContent;
    cell.tagLabel.text = stringFromDate([NSDate dateWithTimeIntervalSince1970:0.001 * [data.time doubleValue]], @"yyyy/MM/dd HH:mm:ss");
    cell.subTitleLabel.text = [NSString stringWithFormat:@"余额：%@", data.balance];
    cell.subTagLabel.text = data.consumeAmount;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
