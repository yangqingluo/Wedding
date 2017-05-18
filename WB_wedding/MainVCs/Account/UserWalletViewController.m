//
//  UserWalletViewController.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "UserWalletViewController.h"
#import "WalletDetailUseVC.h"
#import "WalletPayVC.h"

#import "LoveCoinRechargeVC.h"
#import "PublicWebViewController.h"

@interface UserWalletViewController ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end

@implementation UserWalletViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullUserData) name:AlipaySuccessNotification object:nil];
    [self setupNav];
}


- (void)setupNav {
    [self createNavWithTitle:@"我的钱包" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        else if (nIndex == 1){
            UIButton *btn = NewTextButton(@"明细", [UIColor whiteColor]);
            [btn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
    
    self.navBottomLine.hidden = YES;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailAction{
    [self.navigationController pushViewController:[WalletDetailUseVC new] animated:YES];
}

- (void)pullUserData{
    QKWEAKSELF;
    
    [[QKNetworkSingleton sharedManager] Get:@{@"userId":[AppPublic getInstance].userData.ID} HeadParm:nil URLFooter:@"/user/findonebyid" completion:^(id responseBody, NSError *error){
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                [[AppPublic getInstance] saveUserData:[AppUserData mj_objectWithKeyValues:responseBody[@"data"]]];
            }
            else {
                [weakself showHint:responseBody[@"msg"]];
            }
        }
        else{
            [weakself showHint:@"网络出错"];
        }
        
        [weakself updateSubviews];
    }];
}

- (void)updateSubviews{
    self.moneyLab.text = [NSString stringWithFormat:@"%d", [AppPublic getInstance].userData.money];
}

/**
 *  充值
 *
 *  @param sender
 */
- (IBAction)payClick:(id)sender {
    [self.navigationController pushViewController:[LoveCoinRechargeVC new] animated:YES];
}
/**
 *  开通会员
 *
 *  @param sender
 */
- (IBAction)openVipClick:(UIButton *)sender {
    
    [self.navigationController pushViewController:[WalletPayVC new] animated:YES];
}
/**
 *  查看更多特权
 *
 *  @param sender
 */
- (IBAction)moreInfoClick:(id)sender {
    PublicWebViewController *vc = [[PublicWebViewController alloc] initWithURLString:@"http://123.207.120.62:8080/wanwanpage/pages/vipright.html"];
    vc.title = @"VIP特权";
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
