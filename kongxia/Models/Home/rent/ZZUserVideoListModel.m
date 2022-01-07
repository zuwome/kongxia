//
//  ZZUserVideListModel.m
//  zuwome
//
//  Created by angBiu on 2016/12/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserVideoListModel.h"

@implementation ZZUserVideoListModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (void)getUserVideoList:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/videos",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)getUserPageVideoList:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    NSString *path;
    if ([ZZUserHelper shareInstance].isLogin) {
        path = [NSString stringWithFormat:@"/api/user/%@/videos2",uid];
    } else {
        path = [NSString stringWithFormat:@"/user/%@/videos2",uid];
    }
    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
