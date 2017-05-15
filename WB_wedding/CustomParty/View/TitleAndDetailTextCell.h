//
//  TitleAndDetailTextCell.h
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/15.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleAndDetailTextCell : UITableViewCell

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)title andDetail:(NSString *)detail;

- (void)setTitle:(NSString *)title andDetail:(NSString *)detail;

@end
