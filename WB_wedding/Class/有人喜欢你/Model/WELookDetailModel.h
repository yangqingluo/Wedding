//
//  WELookDetailModel.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WELookDetailModel : NSObject

/**
 *
 */
@property(nonatomic,copy)NSString *title;

/**
 *
 */
@property(nonatomic,copy)NSString *content;
+ (instancetype)modelWithTitle:(NSString *)title content:(NSString *)content;
- (CGFloat)xw_cellHeight;

@end
