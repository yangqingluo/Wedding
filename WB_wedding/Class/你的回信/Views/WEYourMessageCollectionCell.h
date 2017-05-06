//
//  WEYourMessageCollectionCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WEYourMessageCollectionCellDelegate <NSObject>

- (void)deleIndexPath:(NSIndexPath *)indexPath;

@end

static NSString *WEYourMessageCollectionCellID = @"WEYourMessageCollectionCellID";
/**
 *  你的回信的cell
 */
@interface WEYourMessageCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic,strong)NSIndexPath  *indePath;

@property (nonatomic,weak)id<WEYourMessageCollectionCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *percent;

@property (weak, nonatomic) IBOutlet UILabel *fazan;



@end
