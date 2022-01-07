//
//  ZZTopicModel.m
//  zuwome
//
//  Created by angBiu on 2017/4/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTopicModel.h"

@implementation ZZTopicGroupModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"groupId":@"id"}];
}

@end

@implementation ZZTopicModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (void)getTopicsWithParam:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/video/groups" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

+ (void)getSKTopicWithParam:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/sk/groups3" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

+ (void)getTopicDetail:(NSString *)groupId next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/group/%@/detail",groupId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

@end
