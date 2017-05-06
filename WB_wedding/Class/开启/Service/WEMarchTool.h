//
//  WEMarchTool.h
//  WB_wedding
//
//  Created by 谢威 on 17/2/8.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEMarchTool : NSObject

/**
 *  首页匹配
 *
 *  @param userID
 *  @param page
 *  @param size
 *  @param success
 *  @param failed  
 */
+ (void)marchPersonWithID:(NSString *)userID
                     page:(NSString *)page
                     size:(NSString *)size
                  success:(void(^)(id model))success
                   failed:(void(^)(NSString *error))failed;


/**
 *  登录成功就刷新个人信息
 *
 *  @param ID
 *  @param success
 *  @param failed   
 */
+ (void)refreshSelfInfoWithID:(NSString *)ID
                      success:(void(^)(id model))success
                       failed:(void(^)(NSString *error))failed;
@end
