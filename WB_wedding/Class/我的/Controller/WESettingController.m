//
//  WESettingController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WESettingController.h"
#import "TTRangeSlider.h"
#import "WESettingHeadeView.h"
#import "XWUserModel.h"
#import "FirstPageController.h"
#import "WEChangePhoneController.h"
#import "WEChangePwdController.h"
@interface WESettingController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView  *tableView;

@end

@implementation WESettingController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"设置";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 69,KScreenWidth, KScreenHeight-69) style:UITableViewStyleGrouped];
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 60;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"1"];
    [self.view addSubview:self.tableView];
    WESettingHeadeView *view = [WESettingHeadeView xw_loadFromNib];
    self.tableView.tableHeaderView = view;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 3;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"修改手机号";
            
        }else{
            cell.textLabel.text = @"修改密码";
        }
    }
    else{
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"隐私和通知";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"清除缓存";
        }else{
               cell.textLabel.text = @"退出登录";
        }

        
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WEChangePhoneController *vc = [[WEChangePhoneController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            WEChangePwdController *vc = [[WEChangePwdController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        
        if (indexPath.row == 0) {
            
        }else if(indexPath.row == 1){
            
        }else{
            
            [[AppPublic getInstance] logOut];
        
        }
    }

    
    
    
}



@end
