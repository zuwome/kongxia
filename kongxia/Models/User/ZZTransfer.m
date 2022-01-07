//
//  ZZTransfer.m
//  zuwome
//
//  Created by wlsy on 16/2/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTransfer.h"

@implementation ZZTransfer

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)add:(requestCallback)next {
//    NSString *path = [NSString stringWithFormat:@"/api/user/transfer"];
    NSString *path = [NSString stringWithFormat:@"/api/user/newTransfer"];
    [ZZRequest method:@"POST" path:path params:[self toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)rechargeWithParam:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:@"/api/user/recharge" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
