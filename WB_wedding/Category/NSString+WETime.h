//
//  NSString+WETime.h
//  WB_wedding
//
//  Created by dadahua on 17/3/31.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WETime)
+ (NSString *)rightTimeNoHourFromTimestamp:(NSString *)stamp;
+ (NSString *)rightTimeFromTimestamp:(NSString *)stamp;


+ (NSString *)headerImageWithArrayString:(NSString *)ar;
@end
