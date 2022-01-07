//
//  ZZShowMessageRed.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/18.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//消息小红点显示和过滤

#import "ZZShowMessageRed.h"

@implementation ZZShowMessageRed

+ (void)getUnRedOtherMessage {
    [ZZUser getUserUnread:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            ZZUserUnread *userUnread = [[ZZUserUnread alloc] initWithDictionary:data error:nil];
            [ZZUserHelper shareInstance].unreadModel = userUnread;
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdateTaskSnatchCount object:nil];
        }
    }];
}
@end
