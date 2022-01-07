//
//  ZZMessage.m
//  zuwome
//
//  Created by wlsy on 16/1/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessage.h"

@implementation ZZMessageResponseModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"results" : [ZZMessage class],
             };
}

@end


@implementation ZZMessage
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (void)pullRent:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/api/message/rent" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}
+ (void)pullRealname:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/api/message/realname" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)pullOrder:(NSString *)orderId next:(requestCallback)next {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/message/order/%@", orderId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (NSString *)dateString {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    return [formatter stringFromDate:self.created_at];

}


@end
