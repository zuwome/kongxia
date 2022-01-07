//
//  ZZMemedaTopicModel.m
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMemedaTopicModel.h"

@implementation ZZMemedaTopicModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"topicID"
                                                       }];
}

- (void)getMemedaTopics:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/mmd/groups" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)getTopicMemedaListParam:(NSDictionary *)param topicId:(NSString *)topicId next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/group/%@/mmds",topicId] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
