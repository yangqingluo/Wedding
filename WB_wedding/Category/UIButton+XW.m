//
//  UIButton+XW.m
//  HQ
//
//  Created by 谢威 on 16/10/18.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import "UIButton+XW.h"

@implementation UIButton (XW)


+ (instancetype)xw_title:(NSString *)title titleColor:(UIColor *)titleColor font:(CGFloat)font tagrt:(id)tagrt sel:(SEL)sel{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
     btn.titleLabel.font = KFont(font);
    [btn addTarget:tagrt action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
    
    
}

@end
