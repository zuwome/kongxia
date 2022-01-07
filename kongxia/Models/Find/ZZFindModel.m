//
//  ZZFindModel.m
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFindModel.h"

@implementation ZZFindFashionModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)getFindFashionList:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/mmd_hot/users" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)getFindFashionListNeedLogin:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/mmd_hot/users2" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end

@implementation ZZFindModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)getFindBanner:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/system/discovery_banner" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
