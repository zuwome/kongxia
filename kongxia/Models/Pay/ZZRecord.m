//
//  ZZRecord.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRecord.h"

@implementation ZZRecord
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (void)rechargeWithParam:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/user/capital2" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}
@end
