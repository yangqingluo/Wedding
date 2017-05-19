//
//  UserQuestionnaireVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserQuestionnaireVC.h"
#import "TitleAndDetailTextCell.h"
#import "PublicSelectionVC.h"

@interface UserQuestionnaireVC ()

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) NSMutableArray *answersList;

@end

@implementation UserQuestionnaireVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupNav {
    [self createNavWithTitle:@"问卷" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            if (self.questionnaireType == UserQuestionnaireTypeSelf) {
                UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
                [btn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
                return btn;
            }
        }
        
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction{
    NSString *answersString = [self.answersList componentsJoinedByString:@"&"];
    if (![answersString isEqualToString:self.userData.mySurvey]) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:answersString forKey:@"mySurvey"];
        [dic setObject:self.userData.telNumber forKey:@"telNumber"];
        
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] Post:dic HeadParm:nil URLFooter:@"/user/updatesurvey" completion:^(id responseBody, NSError *error){
            [weakself hideHud];
            
            if (!error) {
                if (isHttpSuccess([responseBody[@"success"] intValue])) {
                    self.userData.mySurvey = answersString;
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
    else {
        [self showHint:@"没有改动"];
    }
}

#pragma getter
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 80)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeMiddle, 0, screen_width - 2 * kEdgeMiddle, _headerView.height)];
        label.font = [UIFont systemFontOfSize:appLabelFontSizeMiddle];
        label.textColor = [UIColor blackColor];
        [_headerView addSubview:label];
        label.text = self.questionnaireType == UserQuestionnaireTypeSelf ? @"问卷代表我的心" : @"问卷代表ta的心";
    }
    
    return _headerView;
}

- (NSMutableArray *)answersList{
    if (!_answersList) {
        NSArray *array = [self.userData subItemsIndexWithKey:@"mySurvey" andSeparatedByString:@"&"];
        
        NSUInteger count = [AppPublic getInstance].questionnaireLists.count;
        _answersList = [NSMutableArray new];
        [_answersList addObjectsFromArray:array];
        if (_answersList.count < count) {
            for (NSUInteger index = _answersList.count; index < count; index++) {
                [_answersList addObject:@""];
            }
        }
        
    }
    
    return _answersList;
}

#pragma tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AppPublic getInstance].questionnaireLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeMiddle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoItemData *item = [AppPublic getInstance].questionnaireLists[indexPath.row];
    
    return [TitleAndDetailTextCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:item.name andDetail:[self.userData showStringOfMySurveyForIndex:indexPath.row andLists:self.answersList[indexPath.row]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"questionnaire_cell";
    TitleAndDetailTextCell *cell = (TitleAndDetailTextCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[TitleAndDetailTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if (self.questionnaireType == UserQuestionnaireTypeSelf) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UserInfoItemData *item = [AppPublic getInstance].questionnaireLists[indexPath.row];
    
    [cell setTitle:item.name andDetail:[self.userData showStringOfMySurveyForIndex:indexPath.row andLists:self.answersList[indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoItemData *item = [AppPublic getInstance].questionnaireLists[indexPath.row];
    
    QKWEAKSELF;
    PublicSelectionVC *vc = [[PublicSelectionVC alloc] initWithDataSource:item.subItems selectedArray:[self.answersList[indexPath.row] componentsSeparatedByString:@","] maxSelectCount:item.subItemMaxNumber back:^(NSObject *object){
        if ([object isKindOfClass:[NSString class]]) {
            NSString *selectedString = (NSString *)object;
            if (selectedString.length) {
                weakself.answersList[indexPath.row] = selectedString;
                [weakself.tableView reloadData];
            }
        }
    }];
    
    vc.title = [NSString stringWithFormat:@"编辑问卷"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
