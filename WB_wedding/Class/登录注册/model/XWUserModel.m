//
//  XWUserModel.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/4.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "XWUserModel.h"

@implementation XWUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"xw_id":@"id"
             };
}


+ (instancetype)standardUserInfo{
    
    static XWUserModel *userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[self alloc]init];
        
    });
    
    return userInfo;
}


+(NSString *)filePath{
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"userInfo"];
}


- (BOOL)saveUserInfo{
    
    BOOL isSuccess  = [NSKeyedArchiver archiveRootObject:self toFile:[XWUserModel filePath]];
    return isSuccess;
}


+ (BOOL)removeUserInfoFromlocal{
    
//    //移除登录信息
    [KUserDefaults removeObjectForKey:KISLogin];
    //移除账号名密码
    [KUserDefaults removeObjectForKey:KAccout];
    [KUserDefaults removeObjectForKey:KPassword];
    //移除用户信息
    return [[NSFileManager defaultManager]removeItemAtPath:[XWUserModel filePath] error:nil];
}
+ (XWUserModel *)getUserInfoFromlocal{
    
    XWUserModel* userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[XWUserModel filePath]]];
    return userInfo;
}

+ (BOOL)isLogin{
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:KISLogin];
}

- (void)saveLoginInfoWithAccout:(NSString *)account pwd:(NSString *)pwd{
    
    [KUserDefaults setObject:@YES forKey:KISLogin];
    [KUserDefaults setObject:account forKey:KAccout];
    [KUserDefaults setObject:pwd forKey:KPassword];
}

- (BOOL)isVip{
    
    NSString*str= [NSString stringWithFormat:@"%@",self.vipEndTime];//时间戳
    
    NSTimeInterval time=[str doubleValue]/1000;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    currentDateStr = [currentDateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSDate  *nowDate = [NSDate date];
    
    NSDateFormatter*dateFormatter2 = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    
    NSString*nowDateString = [dateFormatter2 stringFromDate:nowDate];
     nowDateString = [nowDateString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    
    if ([self.vipEndTime isEqualToString:@""]||self.vipEndTime==nil) {
        
        return NO;
        
    }else{
        if ([currentDateStr longLongValue]>[nowDateString longLongValue]) {
            
            return YES;
            
            
        }else{
            return NO;
        }
        
        
    }
    
    

    
}




@end
