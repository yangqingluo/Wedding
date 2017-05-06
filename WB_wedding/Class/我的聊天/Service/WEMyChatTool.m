//
//  WEMyChatTool.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/8.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEMyChatTool.h"

@implementation WEMyChatTool


#pragma mark -- 分手
+ (void)breakOutWithID:(NSString *)ID hisOrHerId:(NSString *)hisOrHerId success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    
    NSDictionary *dic = @{
                          @"myId":ID,
                          @"hisOrHerId":hisOrHerId
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/chat/breakup") parameters:dic completionHandler:^(id  responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            success(@"分手成功");
            
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
    }];
    

}

/**
 *  打开定位
 *
 *  @param myId       <#myId description#>
 *  @param hisOrHerId <#hisOrHerId description#>
 *  @param success    <#success description#>
 *  @param failed     <#failed description#>
 */
+ (void)openLocationWithMyId:(NSString *)myId hisOrHerId:(NSString *)hisOrHerId success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    NSDictionary *dic = @{
                          @"myId":myId,
                          @"hisOrHerId":hisOrHerId
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/location/open") parameters:dic completionHandler:^(id  responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            success(responseObj[@"data"]);
                        
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
    }];
    
    
}


//
#pragma mark -- 获取对方的定位
+ (void)getHisHerLocationWithID:(NSString *)hisOrHerId page:(NSString *)page size:(NSString *)size success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    
    NSDictionary *dic = @{
                          @"hisOrHerId":hisOrHerId,
                          @"page":page,
                          @"size":size
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/location/find") parameters:dic completionHandler:^(id  responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            success(responseObj[@"data"][@"content"]);
            
        }else{
            failed(responseObj[@"msg"]);
            
        }
        
    }];

    
}

#pragma mark -- 上传背景图片
+ (void)postBgPicWithtimeEventId:(NSString *)timeEventId imag:(UIImage *)imag success:(void (^)(id))success failed:(void (^)(NSString *))failed{
    
    
    NSDictionary *dic = @{
                          @"timeEventId":timeEventId
                          };
    
    NSData *imageData = UIImageJPEGRepresentation(imag,0.3);

    
    [HQBaseNetManager POSTImgAndVoiceFile:BASEURL(@"/timeevent/uploadimg") parameters:dic Img:imageData name:@"file" fileName:@"0.jpg" mineType:@"image/png" success:^(id res) {
        success(res);
    } failure:^(NSError *error) {
        
    }];
    
    
    
}


@end
