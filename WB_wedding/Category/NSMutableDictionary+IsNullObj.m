//
//  NSMutableDictionary+IsNullObj.m
//  WB_wedding
//
//  Created by 刘人华 on 17/2/10.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "NSMutableDictionary+IsNullObj.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (IsNullObj)

+ (void)load {
    
    Method originMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:));
    Method customMethod = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(dh_setObject:forKey:));
    method_exchangeImplementations(originMethod, customMethod);
}

- (void)dh_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    if (anObject != nil) {
        if ([anObject isKindOfClass:[NSString class]]) {
            NSString *objStr = anObject;
            if (objStr.length > 0) {
                [self dh_setObject:anObject forKey:aKey];
            }
        } else{
            [self dh_setObject:anObject forKey:aKey];
        }
    }
}


@end
