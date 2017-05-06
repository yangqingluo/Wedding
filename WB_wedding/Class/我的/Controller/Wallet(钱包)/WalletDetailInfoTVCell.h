//
//  WalletDetailInfoTVCell.h
//  WB_wedding
//
//  Created by 刘人华 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletDetailUseModel.h"
static  NSString *const WalletDetailInfoTVCellID = @"WalletDetailInfoTVCellID";

@interface WalletDetailInfoTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *introLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab; // 剩余
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *costLab; // 花费


@property (nonatomic, strong) WalletDetailUseModel *model;
@end
