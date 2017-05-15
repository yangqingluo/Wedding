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

- (BOOL)isVip{
    if (self.vipEndTime) {
        return [self.vipEndTime longLongValue] > 1000 * [[NSDate date] timeIntervalSince1970];
    }
    
    return NO;
}

- (instancetype)copyWithZone:(NSZone *)zone{
    AppUserData *copy = [[[self class] allocWithZone:zone]init];
    
    copy = [AppUserData mj_objectWithKeyValues:[self mj_keyValues]];
    
    return copy;
}

- (NSString *)subItemStringWithKey:(NSString *)string{
    NSString *m_string = @"";
    NSArray *array = [[self valueForKey:string] componentsSeparatedByString:@","];
    
    NSArray *subItemsArray = [AppPublic getInstance].infoItemDic[string];
    for (NSString *itemIndex in array) {
        int index = [itemIndex intValue] - 1;
        if (index < subItemsArray.count && index >= 0) {
            if (m_string.length) {
                m_string = [m_string stringByAppendingString:@","];
            }
            m_string = [m_string stringByAppendingString:subItemsArray[index]];
        }
    }
    
    return m_string;
}

- (NSArray *)subItemsIndexWithKey:(NSString *)string{
    NSArray *array = [[self valueForKey:string] componentsSeparatedByString:@","];
    
    return array;
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
