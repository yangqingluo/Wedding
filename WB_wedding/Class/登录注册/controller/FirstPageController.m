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
#import "ImagePickerController.h"
#import "JKAlert.h"
@interface FirstPageController ()

@end

@implementation FirstPageController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hidenNavigationBar];
}
- (IBAction)login:(UIButton *)sender {
//    JKAlert *aler = [[JKAlert alloc]initWithTitle:@"提示" andMessage:@"选择" style:STYLE_ACTION_SHEET];
//    [aler addButton:ITEM_OK withTitle:@"相册选择" handler:^(JKAlertItem *item) {
//        
//        ImagePickerController *imageVC1 = [[ImagePickerController alloc]init];
//        imageVC1.allowsEditing = YES;
//        
//        [imageVC1 cameraSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum onFinishingBlock:^(UIImagePickerController *picker, NSDictionary *info, UIImage *originalImage, UIImage *editedImage) {
//            
//        
//        } onCancelingBlock:^{
//            
//        }];
//        [self presentViewController:imageVC1 animated:YES completion:nil];
//    }];
//    [aler addButton:ITEM_OK withTitle:@"拍照" handler:^(JKAlertItem *item) {
//        
//        
//    }];
//    [aler show];
//    
    
    LoginViewController *vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)register:(UIButton *)sender {
    WERegisterController *vc = [[WERegisterController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
