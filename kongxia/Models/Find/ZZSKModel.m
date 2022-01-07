//
//  ZZSKModel.m
//  zuwome
//
//  Created by angBiu on 2016/12/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSKModel.h"

@implementation ZZSKModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"skId"
                                                       }];
}

+ (void)zanSkWithModel:(ZZSKModel *)model next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/sk/%@/like",model.skId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            model.like_count++;
            [ZZHUD showSuccessWithStatus:@"点赞成功"];
            next(error,data,task);
        }
    }];
}

+ (void)unzanSkWithModel:(ZZSKModel *)model next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/sk/%@/like",model.skId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            if (model.like_count) {
                model.like_count--;
            }
            [ZZHUD showSuccessWithStatus:@"取消赞"];
            next(error,data,task);
        }
    }];
}

+ (void)getSKDetail:(NSString *)skId params:(NSDictionary *)params next:(requestCallback)next
{
    NSString *path = [NSString stringWithFormat:@"/sk/%@/detail",skId];
    if ([ZZUserHelper shareInstance].isLogin) {
        path = [NSString stringWithFormat:@"/api/sk/%@/detail",skId];
    }
    [ZZRequest method:@"GET" path:path params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
   
        next(error,data,task);
    }];
}

+ (void)getSKCommentList:(NSDictionary *)param skId:(NSString *)skId next:(requestCallback)next
{
    NSString *path = [NSString stringWithFormat:@"/sk/%@/replies",skId];
    if ([ZZUserHelper shareInstance].isLogin) {
        path = [NSString stringWithFormat:@"/api/sk/%@/replies",skId];
    }
    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        
        next(error,data,task);
    }];
}

+ (void)commentMememdaParam:(NSDictionary *)param skId:(NSString *)skId next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/sk/%@/reply",skId] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

+ (void)dashangSkWithParam:(NSDictionary *)param skId:(NSString *)skId next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/sk/%@/tip",skId] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

+(void)deleteSKWithSkId:(NSString *)skId param:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/sk/%@/del",skId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

+ (void)deleteComentWithSkId:(NSString *)skId replyId:(NSString *)replyId next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/sk/%@/reply/%@/del",skId,replyId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

@end

@implementation ZZSKDetailModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end
