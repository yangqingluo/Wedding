//
//  WESeletedViewCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/23.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WESeletedViewCell.h"

@implementation WESeletedViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
- (IBAction)selteBtnClick:(UIButton *)sender {
    [self.delegate didSelted:self.indexPath sender:sender];
}

@end
