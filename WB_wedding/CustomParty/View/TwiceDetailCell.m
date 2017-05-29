//
//  TwiceDetailCell.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/29.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "TwiceDetailCell.h"

@implementation TwiceDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdge, screen_width - 2 * kEdgeMiddle, 20.0)];
        self.titleLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
        self.titleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + kEdgeSmall, self.titleLabel.width, 20.0)];
        self.subTitleLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
        self.subTitleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.subTitleLabel];
        
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdge, screen_width - 2 * kEdgeMiddle, 20.0)];
        self.tagLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
        self.tagLabel.textColor = [UIColor grayColor];
        self.tagLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.tagLabel];
        
        self.subTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tagLabel.left, self.tagLabel.bottom + kEdgeSmall, self.tagLabel.width, 20.0)];
        self.subTagLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
        self.subTagLabel.textColor = [UIColor blackColor];
        self.subTagLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.subTagLabel];
    }
    
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeightMiddle;
}


@end
