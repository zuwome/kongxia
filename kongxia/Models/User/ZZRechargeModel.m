//
//  ZZRechargeModel.m
//  zuwome
//
//  Created by angBiu on 2016/10/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRechargeModel.h"

@implementation ZZRechargeModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"rechargeID"
                                                       }];
}

- (void)rechargeWithParam:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:@"/api/user/recharge" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
