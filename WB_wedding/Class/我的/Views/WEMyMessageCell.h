//
//  WEMyMessageCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/22.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *WEMyMessageCellID = @"WEMyMessageCellID";
@interface WEMyMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iocn;

@property (weak, nonatomic) IBOutlet UIView *tips;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *two;




@end
