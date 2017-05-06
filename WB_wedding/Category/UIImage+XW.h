//
//  UIImage+XW.h
//  LDCloud
//
//  Created by xiewei on 16/2/29.
//  Copyright © 2016年 xiewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XW)
/**
 *  返回一张没有渲染的图片
 *
 *  @param imageName 图片名
 *
 *  @return 没有渲染的图片
 */
+ (instancetype )xw_imageAlwaysOriginal:(NSString *)imageName;

/**
 *  返回一张从中心拉伸的图片
 *
 *  @param imageName 图片名
 *
 *  @return
 */
+ (instancetype)xw_resizedImageWithName:(NSString *)imageName;

/**
 *  返回一张自定义拉伸比例的图片
 *
 *  @param imageName
 *  @param top
 *  @param top
 *
 *  @return
 */
+ (instancetype)xw_resizedImageWithName:(NSString *)imageName left:(CGFloat)left top:(CGFloat)top;



// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;


@end
