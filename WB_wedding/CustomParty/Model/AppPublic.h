//
//  AppPublic.h
//  SafetyOfMAS
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppType.h"
#import "QKNetworkSingleton.h"
#import "UIView+KGViewExtend.h"

#import "EaseUI.h"

//键盘
#import <IQKeyboardManager.h>
//布局
#import <Masonry.h>
//弹出视图
#import <MBProgressHUD.h>
//json解析
#import <MJExtension.h>
//下拉刷新
#import <MJRefresh.h>
//轮播
#import <SDCycleScrollView.h>
//图片下载
#import <SDImageCache.h>


#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#define deepNavigationBarColor       RGBA(0xff, 0x67, 0x6c, 1.0)
#define navigationBarColor           RGBA(0xfb, 0x72, 0x72, 1.0)
#define separaterColor               RGBA(0xe5, 0xe5, 0xe5, 1)
#define separaterAlphaColor          RGBA(0xe5, 0xe5, 0xe5, 0.6)

#define baseBlueColor                RGBA(0x00, 0x84, 0xff, 1)
#define lightWhiteColor              RGBA(0xf5, 0xf5, 0xf5, 1)

#define STATUS_HEIGHT 20.0
#define STATUS_BAR_HEIGHT 64.0
#define TAB_BAR_HEIGHT 49.0
#define DEFAULT_BAR_HEIGHT 44.0

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

#define kButtonCornerRadius          4.0
#define kEdgeSmall   5.0
#define kEdge   10.0
#define kEdgeMiddle   15.0
#define kEdgeBig   20.0


#define kUserName                    @"username_wedding"
#define kUserData                    @"userdata_wedding"


#define EMPassword          @"123456"
#define downloadImagePlace  @"download_image_default"

@interface AppPublic : NSObject

@property (nonatomic, strong) AppUserData *userData;
@property (nonatomic, strong) NSArray *infoItemLists;

+ (AppPublic *)getInstance;

/*!
 @brief 检查版本是否第一次使用
 */
BOOL isFirstUsing();

/*!
 @brief sha1加密
 */
NSString *sha1(NSString *string);

//new button
UIButton *NewTextButton(NSString *title, UIColor *textColor);
UIButton *NewBackButton(UIColor *color);

//日期-文本转换
NSDate *dateFromString(NSString *dateString, NSString *format);
NSString *stringFromDate(NSDate *date, NSString *format);

+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantWidth:(CGFloat)width;
+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantHeight:(CGFloat)height;

//开始抖动
+ (void)BeginWobble:(UIView *)view;

//停止抖动
+ (void)EndWobble:(UIView *)view;

//切圆角
+ (void)roundCornerRadius:(UIView *)view;


/** 将数组转化为json字符串 */
+ (NSString *)convertArrayToJson:(NSArray *)array;

/** 将字典转化为json字符串 *///
+ (NSString *)convertDictionaryToJson:(NSDictionary *)dictionary;

- (void)logOut;
- (void)loginDonewithUserData:(NSDictionary *)data username:(NSString *)username password:(NSString *)password;

- (void)goToMainVC;
- (void)goToLoginCompletion:(void (^)(void))completion;

@end
