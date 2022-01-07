//
//  ZZChatStatusModel.m
//  zuwome
//
//  Created by angBiu on 16/8/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatStatusModel.h"

@implementation ZZChatStatusModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (void)getChatStatus:(NSString *)uid next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/chat_status",uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
