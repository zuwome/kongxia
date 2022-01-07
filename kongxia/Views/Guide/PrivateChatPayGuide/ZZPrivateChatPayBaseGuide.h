//
//  ZZPrivateChatPayBaseGuide.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//私聊付费的弹窗

#import "ZZWeiChatBaseEvaluation.h"

/**
 私信收益发送每条消息2么币的提示
 */
@interface ZZPrivateChatPayBaseGuide : ZZWeiChatBaseEvaluation

+ (void)showSendPrivChatMessageWhenFirstInto;

@end
