//
//  WELookDetailFooterView.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WELookDetailFooterView.h"

@implementation WELookDetailFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)openBtnClick:(UIButton *)sender {
    [self.delegate didOpenBtn:sender];
}

@end
