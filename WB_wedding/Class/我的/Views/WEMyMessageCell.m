//
//  WEMyMessageCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/22.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEMyMessageCell.h"

@implementation WEMyMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tips.layer.cornerRadius = 5;
    self.tips.layer.masksToBounds = YES;
    self.iocn.layer.cornerRadius = 30;
    self.iocn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
