//
//  ZZUserWXModel.m
//  zuwome
//
//  Created by angBiu on 2017/6/2.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserWXModel.h"

@implementation ZZUserWXModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"wid"
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (void)getUserWxList:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/user/wechat_seens" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

+ (void)deleteWXRecord:(NSString *)wid next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/wechat_seen/%@/hide",wid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

@end
