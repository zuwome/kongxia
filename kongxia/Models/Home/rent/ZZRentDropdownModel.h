//
//  ZZRentDropdownModel.h
//  zuwome
//
//  Created by angBiu on 16/6/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ZZRentDropdownModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;//简略地址
@property (nonatomic, strong) NSString *detaiString;//详细地址
@property (nonatomic, strong) CLLocation *location;//经纬度
@property (nonatomic, strong) NSString *city;//城市名
@property (nonatomic, assign) BOOL isAbroat;//是否是国外

@property (nonatomic, copy) NSString *province;

@property (nonatomic, assign) float address_lng;

@property (nonatomic, assign) float address_lat;

- (double)currentDistance:(CLLocation *)userLocation;

@end
