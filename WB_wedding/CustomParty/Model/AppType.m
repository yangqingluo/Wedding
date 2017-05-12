//
//  AppType.m
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppType.h"

@implementation AppType

@end

@implementation AppUserData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"ID":@"id"
             };
}

@end


@implementation UserInfoItemData

- (instancetype)init{
    self = [super init];
    if (self) {
//        [UserInfoItemData mj_setupObjectClassInArray:^NSDictionary *{
//            return @{
//                     @"PInfos" : @"UserPInfo",
//                     };
//        }];
    }
    
    return self;
}

@end
