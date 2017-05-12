//
//  QKNetworkSingleton.m
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "QKNetworkSingleton.h"

@implementation QKNetworkSingleton

+ (QKNetworkSingleton *)sharedManager{
    static QKNetworkSingleton *sharedQKNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedQKNetworkSingleton = [[self alloc] init];
    });
    return sharedQKNetworkSingleton;
}

- (AFHTTPSessionManager *)baseHttpRequestWithParm:(NSDictionary *)parm{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:30];
    
    for (NSString *key in parm.allKeys) {
        if (parm[key]) {
            [manager.requestSerializer setValue:parm[key] forHTTPHeaderField:key];
        }
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    return manager;
}

NSString *urlStringWithService(NSString *service){
    return [NSString stringWithFormat:@"%@%@",appUrlAddress,service];
}

#pragma public
BOOL isHttpSuccess(int state){
    return state == APP_HTTP_SUCCESS;
}

NSString *httpRespString(NSError *error, NSObject *object){
    if (error) {
        return @"网络出错";
    }
    
    NSString *noticeString = @"出错";
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        int state = [[(NSDictionary *)object objectForKey:@"State"] intValue];
        
        switch (state) {
            case APP_HTTP_SUCCESS:{
                noticeString = @"成功";
                
            }
                
            default:{
                noticeString = [NSString stringWithFormat:@"状态码: %d",state];
            }
                break;
        }
        
    }
    
    return noticeString;
}

//Get
- (void)Get:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm];
    NSString *urlStr = [urlStringWithService(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:urlStr parameters:userInfo progress:^(NSProgress * _Nonnull downloadProgress){
        
    } success:^(NSURLSessionDataTask *task, id responseObject){
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        completion(nil, error);
    }];
}
//Post
- (void)Post:(id)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm];
    NSString *urlStr = [urlStringWithService(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo progress:^(NSProgress * _Nonnull downloadProgress){
        
    } success:^(NSURLSessionDataTask *task, id responseObject){
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        if ([self occuredRemoteLogin:task]) {
            completion(task, error);
        }
        else{
            completion(nil, error);
        }
    }];
}

- (void)Post:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block completion:(QKNetworkBlock)completion{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm];
    NSString *urlStr = [urlStringWithService(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:urlStr parameters:userInfo constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull downloadProgress){
        
    } success:^(NSURLSessionDataTask *task, id responseObject){
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        completion(nil, error);
    }];
}

//Put
- (void)Put:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm];
    NSString *urlStr = [urlStringWithService(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager PUT:urlStr parameters:userInfo success:^(NSURLSessionDataTask *task, id responseObject){
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        completion(nil, error);
    }];
}

//Delete
- (void)Delete:(NSDictionary *)userInfo HeadParm:(NSDictionary *)parm URLFooter:(NSString *)urlString completion:(QKNetworkBlock)completion{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithParm:parm];
    NSString *urlStr = [urlStringWithService(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager DELETE:urlStr parameters:userInfo success:^(NSURLSessionDataTask *task, id responseObject){
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error){
        completion(nil, error);
    }];
}

//download
- (BOOL)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString completion:(QKNetworkBlock)completion withDownLoadProgress:(downloadProgress)progress{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completion(nil, error);
    }];
    
    [task resume];
    if (task) {
        return YES;
    }
    else{
        return NO;
    }
}


//login
- (void)loginWithID:(NSString *)username Password:(NSString *)password completion:(QKNetworkBlock)completion{
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"username":username, @"password":sha1(password), @"clienttype":@clienttype}];
    [self Get:postDic HeadParm:nil URLFooter:@"user/loginsystem " completion:^(id responseBody, NSError *error){
        completion(responseBody, error);
        
        if (!error && isHttpSuccess([responseBody[@"Status"] intValue])) {
            [[AppPublic getInstance] loginDonewithUserData:responseBody username:username password:password];
        }
    }];
}

#pragma private
- (BOOL)occuredRemoteLogin:(id)object{
    
    
    return NO;
}

@end
