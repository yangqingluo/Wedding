//
//  WETimeLineCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WETimeLineCell.h"
#import "UIImage+Color.h"

#define m_height  60.0

#define default_labelFontSize 14.0

@interface WETimeLineCell ()

@end

@implementation WETimeLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.textColor = navigationBarColor;
        self.timeLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:self.timeLabel];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.numberOfLines = 0;
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.addressLabel.textColor = navigationBarColor;
        self.addressLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:self.addressLabel];
        
        self.eventLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.eventLabel.textColor = navigationBarColor;
        self.eventLabel.font = [UIFont systemFontOfSize:14.0];
        self.eventLabel.numberOfLines = 0;
        [self addSubview:self.eventLabel];
        
        self.tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.tipView.backgroundColor = RGBA(251, 114, 114, 0.6);
        [AppPublic roundCornerRadius:self.tipView];
        [self addSubview:self.tipView];
        
        UIView *pointView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        pointView.backgroundColor = RGBA(251, 114, 114, 1.0);
        pointView.center = CGPointMake(0.5 * self.tipView.width, 0.5 * self.tipView.height);
        [self.tipView addSubview:pointView];
        [AppPublic roundCornerRadius:pointView];
        
        self.upLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0)];
        self.upLineView.backgroundColor = navigationBarColor;
        [self addSubview:self.upLineView];
        
        self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0)];
        self.bottomLineView.backgroundColor = navigationBarColor;
        [self addSubview:self.bottomLineView];
        
        self.nextArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 15)];
        self.nextArrowView.image = [[UIImage imageNamed:@"cell_next"] imageWithColor:navigationBarColor];
        [self addSubview:self.nextArrowView];
    }
    
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)data{
    
    NSString *eventString = data[@"eventContent"];
    CGFloat height = [AppPublic textSizeWithString:eventString font:[UIFont systemFontOfSize:14.0] constantWidth:0.5 * screen_width].height;
    
    return MAX(m_height, (height  + kEdgeMiddle) / 0.5);
}

#pragma private
//折扣
NSAttributedString *timelineAddressAttributedString(NSString *city, NSString *address){
    NSAttributedString *part1 = [[NSAttributedString alloc]initWithString:city attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:default_labelFontSize + 2],NSForegroundColorAttributeName:navigationBarColor}];
    NSAttributedString *part2 = [[NSAttributedString alloc]initWithString:address attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:default_labelFontSize],NSForegroundColorAttributeName:navigationBarColor}];
    
    NSMutableAttributedString *part = [NSMutableAttributedString new];
    [part appendAttributedString:part1];
    [part appendAttributedString:part2];
    
    return part;
}

#pragma setter
- (void)setData:(NSDictionary *)data{
    _data = data;

    NSString *eventString = data[@"eventContent"];
    
    self.addressLabel.attributedText = timelineAddressAttributedString(data[@"city"], [NSString stringWithFormat:@"\t%@", data[@"location"]]);
    self.eventLabel.text = eventString;
    NSString *time = [NSString stringWithFormat:@"%@", data[@"eventTime"]];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[time longLongValue] / 1000.0];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@", stringFromDate(date, @"yyyy年MM月dd日"), stringFromDate(date, @"HH: mm")];
    
    double eventHeight = [AppPublic textSizeWithString:eventString font:[UIFont systemFontOfSize:14.0] constantWidth:0.5 * screen_width].height;
    double height = MAX(m_height,  (eventHeight  + kEdgeMiddle) / 0.5);
    
    self.tipView.center = CGPointMake(0.35 * screen_width, 0.5 * height);
    self.upLineView.height = self.tipView.top;
    self.upLineView.center = CGPointMake(self.tipView.centerX, 0.5 * self.upLineView.height);
    self.bottomLineView.height = height - self.tipView.bottom;
    self.bottomLineView.center = CGPointMake(self.tipView.centerX, self.tipView.bottom + 0.5 * self.bottomLineView.height);
    
    self.timeLabel.frame = CGRectMake(0, 0, self.tipView.left, height);
    self.addressLabel.frame = CGRectMake(self.tipView.right + kEdge, 0.5 * height - 20 - kEdgeSmall, 0.5 * screen_width, 20);
    self.eventLabel.frame = CGRectMake(self.addressLabel.left, 0.5 * height, self.addressLabel.width, eventHeight);
    self.nextArrowView.center = CGPointMake(screen_width - kEdgeSmall - 0.5 * self.nextArrowView.width, self.tipView.centerY);
}

@end
