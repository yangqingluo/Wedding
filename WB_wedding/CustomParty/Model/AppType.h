//
//  AppType.h
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppType : NSObject

@end


@interface AppUserData : NSObject



@end


@interface UserInfoItemData : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *subItems;

@end
