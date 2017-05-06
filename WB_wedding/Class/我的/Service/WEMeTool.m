
//
//  WEMeTool.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEMeTool.h"

@implementation WEMeTool

#pragma mark -- 查询我的恋爱记录

+ (void)QueryMyLoveRecoderWithIDS:(NSString *)ids
                             page:(NSString *)page
                             size:(NSString *)size
                          success:(void(^)(id model))success
                           failed:(void(^)(NSString *error))failed{
    
    
    NSDictionary *dic = @{
                          @"ids":ids,
                          @"page":page,
                          @"size":size
                        
                          };
    
    
    
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


   [manager POST:BASEURL(@"/loverecord/findexlovers") parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
       
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObj) {
       
       if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
           success(responseObj[@"data"][@"content"]);
           
       }else{
           failed(responseObj[@"msg"]);
           
           
           
           
       }

       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
   }];


//
//    [HQBaseNetManager POST:BASEURL(@"/loverecord/findexlovers") parameters:dic completionHandler:^(id  responseObj, NSError *error) {
//        
//        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
//            success(responseObj[@"data"][@"content"]);
//            
//        }else{
//            failed(responseObj[@"msg"]);
//            
//            
//            
//            
//        }
//        
//    }];

    
}

#pragma mark --  查询对方是否发生过负荷消息

+ (void)queryOppositeWithMyId:(NSString *)mid hisOrHerId:(NSString *)hisOrHerId success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    NSDictionary *dic = @{
                          @"myId":mid,
                          @"hisOrHerId":hisOrHerId
                    };
    
    
    
    
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
    
    
    [manager POST:BASEURL(@"/loverecord/relove") parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObj) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            success(responseObj[@"data"]);
            
        }else{
            failed(responseObj[@"msg"]);
            
            
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    

    
  

    
    
    
}


#pragma mark -- 发送复合消息
+ (void)postFuheMessageWithContent:(NSString *)content imgName:(NSString *)imgName myId:(NSString *)myId otherId:(NSString *)otherId otherNickName:(NSString *)otherNickName success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    NSDictionary *dic = @{
                          @"content":content,
                          @"imgName":imgName,
                          @"otherId":otherId,
                          @"otherNickName":otherNickName,
                          @"myId":myId
                          };
    NSDictionary *diccc = @{
                            @"dto":dic
                            };
    
    
    
    [HQBaseNetManager POST:BASEURL(@"/loverecord/sendrelovemsg") parameters:diccc completionHandler:^(id  responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            
            success(@"发送成功");
            
        }else{
            failed(responseObj[@"msg"]);
            
            
            
            
        }
        
    }];
    

    
  
    
    
    
}

@end
