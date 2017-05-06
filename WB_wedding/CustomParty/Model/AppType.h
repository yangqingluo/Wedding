//
//  AppType.h
//  CRM2017
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppType : NSObject

@end

@interface AppInfo : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *Name;

@end

@interface UserPInfo : AppInfo

@property (strong, nonatomic) NSString *BtnType;
@property (strong, nonatomic) NSString *ClassName;
@property (strong, nonatomic) NSString *ParentId;
@property (strong, nonatomic) NSString *RoutePath;
@property (strong, nonatomic) NSArray *ListmPowers;
@property (assign, nonatomic) BOOL IsActivate;
@property (assign, nonatomic) BOOL IsSelected;

@end

@interface UserRInfo : AppInfo

@property (strong, nonatomic) NSString *PowerList;

@end

@interface UserUInfo : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *HeadImage;
@property (strong, nonatomic) NSString *Token;
@property (strong, nonatomic) NSString *MobileCode;
@property (strong, nonatomic) NSString *RealName;
@property (strong, nonatomic) NSString *UserName;
@property (assign, nonatomic) BOOL IsMale;

@end

@interface AppUserData : NSObject

@property (strong, nonatomic) AppInfo *DInfo;
@property (strong, nonatomic) NSArray<UserPInfo *> *PInfos;
@property (strong, nonatomic) AppInfo *TInfo;
@property (strong, nonatomic) UserRInfo *RInfo;
@property (strong, nonatomic) UserUInfo *UInfo;


@end
