//
//  UserInfoVC.h
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/15.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "AppBasicTableViewController.h"

typedef enum {
    UserInfoTypeSelf = 0,
    UserInfoTypeMsg,
    UserInfoTypeLike,
    UserInfoTypeStart,
}UserInfoType;

@interface UserInfoVC : AppBasicTableViewController

@property (nonatomic) UserInfoType infoType;
@property (strong, nonatomic) AppUserData *userData;

@end
