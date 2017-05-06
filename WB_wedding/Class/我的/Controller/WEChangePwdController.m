//
//  WEChangePwdController.m
//  WB_wedding
//
//  Created by 谢威 on 17/3/29.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEChangePwdController.h"

@interface WEChangePwdController ()

@end

@implementation WEChangePwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationRightBtnWithTitle:@"保存" actionBack:^{
        
    }];
}




@end
