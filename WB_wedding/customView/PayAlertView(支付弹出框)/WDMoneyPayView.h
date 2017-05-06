//
//  WDMoneyPayView.h
//  WB_wedding
//
//  Created by 刘人华 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WDMoneyPayAlipay, //支付宝
    WDMoneyPayWechat, //微信
} WDMoneyPay;

typedef void(^WDMoneyPayBlock)(WDMoneyPay type,id response);

@interface WDMoneyPayView : UIView

- (instancetype)initWithTitle:(NSString *)title money:(double)money success:(WDMoneyPayBlock)successBlock cancle:(void(^)())cancleBlock;

- (void)show;

@end
