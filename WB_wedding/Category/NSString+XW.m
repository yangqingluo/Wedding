//
//  NSString+XW.m
//  ForXiXi
//
//  Created by xiewei on 16/4/14.
//  Copyright © 2016年 龙笛电子商务. All rights reserved.
//

#import "NSString+XW.h"

@implementation NSString (XW)

+ (CGFloat)xw_getStringHeightWithString:(NSString *)string W:(CGFloat)W  font:(NSInteger )font{
    
      return  [string boundingRectWithSize:CGSizeMake(W, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.height;

    
    
}

+ (NSString *)xw_getStringWithTime:(NSTimeInterval )timeString{
    
    NSInteger min = timeString / 60;
    NSInteger seconde = (NSInteger) timeString % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,seconde];
    
}


@end
