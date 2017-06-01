//
//  MessageDetailVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "MessageDetailVC.h"
#import "TitleAndDetailTextCell.h"

@interface MessageDetailVC ()

@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self sendMessageReaded];
}

- (void)setupNav {
    [self createNavWithTitle:@"消息详情" createMenuItem:^UIView *(int nIndex){
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

- (void)sendMessageReaded{
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:@{@"messageId":self.messageData.ID} HeadParm:nil URLFooter:@"/mymessage/readmessage" completion:^(id responseBody, NSError *error){
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                weakself.messageData.isMessageRead = @"1";
            }
        }
    }];
}

- (void)sendMessageGetLove{
    [self showHudInView:self.view hint:nil];
    
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] Get:@{@"myId":[AppPublic getInstance].userData.ID, @"hisOrHerId" : self.messageData.otherId} HeadParm:nil URLFooter:@"/mymessage/getlove" completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                
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

- (void)acceptButtonAction{
    switch (self.messageData.msgType) {
        case UserMessageTypeLove:
        case UserMessageTypeReLove:{
            [self sendMessageGetLove];
        }
            break;
            
        default:
            break;
    }
}

#pragma tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageData.msgType == UserMessageTypeNormal ? 1 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdgeMiddle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *title = @"  的心里话";
        
        return [TitleAndDetailTextCell tableView:tableView heightForRowAtIndexPath:indexPath withTitle:title titleFont:[UIFont systemFontOfSize:appLabelFontSizeMiddle] andDetail:self.messageData.content detailFont:[UIFont systemFontOfSize:appLabelFontSize]];
    }
    
    return kCellHeightMiddle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            NSString *CellIdentifier = @"message_detail_0_cell";
            TitleAndDetailTextCell *cell = (TitleAndDetailTextCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[TitleAndDetailTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.titleLabel.textColor = [UIColor blackColor];
                cell.titleLabel.font = [UIFont systemFontOfSize:appLabelFontSizeMiddle];
                cell.subTitleLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
            }
            
            [cell setTitle:[NSString stringWithFormat:@"%@的心里话", self.messageData.otherNickName] andDetail:self.messageData.content];
            
            return cell;
        }
            break;
            
        case 1:{
            NSString *CellIdentifier = @"message_detail_1_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:appLabelFontSizeMiddle];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor redColor];
            }
            
            cell.textLabel.text = @"接受";
            cell.textLabel.textColor = [UIColor redColor];
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        [self acceptButtonAction];
    }
}

@end
