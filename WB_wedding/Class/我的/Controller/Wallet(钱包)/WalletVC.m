//
//  WalletVC.m
//  WB_wedding
//
//  Created by 刘人华 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//
#import "WalletRightVC.h"
#import "WalletVC.h"
#import "WalletDetailUseVC.h"
#import "WalletPayVC.h"
#import "WELoginTool.h"

#import "LoveCoinRechargeVC.h"

@interface WalletVC ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLab; //钱
@property (weak, nonatomic) IBOutlet UIView *bgView; //背景

@end

@implementation WalletVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.moneyLab.text = [NSString stringWithFormat:@"%.1lf",[[XWUserModel getUserInfoFromlocal].money doubleValue]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alipaySuccess)
                                                 name:AlipaySuccessNotification
                                               object:nil];
    [self initUI];
}

- (void)alipaySuccess {
    
    NSDictionary *dic;
    
        
        dic = @{
                @"latitude":@0,
                @"loginType":@1,
                @"longitude":@0,
                @"password":UserDefaultObjectForKey(KPassword),
                @"telNumber":UserDefaultObjectForKey(KAccout)
                
                };
    
        
    
    
    [HQBaseNetManager POST:BASEURL(@"/user/login")
                parameters:dic
         completionHandler:^(id responseObj, NSError *error) {
        
        if ([responseObj[@"msg"]isEqualToString:@"请求成功"]) {
            
            XWUserModel *model = [XWUserModel mj_objectWithKeyValues:responseObj[@"data"]];
            [model saveUserInfo];
            self.moneyLab.text = [NSString stringWithFormat:@"%.1lf",[model.money doubleValue]];
            
        }else{
            
            
        }
    }];
    

}

- (void)initUI {
    
    
    self.title = @"我的钱包";
    self.bgView.backgroundColor = KNaviBarTintColor;
    //明细
    [self.view addSubview:({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(SCREEN_W - 72, 30, 50, 25);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"明细" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(detailMoneyUseWay) forControlEvents:UIControlEventTouchUpInside];
        btn;
    })];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  充值
 *
 *  @param sender
 */
- (IBAction)payClick:(id)sender {
    
    [self.navigationController pushViewController:[LoveCoinRechargeVC new]
                                         animated:YES];
}
/**
 *  开通会员
 *
 *  @param sender
 */
- (IBAction)openVipClick:(UIButton *)sender {
    
    [self.navigationController pushViewController:[WalletPayVC new]
                                         animated:YES];
}
/**
 *  查看更多特权
 *
 *  @param sender
 */
- (IBAction)moreInfoClick:(id)sender {
    
    [self.navigationController pushViewController:[[WalletRightVC alloc] initWithURLString:@"http://123.207.120.62:8080/wanwanpage/pages/vipright.html"]
                                         animated:YES];
}
/**
 *  明细
 *
 *  @return
 */
- (void)detailMoneyUseWay {
    
    [self.navigationController pushViewController:[WalletDetailUseVC new]
                                         animated:YES];
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
