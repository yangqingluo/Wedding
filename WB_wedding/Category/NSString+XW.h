//
//  NSString+XW.h
//  ForXiXi
//
//  Created by xiewei on 16/4/14.
//  Copyright © 2016年 龙笛电子商务. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (XW)
/**
 *   返回文字的高度
 *
 *  @param string
 *  @param W      W description
 *  @param font
 *
 *  @return
 */
+ (CGFloat)xw_getStringHeightWithString:(NSString *)string W:(CGFloat)W  font:(NSInteger )font;

/**
 *  根据时间获取02:32 这个格式的字符串
 *
 *  @param timeString 
 *
 *  @return
 */
+  (NSString *)xw_getStringWithTime:(NSTimeInterval )timeString;


@end
