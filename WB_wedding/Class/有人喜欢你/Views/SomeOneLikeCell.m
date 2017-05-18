//
//  SomeOneLikeCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "SomeOneLikeCell.h"

@implementation SomeOneLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [AppPublic roundCornerRadius:self.redPiont cornerRadius:0.5 * self.redPiont.width];
    [AppPublic roundCornerRadius:self.headImageView cornerRadius:0.5 * self.headImageView.width];
    [AppPublic roundCornerRadius:self.constellationLabel cornerRadius:5.0];
    [AppPublic roundCornerRadius:self.sexAndAgeLabel cornerRadius:5.0];
    [AppPublic roundCornerRadius:self.matchLabel cornerRadius:5.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)adjustSubviews{
    if (!self.nameLabel.text.length) {
        self.nameLabel.text = @"没有昵称";
    }
    
    self.nameLabel.width = [AppPublic textSizeWithString:self.nameLabel.text font:self.nameLabel.font constantHeight:self.nameLabel.height].width;
    self.addressLabel.left = self.nameLabel.right + kEdge;
    
    [self adjustWidthForLabel:self.sexAndAgeLabel];
    [self adjustWidthForLabel:self.matchLabel];
    [self adjustWidthForLabel:self.constellationLabel];
    
    
    NSArray *labelArray = @[self.sexAndAgeLabel, self.matchLabel, self.constellationLabel];
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
