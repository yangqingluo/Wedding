//
//  XWTitleBottomBtn.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/3.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "XWTitleBottomBtn.h"
#define titleRatio 0.7

@implementation XWTitleBottomBtn


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 设置图片居中
    self.imageView.contentMode = UIViewContentModeCenter;
    // 高亮的时候不需要调整图片
    self.adjustsImageWhenHighlighted = NO;
    
}
/**
 *  按钮里面的文字的大小  和 位置
 */

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0,contentRect.size.height*titleRatio,contentRect.size.width,contentRect.size.height*(1-titleRatio));
    

    
}



/**
 *  按钮里面图片的大小和位置
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((self.frame.size.width - contentRect.size.width)/2,2,contentRect.size.width,contentRect.size.height*titleRatio);
    
    
}
@end
