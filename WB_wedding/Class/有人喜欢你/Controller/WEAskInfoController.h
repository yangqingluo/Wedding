//
//  WEAskInfoController.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "HQBaseViewController.h"

typedef enum : NSUInteger {
    WEAskInfoControllerTypeDefault,
    WEAskInfoControllerTypeChangeInfo,
} WEAskInfoControllerType;
/**
 *  查看问卷的控制器
 */
@interface WEAskInfoController : HQBaseViewController
/**
 *  问卷的答案
 */
@property (nonatomic,copy)NSArray       *anserArray;
@property (nonatomic, assign) WEAskInfoControllerType type;

@end
