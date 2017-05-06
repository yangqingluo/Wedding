//
//  WEAnswerFansSureBtnCell.m
//  WB_wedding
//
//  Created by 刘人华 on 17/2/4.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEAnswerFansSureBtnCell.h"

@implementation WEAnswerFansSureBtnCell

- (void)awakeFromNib {
    // Initialization code
    self.sendBtn.layer.cornerRadius = 10;
    _sendBtn.enabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
