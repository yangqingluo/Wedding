//
//  HQBaseNetManager.m
//  HQ
//
//  Created by 谢威 on 16/10/24.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import "HQBaseNetManager.h"
static AFHTTPSessionManager *manager = nil;
@implementation HQBaseNetManager

+ (AFHTTPSessionManager *)sharedAFManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
        manager.requestSerializer.timeoutInterval = 10.0;
        [manager.securityPolicy setAllowInvalidCertificates:YES];
//        manager.allowsInvalidSSLCertificate = YES;
        
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//        AFHTTPRequestSerializer  *requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        manager.requestSerializer = requestSerializer;
        
        manager.securityPolicy.allowInvalidCertificates=YES;
        
        manager.responseSerializer.acceptableContentTypes =
        
        [NSSet setWithObjects:@"text/html",@"text/json", nil];
        
        // 设置MIME格式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
            });
    return manager;
}

+ (id)GET:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void(^)(id responseObj, NSError *error))complete{
    return [[self sharedAFManager]GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
        complete(nil, error);
    }];
}

+ (id)POST:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void(^)(id responseObj, NSError *error))complete{
    
    
    
    NSString *pathStr = [ self percentPathWithPath:path params:params];
    NSLog(@"请求路径:%@",pathStr);
    
    return [[self sharedAFManager]POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(responseObject, nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
        
        complete(nil, error);
    }];
}

+ (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params{
    NSMutableString *percentPath =[NSMutableString stringWithString:path];
    NSArray *keys = params.allKeys;
    NSInteger count = keys.count;
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            [percentPath appendFormat:@"?%@=%@", keys[i], params[keys[i]]];
        }else{
            [percentPath appendFormat:@"&%@=%@", keys[i], params[keys[i]]];
        }
    }
    return [percentPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}



#pragma mark -- 上传语音和图片
+ (void)POSTImgAndVoiceFile:(NSString *)url_ parameters:(NSDictionary *)paramDic Img:(NSData *)Img name:(NSString *)name fileName:(NSString *)fileName  mineType:(NSString *)type  success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    // 对URL进行转换，URL不能包含ASCII字符集中的字符，需要对ASCII字符进行转换
    NSString *url = [url_ stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    
    AFHTTPSessionManager  * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    //        manager.allowsInvalidSSLCertificate = YES;
    
    //    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    AFHTTPRequestSerializer  *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //
    //    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.requestSerializer = requestSerializer;
    
    manager.securityPolicy.allowInvalidCertificates=YES;
    
    manager.responseSerializer.acceptableContentTypes =
    
    [NSSet setWithObjects:@"text/html",@"text/json", nil];
    
    // 设置MIME格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    
  
    [manager POST:url parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
          [formData appendPartWithFileData:Img name:@"file" fileName:fileName mimeType:type];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                if (success) {
                    success(responseObject);
                }

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    [[self sharedAFManager]POST:url parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:Img name:name fileName:fileName mimeType:type];
//        
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        if (success) {
//            success(responseObject);
//        }
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//        
//        
//        
//        
//    }];
    
    
}



@end
