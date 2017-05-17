//
//  WEMyChatController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/3.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEMyChatController.h"
#import "WETestChatViewController.h"
#import "XWTitleBottomBtn.h"
#import "WEMyChatTool.h"
#import "EaseMessageViewController.h"
//轮播
#import <SDCycleScrollView.h>

@interface WEMyChatController ()<UIAlertViewDelegate>
{
    NSString *loverPhone;
    NSString *loverName;
}
@property (weak, nonatomic) IBOutlet SDCycleScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UIView *missView;
@property (weak, nonatomic) IBOutlet UIView *chatView;

@end

@implementation WEMyChatController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的聊天";
    
//    
//    [self.missView addSubview:({
//        XWTitleBottomBtn *btn = [XWTitleBottomBtn buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"想Ta" forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"miss48"] forState:UIControlStateNormal];
//        [btn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
//        btn.bounds = CGRectMake(0, 0, 80, 80);
//        btn.center = self.missView.center;
//        btn;
//    })];
//    [self.chatView addSubview:({
//        XWTitleBottomBtn *btn = [XWTitleBottomBtn buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"想Ta" forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"talk48"] forState:UIControlStateNormal];
//        [btn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
//        btn.bounds = CGRectMake(0, 0, 80, 80);
//        btn.center = self.missView.center;
//        btn;
//    })];
    
    __weak typeof(self)weakSefl = self;
    [self setNavigationRightBtnWithImageName:@"shengluehao" actionBack:^{
        
        XWPopView *popView = [[XWPopView alloc]initWithItmes:@[@"分手",@"测试",@"测试2"] popViewActionBack:^(NSInteger index) {
            if (index == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"Ta那么可爱，确定要和她Ta分手吗?" delegate:weakSefl cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alert show];
            } else{
                [weakSefl talk:nil];
            }
        
    }];
        [popView showInView:weakSefl.view];
    }];
    self.topScrollView.localizationImageNamesGroup = @[@"baby", downloadImagePlace, downloadImagePlace];
    
    XWUserModel *model = [XWUserModel getUserInfoFromlocal];
//    
//    if (![model.loverId isEqualToString:@""]&&model.loverId != nil) {
//        
//        self.topScrollView.hidden = NO;
//        self.missView.hidden = NO;
//        self.chatView.hidden = NO;
//
//        
//        
//    }else{
//        self.topScrollView.hidden = YES;
//        self.missView.hidden = YES;
//        self.chatView.hidden = YES;
//    }
    
    
}

- (void)configDataSource {
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        XWUserModel *model = [XWUserModel getUserInfoFromlocal];
        if ([KUserDefaults objectForKey:KHisHerID]==nil) {
            [self showMessage:@"你还没有匹配的人" toView:self.view];
            return;
        }
        [self showActivity];
        [WEMyChatTool breakOutWithID:model.xw_id hisOrHerId:[KUserDefaults objectForKey:KHisHerID] success:^(id model) {
            [self cancleActivity];
            [self showMessage:@"分手成功" toView:self.view];
            
            // 清除缓存
            [KUserDefaults removeObjectForKey:KHisHerID];
            [KNotiCenter postNotificationName:KCancleMarch object:nil];
            
        } failed:^(NSString *error) {
            [self cancleActivity];
            [self showMessage:error toView:self.view];
            
            
        }];
        
    }
}


#pragma mark -- 想他
- (IBAction)missHe:(UIButton *)sender {
}


#pragma mark -- 聊天
- (IBAction)talk:(UIButton *)sender {
    WETestChatViewController *vc = [[WETestChatViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

//    if (loverPhone.length == 0) {
//        SVPERROR(@"还没请求到爱人消息");
//        return;
//    }
//    EaseMessageViewController *chatVC = [[EaseMessageViewController alloc] initWithConversationChatter:@"18190019728" conversationType:EMConversationTypeChat];
//    [self.navigationController pushViewController:chatVC animated:YES];
    
    
}



@end
