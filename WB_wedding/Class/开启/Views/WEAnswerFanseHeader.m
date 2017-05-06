//
//  WEAnswerFanseHeader.m
//  WB_wedding
//
//  Created by 刘人华 on 17/2/4.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEAnswerFanseHeader.h"

@implementation WEAnswerFanseHeader

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.headerImgView.layer.cornerRadius = 30;
    self.headerImgView.layer.masksToBounds = YES;
}

@end
