//
//  NSObject+propertyCode.h
//  文艺星球(数据测试)
//
//  Created by 刘人华 on 16/9/7.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (propertyCode)
/**
 *  自动生成属性申明Code
 *
 *  @param dict 传入的字典
 */
+ (void)propertyCodeWithDictionary:(NSDictionary *)dict;
@end
