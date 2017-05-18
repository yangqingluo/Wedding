//
//  SomeOneLikeCell.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *SomeOneLikeCellID = @"SomeOneLikeCellID";
@interface SomeOneLikeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *redPiont;


@property (strong, nonatomic) IBOutlet UILabel *sexAndAgeLabel;
@property (strong, nonatomic) IBOutlet UILabel *constellationLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *matchLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

- (void)adjustSubviews;

@end
