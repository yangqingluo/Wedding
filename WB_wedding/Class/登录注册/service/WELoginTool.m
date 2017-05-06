//
//  WELoginTool.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/4.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WELoginTool.h"
#import "XWUserModel.h"
@implementation WELoginTool

+ (void)normalLoginWithNumber:(NSString *)number latitude:(NSString *)latitude loginType:(NSString *)loginType longitude:(NSString *)longitude password:(NSString *)password success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    NSDictionary *dic;
    if ([loginType isEqualToString:@"1"]) {
        
      dic = @{
                              @"latitude":latitude,
                              @"loginType":loginType,
                              @"longitude":longitude,
                              @"password":password,
                              @"telNumber":number
                              
                              };

        
    }else{
            dic = @{
                              @"latitude":latitude,
                              @"loginType":loginType,
                              @"longitude":longitude,
                              @"password":password,
                              @"telNumber":number
                              
                              };

    }
    
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
//    
//    NSString *ss;
//    if (jsonData && jsonData.length > 0) {
//           ss = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//            
//            
//        }
  
//        NSDictionary *dic2 = @{
//                               @"dto":dic
//                               };
    
    [HQBaseNetManager POST:BASEURL(@"/user/login") parameters:dic completionHandler:^(id responseObj, NSError *error) {
       
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            
            XWUserModel *model = [XWUserModel mj_objectWithKeyValues:responseObj[@"data"]];
            BOOL flag = [model saveUserInfo];
            if (flag) {
                NSLog(@"用户模型存入成功===============%@",responseObj);
            }else{
                NSLog(@"用户模型存入失败");
            }
            // 1.记录登录信息
            [model saveLoginInfoWithAccout:number pwd:password];
            [KUserDefaults setObject:model.xw_id forKey:KPhoneNumber];
            
            // 2.账号保存到userdefault
            UserDefaultSetObjectForKey(dic[@"telNumber"], USERACCOUNT);
            
            success(model);
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
        
        
    }];
    
}
@end

