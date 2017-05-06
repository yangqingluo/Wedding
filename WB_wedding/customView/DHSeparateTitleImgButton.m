//
//  DHSeparateTitleImgButton.m
//  LiteratureStar
//
//  Created by 刘人华 on 16/9/9.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "DHSeparateTitleImgButton.h"

@implementation DHSeparateTitleImgButton {
    CGSize titleSize;
    CGFloat buttonWidth;
    CGFloat buttonHeight;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    buttonWidth = self.frame.size.width;
    buttonHeight = self.frame.size.height;
    /**
     *  获取字符的大小
     */
    titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(buttonWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGRect retValue = CGRectMake(0, buttonHeight - titleSize.height, contentRect.size.width, titleSize.height);
    return retValue;
}
- (CGRect)backgroundRectForBounds:(CGRect)bounds {
    
    CGRect retValue = CGRectMake(buttonWidth / 2.0 - (buttonHeight - titleSize.height) / 2.0 + 5, 5, buttonHeight - titleSize.height - 10, buttonHeight - titleSize.height - 10);
    return retValue;
}
@end
