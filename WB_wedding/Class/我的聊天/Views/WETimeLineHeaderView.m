//
//  WETimeLineHeaderView.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WETimeLineHeaderView.h"

@implementation WETimeLineHeaderView

- (IBAction)locationBtnClick:(UIButton *)sender {
    [self.delegate didLocationBtn:sender];
    
    
}

- (IBAction)bgBtnClick:(UIButton *)sender {
    [self.delegate didChangeBgBtn:sender];
}

- (IBAction)bakBtnClick:(id)sender {
    if (self.delegate) {
        [self.delegate didBack];
    }
}

@end
