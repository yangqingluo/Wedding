//
//  FirstPageController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "FirstPageController.h"
#import "WERegisterController.h"
#import "LoginViewController.h"
#import <UIImage+Gif.h>

@interface FirstPageController ()

@property (nonatomic, strong) UIImageView *gifImageView;

@end

@implementation FirstPageController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"loginBg.jpg"].CGImage);
    [self hidenNavigationBar];
    
    double radius = MAX(120, 0.375 * screen_width);
    self.gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, radius, radius)];
    self.gifImageView.center = CGPointMake(0.5 * screen_width, 0.4 * screen_height - 0.5 * self.gifImageView.height);
    [self.view addSubview:self.gifImageView];
    
    self.gifImageView.image = [UIImage sd_animatedGIFNamed:@"heartbeat"];
}

- (IBAction)login:(UIButton *)sender {
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)register:(UIButton *)sender {
    WERegisterController *vc = [[WERegisterController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
