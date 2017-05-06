//
//  XWImageBtn.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "XWImageBtn.h"

#define titleRatio 0.7

@implementation XWImageBtn


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置图片居中
    self.imageView.contentMode = UIViewContentModeCenter;
    // 高亮的时候不需要调整图片
    self.adjustsImageWhenHighlighted = NO;
    
}

#pragma mark - 绘制按钮子控件
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.superview.frame.size.height;
    if (width!=0 && height!=0) {
       
        // 图片位置
        
        //背景位置
        self.imageView.frame = CGRectMake(0, -10, self.currentImage.size.width+15, self.currentImage.size.height+15);
        
        self.imageView.center = self.imageView.center;
        
        // 文字位置
        self.titleLabel.frame = CGRectMake(-3,CGRectGetMaxY(self.imageView.frame)-5, width, 16);
        
    }
}

@end