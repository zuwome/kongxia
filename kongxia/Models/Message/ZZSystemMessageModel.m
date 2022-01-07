//
//  ZZSystemMessageModel.m
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSystemMessageModel.h"

@implementation ZZSystemMessageDetailModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation ZZSystemMessageModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (void)getSystemMessageList:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/api/message/system" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
