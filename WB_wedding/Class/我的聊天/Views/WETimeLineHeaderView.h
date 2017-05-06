//
//  WETimeLineHeaderView.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol WETimeLineHeaderViewDelegate <NSObject>

- (void)didLocationBtn:(UIButton *)sender;
- (void)didChangeBgBtn:(UIButton *)sender;

- (void)didBack;

@end
@interface WETimeLineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;

@property (nonatomic,weak)id<WETimeLineHeaderViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bgInamegView;


@property (weak, nonatomic) IBOutlet UIButton *bavkkkk;




@end
