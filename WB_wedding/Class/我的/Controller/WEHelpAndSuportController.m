//
//  WEHelpAndSuportController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEHelpAndSuportController.h"

@interface WEHelpAndSuportController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSArray     *data;

@end

@implementation WEHelpAndSuportController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助与支持";
    self.data = @[@"婉婉怎么玩",@"怎样匹配到最适合自己的人选？",@"怎样开启查看对方位置？"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [UIView new];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.data[indexPath.row];
    return cell;

}



@end
