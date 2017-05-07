//
//  LoginViewController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "LoginViewController.h"

#import "WECodeLoginController.h"
#import "WELoginTool.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "EMClient.h"

@interface LoginViewController ()<BMKGeoCodeSearchDelegate,
BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet UIButton *logingBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
@property (nonatomic,copy)NSString  *lng;
@property (nonatomic,copy)NSString  *lat;
/********************* 地图 ****************************/
/**
 *   geo搜索服务
 */
@property (nonatomic,strong)BMKGeoCodeSearch            *geocodesearch;
/**
 *  定位服务类
 */
@property (nonatomic,strong)BMKLocationService          *locService;
/**
 *  当前的经纬度
 */
@property (nonatomic,strong)BMKUserLocation             *currentLocation;




@end

@implementation LoginViewController


- (void)dealloc{
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_locService != nil) {
        _locService = nil;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _geocodesearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    self.logingBtn.layer.cornerRadius = 10;
    self.logingBtn.layer.masksToBounds = YES;
    
    self.baseNavigationBar.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    self.statusView.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    
    [self.baseNavigationBar.backBtn setImage:[UIImage imageNamed:@"return48"] forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.baseNavigationBar];
    [self.view bringSubviewToFront:self.statusView];

    
    // 开始定位服务
    [self configLocation];

    
}

#pragma mark -- 定位服务
- (void)configLocation{
    _locService = [[BMKLocationService alloc]init];
    // 开始定位
    [_locService startUserLocationService];
    // 定位到用户位置后才去 地理编码啊
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    self.geocodesearch.delegate = self;
    
    
}



#pragma mark -- 百度地图代理
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"当前定位城市是：%@",result.addressDetail.city);
        [self.locService stopUserLocationService];
    }
    
    
}
/**
 *  用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.currentLocation = userLocation;
    
    CLLocation *location = self.currentLocation.location;
    self.lng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    self.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    
    
    [self getLocalNameWithBMKUserLocation:userLocation];
    
    
    
}
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败  原因是:%@",error);
    if (error) {
        [self showMessage:@"请开启定位服务" toView:self.view];
    }
    
}



#pragma mark - 反geo检索（根据经纬度获取具体地址）
- (void)getLocalNameWithBMKUserLocation:(BMKUserLocation *)location{
    ///反geo检索信息类
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = location.location.coordinate;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    }
    else{
        NSLog(@"反geo检索发送失败");
    }
}

- (IBAction)login:(UIButton *)sender {

    //验证手机号
    if (self.passWordText.text.length && self.numberText.text.length) {
        [self showActivity];
        
        [WELoginTool normalLoginWithNumber:self.numberText.text latitude:self.lat ? self.lat : @"0" loginType:@"0" longitude:self.lng ? self.lng : @"0" password:self.passWordText.text success:^(id model) {
            
            
            EMError *error = [[EMClient sharedClient] loginWithUsername:self.numberText.text password:EMPassword];
            if (!error || error.code == EMErrorUserAlreadyLogin) {
                
                // 1.环信自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                //
                //                    // 2.回到主界面
                [self cancleActivity];
                [self showMessage:@"登录成功" toView:self.navigationController.view];
                
                [[AppPublic getInstance] goToMainVC];
                
            } else if (error.code == EMErrorUserNotFound) { //未注册
                
                EMError *error = [[EMClient sharedClient] registerWithUsername:self.numberText.text password:self.passWordText.text];
                if (error==nil) {
                    NSLog(@"注册成功");
                    SVPSUCCESS(@"环信注册成功");
                }
            }
            
            
        } failed:^(NSString *error) {
            [self cancleActivity];
            [self showMessage:error toView:self.view];
        }];
        
    }else{
        
        [self showMessage:@"请输入手机号和密码" toView:self.view];

        return;
        
    }
    
        
    
}

- (IBAction)codeLogin:(UIButton *)sender {
    WECodeLoginController *vc = [[WECodeLoginController alloc]init];
    if (self.lng!=nil && self.lat!=nil) {
        vc.lat = self.lat;
        vc.lng = self.lng;
    }else{
        vc.lat = @"0";
        vc.lng = @"0";

    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
