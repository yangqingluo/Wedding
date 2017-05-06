//
//  WEMyAskCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEMyAskCell.h"

@implementation WEMyAskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deleteBtn.layer.cornerRadius = 10;
    self.deleteBtn.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deleBntClick:(id)sender {
    [self.delegate didDeleteIndex:self.indexPath];
}

@end
