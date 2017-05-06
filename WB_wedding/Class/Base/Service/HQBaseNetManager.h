//
//  HQBaseNetManager.h
//  HQ
//
//  Created by 谢威 on 16/10/24.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络请求的基类
 */
@interface HQBaseNetManager : NSObject

+ (AFHTTPSessionManager *)sharedAFManager;
/** 对AFHTTPSessionManager的GET请求方法进行了封装 */
+ (id)GET:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void(^)(id responseObj, NSError *error))complete;

/** 对AFHTTPSessionManager的POST请求方法进行了封装 */
+ (id)POST:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void(^)(id responseObj, NSError *error))complete;
/**
 *  为了应付某些服务器对于中文字符串不支持的情况，需要转化字符串为带有%号形势
 *
 *  @param path   请求的路径，即 ? 前面部分
 *  @param params 请求的参数，即 ? 号后面部分
 *
 *  @return 转化 路径+参数 拼接出的字符串中的中文为 % 号形势
 */
+ (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params;

+ (void)POSTImgAndVoiceFile:(NSString *)url_ parameters:(NSDictionary *)paramDic Img:(NSData *)Img name:(NSString *)name fileName:(NSString *)fileName  mineType:(NSString *)type  success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
