//
//  WESomeOneLikeTool.h
//  WB_wedding
//
//  Created by 谢威 on 17/2/4.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  有人喜欢你的工具类
 */
@interface WESomeOneLikeTool : NSObject
/**
 *  获取有人喜欢的列表
 *
 *  @param myId
 *  @param page
 *  @param size
 *  @param success
 *  @param failed  
 */
+ (void)getSomeOneLikeYouListWithMID:(NSString *)myId
                                page:(NSString *)page
                                size:(NSString *)size
                             success:(void(^)(id model))success
                              failed:(void(^)(NSString *error))failed;




/**
 *  删除喜欢你的人
 *
 *  @param ID      <#ID description#>
 *  @param success <#success description#>
 *  @param failed  <#failed description#>
 */
+ (void)deleteLikeYouWithID:(NSString *)ID
                    success:(void(^)(id model))success
                     failed:(void(^)(NSString *error))failed;



/**
 *  查看喜欢你的人详情
 *
 *  @param ID      <#ID description#>
 *  @param success <#success description#>
 *  @param failed  <#failed description#>
 */
+ (void)lookLikeYouDetailWithID:(NSString *)ID
                        success:(void(^)(id model))success
                         failed:(void(^)(NSString *error))failed;


/**
 *  查看用户评价
 *
 *  @param ID
 *  @param page
 *  @param size
 *  @param success
 *  @param failed  
 */
+ (void)lookUserCommentWithID:(NSString *)ID
                         page:(NSString *)page
                         size:(NSString *)size
                      success:(void(^)(id model))success
                       failed:(void(^)(NSString *error))failed;


/**
 *  选择你喜欢的人回答问题
 *
 *  @param ID      <#ID description#>
 *  @param answers <#answers description#>
 *  @param success <#success description#>
 *  @param failed  <#failed description#>
 */
+ (void)seletedYourLikeWithID:(NSString *)ID
                      answers:(NSString *)answers
                      success:(void(^)(id model))success
                       failed:(void(^)(NSString *error))failed;


/**
 *  提醒你喜欢的人呢
 *
 *  @param ID      <#ID description#>
 *  @param success <#success description#>
 *  @param failed  <#failed description#>
 */
+ (void)remindYourLikeWithID:(NSString *)ID
                     success:(void(^)(id model))success
                      failed:(void(^)(NSString *error))failed;





@end
