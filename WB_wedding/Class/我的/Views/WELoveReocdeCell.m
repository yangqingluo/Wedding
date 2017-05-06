//
//  WELoveReocdeCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WELoveReocdeCell.h"

@implementation WELoveReocdeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 20;
    self.btn.layer.cornerRadius =5;
    self.btn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)fuheClick:(id)sender {
    [self.delegate didFuheClickWithIndex:self.indexPath];
}

@end
