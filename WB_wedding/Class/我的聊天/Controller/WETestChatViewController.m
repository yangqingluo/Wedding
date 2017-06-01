//
//  WETestChatViewController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WETestChatViewController.h"
#import "UserTimeLineVC.h"

@interface WETestChatViewController ()

@end

@implementation WETestChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self)weakSelf = self;
    [self setNavigationRightBtnWithTitle:@"时间轴" actionBack:^{
        UserTimeLineVC *vc = [[UserTimeLineVC alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}



@end
