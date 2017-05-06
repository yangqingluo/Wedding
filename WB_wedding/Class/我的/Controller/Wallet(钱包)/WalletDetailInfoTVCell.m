//
//  WalletDetailInfoTVCell.m
//  WB_wedding
//
//  Created by 刘人华 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WalletDetailInfoTVCell.h"
#import "NSString+WETime.h"

@implementation WalletDetailInfoTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(WalletDetailUseModel *)model {
    
    _model = model;
    _introLab.text = model.consumeContent;
    _balanceLab.text = model.balance;
    _timeLab.text = [NSString rightTimeFromTimestamp:model.time];
    _costLab.text = model.consumeContent;
}

@end
