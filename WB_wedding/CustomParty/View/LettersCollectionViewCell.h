//
//  LettersCollectionViewCell.h
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "QKBaseCollectionViewCell.h"

@interface LettersCollectionViewCell : QKBaseCollectionViewCell

@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *matchLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) AppUserData *userData;

@end
