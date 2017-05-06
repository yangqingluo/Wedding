//
//  WELocationCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/2/14.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *WELocationCellID = @"WELocationCellID";
@interface WELocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *adress;

@end
