//
//  ZZComment.m
//  zuwome
//
//  Created by wlsy on 16/1/31.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZComment.h"

@implementation ZZComment
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)add:(NSString *)status next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/comment?order_status=%@", self.order,status];
    [ZZRequest method:@"POST" path:path params:[self toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
