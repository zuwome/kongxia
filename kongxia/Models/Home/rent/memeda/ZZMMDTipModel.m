//
//  ZZMMDTipModel.m
//  zuwome
//
//  Created by angBiu on 16/8/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMMDTipModel.h"

@implementation ZZMMDTipListModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZMMDTipModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (void)getMMDTipsListParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/mmd/%@/tips",mid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)getSKTipsListParam:(NSDictionary *)param skId:(NSString *)skId next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/sk/%@/tips",skId] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)getMMDThreeTipsMid:(NSString *)mid next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/mmd/%@/tips_front",mid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
         NSLog(@"PY_%@",data);
        next(error, data, task);
        
    }];
}

+ (void)getSKThreeTipsSkId:(NSString *)skId next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/sk/%@/tips_front",skId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
