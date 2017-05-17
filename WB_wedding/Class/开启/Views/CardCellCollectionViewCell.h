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

/**
 *  这个cell对应的数据源的id
 */
@property (nonatomic,copy)NSString  *ids;


@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sexAndAgeLabel;
@property (strong, nonatomic) IBOutlet UILabel *constellationLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLabel;

@property (strong, nonatomic) IBOutlet UIView *matchView;
@property (strong, nonatomic) IBOutlet UILabel *matchLabel;

-(void)setBlur:(CGFloat)ratio; //设置毛玻璃效果

- (void)starLRMove:(BOOL)flag back:(back)action;

- (void)adjustSubviews;

@end
