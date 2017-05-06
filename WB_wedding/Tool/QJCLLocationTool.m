//
//  QJCLLocationTool.m
//  LiteratureStar
//
//  Created by 刘人华 on 16/9/5.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "QJCLLocationTool.h"

static QJCLLocationTool *tool = nil;


@interface QJCLLocationTool ()<CLLocationManagerDelegate>
{
    
}
@property (nonatomic, strong) CLGeocoder *geoCoder; //地理编码

@end

@implementation QJCLLocationTool

+ (instancetype)locationTool {
    
    if (!tool) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            tool = [[QJCLLocationTool alloc] init];
        });
    }
    return tool;
}

#pragma mark - private

#pragma mark - public
- (double )getLongitude {
    
    return self.locationManager.location.coordinate.longitude;
}

- (double)getLatitude {
    
    return self.locationManager.location.coordinate.latitude;
}

- (CLLocation *)getUserLocation {
    
    return self.locationManager.location;
}

- (void)getAddressWith:(CLLocation *)location
              complete:(CLGeocoderBlock)geocoderBlcok
{
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {

        if (error) {
            if (geocoderBlcok) geocoderBlcok(NO,error.localizedDescription);
        } else {
            CLPlacemark *placemark = placemarks[0];
            if (geocoderBlcok) geocoderBlcok(YES,placemark.thoroughfare);
        }
        
    }];
}

#pragma mark - delegate
- (void)     locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways
        || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
    } else if (status == kCLAuthorizationStatusDenied
               || status == kCLAuthorizationStatusRestricted
               || status == kCLAuthorizationStatusNotDetermined) {
//        SVPERROR(@"定位服务出现问题");
//        DLog(@"定位服务出现问题");
    }
}

#pragma mark - lazy load
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        if (![CLLocationManager locationServicesEnabled]) {
            
        }
        if (iOS8) {
            [_locationManager requestWhenInUseAuthorization];
        } else {
            [_locationManager startUpdatingLocation];
        }
    }
    return _locationManager;
}

- (CLGeocoder *)geoCoder {
    
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}
@end

