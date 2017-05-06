//
//  UITableView+XW.m
//  HQ
//
//  Created by 谢威 on 16/10/12.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import "UITableView+XW.h"

#define AnimationTime 0.8

@implementation UITableView (XW)


- (void)animationScaleCell:(UITableViewCell *)cell Scale:(CGFloat)scale{
    CATransform3D  scale3D = CATransform3DMakeScale(0,scale, scale);
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset =  CGSizeMake(10, 10);
    cell.alpha = 0.;
    cell.layer.transform = scale3D;
    [UIView animateWithDuration:AnimationTime delay:0 usingSpringWithDamping:1. initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            cell.layer.transform = CATransform3DIdentity;
                            cell.alpha = 1.;
                            cell.layer.shadowOffset = CGSizeMake(0, 0);
    } completion:^(BOOL finished) {
        
        
    }];
    
}
- (void)animationRotationCell:(UITableViewCell *)cell{
    cell.layer.transform = CATransform3DMakeRotation(M_2_PI,0, 1,0);
    cell.alpha = 0;
    [UIView animateWithDuration:AnimationTime delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1.;
    } completion:^(BOOL finished) {
       
        
    }];
    
}




@end
