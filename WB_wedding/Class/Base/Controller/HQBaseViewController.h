//
//  HQBaseViewController.h
//  HQ
//
//  Created by 谢威 on 16/9/19.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseNavigationBar.h"

typedef void(^actionBack)(void);
/**
 *  所有控制器的基类
 */
@interface HQBaseViewController : UIViewController
/**
 *  宽高比
 */
@property (nonatomic, assign) CGFloat scaleX;
@property (nonatomic, assign) CGFloat scaleY;
/**
 *  自定义的导航栏 系统的导航栏被隐藏了
 */
@property (nonatomic,strong)HQBaseNavigationBar  *baseNavigationBar;
/**
 *  状态栏
 */
@property (nonatomic,strong) UIView *statusView;


@property (nonatomic, strong) UIColor *navBarColor;
- (void)hidenNavigationBar;
- (void)showNavigationBar;

/**
 *  配置数据源
 */
- (void)configDataSource;
/**
 *  配置UI
 */
- (void)configUserInterface;
/**
 *  刷新数据
 */
- (void)refreshData;
/**
 *  在哪个视图层上显示
 *
 *  @param msg
 *  @param view
 */
- (void)showMessage:(NSString *)msg toView:(UIView *)view;

/**
 *  提示没网络
 */
- (void)showNoNetError;

/**
 *  显示菊花
 */
- (void)showActivity;
/**
 *  关闭菊花
 */
- (void)cancleActivity;


/**
 *  设置右边的导航栏上的图片按钮
 *
 *  @param imageName 图片
 *  @param back
 */
- (void)setNavigationRightBtnWithImageName:(NSString *)imageName actionBack:(actionBack)back;

/**
 *  设置右边的导航栏上的文字按钮
 *
 *  @param imageName 文字
 *  @param back
 */
- (void)setNavigationRightBtnWithTitle:(NSString *)title actionBack:(actionBack)back;
- (void)setNavigationRightBtnWithTitle:(NSString *)title selecterBack:(SEL)sel;

//检测是否是手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum;






/** 将数组转化为json字符串 */
- (NSString *)convertArrayToJson:(NSArray *)array;

/** 将字典转化为json字符串 */
- (NSString *)convertDictionaryToJson:(NSDictionary *)dictionary;


@end
