//
//  AppBasicViewController.h
//  helloworld
//
//  Created by chen on 14/6/30.
//  Copyright (c) 2014年 yangqingluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+KGViewExtend.h"

#define iosVersion      ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface AppBasicViewController : UIViewController

/**
 *  宽高比
 */
@property (nonatomic, assign) CGFloat scaleX;
@property (nonatomic, assign) CGFloat scaleY;

@property (nonatomic, strong) UIImageView *navigationBarView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *navBottomLine;

- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem;


@end
