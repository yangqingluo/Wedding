//
//  WEMarchTool.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/8.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEMarchTool.h"
#import "WEHomeCacheTool.h"
@implementation WEMarchTool


#pragma mark -- 首页匹配
+ (void)marchPersonWithID:(NSString *)userID page:(NSString *)page size:(NSString *)size success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    NSDictionary *dic = @{
                          @"page":page,
                          @"size":size,
                          @"userId":userID
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/match/find") parameters:dic completionHandler:^(id  responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            NSArray *array = responseObj[@"data"][@"content"];
            
            // 存入数据库
            [WEHomeCacheTool saveHomeInfoWithArray:array];
            
            /**
             *  首页匹配的总人数
             */
            [KUserDefaults setObject:responseObj[@"data"][@"totalElements"] forKey:KHomeSize];
            
            
             success(array);
            
            
        }else{
            failed(responseObj[@"msg"]);
            
            
            
            
        }
        
    }];

    
    
}

#pragma mark ---- 刷新个人信息
+ (void)refreshSelfInfoWithID:(NSString *)ID success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    
    NSDictionary *dic = @{
                         
                          @"userId":ID
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/user/findonebyid") parameters:dic completionHandler:^(id  responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
//            [XWUserModel removeUserInfoFromlocal];
            
            XWUserModel *model = [XWUserModel mj_objectWithKeyValues:responseObj[@"data"]];
            
            BOOL flag = [model saveUserInfo];
            
            if (flag) {
                NSLog(@"用户模型存入成功===============%@",responseObj);
            }else{
                NSLog(@"用户模型存入失败");
            }
            // 1.记录登录信息
            
//            [KUserDefaults setObject:model.xw_id forKey:KPhoneNumber];
//            
//            // 2.账号保存到userdefault
//            UserDefaultSetObjectForKey(dic[@"telNumber"], USERACCOUNT);
//            
            
            
            
            
        }else{
            failed(responseObj[@"msg"]);
            
            
            
            
        }
        
    }];
    
}


@end
