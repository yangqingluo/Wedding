//
//  WESettingHeadeView.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WESettingHeadeView.h"

@implementation WESettingHeadeView

-(void)awakeFromNib{
    
    //standard rsnge slider
    self.one.delegate = self;
    self.one.minValue = 18;
    self.one.maxValue = 70;
    self.one.selectedMinimum = 18;
    self.one.selectedMaximum = 70;
    
    
    //standard rsnge slider
    self.two.delegate = self;
    self.two.minValue = 1;
    self.two.maxValue = 10;
    self.two.selectedMinimum = 1;
    self.two.selectedMaximum = 10;

    
}

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    if (sender == self.one){
        NSLog(@"Standard slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        self.ageLable.text= [NSString stringWithFormat:@"%.0f--%.0f",selectedMinimum,selectedMaximum];
        
    }else{
          self.rangeLable.text= [NSString stringWithFormat:@"%.0f--%.0f",selectedMinimum,selectedMaximum];
    }
   


}


@end
