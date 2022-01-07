//
//  ZZUserLabel.m
//  zuwome
//
//  Created by angBiu on 16/6/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserLabel.h"

@implementation ZZUserLabel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"labelId",
                                                       @"content":@"content"
                                                       }];
}

- (void)getData:(NSString *)url next:(requestCallback)next {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"%@",url] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

//跟我 那 更新接口一样
- (void)updateDataWithParam:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user2"] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
