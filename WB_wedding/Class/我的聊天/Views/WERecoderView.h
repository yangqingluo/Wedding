//
//  WERecoderView.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WERecoderViewDelegate <NSObject>

- (void)didSureBtnClick:(NSString *)adress event:(NSString *)envent;

- (void)didCancle;

@end


@interface WERecoderView : UIView
@property (weak, nonatomic) IBOutlet UITextField *adressTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventTextFiled;


@property (nonatomic,weak)id<WERecoderViewDelegate>delegate;

@end
