//
//  XWPopView.h
//  SpeedDoctorPatient
//
//  Created by 谢威 on 16/11/15.
//  Copyright © 2016年 chenhong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^popViewActionBack)(NSInteger index);


/**
 *  筛选弹出框
 */
@interface XWPopView : UIView

-(instancetype)initWithItmes:(NSArray *)items popViewActionBack:(popViewActionBack)back;

- (void)showInView:(UIView *)view;

@end
