//
//  WERecoderView.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WERecoderView.h"

@implementation WERecoderView

- (IBAction)sureBtnClick:(UIButton *)sender {
    [self.delegate didSureBtnClick:self.adressTextField.text event:self.eventTextFiled.text];
    
    
}


- (IBAction)cancleBtnClick:(UIButton *)sender {
    [self.delegate didCancle];
}



@end
