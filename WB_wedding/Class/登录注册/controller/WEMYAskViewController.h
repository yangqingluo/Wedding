//
//  WEMYAskViewController.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "HQBaseViewController.h"

typedef void(^AskVCBlock)(NSString *questions);
/**
 *  我的提问
 */
@interface WEMYAskViewController : HQBaseViewController
@property (nonatomic, copy) void(^blockAskBlock)(NSString *questions);
@property (nonatomic, strong) NSString *questionStr;
@end
