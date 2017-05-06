//
//  QJCLLocationTool.h
//  LiteratureStar
//
//  Created by 刘人华 on 16/9/5.
//  Copyright © 2016年 dahua. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
typedef void(^CLGeocoderBlock)(BOOL succes, id obj);

@interface QJCLLocationTool : NSObject

+ (instancetype)locationTool;
@property (nonatomic, strong) CLLocationManager *locationManager; //定位

- (CLLocation *)getUserLocation;

- (double )getLatitude;
- (double )getLongitude;
- (void)getAddressWith:(CLLocation *)location complete:(CLGeocoderBlock)geocoderBlcok;


@end
