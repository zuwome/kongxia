//
//  ZZRuleHelper.m
//  zuwome
//
//  Created by wlsy on 16/1/30.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRuleHelper.h"

@implementation ZZRuleHelper

+ (void)pullRefuseList:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/api/rule/refuse" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}
+ (void)pullCancelList:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/api/rule/cancel" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}
+ (void)pullRefundList:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/api/rule/refund2" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}
+ (void)pullAppealList:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/api/rule/appeal" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)pullDepositList:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/rule/refund_deposit" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)pullRefund:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/rule" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
