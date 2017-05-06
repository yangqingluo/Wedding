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

@property (nonatomic,strong)PhotoPickerView   *piView;


@end

@implementation WEPostTimeLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUserInterface];
}
- (void)configUserInterface{
    self.title = @"记录时间轴";
    WS;
    [self setNavigationRightBtnWithTitle:@"确定" actionBack:^{
        if (_titleLable.text.length&&self.textView.text.length&&self.adressTextFile.text.length) {
            [weakSelf postTimeLine:weakSelf.adressTextFile.text tile:weakSelf.titleLable.text note:weakSelf.textView.text];
                     
        }else{
            [weakSelf showMessage:@"请填写完所有的信息" toView:weakSelf.view];
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
    
    [self showActivity];
    
    NSString *lo = [KUserDefaults objectForKey:@"locationCity"];
    if ([lo isEqualToString:@""]||lo == nil) {
        lo =@"";
    }
  
    NSDictionary *dic = @{
                          @"timeEventId":self.infoDic[@"id"],
                          @"location":location,
                          @"title":title,
                          @"city":lo,
                          @"note":note,
                          @"sex":[XWUserModel getUserInfoFromlocal].sex,
                          };
        
    AFHTTPSessionManager  * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    //        manager.allowsInvalidSSLCertificate = YES;
    
    //    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    AFHTTPRequestSerializer  *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //
    //    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.requestSerializer = requestSerializer;
    
    manager.securityPolicy.allowInvalidCertificates=YES;
    
    manager.responseSerializer.acceptableContentTypes =
    
    [NSSet setWithObjects:@"text/html",@"text/json", nil];
    
    // 设置MIME格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    
    
    [manager POST:BASEURL(@"/timeevent/createcontent") parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int idx = 0;
        for (UIImage *image in self.piView.selectedPhotos) {
            idx ++;
            NSData *data= UIImageJPEGRepresentation(image, 0.3);
            [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"picflie%ld.jpg",(long)idx] mimeType:@"image/jpeg"];
            
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [self cancleActivity];
        [self showMessage:@"发布成功" toView:self.view];
        [KNotiCenter postNotificationName:@"PostSuccess" object:nil];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self cancleActivity];
        [self showMessage:error.description toView:self.view];

    }];
    
   

    
}




















@end
