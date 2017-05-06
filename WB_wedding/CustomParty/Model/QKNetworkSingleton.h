//
//  QKNetworkSingleton.h
//  CRM2017
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>
//网络
#import <AFNetworking.h>

#define appUrlAddress @"http://123.207.120.62:80"

#define APP_HTTP_SUCCESS	             	200	//成功

#define clienttype 1

typedef void(^QKNetworkBlock)(id responseBody, NSError *error);
typedef void(^downloadProgress)(float progress);

@interface QKNetworkSingleton : NSObject

BOOL isHttpSuccess(int state);
NSString *httpRespString(NSError *error, NSObject *object);

+ (QKNetworkSingleton *)sharedManager;

//Get
- (void)Get:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion;

//Post
- (void)Post:(id)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion;

- (void)Post:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block completion:(QKNetworkBlock)completion;

//Put
- (void)Put:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion;

//Delete
- (void)Delete:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion;

//download
- (BOOL)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString completion:(QKNetworkBlock)completion withDownLoadProgress:(downloadProgress)progress;


//login
- (void)loginWithID:(NSString *)username Password:(NSString *)password completion:(QKNetworkBlock)completion;

@end
