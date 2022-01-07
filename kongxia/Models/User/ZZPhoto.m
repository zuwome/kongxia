//
//  ZZPhoto.m
//  zuwome
//
//  Created by wlsy on 16/1/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPhoto.h"

@implementation ZZPhoto

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)add:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/api/photo" params:[self toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)remove:(requestCallback)next {
    [ZZRequest method:@"DELETE" path:[NSString stringWithFormat:@"/api/photo/%@", self.id] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
