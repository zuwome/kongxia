//
//  ZZMyLocationModel.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/24.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZMyLocationModel.h"

@implementation ZZMyLocationModel



+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (double)currentDistance:(CLLocation *)userLocation {
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:_address_lat longitude:_address_lng];
    return [curLocation distanceFromLocation:userLocation] / 1000;
}

- (BOOL)isEqual: (id)other {
    NSLog(@"didEnter: IsEqual");
    return YES;
}

- (NSUInteger)hash {
    NSLog(@"didEnter: Hash");
    return 1;
}

@end

