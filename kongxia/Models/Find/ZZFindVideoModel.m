//
//  ZZFindVideoModel.m
//  zuwome
//
//  Created by angBiu on 2016/12/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFindVideoModel.h"

@implementation ZZFindVideoModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (void)getFindVideoList:(NSDictionary *)param next:(requestCallback)next
{
//    NSString *path = [NSString stringWithFormat:@"/videos"];
//    if ([ZZUserHelper shareInstance].isLogin) {
//        path = [NSString stringWithFormat:@"/api/videos"];
//    }
    NSString *path = [NSString stringWithFormat:@"/main_group/%@/videos", param[@"groupId"]];
    if ([ZZUserHelper shareInstance].isLogin) {
        path = [NSString stringWithFormat:@"/api/main_group/%@/videos", param[@"groupId"]];
    }
    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)getRecommendVideList:(NSDictionary *)param next:(requestCallback)next
{
    NSString *path = [NSString stringWithFormat:@"/videos_recommend"];
    if ([ZZUserHelper shareInstance].isLogin) {
        path = [NSString stringWithFormat:@"/api/videos_recommend"];
    }
    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)getTopicVideoList:(NSDictionary *)param groupId:(NSString *)groupId next:(requestCallback)next
{
    NSString *path = [NSString stringWithFormat:@"/group/%@/videos",groupId];
    if ([ZZUserHelper shareInstance].isLogin) {
        path = [NSString stringWithFormat:@"/api/group/%@/videos",groupId];
    }
    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
