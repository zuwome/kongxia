//
//  ZZMyLocationModel.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/24.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZZMyLocationModel

@end

@interface ZZMyLocationModel : JSONModel

@property (nonatomic, copy) NSString *_id;

@property (nonatomic, copy) NSString *simple_address;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) double address_lat;

@property (nonatomic, assign) double address_lng;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *user;

- (double)currentDistance:(CLLocation *)userLocation;

@end

