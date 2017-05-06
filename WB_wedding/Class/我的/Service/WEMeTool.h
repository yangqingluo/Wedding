//
//  WEMeTool.h
//  WB_wedding
//
//  Created by 谢威 on 17/2/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  我的 这个模块的 工具类
 */
@interface WEMeTool : NSObject
/**
 *  查询我的恋爱记录
 *
 *  @param ids
 *  @param page
 *  @param size
 *  @param success
 *  @param failed  
 */
+ (void)QueryMyLoveRecoderWithIDS:(NSString *)ids
                             page:(NSString *)page
                             size:(NSString *)size
                          success:(void(^)(id model))success
                           failed:(void(^)(NSString *error))failed;


/**
 *  查询对方是否发生过负荷消息
 *
 *  @param mid        <#mid description#>
 *  @param hisOrHerId <#hisOrHerId description#>
 *  @param success    <#success description#>
 *  @param failed     <#failed description#>
 */
+(void)queryOppositeWithMyId:(NSString *)mid
                  hisOrHerId:(NSString *)hisOrHerId
                     success:(void(^)(id model))success
                      failed:(void(^)(NSString *error))failed;


/**
 *  发送复合消息
 *
 *  @param content
 *  @param imgName
 *  @param myId
 *  @param otherId
 *  @param otherNickName
 *  @param success
 *  @param failed
 */
+ (void)postFuheMessageWithContent:(NSString *)content
                           imgName:(NSString *)imgName
                              myId:(NSString *)myId
                           otherId:(NSString *)otherId
                     otherNickName:(NSString *)otherNickName
                           success:(void(^)(id model))success
                            failed:(void(^)(NSString *error))failed;



@end
