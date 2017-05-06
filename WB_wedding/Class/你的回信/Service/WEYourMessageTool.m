
//
//  WEYourMessageTool.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/6.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEYourMessageTool.h"

@implementation WEYourMessageTool

#pragma mark -- 查询回复了你的人呢
+ (void)findReplyYourWithID:(NSString *)ID page:(NSString *)page size:(NSString *)size success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    NSDictionary *dic = @{
                          @"myId":ID,
                          @"page":page,
                          @"size":size
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/urreply/find") parameters:dic completionHandler:^(id responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            NSArray *array = responseObj[@"data"][@"content"];
            success(array);
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
        
        
    }];
    

    
}

#pragma mark -- 删除回复你的人
+ (void)deleteLikeYouWithID:(NSString *)ID success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    NSDictionary *dic = @{
                          @"ids":ID
                          };
    
    [[QKNetworkSingleton sharedManager] Post:dic HeadParm:nil URLFooter:@"/urreply/delete" completion:^(id responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            
            success(responseObj);
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
        
        
    }];
    
//    [HQBaseNetManager POST:BASEURL(@"/urreply/delete") parameters:dic completionHandler:^(id responseObj, NSError *error) {
//        
//        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
//          
//            
//            
//        }else{
//            failed(responseObj[@"msg"]);
//            
//        }
//        
//        
//        
//    }];
    
    
    
}



#pragma mark ---  设置回复了你的人
+ (void)settingReplyYouWithID:(NSString *)ID success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    
    NSDictionary *dic = @{
                          @"id":ID
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/urreply/read") parameters:dic completionHandler:^(id responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            success(@"查看成功");
            
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
        
        
    }];
    
    
    
}

#pragma mark -- 建立关系
+ (void)buildRelationShipWithUserID:(NSString *)userID hisOrHerId:(NSString *)hisOrHerId success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    
    
    NSDictionary *dic = @{
                          @"myId":userID,
                          @"hisOrHerId":hisOrHerId
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/urreply/choose") parameters:dic completionHandler:^(id responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            success(@"建立成功");
            
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
        
        
    }];
    
}



@end
