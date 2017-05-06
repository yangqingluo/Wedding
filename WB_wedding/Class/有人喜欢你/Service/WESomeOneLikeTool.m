
//
//  WESomeOneLikeTool.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/4.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WESomeOneLikeTool.h"

@implementation WESomeOneLikeTool

+ (void)getSomeOneLikeYouListWithMID:(NSString *)myId page:(NSString *)page size:(NSString *)size success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    NSDictionary *dic = @{
                          @"myId":myId,
                          @"page":page,
                          @"size":size
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/likeu/find") parameters:dic completionHandler:^(id responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            NSArray *array = responseObj[@"data"][@"content"];
            success(array);
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
        
        
    }];

    
    
    
}


#pragma mark -- 删除喜欢你的人呢
+ (void)deleteLikeYouWithID:(NSString *)ID success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    
    NSDictionary *dic = @{
                          @"id":ID
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/likeu/delete") parameters:dic completionHandler:^(id responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            success(@"删除成功");
            
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
        
        
    }];

    
    
}

#pragma mark  查看喜欢你的人详情
+ (void)lookLikeYouDetailWithID:(NSString *)ID success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    NSDictionary *dic = @{
                          @"id":ID
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/likeu/read") parameters:dic completionHandler:^(id responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            
            
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
        
        
    }];

    
}

#pragma mark -- 查看用户评价
+ (void)lookUserCommentWithID:(NSString *)ID page:(NSString *)page size:(NSString *)size success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    NSDictionary *dic = @{
                          @"myId":ID,
                          @"page":page,
                          @"size":size
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/comment/find") parameters:dic completionHandler:^(id  responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            NSArray *array = responseObj[@"data"][@"content"];
            success(array);
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
     
    }];
        
}

#pragma mark -- 选择你喜欢的人回答问题
+ (void)seletedYourLikeWithID:(NSString *)ID answers:(NSString *)answers success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    NSDictionary *dic = @{
                          @"id":ID,
                          @"answers":answers
                          };
    
    [HQBaseNetManager POST:BASEURL(@"/likeu/chooseanswer") parameters:dic completionHandler:^(id  responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
        
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
    }];
    
    
    
    
}


#pragma mark --  提醒你喜欢的人呢
+ (void)remindYourLikeWithID:(NSString *)ID success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    NSDictionary *dic = @{
                          @"id":ID
                          
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/likeu/remind") parameters:dic completionHandler:^(id  responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            success (@"提醒成功");
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
    }];
    
    
    
}


@end
