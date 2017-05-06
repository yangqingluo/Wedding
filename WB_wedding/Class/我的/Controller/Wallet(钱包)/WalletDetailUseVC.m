//
//  WalletDetailUseVC.m
//  WB_wedding
//
//  Created by 刘人华 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WalletDetailUseVC.h"
#import "WalletDetailInfoTVCell.h"
#import "WalletDetailUseModel.h"

@interface WalletDetailUseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation WalletDetailUseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"明细";
    [self.view addSubview:self.mTableView];
    self.dataSource = [NSMutableArray array];
    [BANetManager ba_requestWithType:BAHttpRequestTypeGet
                           urlString:BASEURL(@"/consume/finddetails")
                          parameters:@{@"userId":[XWUserModel getUserInfoFromlocal].xw_id,
                                       @"page":@1,
                                       @"size":@10}
                        successBlock:^(id response) {
                            if ([response[@"success"] boolValue]) {
                                self.dataSource = [WalletDetailUseModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"content"]];
                                [self.mTableView reloadData];
                                if (self.dataSource.count < 10) {
                                    [self.mTableView.footer endRefreshingWithNoMoreData];
                                }
                            }
                        }
                        failureBlock:^(NSError *error) {
                            
                        }
                            progress:nil];
}

- (void)loadMoreData
{
    NSInteger count = self.dataSource.count / 10 + 1;
    [self.mTableView.mj_footer endRefreshing];
    [BANetManager ba_requestWithType:BAHttpRequestTypeGet
                           urlString:BASEURL(@"/consume/finddetails")
                          parameters:@{@"userId":[XWUserModel getUserInfoFromlocal].xw_id,
                                       @"page":@(count),
                                       @"size":@10}
                        successBlock:^(id response) {
                            NSMutableArray *ar = [WalletDetailUseModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"content"]];
                            
                                if ([response[@"success"] boolValue]) {
                                    
                                [self.dataSource addObjectsFromArray:ar];
                                [self.mTableView reloadData];
                                    
                                    if (ar.count < 10) {
                                        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
                                    }

                                } else{
                                    SVPERROR(response[@"msg"]);
                                }
                            
                            
                        }
                        failureBlock:^(NSError *error) {
                            
                        }
                            progress:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    WalletDetailInfoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:WalletDetailInfoTVCellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (UITableView *)mTableView {
    
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64) style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.rowHeight = 70;
        _mTableView.dataSource = self;
        [_mTableView registerNib:[UINib nibWithNibName:@"WalletDetailInfoTVCell" bundle:nil]
          forCellReuseIdentifier:WalletDetailInfoTVCellID];
        _mTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _mTableView;
}
@end
