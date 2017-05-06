//
//  WEImageTopBtn.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/3.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEImageTopBtn.h"
#define titleRatio 0.7
@implementation WEImageTopBtn


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 设置图片居中
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    // 高亮的时候不需要调整图片
    self.adjustsImageWhenHighlighted = NO;
    
}
/**
 *  按钮里面的文字的大小  和 位置
 */

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat X = 0;
    CGFloat Y = contentRect.size.height *titleRatio+5;
    CGFloat titleH = contentRect.size.height*(1-titleRatio);
    CGFloat titleW = contentRect.size.width;
    
    return CGRectMake(X,Y,titleW,titleH);
    
}
/**
 *  按钮里面图片的大小和位置
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat X = 0;
    CGFloat W = contentRect.size.width;
    return CGRectMake(X,0,W,contentRect.size.height*titleRatio);
    
    
}
@end
