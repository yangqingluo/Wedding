//
//  WalletRightVC.m
//  WB_wedding
//
//  Created by 刘人华 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WalletRightVC.h"

@interface WalletRightVC ()

@end

@implementation WalletRightVC

- (void)viewDidLoad {
    [self setupNav];
    
    [super viewDidLoad];
}

- (void)setupNav {
    [self createNavWithTitle:@"特权" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton([UIColor whiteColor]);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
    
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
    

@end
