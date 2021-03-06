//
//  ZZCity.m
//  zuwome
//
//  Created by wlsy on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZCity.h"

@implementation ZZCity
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"cityId"
                                                       }];
}

- (void)list:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/city/list" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
