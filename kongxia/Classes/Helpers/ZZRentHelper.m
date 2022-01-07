//
//  ZZRentHelper.m
//  zuwome
//
//  Created by wlsy on 16/1/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentHelper.h"

@implementation ZZRentHelper

- (void)pullExploreWithParams:(NSMutableDictionary *)params next:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/rent/explore" params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}


- (void)pullExploreWithParamsAll:(NSMutableDictionary *)params lt:(NSDate *)lt next:(requestCallback)next {
    if (!params) {
        params = [NSMutableDictionary dictionary];
    }
    if (lt) {
        [params setObject:lt forKey:@"lt"];
    }
    [ZZRequest method:@"GET" path:@"/rent/explore2" params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}


- (void)pullWithParams:(NSMutableDictionary *)params lt:(NSDate *)lt next:(requestCallback)next {
    if (!params) {
        params = [NSMutableDictionary dictionary];
    }
    if (lt) {
        [params setObject:lt forKey:@"lt"];
    }
    [ZZRequest method:@"GET" path:@"/api/rents" params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
