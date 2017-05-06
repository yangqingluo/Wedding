//
//  MyEvaluateVC.m
//  WB_wedding
//
//  Created by 刘人华 on 17/1/19.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "MyEvaluateVC.h"
#import "MyEvaluateCell.h"
#import "WEMyEvaluateModel.h"

@interface MyEvaluateVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIAlertView *deleteAlert;
@property (nonatomic, strong) UIAlertView *complainAlert;
@property (nonatomic, strong) WEMyEvaluateModel *evalueateModel;

@end

@implementation MyEvaluateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的评价";
    [self.view addSubview:self.mTableView];
    self.dataSource = [NSMutableArray array];
    
    [BANetManager ba_requestWithType:BAHttpRequestTypeGet
                           urlString:BASEURL(@"/comment/find")
                          parameters:@{@"myId":[XWUserModel getUserInfoFromlocal].xw_id,
                                       @"page":@1,
                                       @"size":@20}
                        successBlock:^(id response) {
                            if ([response[@"success"] boolValue]) {
                                self.dataSource = [WEMyEvaluateModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"content"]];
                                [self.mTableView reloadData];
                            } else{
                                SVPERROR(response[@"msg"]);
                            }
                        }
                        failureBlock:^(NSError *error) {
                            
                        }
                            progress:nil];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return self.dataSource.count;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyEvaluateCell *cell = [MyEvaluateCell cellWithTableView:tableView];
    WEMyEvaluateModel *model = self.dataSource[indexPath.row];

    NSURL *imagURL =[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@/%@",ImageURL,model.otherId,model.otherTouxiangUrl]];
    [cell.headerImgeView sd_setImageWithURL:imagURL placeholderImage:nil];
    cell.nameLab.text = model.otherNickname;
    cell.showLbl.text = model.content;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.evalueateModel = self.dataSource[indexPath.row];
    UITableViewRowAction *actionDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除一条评论需要花费100喜币" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        self.deleteAlert = alert;
        [alert show];
    }];
    actionDelete.backgroundColor = [UIColor cyanColor];
    UITableViewRowAction *actionComplian = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"投诉" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"投诉");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"投诉原因" message:@"请输入投诉原因" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        self.complainAlert = alert;
        [alert show];
        
        
        
    }];
    actionComplian.backgroundColor = [UIColor redColor];
    return @[actionDelete,actionComplian];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        if (self.deleteAlert == alertView) {
            
            NSString *complianId = self.evalueateModel.idField;
            NSString *myId = self.evalueateModel.myId;
            NSString *cost = @"100";
            [BANetManager ba_requestWithType:BAHttpRequestTypePost
                                   urlString:BASEURL(@"/comment/delete")
                                  parameters:@{@"id":complianId,
                                               @"myId":myId,
                                               @"cost":cost}
                                successBlock:^(id response) {
                                    NSLog(@"花费--->%@",response);
                                    if ([response[@"success"] boolValue]) {
                                        SVPSUCCESS(@"删除成功");
                                        // 删除cell
                                        NSInteger index = [self.dataSource indexOfObject:self.evalueateModel];
                                        NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
                                        
                                        [self.dataSource removeObjectAtIndex:index];
                                        [self.mTableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                                    } else{
                                        SVPERROR(response[@"msg"]);
                                    }
                                }
                                failureBlock:^(NSError *error) {
                                    
                                }
                                    progress:nil];

            
        } else if (self.complainAlert == alertView) {
            
            NSString *reportContent = [alertView textFieldAtIndex:0].text;
            NSString *reportedItemId = self.evalueateModel.idField;
            [BANetManager ba_requestWithType:BAHttpRequestTypePost
                                   urlString:BASEURL(@"/comment/report")
                                  parameters:@{@"reportContent":reportContent,
                                               @"reportedItemId":reportedItemId}
                                successBlock:^(id response) {
                                    NSLog(@"投诉--->%@",response);
                                    if ([response[@"success"] boolValue]) {
                                        SVPSUCCESS(@"我们已收到您的投诉，请耐心等候");
                                    } else{
                                        SVPERROR(response[@"msg"]);
                                    }

                                }
                                failureBlock:^(NSError *error) {
                                    
                                }
                                    progress:nil];
            
        }
    }
    [self.mTableView setEditing:NO animated:YES];
}

- (UITableView *)mTableView {
    
    if (!_mTableView) {
        CGRect frame = CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64);
        _mTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [_mTableView registerClass:[MyEvaluateCell class] forCellReuseIdentifier:MyEvaluateCellID];
        _mTableView.delegate = self;
        _mTableView.tableFooterView = [UIView new];
        _mTableView.dataSource = self;
        _mTableView.rowHeight = 80.f;
        _mTableView.separatorStyle = NO;
    }
    return _mTableView;
}


@end
