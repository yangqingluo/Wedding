//
//  CardCellCollectionViewCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^back)(void);
static NSString *CardCellCollectionViewCellID= @"CardCellCollectionViewCellID";
@interface CardCellCollectionViewCell : UICollectionViewCell
-(void)setBlur:(CGFloat)ratio; //设置毛玻璃效果

- (void)starLRMove:(BOOL)flag back:(back)action;

@property (weak, nonatomic) IBOutlet UIImageView *imagView;
@property (weak, nonatomic) IBOutlet UILabel *xinzuoLable;
@property (weak, nonatomic) IBOutlet UILabel *pipeLable;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
/**
 *  这个cell对应的数据源的id
 */
@property (nonatomic,copy)NSString  *ids;
@property (weak, nonatomic) IBOutlet UILabel *ardess;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
