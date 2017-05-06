//
//  LoveCoinRechargeVC.m
//  WB_wedding
//
//  Created by 刘人华 on 17/1/18.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "LoveCoinRechargeVC.h"
#import "WDMoneyPayView.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface LoveCoinRechargeVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyTf;

@end

@implementation LoveCoinRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"喜币充值";
    self.moneyTf.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (IBAction)nextStepClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (_moneyTf.text.length > 0) {
        double money = [_moneyTf.text intValue] * 0.1;
        [[[WDMoneyPayView alloc] initWithTitle:@"喜币充值" money:money success:^(WDMoneyPay type, id response) {
            NSString *moneyStr = [NSString stringWithFormat:@"充值%@",response];
            if (type == WDMoneyPayAlipay) {
                // 支付宝
//                [self PayAliPayWithMoney:moneyStr];
                [BANetManager ba_requestWithType:BAHttpRequestTypePost
                                       urlString:BASEURL(@"/alipay/pay")
                                      parameters:@{@"body":@"xibi",
                                                   @"subject":@([_moneyTf.text intValue]),
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
            }
            
            
//            SVPINFO(moneyStr);
            
        } cancle:^{
            
        }] show];
    }
}
- (void)PayAliPayWithMoney:(NSString *)money{
    
    NSString *partner = @"2088522653994056";
    NSString *seller = @"17828042949";
    NSString *privateKey = AlipyPrviteKey;
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    
    
    Order *order = [[Order alloc]init];
    
    // 2.生成订单
    // Order 是支付宝制定的订单格式，不能修改，只能赋值
    // 如果在跳转到支付宝的时候，出现“系统繁忙”的提示，可能是Order属性赋值的格式正确
    // 不需要的属性，就可以不用赋值
    
    
    order.partner = partner;    // 合作身份ID，
    order.sellerID = seller;      // 商家支付宝账号
    order.outTradeNO = @"123123123";    // 交易订单号（注意格式要和你们公司后台商量好）
    
    
    
    // 2.2.商品信息（注意格式）
     order.subject = @"测试商品"; //商品标题
    order.body = @"测试描述"; //商品描述
    order.totalFee = @"0.01"; //商品价格
    
        
    // 2.3.回调地址，支付宝服务器异步传给商户服务器的地址
    order.notifyURL =  @"http://www.xxx.com";
    
    
    
    // 下面的五个参数  默认就可以
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";  // 订单失效时间（默认30分钟）看公司标准
    order.showURL = @"m.alipay.com";

    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"LS.WB.Love";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];

    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        
        
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA2"];
        
        
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSLog(@"-----%@",resultDic);
            
            
            
        }];
    }

    
    
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
@end
