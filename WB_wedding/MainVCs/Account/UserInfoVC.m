//
//  UserInfoVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/15.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoHeaderView.h"
#import "TitleAndDetailTextCell.h"
#import "CheckQuestionnaireCell.h"

#import "UserInfoEditVC.h"
#import "UserQuestionnaireVC.h"

#import "WECompletInfoController.h"

@interface UserInfoVC ()

@property (nonatomic,strong) UserInfoHeaderView *headerView;

@end

@implementation UserInfoVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.infoType == UserInfoTypeSelf) {
        _userData = nil;
        [self updateSubviews];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    UserInfoHeaderView *headeView = [UserInfoHeaderView appLoadFromNib];
    self.tableView.tableHeaderView = headeView;
    headeView.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.headerView = headeView;
    
    [self updateSubviews];
}

- (void)setupNav {
    [self createNavWithTitle:self.title createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            if (self.infoType == UserInfoTypeSelf) {
                UIButton *btn = NewTextButton(@"编辑", [UIColor whiteColor]);
                [btn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
                return btn;
            }
        }
        
        return nil;
    }];
    
    self.navBottomLine.hidden = YES;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction{
//    WECompletInfoController *vc = [WECompletInfoController new];
//    vc.isUserSetting = YES;
//    vc.telPhone = self.userData.telNumber;
//    vc.userId = self.userData.ID;
    UserInfoEditVC *vc = [UserInfoEditVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkAction{
    if (self.userData.mySurvey) {
        if ([self.userData subItemsIndexWithKey:@"mySurvey" andSeparatedByString:@"&"].count != [AppPublic getInstance].questionnaireLists.count) {
            [self showHint:@"问卷数据出错"];
            return;
        }
    }
    
    UserQuestionnaireVC *vc = [UserQuestionnaireVC new];
    vc.userData = [self.userData copy];
    if (self.infoType == UserInfoTypeSelf) {
        vc.questionnaireType = UserQuestionnaireTypeSelf;
    }
    else {
        vc.questionnaireType = UserQuestionnaireTypeOthers;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateSubviews{
    self.headerView.cycleScrollView.imageURLStringsGroup = [self.userData showImageArray];
    
    self.headerView.nameLabel.text = self.userData.nickname;
    self.headerView.addressLabel.text = self.userData.city;
    self.headerView.sexAndAgeLabel.text = [NSString stringWithFormat:@"%@ %d", [self.userData showStringOfSex], self.userData.age];
    self.headerView.constellationLabel.text = self.userData.xingZuo;
    
    self.headerView.matchView.hidden = (self.infoType != UserInfoTypeStart);
    if (self.infoType == UserInfoTypeSelf || self.infoType == UserInfoTypeStart) {
        self.headerView.thirdLabel.text = [NSString stringWithFormat:@"%dcm", self.userData.height];
        self.headerView.matchLabel.text = self.userData.matchDegree;
    }
    else {
        self.headerView.thirdLabel.text = [NSString stringWithFormat:@"匹配度%@%%", self.userData.matchDegree];
    }
    
    [self.headerView adjustSubviews];
    
    [self.tableView reloadData];
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
            
            return indexPath.row == 0 ? [CheckQuestionnaireCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:item.name andDetail:[self.userData subItemStringWithKey:item.key]] : [TitleAndDetailTextCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:item.name andDetail:[self.userData subItemStringWithKey:item.key]];
        }
            break;
            
        case 2:{
            return [TitleAndDetailTextCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:@"    " andDetail:[self.userData showStringOfMyQuestion]];
        }
            break;
            
        default:
            break;
    }
    
    return kCellHeightMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = (indexPath.section == 0 && indexPath.row == 0) ? @"userinfo_check_cell" : @"userinfo_cell";
    TitleAndDetailTextCell *cell = (TitleAndDetailTextCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell = [[CheckQuestionnaireCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            [((CheckQuestionnaireCell *)cell).checkButton addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            cell = [[TitleAndDetailTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:{
            [cell setTitle:@"真实姓名" andDetail:self.userData.realname];
        }
            break;
            
        case 1:{
            UserInfoItemData *item = [AppPublic getInstance].infoItemLists[indexPath.row];
            
            [cell setTitle:item.name andDetail:[self.userData subItemStringWithKey:item.key]];
        }
            break;
            
        case 2:{
            [cell setTitle:(self.infoType == UserInfoTypeSelf) ? @"我的提问" : @"ta的提问" andDetail:[self.userData showStringOfMyQuestion]];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
