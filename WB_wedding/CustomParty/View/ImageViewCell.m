//
//  ImageViewCell.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "ImageViewCell.h"

@implementation ImageViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.showImageView = [UIImageView new];
        [self.contentView addSubview:self.showImageView];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.subTitleLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
        self.subTitleLabel.textColor = [UIColor blackColor];
        self.subTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.subTitleLabel];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
