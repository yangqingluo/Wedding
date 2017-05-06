//
//  WESeletedViewCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/23.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WESeletedViewCellDelegate <NSObject>

- (void)didSelted:(NSIndexPath *)indexPath sender:(UIButton *)sender;

@end

static NSString *WESeletedViewCellID= @"WESeletedViewCellID";
@interface WESeletedViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (nonatomic,strong)NSIndexPath  *indexPath;
//@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (nonatomic,weak)id<WESeletedViewCellDelegate>delegate;
@end
