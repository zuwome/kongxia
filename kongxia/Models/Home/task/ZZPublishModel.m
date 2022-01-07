//
//  ZZPublishModel.m
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZPublishModel.h"

@implementation ZZPublishModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (void)getPublishGraberList:(NSDictionary *)parm pId:(NSString *)pId next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/pd/%@/grabers",pId] params:parm next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

+ (void)getRoomToken:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/channel_key" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            next(error,data,task);
        });
    }];
}

+ (void)hideSnatchUser:(NSString *)uid next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/set_hide",uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

+ (void)noCounting:(NSString *)pid next:(requestCallback)next {
    
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/pd/%@/flag",pid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

@end
