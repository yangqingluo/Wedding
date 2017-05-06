//
//  NSString+WETime.m
//  WB_wedding
//
//  Created by dadahua on 17/3/31.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "NSString+WETime.h"

@implementation NSString (WETime)
+ (NSString *)rightTimeFromTimestamp:(NSString *)stamp {
    
    NSString*str= [NSString stringWithFormat:@"%@",stamp];//时间戳
    
    NSTimeInterval time=[str doubleValue]/1000;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;

}
+ (NSString *)rightTimeNoHourFromTimestamp:(NSString *)stamp {
    
    NSString*str= [NSString stringWithFormat:@"%@",stamp];//时间戳
    
    NSTimeInterval time=[str doubleValue]/1000;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
    
}

+ (NSString *)headerImageWithArrayString:(NSString *)ar {
    
    NSString *imageSrtring = ar;
    if (![imageSrtring isEqualToString:@""]) {
        NSArray *array = [imageSrtring componentsSeparatedByString:@","];
        return array[0];
        
    } else {
        return nil;
    }
}
@end
