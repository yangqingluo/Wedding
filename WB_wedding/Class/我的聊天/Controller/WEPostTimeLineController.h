//
//  WEPostTimeLineController.h
//  WB_wedding
//
//  Created by 谢威 on 17/2/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "HQBaseViewController.h"

#define kNotification_PushTimeLine  @"Notification_PushTimeLine"

/**
 *  发布时间轴
 */
@interface WEPostTimeLineController : HQBaseViewController


@property (strong, nonatomic) UserTimeLineData *data;


@end
