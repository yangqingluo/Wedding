//
//  AppType.m
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import "AppType.h"

@implementation AppType

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"ID":@"id"
             };
}

@end

@implementation AppUserData

+ (NSString *)showRelationTimeWithTimeString:(NSString *)string{
    NSArray *array = [string componentsSeparatedByString:@"-"];
    if (array.count >= 3) {
        NSString *m_string = @"";
        for (NSUInteger i = 0; i < 3; i++) {
            int time = [array[i] intValue];
            if (time > 0) {
                m_string = [NSString stringWithFormat:@"%@%d",m_string, time];
                switch (i) {
                    case 0:{
                        m_string = [NSString stringWithFormat:@"%@年",m_string];
                    }
                        break;
                        
                    case 1:{
                        m_string = [NSString stringWithFormat:@"%@个月",m_string];
                    }
                        break;
                        
                    case 2:{
                        m_string = [NSString stringWithFormat:@"%@天",m_string];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
        
        if (m_string.length) {
            return m_string;
        }
        else {
            return @"1天不到";
        }
    }
    
    return nil;
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

- (NSArray *)subItemsIndexWithKey:(NSString *)string andSeparatedByString:(NSString *)separatedByString{
    NSArray *array = [[self valueForKey:string] componentsSeparatedByString:separatedByString];
    
    return array;
}

- (NSString *)showStringOfMyQuestion{
    NSString *m_string = @"";
    NSArray *array = [self.myQuestion componentsSeparatedByString:@"&"];
    
    int index = 0;
    for (int i = 0; i < array.count; i++) {
        NSString *question = array[i];
        if (question.length) {
            m_string = [m_string stringByAppendingFormat:@"%@%d.%@", m_string.length ? @"\n" : @"", ++index, question];
        }
    }
    
    return m_string;
}

- (NSArray *)showArrayOfMyQuestion{
    return [self.myQuestion componentsSeparatedByString:@"&"];
}

- (NSArray *)showImageArray{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.imgArray.count];
    for (NSString *imgUrlString in self.imgArray) {
        [array addObject:imageUrlStringWithImagePath(imgUrlString)];
    }
    
    return array;
}

- (NSString *)showStringOfSex{
    return [self.sex isEqualToString:@"0"] ? @"男" : @"女";
}

- (NSString *)showStringOfMySurveyForIndex:(NSUInteger)index andLists:(NSString *)listsString{
    NSString *m_string = @"";
    if (index < [AppPublic getInstance].questionnaireLists.count) {
        UserInfoItemData *item = [AppPublic getInstance].questionnaireLists[index];
        NSArray *array = [listsString componentsSeparatedByString:@","];
        for (NSString *itemIndex in array) {
            int subIndex = [itemIndex intValue] - 1;
            if (subIndex < item.subItems.count && subIndex >= 0) {
                if (m_string.length) {
                    m_string = [m_string stringByAppendingString:@";\n"];
                }
                m_string = [m_string stringByAppendingString:item.subItems[subIndex]];
            }
        }
    }
    
    return m_string;
}

- (NSString *)showStringOfBirthday{
    NSString *m_string = @"";
    if (self.birthday) {
        NSTimeInterval timeInterval = 0.001 * [self.birthday doubleValue];
        m_string = stringFromDate([NSDate dateWithTimeIntervalSince1970:timeInterval], @"yyyy/MM/dd");
    }
    
    
    return m_string;
}

- (NSDate *)dateOfBirthday{
    return [NSDate dateWithTimeIntervalSince1970:(0.001 * [self.birthday doubleValue])];
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



@implementation UserJudgementDate



@end

@implementation UserMessageData



@end
