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

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.xinzuoLable.layer.cornerRadius = 5;
    self.xinzuoLable.layer.masksToBounds = YES;
    self.pipeLable.layer.cornerRadius = 3;
    self.pipeLable.layer.masksToBounds = YES;
    self.ageLable.layer.cornerRadius = 3;
    self.ageLable.layer.masksToBounds = YES;
    
}



//设置毛玻璃效果
-(void)setBlur:(CGFloat)ratio
{
    if (!self.blurView.superview) {
        [self.contentView addSubview:self.blurView];
    }
    [self.contentView bringSubviewToFront:self.blurView];
    self.blurView.alpha = ratio;
}





-(UIVisualEffectView*)blurView
{
    if (!_blurView) {
        _blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurView.frame = self.bounds;
    }
    return _blurView;
}


@end
