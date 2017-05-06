//
//  EMChoicePriceSliderView.h
//  EMSliderPrice
//
//  Created by xiaoka on 16/11/22.
//  Copyright © 2016年 xiaoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  EMChoicePriceSliderViewDelegate<NSObject>
@optional
- (void)choicePriceViewGetMinMoney:(NSString *)minMoney maxMoney:(NSString *)maxMoney;

@end

@interface EMChoicePriceSliderView : UIView

@property (nonatomic, assign) id<EMChoicePriceSliderViewDelegate>delegate;

@end
