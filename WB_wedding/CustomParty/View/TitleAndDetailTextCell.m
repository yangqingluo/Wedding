//
//  TitleAndDetailTextCell.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/15.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "TitleAndDetailTextCell.h"

@interface TitleAndDetailTextCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation TitleAndDetailTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEdgeMiddle, kEdge, screen_width - kEdgeMiddle - kEdgeBig, 0.0)];
        self.titleLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
        self.titleLabel.textColor = [UIColor grayColor];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + kEdge, self.titleLabel.width, 0.0)];
        self.subTitleLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
        self.subTitleLabel.textColor = [UIColor blackColor];
        self.subTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.subTitleLabel];
    }
    
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)title andDetail:(NSString *)detail{
    CGFloat width = screen_width - kEdgeMiddle - kEdgeBig;
    CGFloat height = kEdge + [AppPublic textSizeWithString:title font:[UIFont systemFontOfSize:appLabelFontSize] constantWidth:width].height + kEdge + [AppPublic textSizeWithString:detail font:[UIFont systemFontOfSize:appLabelFontSize] constantWidth:width].height + kEdge;
    
    return MAX(kCellHeightMiddle, height);
}

- (void)setTitle:(NSString *)title andDetail:(NSString *)detail{
    self.titleLabel.text = title;
    self.subTitleLabel.text = detail;
    
    self.titleLabel.height = [AppPublic textSizeWithString:title font:[UIFont systemFontOfSize:appLabelFontSize] constantWidth:self.titleLabel.width].height;
    
    self.subTitleLabel.height = [AppPublic textSizeWithString:detail font:[UIFont systemFontOfSize:appLabelFontSize] constantWidth:self.subTitleLabel.width].height;
    self.subTitleLabel.top = self.titleLabel.bottom + kEdge;
}

@end
