//
//  XWPickerView.h
//  HQ
//
//  Created by 谢威 on 16/9/28.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CallBack)(NSString *seletedString);
/**
 *  自定义的picker
 */
@interface XWPickerView : UIView


- (instancetype)initWithCallBack:(CallBack)callBack WithDataSource:(NSArray *)dataSource;
- (void)show;

@end
