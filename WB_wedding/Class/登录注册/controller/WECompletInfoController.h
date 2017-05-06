//
//  WECompletInfoController.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "HQBaseViewController.h"


@interface WECompletInfoController : HQBaseViewController
@property (nonatomic, copy) NSString *telPhone; //电话
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign) BOOL isUserSetting; //判断是否是用户设置界面,不是用户设置界面，就是注册过去的界面
@end
