//
//  AppType.m
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppType.h"

@implementation AppType

@end

@implementation AppInfo



@end


@implementation UserPInfo



@end

@implementation UserRInfo



@end

@implementation UserUInfo



@end

@implementation AppUserData

- (instancetype)init{
    self = [super init];
    if (self) {
        [AppUserData mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"PInfos" : @"UserPInfo",
                     //                  @"PInfos" : [UserPInfo class],
                     };
        }];
    }
    
    
    return self;
}

@end
