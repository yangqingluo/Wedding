//
//  UserInfoEditVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserInfoEditVC.h"
#import "PublicSelectionVC.h"

@interface UserInfoEditVC ()

@property (strong, nonatomic) AppUserData *userData;

@end

@implementation UserInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav {
    [self createNavWithTitle:@"完善资料" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (UserInfoItemData *item in [AppPublic getInstance].infoItemLists) {
        if (![[[AppPublic getInstance].userData valueForKey:item.key] isEqualToString:[self.userData valueForKey:item.key]]) {
            [dic setObject:[self.userData valueForKey:item.key] forKey:item.key];
        }
    }
    
    if (dic.count) {
        [dic setObject:self.userData.telNumber forKey:@"telNumber"];
        
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] Post:dic HeadParm:nil URLFooter:@"/user/updatedoc" completion:^(id responseBody, NSError *error){
            [weakself hideHud];
            
            if (!error) {
                if (isHttpSuccess([responseBody[@"success"] intValue])) {
                    [[AppPublic getInstance] saveUserData:self.userData];
                    [weakself goBack];
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
- (AppUserData *)userData{
    if (!_userData) {
        _userData = [[AppPublic getInstance].userData copy];
    }
    
    return _userData;
}

#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [AppPublic getInstance].infoItemLists.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeightMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"userinfo_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text = self.userData.nickname;
            cell.detailTextLabel.text = @"查看问卷";
        }
            break;
            
        case 1:{
            UserInfoItemData *item = [AppPublic getInstance].infoItemLists[indexPath.row];
            cell.textLabel.text = item.name;
            
            cell.detailTextLabel.text = [self.userData subItemStringWithKey:item.key];
        }
            break;
            
        case 2:{
            cell.textLabel.text = @"我的提问";
            cell.detailTextLabel.text = @"";
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 1:{
            UserInfoItemData *item = [AppPublic getInstance].infoItemLists[indexPath.row];
            
            QKWEAKSELF;
            PublicSelectionVC *vc = [[PublicSelectionVC alloc] initWithDataSource:item.subItems selectedArray:[self.userData subItemsIndexWithKey:item.key] maxSelectCount:item.subItemMaxNumber back:^(NSString *selectedString){
                if (selectedString.length) {
                    [weakself.userData setValue:selectedString forKey:item.key];
                    [weakself.tableView reloadData];
                }
            }];
            
            vc.title = [NSString stringWithFormat:@"选择%@", item.name];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
