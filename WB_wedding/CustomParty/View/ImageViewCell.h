//
//  ImageViewCell.h
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ImageViewCell : SWTableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UILabel *timeLabel;//未实例化，使用时实例化
@property (strong, nonatomic) UIImageView *tagImageView;//未实例化，使用时实例化
@property (strong, nonatomic) UIButton *tagButton;//未实例化，使用时实例化
@property (strong, nonatomic) UIImageView *showImageView;

@end
