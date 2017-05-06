//
//  WELookDetailHeaderView.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WELookDetailHeaderViewDelegate <NSObject>
/**
 *  查看评价
 */
-(void)looke;

@end

@interface WELookDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet SDCycleScrollView *scolView;

@property (nonatomic,weak)id<WELookDetailHeaderViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
@property (weak, nonatomic) IBOutlet UILabel *pipeLable;
@property (weak, nonatomic) IBOutlet UILabel *xinzuoLable;
@property (weak, nonatomic) IBOutlet UILabel *heightLable;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *adress;

@end
