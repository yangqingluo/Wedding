
//
//  WECodeLoginController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WECodeLoginController.h"
#import <SMS_SDK/SMSSDK.h>
#import "UIButton+CountDown.h"
#import "WELoginTool.h"
@interface WECodeLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UIButton *codeBnt;

@end

@implementation WECodeLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证码登录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.baseNavigationBar.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    self.statusView.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    
    [self.baseNavigationBar.backBtn setImage:[UIImage imageNamed:@"return48"] forState:UIControlStateNormal];

}

- (IBAction)loginBtn:(id)sender {
    if (kAppDelegate.isOnLine == NO) {
        [self showNoNetError];
        return;
    }
    if ([self isMobileNumber:self.numText.text] == NO) {
        [self showMessage:@"请输入正确的手机号" toView:self.view];
        return;

    }
    if (self.passText.text.length) {
        
        
        [SMSSDK commitVerificationCode:self.passText.text
                           phoneNumber:self.numText.text
                                  zone:@"86"
                                result:^(SMSSDKUserInfo *userInfo, NSError *error) {
                                    // 判断验证码是否正确
                                    if (!error) {
                                        NSLog(@"验证成功");
                                        
                        [self showActivity];
                        [WELoginTool normalLoginWithNumber:self.numText.text latitude:self.lat loginType:@"1" longitude:self.lng password:self.passText.text success:^(id model) {
                            [self cancleActivity];
                            [self showMessage:@"登录成功" toView:self.view];
                            
                            [[AppPublic getInstance] goToMainVC];
                            
                        } failed:^(NSString *error) {
                            [self cancleActivity];
                            [self showMessage:error toView:self.view];

                        }];
                        
                                        
                                    }else{
                                        
                                        [self showMessage:@"请输入正确的验证码" toView:self.view];
                                    }
                                    
                    }];
         
        
    }else{
        [self showMessage:@"请输入验证码" toView:self.view];
        return;

    }
    
}
    
    




- (IBAction)codeBtnCLick:(UIButton *)sender {
    if ([self isMobileNumber:self.numText.text] == NO) {
        [self showMessage:@"请输入正确的手机号" toView:self.view];
        return;
    }
    

    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.numText.text zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
                                     if (!error) {
                                         NSLog(@"获取验证码成功");
                                     } else {
                                         NSLog(@"错误信息：%@",error);
                                     }
                                 }];
    [sender startWithTime:60 title:@"获取验证码" countDownTitle:@"秒" mainColor:MAINCOLOR countColor:[UIColor whiteColor]];
}


@end
