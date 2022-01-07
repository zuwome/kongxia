//
//  ZZContactModel.m
//  zuwome
//
//  Created by angBiu on 2016/10/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZContactModel.h"

@implementation ZZContactModel

- (void)blcokContact:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:@"/api/user/contacts/block" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)unblockContact:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:@"/api/user/contacts/unblock" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)getContactBlockList:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/user/block/contacts" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
