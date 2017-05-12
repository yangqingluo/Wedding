//
//  UserInfoEditVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserInfoEditVC.h"

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
        
        return nil;
    }];
    
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
