//
//  WELoginTool.h
//  WB_wedding
//
//  Created by 谢威 on 17/2/4.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  登录的工具类
 */
@interface WELoginTool : NSObject
/**
 *  登录
 *
 *  @param number
 *  @param latitude
 *  @param loginType
 *  @param longitude
 *  @param password
 *  @param success
 *  @param failed    
 */
+ (void)normalLoginWithNumber:(NSString *)number
                     latitude:(NSString *)latitude
                    loginType:(NSString *)loginType
                    longitude:(NSString *)longitude
                     password:(NSString *)password
                      success:(void(^)(id model))success
                       failed:(void(^)(NSString *error))failed;


@end
