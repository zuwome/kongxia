//
//  ZZRent.m
//  zuwome
//
//  Created by wlsy on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRent.h"

@implementation ZZRent
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (NSNumber *)minPrice {
    __block float xmin = MAXFLOAT;
    [self.topics enumerateObjectsUsingBlock:^(ZZTopic *topic, NSUInteger idx, BOOL * _Nonnull stop) {
        float x = [topic.price floatValue];
        if (x < xmin) xmin = x;
    }];
    if (xmin == MAXFLOAT) {
        xmin = 0;
    }
    return @(xmin);
}

- (void)enable:(BOOL)show next:(requestCallback)next {
    [ZZRequest method:show?@"POST":@"DELETE" path:@"/api/rent/show" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
