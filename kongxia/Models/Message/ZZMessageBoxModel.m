//
//  ZZMessageBoxModel.m
//  zuwome
//
//  Created by angBiu on 2017/6/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZMessageBoxModel.h"

@implementation ZZMessageBoxDetailModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"boxId"
                                                       }];
}

@end

@implementation ZZMessageBoxModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (void)getMessageBoxList:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/user/say_hi/total" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

+ (void)sayHiWithUid:(NSString *)uid param:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/say_hi",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

@end
