//
//  WETimeLineCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  时间轴的控制器
 */
@interface TimeLineCell : UITableViewCell

@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIView *upLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIImageView *nextArrowView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *eventLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UserTimeLineEventData *data;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withData:(UserTimeLineEventData *)data;


@end
