//
//  WETimeLineCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *WETimeLineCellID=  @"WETimeLineCellID";
/**
 *  时间轴的控制器
 */
@interface WETimeLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *envent;
@property (weak, nonatomic) IBOutlet UILabel *adress;

@end
