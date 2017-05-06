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
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sexage;

@property (weak, nonatomic) IBOutlet UILabel *march;
@property (weak, nonatomic) IBOutlet UILabel *xinzuo;

@property (weak, nonatomic) IBOutlet UILabel *adress;

@property (weak, nonatomic) IBOutlet UILabel *fazhang;
@property (weak, nonatomic) IBOutlet UIView *redPiont;

@end
