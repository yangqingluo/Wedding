//
//  WESettingHeadeView.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTRangeSlider.h"
@interface WESettingHeadeView : UIView<TTRangeSliderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
@property (weak, nonatomic) IBOutlet UILabel *rangeLable;
@property (weak, nonatomic) IBOutlet TTRangeSlider *two;

@property (weak, nonatomic) IBOutlet TTRangeSlider *one;
@end
