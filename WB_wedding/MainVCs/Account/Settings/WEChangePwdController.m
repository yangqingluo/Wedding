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
    [self setupNav];
}

- (void)setupNav {
    [self createNavWithTitle:@"修改密码" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"保存", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction{
    
}



@end
