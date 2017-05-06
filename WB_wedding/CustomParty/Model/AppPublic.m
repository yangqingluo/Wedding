//
//  AppPublic.m
//  SafetyOfMAS
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "AppPublic.h"
#import <CommonCrypto/CommonDigest.h>

#import "MainTabNavController.h"
#import "FirstPageController.h"
#import "HQMainTabBarController.h"

@implementation AppPublic

__strong static AppPublic  *_singleManger = nil;

+ (AppPublic *)getInstance{
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        _singleManger = [[AppPublic alloc] init];
        
        
    });
    return _singleManger;
}

- (instancetype)init{
    if (_singleManger) {
        return _singleManger;
    }
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma getter
- (AppUserData *)userData{
    if (!_userData) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *data = [ud objectForKey:kUserData];
        if (data) {
            _userData = [AppUserData mj_objectWithKeyValues:data];
        }
    }
    
    return _userData;
}

#pragma public
//检查该版本是否第一次使用
BOOL isFirstUsing(){
    //#if DEBUG
    //    NSString *key = @"CFBundleVersion";
    //#else
    NSString *key = @"CFBundleShortVersionString";
    //#endif
    
    // 1.当前版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    
    // 2.从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    // 3.写入本次版本号
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return ![version isEqualToString:saveVersion];
}

NSString *sha1(NSString *string){
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    
    
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    
    
    for(int i=0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        
        [outputStr appendFormat:@"%02x", digest[i]];
        
    }
    
    return outputStr;
}

//开始抖动
- (void)BeginWobble:(UIView *)view{
    srand([[NSDate date] timeIntervalSince1970]);
    float rand=(float)random();
    CFTimeInterval t = rand * 0.0000000001;
    
    [UIView animateWithDuration:0.1 delay:t options:0 animations:^{
        view.transform = CGAffineTransformMakeRotation(-0.05);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^{
            view.transform = CGAffineTransformMakeRotation(0.05);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

//停止抖动
- (void)EndWobble:(UIView *)view{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)logOut{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kUserData];
    _userData = nil;
    
    [self goToLoginCompletion:nil];
}

- (void)loginDonewithUserData:(NSDictionary *)data username:(NSString *)username password:(NSString *)password{
    if (!data || !username) {
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:username forKey:kUserName];
    _userData = [AppUserData mj_objectWithKeyValues:data[@"Data"]];
    [ud setObject:[_userData mj_keyValues] forKey:kUserData];
    
    [self goToMainVC];
}

- (void)goToMainVC{
    MainTabNavController *nav = [MainTabNavController new];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
}

- (void)goToLoginCompletion:(void (^)(void))completion{
    FirstPageController *vc = [FirstPageController new];
    
    [UIApplication sharedApplication].delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
}

@end
