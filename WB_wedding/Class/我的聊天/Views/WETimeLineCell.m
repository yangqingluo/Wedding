//
//  WETimeLineCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WETimeLineCell.h"

@implementation WETimeLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tipView.layer.cornerRadius = 10;
    self.tipView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
