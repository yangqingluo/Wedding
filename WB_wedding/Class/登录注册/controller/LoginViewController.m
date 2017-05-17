//
//  LoginViewController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "LoginViewController.h"
#import "WECodeLoginController.h"
#import "EMClient.h"

#import "WELoginTool.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logingBtn;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    self.logingBtn.layer.cornerRadius = 10;
    self.logingBtn.layer.masksToBounds = YES;
    
    self.baseNavigationBar.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    self.statusView.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    
    [self.baseNavigationBar.backBtn setImage:[UIImage imageNamed:@"return48"] forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.baseNavigationBar];
    [self.view bringSubviewToFront:self.statusView];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.usernameTextField.text = [ud objectForKey:kUserName];
}

- (IBAction)login:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (self.usernameTextField.text.length == 0) {
        [self showHint:@"请输入用户名"];
    }
    else if (self.passwordTextField.text.length < kPasswordLengthMin) {
        [self showHint:@"请输入正确的密码"];
    }
    else {
        [self showHudInView:self.view hint:nil];
        
        QKWEAKSELF;
        [[QKNetworkSingleton sharedManager] loginWithID:self.usernameTextField.text Password:self.passwordTextField.text LoginType:0 completion:^(id responseBody, NSError *error){
            [weakself hideHud];
            
            if (!error) {
                if (isHttpSuccess([responseBody[@"success"] intValue])) {
                    EMError *error = [[EMClient sharedClient] loginWithUsername:self.usernameTextField.text password:EMPassword];
                    if (!error || error.code == EMErrorUserAlreadyLogin) {
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                    } else if (error.code == EMErrorUserNotFound) {
                        //未注册
                        EMError *error = [[EMClient sharedClient] registerWithUsername:self.usernameTextField.text password:EMPassword];
                        if (!error) {
                            NSLog(@"环信注册成功");
                        }
                    }
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

- (IBAction)codeLogin:(UIButton *)sender {
    WECodeLoginController *vc = [[WECodeLoginController alloc]init];
    if ([AppPublic getInstance].location) {
        vc.lat = [NSString stringWithFormat:@"%.6f", [AppPublic getInstance].location.coordinate.latitude];
        vc.lng = [NSString stringWithFormat:@"%.6f", [AppPublic getInstance].location.coordinate.longitude];
    }else{
        vc.lat = @"0";
        vc.lng = @"0";

    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
