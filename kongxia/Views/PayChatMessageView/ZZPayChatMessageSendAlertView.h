//
//  ZZPayChatMessageSendAlertView.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/24.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZWeiChatBaseEvaluation.h"

/**
 第一次进入聊天界面判断对面需要提示  发送么币的就提示
 */
@interface ZZPayChatMessageSendAlertView : ZZWeiChatBaseEvaluation
+ (void)showAlertView;
@end
