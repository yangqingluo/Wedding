//
//  AppPublic.m
//  SafetyOfMAS
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "AppPublic.h"
#import <CommonCrypto/CommonDigest.h>

#import "UIImage+Color.h"
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

- (NSArray *)infoItemLists{
    if (!_infoItemLists) {
        _infoItemLists = @[@"行业",@"工作领域",@"学历",@"自我评价",@"娱乐休闲",@"业余爱好",@"喜欢的运动",@"喜欢的食物",@"喜欢的电影",@"喜欢的书籍和动漫",@"去过的地方",@"工资"];
    }
    
    return _infoItemLists;
}

- (NSDictionary *)infoItemDic{
    if (!_infoItemDic) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"infoItems" ofType:@"txt"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            _infoItemDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        }
    }
    
    return _infoItemDic;
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

UIButton *NewTextButton(NSString *title, UIColor *textColor){
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 64, 0, 64, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    //    saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    return button;
}

UIButton *NewBackButton(UIColor *color){
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *i = [UIImage imageNamed:@"nav_back"];
    if (color) {
        i = [i imageWithColor:color];
    }
    
    [btn setImage:i forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 64, 44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(10, kEdge, 10, 64 - kEdge - 14);
    return btn;
}

//日期-文本转换
NSDate *dateFromString(NSString *dateString, NSString *format){
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    
    return destDate;
    
}

NSString *stringFromDate(NSDate *date, NSString *format){
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    return destDateString;
}

+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantWidth:(CGFloat)width{
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = 0;
    
    NSStringDrawingOptions drawOptions = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attibutes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:drawOptions attributes:attibutes context:nil].size;
}

+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantHeight:(CGFloat)height{
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = 0;
    
    
    NSStringDrawingOptions drawOptions = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attibutes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:drawOptions attributes:attibutes context:nil].size;
}

/** 将数组转化为json字符串 */
+ (NSString *)convertArrayToJson:(NSArray *)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        if (jsonData && jsonData.length > 0) {
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            return jsonStr;
        }
        return nil;
    } else {
        return nil;
    }
}


/** 将字典转化为json字符串 *///
+ (NSString *)convertDictionaryToJson:(NSDictionary *)dictionary{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        if (jsonData && jsonData.length > 0) {
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            return jsonStr;
        }
        return nil;
    } else {
        return nil;
    }
}

//开始抖动
+ (void)BeginWobble:(UIView *)view{
    srand([[NSDate date] timeIntervalSince1970]);
    float rand = (float)random();
    CFTimeInterval t = rand * 0.0000000001;
    
    [UIView animateWithDuration:0.1 delay:t options:0 animations:^{
        view.transform = CGAffineTransformMakeRotation(-0.01);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^{
            view.transform = CGAffineTransformMakeRotation(0.01);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

//停止抖动
+ (void)EndWobble:(UIView *)view{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

//切圆角
+ (void)roundCornerRadius:(UIView *)view{
    view.layer.cornerRadius = 0.5 * MAX(view.width, view.height);
    view.layer.masksToBounds = YES;
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
