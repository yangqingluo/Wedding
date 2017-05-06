//
//  WEHomeCacheTool.h
//  WB_wedding
//
//  Created by 谢威 on 17/2/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  首页缓存的工具类
 */
@interface WEHomeCacheTool : NSObject

/**
 *  存入信息
 *
 *  @param array <#array description#>
 */
+ (void)saveHomeInfoWithArray:(NSArray *)array;


/**
 *  读取全部数据
 *
 *  @return
 */
+ (NSArray *)readAllInfo;

/**
 *  更具ID 去删除
 *
 *  @param ID 
 */
+ (void)deleteInfoWithID:(NSString *)ID;













@end
