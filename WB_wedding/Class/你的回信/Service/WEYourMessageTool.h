//
//  WEYourMessageTool.h
//  WB_wedding
//
//  Created by 谢威 on 17/2/6.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  你的回信的工具类
 */
@interface WEYourMessageTool : NSObject
/**
 *  查询回复了你的人呢
 *
 *  @param ID      <#ID description#>
 *  @param success <#success description#>
 *  @param failed  <#failed description#>
 */
+ (void)findReplyYourWithID:(NSString *)ID
                       page:(NSString *)page
                       size:(NSString *)size
                    success:(void(^)(id model))success
                     failed:(void(^)(NSString *error))failed;



/**
 *  删除回复你的人
 *
 *  @param ID      <#ID description#>
 *  @param success <#success description#>
 *  @param failed  <#failed description#>
 */
+ (void)deleteLikeYouWithID:(NSString *)ID
                    success:(void(^)(id model))success
                     failed:(void(^)(NSString *error))failed;


/**
 *  设置回复了你的人
 *
 *  @param ID      <#ID description#>
 *  @param success <#success description#>
 *  @param failed  <#failed description#>
 */
+ (void)settingReplyYouWithID:(NSString *)ID
                      success:(void(^)(id model))success
                       failed:(void(^)(NSString *error))failed;



/**
 *  建立关系
 *
 *  @param userID
 *  @param hisOrHerId
 *  @param success
 *  @param failed
 */
+ (void)buildRelationShipWithUserID:(NSString *)userID
                         hisOrHerId:(NSString *)hisOrHerId
                            success:(void(^)(id model))success
                             failed:(void(^)(NSString *error))failed;











@end
