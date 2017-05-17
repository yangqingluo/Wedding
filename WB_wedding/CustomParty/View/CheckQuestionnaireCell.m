//
//  CheckQuestionnaireCell.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "CheckQuestionnaireCell.h"

@implementation CheckQuestionnaireCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.checkButton.backgroundColor = [UIColor clearColor];
        [self.checkButton setTitle:@"查看问卷" forState:UIControlStateNormal];
        [self.checkButton setTitleColor:navigationBarColor forState:UIControlStateNormal];
        self.checkButton.titleLabel.font = [UIFont systemFontOfSize:appButtonTitleFontSize];
        self.checkButton.height = 30;
        self.checkButton.width = [AppPublic textSizeWithString:self.checkButton.titleLabel.text font:self.checkButton.titleLabel.font constantHeight:self.checkButton.height].width + kEdgeMiddle;
        self.checkButton.left = self.titleLabel.left;
        self.checkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:self.checkButton];
    }
    
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)title titleFont:(UIFont *)titleFont andDetail:(NSString *)detail detailFont:(UIFont *)detailFont{
    return [super tableView:tableView heightForRowAtIndexPath:indexPath withTitle:title titleFont:titleFont andDetail:detail detailFont:detailFont] + 40;
}

- (void)setTitle:(NSString *)title andDetail:(NSString *)detail{
    [super setTitle:title andDetail:detail];
    
    self.checkButton.top = self.subTitleLabel.bottom + kEdgeSmall;
}

@end
