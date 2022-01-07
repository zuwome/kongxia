//
//  ZZUserBlackModel.m
//  zuwome
//
//  Created by angBiu on 16/9/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserBlackModel.h"

@implementation ZZUserBlackDetailModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"blackId"
                                                       }];
}

@end

@implementation ZZUserBlackModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)getBlackList:(NSDictionary *)aDict next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/user/blacks" params:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
