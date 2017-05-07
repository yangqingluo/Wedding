//
//  WERegisterController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WERegisterController.h"
#import "UIButton+CountDown.h"
#import <SMS_SDK/SMSSDK.h>
#import "WECompletInfoController.h"
#import "BANetManager.h"
#import "EMClient.h"

@interface WERegisterController ()<UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *verifyTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *surePwdTf; //再次确认密码


@property (nonatomic, strong) NSArray *tfAr; //键盘的数组
@end

@implementation WERegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.registerBtn.layer.cornerRadius = 10;
    self.registerBtn.layer.masksToBounds = YES;
    self.title = @"注册";
    
    self.baseNavigationBar.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    self.statusView.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    
    [self.baseNavigationBar.backBtn setImage:[UIImage imageNamed:@"return48"] forState:UIControlStateNormal];
    
    [self.view bringSubviewToFront:self.baseNavigationBar];
    [self.view bringSubviewToFront:self.statusView];

    _tfAr = @[_phoneTf,_verifyTf,_passwordTf,_surePwdTf];
    for (UITextField *tf in _tfAr) {
        tf.delegate = self;
    }
    
}
- (IBAction)registerBtnClick:(UIButton *)sender {
    
#warning 测试
//    /**
//     测试
//     */
    //    WECompletInfoController *vc = [[WECompletInfoController alloc]init];
    //    vc.telPhone = _phoneTf.text.length>0?_phoneTf.text:@"18190019728";
    //    [self.navigationController pushViewController:vc animated:YES];
    //    return;
//    /**
//     测试
//     */
    
    
    // 判断除了验证码的输入框
    for (UITextField *tf in _tfAr) {
        if (tf.text.length < 1) {
            SVPERROR(@"请输入完整");
            return;
        }
    }
    
    // 判断两次输入是否一致
    if (![_passwordTf.text isEqualToString:_surePwdTf.text]) {
        SVPERROR(@"两次输入不一致");
        return;
    }
    
    
    
    [SMSSDK commitVerificationCode:_verifyTf.text
                       phoneNumber:_phoneTf.text
                              zone:@"86"
                            result:^(SMSSDKUserInfo *userInfo, NSError *error) {
                                // 判断验证码是否正确
                                if (!error) {
                                    
                                    NSLog(@"验证成功");
                                    /**
                                     *  注册网络请求
                                     */
                                    SVPSTATUS(@"注册中..");
                                    [BANetManager ba_requestWithType:BAHttpRequestTypePost
                                                           urlString:BASEURL(@"/user/register")
                                                          parameters:@{@"password": _passwordTf.text,
                                                                       @"telNumber": _phoneTf.text}
                                                        successBlock:^(id response) {
                                                            
                                                            /**
                                                             *  请求成功
                                                             */
                                                            SVPSUCCESS(@"填写资料");
                                                            if ([response[@"success"] boolValue]) {//真正成功
                                                                
                                                                // 1.注册环信
                                                                EMError *error = [[EMClient sharedClient] registerWithUsername:_phoneTf.text password:EMPassword];
                                                                if (error==nil) {
                                                                    NSLog(@"环信注册成功");
                                                                // 2.到完善资料界面
                                                                    WECompletInfoController *vc = [[WECompletInfoController alloc]init];
                                                                    vc.userId = response[@"data"];
                                                                    [self.navigationController pushViewController:vc animated:YES];
                                                                }
                                                                
                                                                

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
}


- (IBAction)sendMsgClick:(UIButton *)sender {
    
    if (_phoneTf.text.length != 11) {
        SVPERROR(@"电话号码输入错误");
        return;
    }
#warning 没验证手机号是否注册
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:_phoneTf.text zone:@"86"
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField != _surePwdTf) {
        NSInteger index = [_tfAr indexOfObject:textField];
        [_tfAr[++ index] becomeFirstResponder];
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    WECompletInfoController *vc = [[WECompletInfoController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
