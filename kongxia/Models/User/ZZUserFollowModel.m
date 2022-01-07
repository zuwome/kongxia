//
//  ZZUserFollowModel.m
//  zuwome
//
//  Created by angBiu on 16/8/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserFollowModel.h"

@implementation ZZUserFollowModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (void)getUserFansListWithParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/followers",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)getUnloginUserFansListWithParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/user/%@/followers",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)getUserAttentionListParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/followings",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)getUnloginUserAttentionListParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/user/%@/followings",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)getFansListWithParam:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/user/followers" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)getAttentionListParam:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/user/followings" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
