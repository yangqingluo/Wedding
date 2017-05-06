//
//  WECommetViewController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WECommetViewController.h"
#import "WECommentCell.h"
#import "WESomeOneLikeTool.h"
@interface WECommetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WECommetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"Baby的评价";
    [self.tableView registerNib:[UINib nibWithNibName:@"WECommentCell" bundle:nil] forCellReuseIdentifier:WECommentCellID];
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [UIView new];
    
    [WESomeOneLikeTool lookUserCommentWithID:self.ID page:@"1" size:@"10" success:^(id model) {
        
    } failed:^(NSString *error) {
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WECommentCell *cell = [tableView dequeueReusableCellWithIdentifier:WECommentCellID];
    
    return cell;
    
}



@end
