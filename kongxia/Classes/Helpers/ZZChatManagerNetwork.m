//
//  ZZChatManagerNetwork.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/12.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChatManagerNetwork.h"
#import "ZZChatStatusModel.h"
#import "ZZVideoMessage.h"
#import <RongIMLib/RongIMLib.h>
#import "ZZChatBaseModel.h"
#import "ZZMessageBoxModel.h"
#import "ZZDateHelper.h"

@implementation ZZChatManagerNetwork
+(void)sendVideoMessageWithDestinationUidString:(NSString *)uidString withType:(NSString *)type sendType:(NSString *)sendType chatContent:(NSString *)chatContent {
    
    [ZZChatManagerNetwork  judgeWhetherOrNotToSayHelloWithDestinationUidString:uidString withType:type sendType:sendType chatContent:chatContent];
}


/**
 判断是否可以直接聊天 ,并发送消息

 @param uidString 对方的uid
 @param chatContent 消息的内容
 */
+ (void)judgeWhetherOrNotToSayHelloWithDestinationUidString:(NSString *)uidString withType:(NSString *)type sendType:(NSString *)sendType chatContent:(NSString *)chatContent{
    
//    [ZZChatStatusModel getChatStatus:uidString next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        if (error) {
//            [ZZHUD showErrorWithStatus:error.message];
//        } else {
//            ZZChatStatusModel *chatModel = [[ZZChatStatusModel alloc] initWithDictionary:data error:nil];
//
//            if (chatModel.chat_status == 0) {
//                [ZZChatManagerNetwork userRefuseWhenNoChatWithType:type andDestinationUidString:uidString videoMessageType:@"视屏挂断的消息" chatContent:chatContent];
//            } else {
                [ZZChatManagerNetwork userRefuseWithType:type andDestinationUidString:uidString chatContent:chatContent];
//            }
//        }
//    }];
}

/**
 用户拒绝接受视屏 (已经聊过的人)
 */
+ (void)userRefuseWithType:(NSString *)type  andDestinationUidString:(NSString *)uidString chatContent:(NSString *)chatContent
{
    ZZVideoMessage *contentModel = [ZZVideoMessage messageWithContent:chatContent];
    contentModel.videoType = type;
     __block   RCMessage *message =  [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:uidString content:contentModel pushContent:nil pushData:nil success:^(long messageId) {
    
     ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
        model.message = message;
        model.showTime = NO;
        model.message.targetId  = uidString;
        NSDictionary *aDict = @{@"message":model};
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_SendMessage object:nil userInfo:aDict];
        NSLog(@"PY_发送成功,插入聊天列表数据")
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"PY_发送失败");
    }];
}
/**
 用户拒绝接受视屏 (没有聊过的人)
 */
+ (void)userRefuseWhenNoChatWithType:(NSString *)type andDestinationUidString:(NSString *)uidString videoMessageType:(NSString *)videoMessageType chatContent:(NSString *)chatContent
{
    
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/say_hi",uidString] params:@{@"content":chatContent,@"videoMessageType":@"视屏挂断的消息"} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        ZZVideoMessage *contentModel = [ZZVideoMessage messageWithContent:chatContent];
        contentModel.videoType = type;
        
        [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_PRIVATE targetId:uidString sentStatus:SentStatus_SENT content:contentModel];
    }];
}

+ (void)getMessageWithTargetId:(NSString *)targetId isloadSuccess:(void(^)(BOOL success))callIsloadSuccess {
    
    if ([[ZZUserHelper shareInstance] loadSayHiMessageDataWithtargetId:targetId]) {
        if (callIsloadSuccess) {
            callIsloadSuccess(YES);
        }
        return;
    }
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/from/%@/say_hi/all",targetId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            NSMutableArray *array = [ZZMessageBoxModel arrayOfModelsFromDictionaries:data error:nil];
            for (int i=0; i<array.count; i++) {
                ZZMessageBoxModel *boxModel = array[array.count - 1 - i];
                RCTextMessage*sayHiMessage =  [RCTextMessage messageWithContent:boxModel.say_hi.content];
                NSDate *date = [[ZZDateHelper shareInstance] getDateWithDateString:boxModel.say_hi.created_at];
                [[RCIMClient sharedRCIMClient] insertIncomingMessage:ConversationType_PRIVATE targetId:targetId senderUserId:boxModel.say_hi.from.uid receivedStatus:ReceivedStatus_READ content:sayHiMessage sentTime:[date timeIntervalSince1970]*1000 ];
               
            }
            if (callIsloadSuccess) {
                [[ZZUserHelper shareInstance] saveSayHiMessageListDataWithtargetId:targetId];
                  callIsloadSuccess(YES);
            }
        }
    }];
}
@end
