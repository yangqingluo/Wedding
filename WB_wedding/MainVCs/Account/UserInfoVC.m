//
//  UserInfoVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/15.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoEditVC.h"
#import "UserInfoHeaderView.h"
#import "TitleAndDetailTextCell.h"


@interface UserInfoVC ()

@property (nonatomic,strong) UserInfoHeaderView *headeView;

@end

@implementation UserInfoVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    UserInfoHeaderView *headeView = [UserInfoHeaderView appLoadFromNib];
    self.tableView.tableHeaderView = headeView;
    headeView.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    headeView.cycleScrollView.imageURLStringsGroup = [[AppPublic getInstance].userData showImageArray];
    self.headeView = headeView;
}

- (void)setupNav {
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"编辑", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
    
    self.navBottomLine.hidden = YES;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction{
    UserInfoEditVC *vc = [UserInfoEditVC new];
    [self.navigationController pushViewController:vc animated:YES];
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
    if (section == 2) {
        return kEdgeMiddle;
    }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return 90;
        }
            break;
            
        case 1:{
            UserInfoItemData *item = [AppPublic getInstance].infoItemLists[indexPath.row];
            
            return [TitleAndDetailTextCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:item.name andDetail:[[AppPublic getInstance].userData subItemStringWithKey:item.key]];
        }
            break;
            
        case 2:{
            return [TitleAndDetailTextCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:@"我的提问" andDetail:[[AppPublic getInstance].userData showStringOfMyQuestion]];
        }
            break;
            
        default:
            break;
    }
    
    return kCellHeightMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"userinfo_cell";
    TitleAndDetailTextCell *cell = (TitleAndDetailTextCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[TitleAndDetailTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:{
            [cell setTitle:[NSString stringWithFormat:@"真实姓名\n%@", [AppPublic getInstance].userData.realname] andDetail:@"查看问卷"];
        }
            break;
            
        case 1:{
            UserInfoItemData *item = [AppPublic getInstance].infoItemLists[indexPath.row];
            
            [cell setTitle:item.name andDetail:[[AppPublic getInstance].userData subItemStringWithKey:item.key]];
        }
            break;
            
        case 2:{
            [cell setTitle:@"我的提问" andDetail:[[AppPublic getInstance].userData showStringOfMyQuestion]];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
