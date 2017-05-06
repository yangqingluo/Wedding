//
//  WEChooseCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEChooseCell.h"

@implementation WEChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancleBtn.layer.cornerRadius = 10;
    self.cancleBtn.layer.masksToBounds = YES;
}
- (IBAction)canClebtnClick:(id)sender {
    [self.delegate didDeleteIndex:self.indexPath];
}

@end
