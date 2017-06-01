//
//  WEPostTimeLineController.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/16.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEPostTimeLineController.h"
#import "PhotoPickerView.h"

@interface WEPostTimeLineController ()

@property (weak, nonatomic) IBOutlet UITextField *titleLable;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *picContentView;
@property (weak, nonatomic) IBOutlet UITextField *adressTextFile;

@property (strong, nonatomic) PhotoPickerView   *piView;


@end

@implementation WEPostTimeLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUserInterface];
}
- (void)configUserInterface{
    self.title = @"记录时间轴";
    QKWEAKSELF;
    [self setNavigationRightBtnWithTitle:@"确定" actionBack:^{
        if (_titleLable.text.length&&self.textView.text.length&&self.adressTextFile.text.length) {
            [weakself postTimeLine:weakself.adressTextFile.text tile:weakself.titleLable.text note:weakself.textView.text];
                     
        }else{
            [weakself showMessage:@"请填写完所有的信息" toView:weakself.view];
            return;
            
        }
        
    }];
    self.piView = [[PhotoPickerView alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth-30,90) itemMargin:15 viewController:self maxChoose:9 holderImageName:@"xw_post"];
    [self.picContentView addSubview:self.piView];
    [self.piView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.picContentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.picContentView.mas_top);
        make.height.mas_equalTo(self.scaleY*90);
    }];

    
}
#pragma mark -- 发布
- (void)postTimeLine:(NSString *)location tile:(NSString *)title note:(NSString *)note{
    [self showHudInView:self.view hint:nil];
    
    NSDictionary *m_dic = @{@"timeEventId":self.data.ID,
                          @"location":location,
                          @"title":title,
                          @"city":[AppPublic getInstance].locationCity,
                          @"note":note,
                          @"sex":[AppPublic getInstance].userData.sex,
                          };
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:self.piView.selectedPhotos.count];
    for (UIImage *image in self.piView.selectedPhotos) {
        [imageArray addObject:dataOfImageCompression(image, NO)];
    }
    
    QKWEAKSELF;
    [[QKNetworkSingleton sharedManager] pushImages:imageArray Parameters:m_dic URLFooter:@"/timeevent/createcontent" completion:^(id responseBody, NSError *error){
        [weakself hideHud];
        
        if (!error) {
            if (isHttpSuccess([responseBody[@"success"] intValue])) {
                [KNotiCenter postNotificationName:kNotification_PushTimeLine object:nil];
                [weakself.navigationController popViewControllerAnimated:YES];
            }
            else {
                [weakself showHint:responseBody[@"msg"]];
            }
        }
        else{
            [weakself showHint:@"网络出错"];
        }
        
    } withUpLoadProgress:^(float progress){
        
    }];
}

@end
