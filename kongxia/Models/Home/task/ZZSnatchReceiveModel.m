//
//  ZZSnatchReceiveModel.m
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSnatchReceiveModel.h"

@implementation ZZSnatchReceiveModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (void)getMySantchReceiveList:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/pd_receive/list" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

@end
