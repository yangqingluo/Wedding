//
//  WalletPayVC.m
//  WB_wedding
//
//  Created by 刘人华 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//
#import "WDMoneyPayView.h"
#import "WalletPayVC.h"
#import <AlipaySDK/AlipaySDK.h>

@interface WalletPayVC ()
@property (weak, nonatomic) IBOutlet UIButton *monthPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *yearPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@end

@implementation WalletPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开通会员";
}
- (IBAction)monthPayClick:(UIButton *)sender {
    
    _monthPayBtn.selected = YES;
    _yearPayBtn.selected = !_monthPayBtn.isSelected;
}

- (IBAction)yearPayClick:(UIButton *)sender {

    _yearPayBtn.selected = YES;
    _monthPayBtn.selected = !_yearPayBtn.isSelected;
    
}
- (IBAction)nextStepClick:(UIButton *)sender {
    
    NSString *title = _monthPayBtn.isSelected?@"购买一个月会员":@"购买一年会员";
    double money = _monthPayBtn.isSelected?19.90:199.00;
    [[[WDMoneyPayView alloc] initWithTitle:title money:money success:^(WDMoneyPay type, id response) {
        NSString *responStr = [NSString stringWithFormat:@"支付%@",response];
        SVPINFO(responStr);
        
        [BANetManager ba_requestWithType:BAHttpRequestTypePost
                               urlString:BASEURL(@"/alipay/pay")
                              parameters:@{@"body":@"huiyuan",
                                           @"subject":_monthPayBtn.isSelected?@1:@12,
                                           @"totalAmount":@(money),
                                           @"userId":[XWUserModel getUserInfoFromlocal].xw_id}
                            successBlock:^(id response) {
                                if ([response[@"success"] boolValue]) {
                                    /**
                                     *  跳转支付宝
                                     */
                                    NSString *appScheme = @"LS.WB.Love";
                                    NSString *payStr = response[@"data"];
                                    [[AlipaySDK defaultService] payOrder:payStr
                                                              fromScheme:appScheme
                                                                callback:^(NSDictionary *resultDic) {
                                                                    NSLog(@"网页跳转支付宝reslut = %@",resultDic);
                                                                }];
                                    [self.navigationController popViewControllerAnimated:YES];
                                } else{
                                    SVPERROR(response[@"msg"]);
                                }
                            }
                            failureBlock:^(NSError *error) {
                                
                            }
                                progress:nil];

        
    } cancle:^{
        
    }] show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
