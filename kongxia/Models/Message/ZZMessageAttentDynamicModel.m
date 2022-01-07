//
//  ZZMessageAttentDynamicModel.m
//  zuwome
//
//  Created by angBiu on 16/8/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageAttentDynamicModel.h"

@implementation ZZMessageAttentDynamicModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (void)getAttentDynamic:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/following/messages" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)getUserPageDynamic:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    NSString *path;
    if ([ZZUserHelper shareInstance].isLogin) {
        path = [NSString stringWithFormat:@"/api/user/%@/actions",uid];
    } else {
        path = [NSString stringWithFormat:@"/user/%@/actions",uid];
    }
    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
