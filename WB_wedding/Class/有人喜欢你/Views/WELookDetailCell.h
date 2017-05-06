//
//  WELookDetailCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WELookDetailCellDelegate <NSObject>

- (void)didWenJuan;
- (void)didPingjia;

@end

static NSString *WELookDetailCellID = @"WELookDetailCellID";
@interface WELookDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *oneLable;
@property (weak, nonatomic) IBOutlet UILabel *twoLable;

@property (weak, nonatomic) IBOutlet UIButton *wenjuanBtn;

@property (nonatomic,weak)id<WELookDetailCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *pingjia;

@end
