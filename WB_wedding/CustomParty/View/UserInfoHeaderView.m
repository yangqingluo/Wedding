//
//  UserInfoHeaderView.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserInfoHeaderView.h"


@implementation UserInfoHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [AppPublic roundCornerRadius:self.constellationLabel cornerRadius:5.0];
    [AppPublic roundCornerRadius:self.sexAndAgeLabel cornerRadius:5.0];
    [AppPublic roundCornerRadius:self.thirdLabel cornerRadius:5.0];
    
    self.height = screen_width * self.height / self.width;
    self.width = screen_width;
}

- (void)adjustSubviews{
    if (!self.nameLabel.text.length) {
        self.nameLabel.text = @"还没有昵称";
    }
    
    self.nameLabel.width = [AppPublic textSizeWithString:self.nameLabel.text font:self.nameLabel.font constantHeight:self.nameLabel.height].width;
    self.addressLabel.left = self.nameLabel.right + kEdge;
    
    [self adjustWidthForLabel:self.sexAndAgeLabel];
    [self adjustWidthForLabel:self.constellationLabel];
    [self adjustWidthForLabel:self.thirdLabel];
    
    NSArray *labelArray = @[self.sexAndAgeLabel, self.constellationLabel, self.thirdLabel];
    CGFloat left = self.sexAndAgeLabel.left;
    for (UILabel *label in labelArray) {
        label.hidden = (label.text.length == 0);
        if (!label.hidden) {
            label.left = left;
            left += label.width + kEdge;
        }
    }
}

- (void)adjustWidthForLabel:(UILabel *)label{
    if (label.text.length) {
        label.width = [AppPublic textSizeWithString:label.text font:label.font constantHeight:label.height].width + 2 * kEdgeSmall;
    }
}

@end
