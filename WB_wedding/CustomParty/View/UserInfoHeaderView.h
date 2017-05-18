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
@property (strong, nonatomic) IBOutlet UILabel *sexAndAgeLabel;
@property (strong, nonatomic) IBOutlet UILabel *constellationLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLabel;

@property (strong, nonatomic) IBOutlet UIView *matchView;
@property (strong, nonatomic) IBOutlet UILabel *matchLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkJudgeButton;

- (void)adjustSubviews;

@end
