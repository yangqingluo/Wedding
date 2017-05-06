//
//  AppDelegate.h
//  WB_wedding
//
//  Created by 谢威 on 17/1/3.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,getter=isWiFi) BOOL   wifiStatus;//是否是wifi状态
/**
 *  百度地图管理者
 */
@property (nonatomic,strong)BMKMapManager       *mapManager;
/**
 *   geo搜索服务
 */
@property (nonatomic,strong)BMKGeoCodeSearch            *geocodesearch;
@end

