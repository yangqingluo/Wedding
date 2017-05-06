/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "AppDelegate+EaseMob.h"

#import "ChatDemoHelper.h"

/**
 *  本类中做了EaseMob初始化和推送等操作
 */

@implementation AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig
{
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:appkey
                                       apnsCertName:apnsCertName
                                        otherConfig:otherConfig];
    
    [ChatDemoHelper shareHelper];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loginStateChange:)
//                                                 name:kLoginStatus
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(EaseMobLoginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
}

#pragma mark - App Delegate

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
    //                                                    message:error.description
    //                                                   delegate:nil
    //                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
    //                                          otherButtonTitles:nil];
    //    [alert show];
}

#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //    NSError *parseError = nil;
    //    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
    //                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    //    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
    //                                                    message:str
    //                                                   delegate:nil
    //                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
    //                                          otherButtonTitles:nil];
    //    [alert show];
    
}

#pragma mark - private
//登陆状态改变
- (void)loginStateChange:(NSNotification *)notification{
    if ([EMClient sharedClient].isLoggedIn) {
        return;
    }
    
//    [self EMloginWithUsername:newChatMemberIDWithID([AppPublic shareInstanceApp].UserInfo.ID) password:[AppPublic shareInstanceApp].UserInfo.ChatId];
}

- (void)EaseMobLoginStateChange:(NSNotification *)notification{
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) {
        
    }
    else{
//        [[AppPublic shareInstanceApp]logOut];
//        [[AppPublic shareInstanceApp]goToLoginCompletion:^{
//            
//        }];
    }
}


#pragma EMlogin
- (void)EMloginWithUsername:(NSString *)username password:(NSString *)password{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                //设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[EMClient sharedClient] dataMigrationTo3];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ChatDemoHelper shareHelper] asyncGroupFromServer];
                        [[ChatDemoHelper shareHelper] asyncConversationFromDB];
                        [[ChatDemoHelper shareHelper] asyncPushOptions];
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                        
                        //保存最近一次登录用户名
                        [self saveLastLoginUsername];
                    });
                });
            } else {
                NSLog(@"环信登录出错:%d...",error.code);
                switch (error.code){
                        //                    case EMErrorNotFound:
                        //                        TTAlertNoTitle(error.errorDescription);
                        //                        break;
                    case EMErrorNetworkUnavailable:
                        //                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                        break;
                    case EMErrorServerNotReachable:
                        //                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                        break;
                    case EMErrorUserAuthenticationFailed:
                        //                        TTAlertNoTitle(error.errorDescription);
                        break;
                    case EMErrorServerTimeout:
                        //                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                        break;
                    default:
                        //                        TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                        break;
                }
            }
        });
    });
}

#pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

@end
