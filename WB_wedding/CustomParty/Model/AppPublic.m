//
//  AppPublic.m
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "AppPublic.h"
#import <CommonCrypto/CommonDigest.h>

#import "UIImage+Color.h"
#import "FirstPageController.h"
#import "BlockAlertView.h"

@interface AppPublic()<CLLocationManagerDelegate>

//定位管理器
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

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

- (void)updateLocation{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            //ios8+以上要授权
            if (IOS_VERSION >=8.0) {
                [self.locationManager requestWhenInUseAuthorization];//使用中授权
            }
            
            [self.locationManager startUpdatingLocation];
        }
        else if ([CLLocationManager locationServicesEnabled]//确定用户的位置服务启用
                 &&   ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)){
            [self.locationManager startUpdatingLocation];
        }
        else{
            BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"请打开系统设置中\"隐私-定位服务\"，允许\"%@\"使用您的位置",self.appName] cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            } otherButtonTitles:@"设置", nil];
            [alert show];
        }
    });
}

#pragma getter
- (NSString *)appName{
    if (!_appName) {
        _appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    
    return _appName;
}

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
        NSString *path = [[NSBundle mainBundle] pathForResource:@"infoItems" ofType:@"txt"];
        if (path) {
            NSArray *keyValuesArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
            _infoItemLists = [UserInfoItemData mj_objectArrayWithKeyValuesArray:keyValuesArray];
        }
    }
    
    return _infoItemLists;
}

- (NSDictionary *)infoItemDic{
    if (!_infoItemDic) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        for (UserInfoItemData *item in self.infoItemLists) {
            [dic setObject:item.subItems forKey:item.key];
        }
        
        _infoItemDic = [NSDictionary dictionaryWithDictionary:dic];
    }
    
    return _infoItemDic;
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        
        if ([CLLocationManager locationServicesEnabled]) {
            _locationManager.delegate = self;
            _locationManager.distanceFilter = 10000.0;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        }else{
            NSLog(@"定位失败，请确定是否开启定位功能");
        }
    }
    
    return _locationManager;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *cl = [locations lastObject];
    
    if (cl) {
        self.location = cl;
//        [manager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
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

//图像压缩
NSData *dataOfImageCompression(UIImage *image, BOOL isHead){
    //头像图片
    if (isHead) {
        //调整分辨率
        if (image.size.width > headImageSizeMax || image.size.height > headImageSizeMax) {
            //压缩图片
            CGSize newSize = CGSizeMake(image.size.width, image.size.height);
            
            CGFloat tempHeight = newSize.height / headImageSizeMax;
            CGFloat tempWidth = newSize.width / headImageSizeMax;
            
            if (tempWidth > 1.0 && tempWidth > tempHeight) {
                newSize = CGSizeMake(image.size.width / tempWidth, image.size.height / tempWidth);
            }
            else if (tempHeight > 1.0 && tempWidth < tempHeight){
                newSize = CGSizeMake(image.size.width / tempHeight, image.size.height / tempHeight);
            }
            
            UIGraphicsBeginImageContext(newSize);
            [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        
    }
    
    //调整大小
    CGFloat scale = 1.0;
    NSData *imageData;
    
    do {
        if (imageData) {
            scale *= (imageDataMax / imageData.length);
        }
        imageData = UIImageJPEGRepresentation(image, scale);
    } while (imageData.length > imageDataMax);
    
    return imageData;
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
    NSDictionary *attibutes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:drawOptions attributes:attibutes context:nil].size;
}

+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantHeight:(CGFloat)height{
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = 0;
    
    
    NSStringDrawingOptions drawOptions = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attibutes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
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
    [AppPublic roundCornerRadius:view cornerRadius:0.5 * MAX(view.width, view.height)];
}

+ (void)roundCornerRadius:(UIView *)view cornerRadius:(CGFloat)radius{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

- (void)logOut{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kUserData];
    _userData = nil;
    
    self.mainTabNav = nil;
    [self goToLoginCompletion:^{
        
    }];
    
}

- (void)loginDoneWithUserData:(NSDictionary *)data username:(NSString *)username password:(NSString *)password{
    if (!data || !username) {
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:username forKey:kUserName];
    
    [self saveUserData:[AppUserData mj_objectWithKeyValues:data]];
    [self goToMainVC];
}

- (void)saveUserData:(AppUserData *)data{
    if (!data) {
        return;
    }
    _userData = [data copy];
    NSDictionary *dic = [_userData mj_keyValues];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:dic forKey:kUserData];
}

- (void)goToMainVC{
    self.mainTabNav = [MainTabNavController new];
    [[UIApplication sharedApplication].delegate window].rootViewController = self.mainTabNav;
}

- (void)goToLoginCompletion:(void (^)(void))completion{
    FirstPageController *vc = [FirstPageController new];
    
    [UIApplication sharedApplication].delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    if (completion) {
        completion();
    }
    
}

@end
