//
//  WEMessageReslutController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/22.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEMessageReslutController.h"

@interface WEMessageReslutController ()
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation WEMessageReslutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseNavigationBar.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    self.statusView.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    
    [self.baseNavigationBar.backBtn setImage:[UIImage imageNamed:@"return48"] forState:UIControlStateNormal];
    
    [self.view bringSubviewToFront:self.baseNavigationBar];
    [self.view bringSubviewToFront:self.statusView];
    
    
    if ([[NSString stringWithFormat:@"%@",self.dic[@"msgType"]]isEqualToString:@"2"]) {
        // 复合
         self.name.text = [NSString stringWithFormat:@"%@的心里话",self.dic[@"otherNickName"]];
        
    }else{
        // 定位
          self.name.text = [NSString stringWithFormat:@"%@想和你开启定位",self.dic[@"otherNickName"]];
          self.content.text = [NSString stringWithFormat:@"%@",self.dic[@"content"]];
        
    }

}

- (IBAction)recivieBtnClick:(id)sender {
}


@end
