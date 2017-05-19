//
//  UserSettingVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/19.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserSettingVC.h"
#import "WEChangePhoneController.h"
#import "WEChangePwdController.h"

#import "WESettingHeadeView.h"
#import "BlockAlertView.h"

@interface UserSettingVC ()

@property (strong, nonatomic) NSArray *showArray;

@end

@implementation UserSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    WESettingHeadeView *view = [WESettingHeadeView appLoadFromNib];
    self.tableView.tableHeaderView = view;
}

- (void)setupNav {
    [self createNavWithTitle:@"设置" createMenuItem:^UIView *(int nIndex){
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

- (void)doClearCache{
    //清除图片缓存
    [self showHudInView:self.view hint:nil];
    
    QKWEAKSELF;
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        [weakself hideHud];
        [weakself.tableView reloadData];
    }];
}

#pragma getter
- (NSArray *)showArray{
    if (!_showArray) {
        _showArray = @[
                       @[@{@"title":@"修改手机号",@"subTitle":@"",@"headImage":@""},
                         @{@"title":@"修改密码",@"subTitle":@"",@"headImage":@""},
                         ],
                       @[@{@"title":@"隐私和通知",@"subTitle":@"",@"headImage":@""},
                         @{@"title":@"清除缓存",@"subTitle":@"",@"headImage":@""},
                         @{@"title":@"退出登录",@"subTitle":@"",@"headImage":@""},
                         ],
                       ];
    }
    
    return _showArray;
}

- (BOOL)isAllowedNotification {
    if (IOS_VERSION >= 8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    
    return NO;
}

#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.showArray[section];
    
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.showArray.count - 1) {
        return kEdgeMiddle;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeightMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"setting_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *array = self.showArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[SDImageCache sharedImageCache].getSize / 1024.0 / 1024.0];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                WEChangePhoneController *vc = [[WEChangePhoneController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 1:{
                WEChangePwdController *vc = [[WEChangePwdController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 0:{
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
                break;
                
            case 1:{
                QKWEAKSELF;
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定清除缓存？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [weakself doClearCache];
                    }
                }otherButtonTitles:@"确定", nil];
                
                [alert show];
            }
                break;
                
            case 2:{
                BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"确定要退出账号？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [[AppPublic getInstance] logOut];
                    }
                }otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
                
            default:
                break;
        }
    }
}
@end
