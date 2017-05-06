//
//  WESeletedController.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/23.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "HQBaseViewController.h"


typedef void(^backAction)(NSString *s);

@interface WESeletedController : HQBaseViewController


-(instancetype)initWithDataSource:(NSArray *)data title:(NSString *)title type:(NSString *)type maxCount:(NSInteger)count back:(backAction)back originalString:(NSString *)originalStr;

@end
