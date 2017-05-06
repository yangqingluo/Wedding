//
//  UITableView+XW.h
//  HQ
//
//  Created by 谢威 on 16/10/12.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (XW)


/**
 *  从中间慢慢向两边扩大的cell
 *
 *  @param cell  cell description
 *  @param scale scale description
 */
- (void)animationScaleCell:(UITableViewCell *)cell      Scale:(CGFloat)scale;
/**
 *  选择出现的cell
 *
 *  @param cell 
 */
- (void)animationRotationCell:(UITableViewCell *)cell;




@end
