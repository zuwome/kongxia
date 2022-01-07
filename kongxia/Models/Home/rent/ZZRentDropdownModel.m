//
//  ZZRentDropdownModel.m
//  zuwome
//
//  Created by angBiu on 16/6/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentDropdownModel.h"

@implementation ZZRentDropdownModel



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.detaiString forKey:@"detaiString"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isAbroat] forKey:@"isAbroat"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.detaiString = [aDecoder decodeObjectForKey:@"detaiString"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.isAbroat = [[aDecoder decodeObjectForKey:@"isAbroat"] boolValue];
    }
    
    return self;
}

- (double)currentDistance:(CLLocation *)userLocation {
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:_address_lat longitude:_address_lng];
    return [curLocation distanceFromLocation:userLocation] / 1000;
}

@end
