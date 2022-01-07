//
//  ZZInternationalCityModel.m
//  zuwome
//
//  Created by angBiu on 2016/11/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZInternationalCityModel.h"

@implementation ZZInternationalCityModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                       @"id":@"cityId"
                                                       }];
}

+ (void)getInternationalCityList:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/country/list" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

@end
