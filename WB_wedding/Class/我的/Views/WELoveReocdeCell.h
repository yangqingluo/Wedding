//
//  WELoveReocdeCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WELoveReocdeCellDelegate <NSObject>

- (void)didFuheClickWithIndex:(NSIndexPath *)index;

@end


static NSString *WELoveReocdeCellID= @"WELoveReocdeCellID";
@interface WELoveReocdeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (nonatomic,strong)NSIndexPath     *indexPath;

@property (nonatomic,weak)id<WELoveReocdeCellDelegate>delegate;










@end
