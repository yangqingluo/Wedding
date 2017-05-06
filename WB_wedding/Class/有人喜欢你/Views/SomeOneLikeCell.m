//
//  SomeOneLikeCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "SomeOneLikeCell.h"

@implementation SomeOneLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.cornerRadius = 25;
    self.icon.layer.masksToBounds = YES;
    self.redPiont.layer.masksToBounds = YES;
    self.redPiont.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
