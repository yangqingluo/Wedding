//
//  WEYourMessageCollectionCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEYourMessageCollectionCell.h"

@implementation WEYourMessageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deleteBtn.hidden = YES;
    
}
- (IBAction)deleteBtnClick:(UIButton *)sender {
    [self.delegate deleIndexPath:self.indePath];
}



@end
