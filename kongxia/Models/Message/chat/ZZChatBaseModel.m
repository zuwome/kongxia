//
//  ZZChatBaseModel.m
//  zuwome
//
//  Created by angBiu on 16/10/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBaseModel.h"
#import "ZZDateHelper.h"

@implementation ZZChatBaseModel

/**
 *  判断是否超过最大撤回消息时间
 */
- (BOOL)isPassRevokeTime {
    // 只有发送的消息才能允许被撤回
    if (_message.messageDirection != MessageDirection_SEND) {
        return NO;
    }
    
    // 最大可撤回时间 2分钟
    long long maximunRevokeTime = 2 * 60 * 1000;
    
    // 当前时间
    long long currentMillisecond = [[[NSDate alloc] init] timeIntervalSince1970] * 1000;
    
    return (currentMillisecond - _message.sentTime > maximunRevokeTime);
}

@end
