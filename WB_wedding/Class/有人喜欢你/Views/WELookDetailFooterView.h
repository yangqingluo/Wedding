//
//  WELookDetailFooterView.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WELookDetailFooterViewDelegate <NSObject>

-(void)didOpenBtn:(UIButton *)sender;

@end



@interface WELookDetailFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *oneLable;

@property (weak, nonatomic) IBOutlet UILabel *twoLable;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

@property (nonatomic,weak)id<WELookDetailFooterViewDelegate>delegate;

@end
