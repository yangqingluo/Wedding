//
//  UIImage+XW.m
//  LDCloud
//
//  Created by xiewei on 16/2/29.
//  Copyright © 2016年 xiewei. All rights reserved.
//

#import "UIImage+XW.h"
#import <objc/message.h>
//#import <objc/Object.h>
#import <objc/runtime.h>
@implementation UIImage (XW)

+(void)load{
    Method imageName = class_getClassMethod(self, @selector(imageNamed:));
    Method xw_imageName = class_getClassMethod(self, @selector(xw_imageName:));
    method_exchangeImplementations(imageName, xw_imageName);
    
}

+ (instancetype)xw_imageName:(NSString *)name{
    UIImage *iamge = [self xw_imageName:name];
    if (iamge==nil) {
        NSLog(@"加载了空的图片了");
    }
    return iamge;
    
}



+ (instancetype )xw_imageAlwaysOriginal:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}


+ (instancetype)xw_resizedImageWithName:(NSString *)imageName{
    
    UIImage *image = [self imageNamed:imageName];
    
    return[image stretchableImageWithLeftCapWidth:image.size.width * 0.5  topCapHeight:image.size.height * 0.5];
    
    
}

+ (instancetype)xw_resizedImageWithName:(NSString *)imageName left:(CGFloat)left top:(CGFloat)top{
    
    UIImage *image = [UIImage imageNamed:imageName];
    return[image stretchableImageWithLeftCapWidth:image.size.width *left  topCapHeight:image.size.height * top];
    
    
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}



@end
