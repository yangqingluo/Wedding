//
//  WEMyAskCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WEMyAskCellDelegate <NSObject>

- (void)didDeleteIndex:(NSIndexPath *)indexPath;

@end

static NSString *WEMyAskCellID = @"WEMyAskCellID";
@interface WEMyAskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *one;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic,strong)NSIndexPath  *indexPath;
@property (nonatomic,weak)id<WEMyAskCellDelegate>delegate;
@end
