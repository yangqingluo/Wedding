//
//  WECommentCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WECommentCell.h"

@implementation WECommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.cornerRadius =25;
    self.icon.layer.masksToBounds = YES;
    
}


@end
