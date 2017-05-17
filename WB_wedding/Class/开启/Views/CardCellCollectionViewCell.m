//
//  CardCellCollectionViewCell.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "CardCellCollectionViewCell.h"


@interface CardCellCollectionViewCell ()

@property(nonatomic, strong)UIVisualEffectView* blurView;
@property (nonatomic,copy)back   back;

//是否移动
@property (nonatomic,assign) BOOL isMoved;


@end

@implementation CardCellCollectionViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [AppPublic roundCornerRadius:self cornerRadius:10.0];
    [AppPublic roundCornerRadius:self.constellationLabel cornerRadius:5.0];
    [AppPublic roundCornerRadius:self.sexAndAgeLabel cornerRadius:5.0];
    [AppPublic roundCornerRadius:self.thirdLabel cornerRadius:5.0];
    
}

//设置毛玻璃效果
- (void)setBlur:(CGFloat)ratio{
    if (!self.blurView.superview) {
        [self.contentView addSubview:self.blurView];
    }
    [self.contentView bringSubviewToFront:self.blurView];
    self.blurView.alpha = ratio;
}

- (UIVisualEffectView *)blurView{
    if (!_blurView) {
        _blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurView.frame = self.bounds;
    }
    return _blurView;
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

- (void)starLRMove:(BOOL)flag back:(back)action{
    
}

- (void)adjustWidthForLabel:(UILabel *)label{
    if (label.text.length) {
        label.width = [AppPublic textSizeWithString:label.text font:label.font constantHeight:label.height].width + 2 * kEdgeSmall;
    }
}

@end
