//
//  WELookDetailHeaderView.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WELookDetailHeaderView.h"

@implementation WELookDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    self.xinzuoLable.layer.cornerRadius = 5;
    self.xinzuoLable.layer.masksToBounds = YES;
    self.pipeLable.layer.cornerRadius = 3;
    self.pipeLable.layer.masksToBounds = YES;
    self.ageLable.layer.cornerRadius = 3;
    self.ageLable.layer.masksToBounds = YES;
    self.heightLable.layer.cornerRadius = 3;
    self.heightLable.layer.masksToBounds = YES;
    
}

- (IBAction)look:(UIButton *)sender {
    [self.delegate looke];
}

@end
