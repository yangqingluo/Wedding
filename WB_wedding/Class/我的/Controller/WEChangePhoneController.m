//
//  WEChangePhoneController.m
//  WB_wedding
//
//  Created by 谢威 on 17/3/29.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEChangePhoneController.h"
#import <SMS_SDK/SMSSDK.h>
#import "UIButton+CountDown.h"
@interface WEChangePhoneController ()

@end

@implementation WEChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    
    QKWEAKSELF;
    [self setNavigationRightBtnWithTitle:@"保存" actionBack:^{
        
        if ([self.pwdTextFild.text isEqualToString:@""]||self.pwdTextFild.text == nil) {
            
            [weakself showMessage:@"请输入密码" toView:weakself.view];
            return ;
        }
        
        if ([self.numTextFiled.text isEqualToString:@""]||self.numTextFiled.text == nil) {
            
            [weakself showMessage:@"请输入手机号" toView:weakself.view];
            return ;
        }
        
        if ([self.codeTextf.text isEqualToString:@""]||self.codeTextf.text == nil) {
            
            [weakself showMessage:@"请输入验证码" toView:weakself.view];
            return ;
        }
        
        [SMSSDK commitVerificationCode:self.codeTextf.text phoneNumber:self.numTextFiled.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
            
            
            // 判断验证码是否正确
            if (!error) {
                
                NSLog(@"验证成功");
                /**
                 *  注册网络请求
                 */
                SVPSTATUS(@"注册中..");
                [BANetManager ba_requestWithType:BAHttpRequestTypePost
                                       urlString:BASEURL(@"/user/changetelnumber")
                                      parameters:@{@"userId":[XWUserModel getUserInfoFromlocal].xw_id,
                                                   @"newTelNumber":self.numTextFiled.text,
                                                   @"password":self.pwdTextFild.text}
                                    successBlock:^(id response) {
                                        
                                        /**
                                         *  请求成功
                                         */
                                        SVPSUCCESS(@"修改成功");
                                        [self.navigationController popViewControllerAnimated:YES];
                                        if ([response[@"success"] boolValue]) {//真正成功
                                            
                                            
                                            
                                        } else{
                                            NSString *errorStr = response[@"msg"];
                                            SVPERROR(errorStr);
                                        }
                                    }
                                    failureBlock:^(NSError *error) {
                                        SVPERROR(@"网络错误");
                                    }
                                        progress:nil];
            }
            else
            {
                NSLog(@"错误信息：%@",error);
                SVPERROR(@"验证码不正确");
            }

        }];
        
        
        
        
        
    }];
    
}
- (IBAction)postBtnCLick:(UIButton *)sender {
    

    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.numTextFiled.text zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
                                     if (!error) {
                                         NSLog(@"获取验证码成功");
                                     } else {
                                         NSLog(@"错误信息：%@",error);
                                     }
                                 }];
    [sender startWithTime:60 title:@"获取验证码" countDownTitle:@"秒" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];

    
    
    
}



@end
