//
//  UserInfoHeaderView.h
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>

@interface UserInfoHeaderView : UIView

@property (strong, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) IBOutlet UILabel *ageLable;
@property (strong, nonatomic) IBOutlet UILabel *constellationLable;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *adressLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLable;

@property (strong, nonatomic) IBOutlet UIView *matchView;
@property (strong, nonatomic) IBOutlet UILabel *matchLable;

@end
