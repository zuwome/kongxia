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
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                       @"id":@"cityId"
                                                       }];
}

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//        @"cityId":@"id"
//             };
//}

- (void)list:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/city/list" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *timestamp = dic[@"timestamp"];
    NSString *cityId = dic[@"id"];
    if ([cityId isKindOfClass:[NSString class]] && ![ZZUtils isEmpty:cityId]) {
        _cityId = cityId;
    }
    
//    if (![timestamp isKindOfClass:[NSNumber class]]) return NO;
//    _createdAt = [NSDate dateWithTimeIntervalSince1970:timestamp.floatValue];
    return YES;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (!_cityId) return NO;
    dic[@"id"] = _cityId;
    return YES;
}

@end
