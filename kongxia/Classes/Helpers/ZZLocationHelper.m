//
//  ZZLocationHelper.m
//  zuwome
//
//  Created by angBiu on 2017/1/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLocationHelper.h"

@implementation ZZLocationHelper

+ (instancetype)shareInstance
{
    __strong static id sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

#pragma mark - 定位

- (void)getLocation
{
    _haveGetLocation = NO;
    if ([CLLocationManager locationServicesEnabled] && [ZZUserHelper shareInstance].isLogin) {
        //定位地址
        if (!_LocationManager) {
            _LocationManager = [[CLLocationManager alloc] init];
            _LocationManager.delegate = self;
            [_LocationManager requestWhenInUseAuthorization]; //使用中授权
        }
        [_LocationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (_haveGetLocation) {
        return;
    }
    _haveGetLocation = YES;
    [_LocationManager stopUpdatingLocation];
    if ([ZZUserHelper shareInstance].isLogin) {
        [[ZZUserHelper shareInstance] updateUserLocationWithLocation:locations[0]];
        [ZZUserHelper shareInstance].location = locations[0];
    }
}

@end
