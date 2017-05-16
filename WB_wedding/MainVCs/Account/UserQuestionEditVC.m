//
//  UserQuestionEditVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserQuestionEditVC.h"
#import "TextFieldCell.h"
#import "TitleAndDetailTextCell.h"

@interface UserQuestionEditVC ()<UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *questionArray;

@end

@implementation UserQuestionEditVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:NO];
}

- (void)setupNav {
    [self createNavWithTitle:@"我的提问" createMenuItem:^UIView *(int nIndex){
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
    [self dismissKeyboard];
    
    for (NSString *question in self.questionArray) {
        if (question.length == 0) {
            [self showHint:@"问题不能为空"];
            return;
        }
    }
    
    NSString *questionString = [self.questionArray componentsJoinedByString:@"&"];
    
    if ([questionString isEqualToString:[AppPublic getInstance].userData.myQuestion]) {
        [self goBack];
    }
    else {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:[AppPublic getInstance].userData.telNumber forKey:@"telNumber"];
        [dic setObject:questionString forKey:@"myQuestion"];
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] Post:dic HeadParm:nil URLFooter:@"/user/updatedoc" completion:^(id responseBody, NSError *error){
            [weakself hideHud];
            
            if (!error) {
                if (isHttpSuccess([responseBody[@"success"] intValue])) {
                    [AppPublic getInstance].userData.myQuestion = questionString;
                    [[AppPublic getInstance] saveUserData:[AppPublic getInstance].userData];
                    
                    weakself.doneBlock(questionString);
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
- (NSMutableArray *)questionArray{
    if (!_questionArray) {
        _questionArray = [[NSMutableArray alloc] initWithArray:[[AppPublic getInstance].userData showArrayOfMyQuestion]];
    }
    
    return _questionArray;
}

#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.questionArray.count;
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
    if (indexPath.section == 0) {
        return [TitleAndDetailTextCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:@"请编辑3-10个问题" titleFont:[UIFont systemFontOfSize:appLabelFontSizeMiddle] andDetail:@"您的问题将会被发送给您选中的心仪对象，您可以通过ta的回答来判断是否与他交往。" detailFont:[UIFont systemFontOfSize:appLabelFontSize]];
    }
    return kCellHeightMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            static NSString *CellIdentifier = @"question_0_cell";
            TitleAndDetailTextCell *cell = (TitleAndDetailTextCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[TitleAndDetailTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.titleLabel.font = [UIFont systemFontOfSize:appLabelFontSizeMiddle];
                cell.titleLabel.textColor = [UIColor blackColor];
            }
            
            [cell setTitle:@"请编辑3-10个问题" andDetail:@"您的问题将会被发送给您选中的心仪对象，您可以通过ta的回答来判断是否与他交往。"];
            
            return cell;
        }
            break;
            
        case 1:{
            static NSString *CellIdentifier = @"question_1_cell";
            TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.textField.borderStyle = UITextBorderStyleNone;
                cell.textField.clearButtonMode = UITextFieldViewModeAlways;
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.delegate = self;
                cell.textField.placeholder = @"请编辑问题";
                cell.textField.width = screen_width - cell.textField.left - 2 * kEdgeBig;
                
                UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, cell.textField.height)];
                leftLabel.font = cell.textField.font;
                leftLabel.textColor = cell.textField.textColor;
                cell.textField.leftView = leftLabel;
                cell.textField.leftViewMode = UITextFieldViewModeAlways;
            }
            
            ((UILabel *)cell.textField.leftView).text = [NSString stringWithFormat:@"%d.\t", (int)indexPath.row + 1];
            cell.textField.text = self.questionArray[indexPath.row];
            cell.textField.tag = indexPath.row;
            
            return cell;
        }
            break;
            
        case 2:{
            static NSString *CellIdentifier = @"question_2_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:appLabelFontSizeMiddle];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor redColor];
            }
            
            cell.textLabel.text = @"添加问题";
            cell.textLabel.textColor = self.questionArray.count < 10 ? [UIColor redColor] : [UIColor lightGrayColor];
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (self.questionArray.count < 10) {
            [self.questionArray addObject:@""];
            [self.tableView reloadData];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section == 1 && indexPath.row > 2);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.questionArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

#pragma  mark - TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return (range.location < kNameLengthMax);
}

- (void)textFieldTextDidChange:(NSNotification *)notify{
    UITextField *textField = [notify object];
    if (textField.tag < self.questionArray.count) {
        self.questionArray[textField.tag] = textField.text;
    }
}

@end
