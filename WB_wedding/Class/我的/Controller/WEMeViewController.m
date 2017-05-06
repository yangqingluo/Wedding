//
//  WEMeViewController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/3.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEMeViewController.h"
#import "WalletVC.h"
#import <SDCycleScrollView.h>
#import "WELookDetailViewController.h"
#import "WELoveRecoderController.h"
#import "WEHelpAndSuportController.h"
#import "MyEvaluateVC.h"
#import "WESettingController.h"
#import "WEMyMessgaeController.h"
#import "NSString+WETime.h"
@interface WEMeViewController ()

@property (nonatomic, strong) SDCycleScrollView *cycleScrollview;
@property (nonatomic, strong) UIScrollView *mainScrollView; //主要滑动界面
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation WEMeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configUserInterface];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self configUserInterface];
}

- (void)configUserInterface {
    
    XWUserModel *model = [XWUserModel getUserInfoFromlocal];
    self.moneyLab.text = [NSString stringWithFormat:@"%.1lf",[[XWUserModel getUserInfoFromlocal].money doubleValue]];
   

        NSURL *imagURL =[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@/%@",ImageURL,model.xw_id, [NSString headerImageWithArrayString:model.imgFileNames]]];
        [_headerImgView sd_setImageWithURL:imagURL placeholderImage:nil];
        
    
}

- (IBAction)btnClick:(UIButton *)sender {
    
    switch (sender.tag - 800) {
        case 0://个人资料
        {
//            SVPSTATUS(@"跳转中...");
//            [BANetManager ba_requestWithType:BAHttpRequestTypeGet
//                                   urlString:BASEURL(@"/user/findonebyid")
//                                  parameters:@{@"userId":[XWUserModel getUserInfoFromlocal].xw_id}
//                                successBlock:^(id response) {
//                                    [SVProgressHUD dismiss];
//                                    if ([response[@"success"] boolValue]) {
                                        WELookDetailViewController *vc = [[WELookDetailViewController alloc]initWithType:vcTypeSelfInfo];
            
//                                        vc.dic = response[@"data"];
                                         
                                        [self.navigationController pushViewController:vc animated:YES];
//                                    } else{
//                                        SVPERROR(response[@"msg"]);
//                                    }
//                                }
//                                failureBlock:^(NSError *error) {
//                                    SVPERROR(@"网络错误");
//                                }
//                                    progress:nil];
//            
//            
        }
            break;
        case 1://我的钱吧
        {
            WalletVC *vc = [[WalletVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2://恋爱记录
        {
            WELoveRecoderController *vc = [[WELoveRecoderController alloc]init];
             
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 3://我的评价
        {
            MyEvaluateVC *vc = [[MyEvaluateVC alloc] init];
             
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4://我的消息
        {
            WEMyMessgaeController *vc = [[WEMyMessgaeController alloc]init];
             
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5://设置
        {
            WESettingController *vc = [[WESettingController alloc]init];
             
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 6://帮组和设置
        {
            WEHelpAndSuportController *vc = [[WEHelpAndSuportController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}



@end
