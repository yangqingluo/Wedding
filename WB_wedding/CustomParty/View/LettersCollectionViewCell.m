//
//  LettersCollectionViewself.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "LettersCollectionViewCell.h"

@implementation LettersCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.baseView = [[UIView alloc] initWithFrame:CGRectMake(kEdge, kEdge, self.width - 2 * kEdge, self.height - kEdge)];
        self.baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.baseView];
        
        self.imgView.frame = CGRectMake(0, 0, self.baseView.width, self.baseView.width);
        self.removeButton.frame = CGRectMake(self.baseView.right - kEdge, self.baseView.top - kEdge, 2 * kEdge, 2 * kEdge);
        
        [self.imgView removeFromSuperview];
        [self.baseView addSubview:self.imgView];
        [AppPublic roundCornerRadius:self.baseView cornerRadius:5.0];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeSmall, self.imgView.bottom, 20, self.baseView.height - self.imgView.bottom)];
        self.nameLabel.font = [UIFont systemFontOfSize:appLabelFontSizeMiddle];
        self.nameLabel.textColor = [UIColor blackColor];
        [self.baseView addSubview:self.nameLabel];
        
        self.matchLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.right + kEdge, self.nameLabel.top, 20, self.nameLabel.height)];
        self.matchLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
        self.matchLabel.textColor = navigationBarColor;
        [self.baseView addSubview:self.matchLabel];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.baseView.width - 80 - kEdgeSmall, self.imgView.bottom, 80, self.nameLabel.height)];
        self.statusLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
        self.statusLabel.textColor = navigationBarColor;
        self.statusLabel.textAlignment = NSTextAlignmentRight;
        [self.baseView addSubview:self.statusLabel];
    }
    
    return self;
}

- (void)adjustWidthForLabel:(UILabel *)label{
    if (label.text.length) {
        label.width = [AppPublic textSizeWithString:label.text font:label.font constantHeight:label.height].width;
    }
}

#pragma setter
- (void)setUserData:(AppUserData *)userData{
    _userData = userData;
    
    if (userData.imgArray.count) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageUrlStringWithImagePath(userData.imgArray[0])] placeholderImage:[UIImage imageNamed:downloadImagePlace]];
    }
    else {
        self.imgView.image = [UIImage imageNamed:downloadImagePlace];
    }
    
    self.nameLabel.text = userData.nickname;
    self.matchLabel.text = [NSString stringWithFormat:@"%d%%", [userData.matchDegree intValue]];
    self.statusLabel.text = [userData.status boolValue] ? @"名花有主" : @"可发展";
    
    [self adjustWidthForLabel:self.nameLabel];
    [self adjustWidthForLabel:self.matchLabel];
    
    NSArray *labelArray = @[self.nameLabel, self.matchLabel];
    CGFloat left = self.nameLabel.left;
    for (UILabel *label in labelArray) {
        label.hidden = (label.text.length == 0);
        if (!label.hidden) {
            label.left = left;
            left += label.width + kEdgeSmall;
        }
    }
}


@end
