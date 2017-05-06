//
//  WEChooseCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WEChooseCellDelegate <NSObject>

- (void)didDeleteIndex:(NSIndexPath *)index;

@end
static NSString *WEChooseCellID= @"WEChooseCellID";
@interface WEChooseCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iamgeView;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (nonatomic,strong)NSIndexPath  *indexPath;


@property (nonatomic,weak)id<WEChooseCellDelegate>delegate;
@end
