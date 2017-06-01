//
//  AppDelegate.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/3.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "QJCLLocationTool.h"
#import "AppDelegate.h"
#import "WELoginTool.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "XWUserModel.h"
#import <CoreLocation/CoreLocation.h>
#import "HQBaseNetManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <IQKeyboardManager.h>
#import "AppDelegate+EaseMob.h"
#import "EaseSDKHelper.h"


#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "WEMarchTool.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#define JPushChannel @"Publish channel"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static NSString *const MOB_AppKey = @"1b12a4df0aba0";
static NSString *const MOB_AppSecret = @"dae490978de8f0daae85538b95be78aa";

@interface AppDelegate ()<JPUSHRegisterDelegate>

/**
 *  百度地图管理者
 */
@property (nonatomic,strong)BMKMapManager       *mapManager;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [self configKeyBorad];
    [self configMOB];
    [self configBaiduMap];
    
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"ww_dev";
#else
    apnsCertName = @"ww_dis";
#endif
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    if ([AppPublic getInstance].userData) {
        [[AppPublic getInstance] goToMainVC];
    }
    else {
        [[AppPublic getInstance] goToLoginCompletion:nil];
    }
    
    [self.window makeKeyAndVisible];
    
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:@"1187170107178654#qqyzww"
                apnsCertName:apnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:@YES}];
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"64be46b9453a642f86fbe513"
                          channel:JPushChannel
                 apsForProduction:NO
            advertisingIdentifier:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNoti:) name:kJPFNetworkDidSetupNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeNoti:) name:kJPFNetworkDidCloseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registSuccessNoti:) name:kJPFNetworkDidRegisterNotification object:nil];
    
    
    
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    return YES;
}

- (void)setupNoti:(NSNotification *)noti{
    NSLog(@"+++++++++++++++++++++建立通知连接:%@",noti.userInfo);
}
- (void)closeNoti:(NSNotification *)noti{
    NSLog(@"--------------------关闭通知连接:%@",noti.userInfo);
}
- (void)registSuccessNoti:(NSNotification *)noti{
    NSLog(@"aaaaaaaaaaaaaaaaaaaa注册通知成功:%@",noti.userInfo);
}
- (void)getUserNoti:(NSNotification *)noti{
    NSLog(@"iiiiiiiiiiiiiiiiiiii收到自定义通知(非APNS):%@",noti.userInfo);
}

#pragma mark 配置百度地图
- (void)configBaiduMap{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL isSuccess = [_mapManager start:BaiduMapKey generalDelegate:nil];
    if (!isSuccess) {
        NSLog(@"百度地图管理者初始化失败");
    }
}

#pragma mark -- 配置键盘
- (void)configKeyBorad{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //控制整个功能启用
    [manager setEnable:YES];
    // 控制是否显示键盘上的工具条
    [manager setEnableAutoToolbar:YES];
    //控制点击空白是否收起键盘
    manager.shouldResignOnTouchOutside = YES;
    //控制键盘上的工具条文字颜色是否用户自定义
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    //设置Done按钮的文字（也可以不设文字，设图片）
    manager.toolbarDoneBarButtonItemText = @"完成";
    //防止IQKeyboardManager让rootview上滑过度,默认是YES
    manager.preventShowingBottomBlankSpace = YES;
    // 最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘
    manager.toolbarManageBehaviour = IQAutoToolbarByTag;
}


- (void)configMOB {
    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:MOB_AppKey
             withSecret:MOB_AppSecret];
    //关闭掉访问通讯录
    [SMSSDK enableAppContactFriends:NO];
}


#pragma mark=============在下面两个方法中处理支付宝的回调================
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSLog(@"application--->%@,url--->%@,sourceApplication-->%@,annotation->%@",application,url,sourceApplication,annotation);
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"---网页支付宝回调--->%@",resultDic);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                // 发送个通知
                [[NSNotificationCenter defaultCenter] postNotificationName:AlipaySuccessNotification object:nil];
            }
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            
            
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
    NSLog(@"%@收到通知:%@",userInfo, [self logDic:userInfo]);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
