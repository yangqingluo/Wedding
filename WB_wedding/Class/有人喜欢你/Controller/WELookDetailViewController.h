//
//  WELookDetailViewController.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "HQBaseViewController.h"

typedef enum {
  vcTypeYourMsg,
  vcTypeYourLike,
  vcTypeSelfInfo, // 个人信息
   vcTypeHome
}vcType;


/**
 *  查看资料控制器
 */
@interface WELookDetailViewController : HQBaseViewController

- (instancetype)initWithType:(vcType)type;


@property (nonatomic,copy)NSString *ID;

/**
 *  信息 没有转模型
 */
@property (nonatomic,copy)NSDictionary *dic;

@end
