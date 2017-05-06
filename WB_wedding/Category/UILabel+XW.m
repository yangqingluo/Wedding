//
//  UILabel+XW.m
//  HQ
//
//  Created by 谢威 on 16/9/26.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import "UILabel+XW.h"

@implementation UILabel (XW)


- (void)xw_setLableFont:(CGFloat)font text:(NSString *)text textColor:(UIColor *)color textAliment:(NSTextAlignment)aliment{
    
    self.text = text;
    self.textAlignment = aliment;
    self.textColor = color;
    self.font = KFont(font);
    
}

@end
