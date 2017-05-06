//
//  WEMyChatTool.h
//  WB_wedding
//
//  Created by 谢威 on 17/2/8.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEMyChatTool : NSObject

/**
 *  分手
 *
 *  @param ID         <#ID description#>
 *  @param hisOrHerId <#hisOrHerId description#>
 *  @param success    <#success description#>
 *  @param failed     <#failed description#>
 */
+ (void)breakOutWithID:(NSString *)ID
            hisOrHerId:(NSString *)hisOrHerId
               success:(void(^)(id model))success
                failed:(void(^)(NSString *error))failed;

/**
 *  打开定位
 *
 *  @param myId       <#myId description#>
 *  @param hisOrHerId <#hisOrHerId description#>
 *  @param success    <#success description#>
 *  @param failed     <#failed description#>
 */
+ (void)openLocationWithMyId:(NSString *)myId
                  hisOrHerId:(NSString *)hisOrHerId
                     success:(void(^)(id model))success
                      failed:(void(^)(NSString *error))failed;



/**
 *  获取对方的定位
 *
 *  @param hisOrHerId
 *  @param page
 *  @param size
 *  @param success    <#success description#>
 *  @param failed     
 */
+ (void)getHisHerLocationWithID:(NSString *)hisOrHerId
                           page:(NSString *)page
                           size:(NSString *)size
                        success:(void(^)(id model))success
                         failed:(void(^)(NSString *error))failed;







/**
 *  上传背景图片
 *
 *  @param timeEventId
 *  @param imag
 *  @param success
 *  @param failed      
 */
+ (void)postBgPicWithtimeEventId:(NSString *)timeEventId
                            imag:(UIImage *)imag
                         success:(void(^)(id model))success
                          failed:(void(^)(NSString *error))failed;










@end
