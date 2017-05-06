//
//  XWDatePickerView.h
//  HQ
//
//  Created by 谢威 on 16/9/28.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBack)(NSString *date);

/**
 *  时间选择的picker
 */
@interface XWDatePickerView : UIView

- (instancetype)initWithCallBack:(CallBack)callBack;
- (void)show;

@end
