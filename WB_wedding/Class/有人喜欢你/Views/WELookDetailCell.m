
//
//  WELookDetailCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WELookDetailCell.h"

@implementation WELookDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)wenjianBtnClicj:(id)sender {
    [self.delegate didWenJuan];
}
- (IBAction)lookPingjia:(id)sender {
    [self.delegate didPingjia];
}



@end
