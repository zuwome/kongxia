//
//  ZZPrivateChatPayManager.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
/*
 客户端的流程

 
 */
#import "ZZActivityUrlNetManager.h"
#import <RongIMLib/RongIMLib.h>
#import "ZZChatUtil.h"
#import "ZZGifMessageModel.h"
#import "ZZPrivateChatPayManager.h"
#import "ZZMeBiViewController.h"
#import "ZZChatBaseModel.h"
#import "ZZKeyValueStore.h"
@implementation ZZPrivateChatPayManager

/**
 请求用户的私聊付费的模块,以及用户当前的违禁词的个数
 
 @param uid 当前即将聊天的用户
 @param privateChatPayCallBack  私聊付费的回调
 */
+ (void)requestUserInfoAndSensitiveNumberWithUid:(NSString *)uid privateChatPay:(void(^)(ZZPrivateChatPayModel *payModel))privateChatPayCallBack {
    
    __block  ZZPrivateChatPayModel *model;
    __block   NSInteger number = -1;
    __block   int count = 0;
    /** 未读的消息 */
    __block   NSInteger wait_answerCout = -1;
    __block   NSInteger answeredCout = -1;
   /** 请求私聊付费 */

        [ZZPrivateChatPayManager requestUserInfoWithUid:uid privateChatPay:^(ZZPrivateChatPayModel *payModel) {
            model = payModel;
            count +=1;
            //更新UI操作
            if (privateChatPayCallBack) {
                if (count>2) {
                    NSLog(@"PY_私聊付费的数据_接口%d",count);
                    model.answeredCout = answeredCout;
                    model.wait_answerCout = wait_answerCout;
                    model.timesNumber = number;
                    model.unReadCout = answeredCout;
                    privateChatPayCallBack(model);
                }
            }
        }];


    [ZZUserHelper requestMeBiAndMoneynext:^(ZZError *error, id data, NSURLSessionDataTask *task) {
           count +=1;
        if (privateChatPayCallBack) {
            if (count>2) {
                NSLog(@"PY_私聊付费的数据_接口%d",count);
                model.answeredCout = answeredCout;
                model.wait_answerCout = wait_answerCout;
                model.timesNumber = number;
                model.unReadCout = answeredCout;
                privateChatPayCallBack(model);
            }
        }
    }];
  
        [ZZPrivateChatPayManager requestUserInfoPrivateChatMessageWithUid:uid callBack:^(NSNumber *wait_answerNumber, NSNumber *answered) {
            wait_answerCout = [wait_answerNumber integerValue];
            answeredCout= [answered integerValue];
            count +=1;
            //更新UI操作
            if (privateChatPayCallBack) {
                if (count>2) {
                    NSLog(@"PY_私聊付费的数据_接口%d",count);
                    model.answeredCout = answeredCout;
                    model.wait_answerCout = wait_answerCout;
                    model.timesNumber = number;
                    model.unReadCout = answeredCout;
                    privateChatPayCallBack(model);
                }
            }
        }];
}

/**
 
 私聊付费的请求
 
 @param uid 对方的uid
 @param completionCall 私聊付费的回调
 */
+ (void)requestUserInfoWithUid:(NSString *)uid privateChatPay:(void(^)(ZZPrivateChatPayModel *payModel))privateChatPayCallBack  {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/chatcharge2",uid]  params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        ZZPrivateChatPayModel *payModel ;
        if (data) {
           NSLog(@"PY_私聊付费的接口_%@",data);
           payModel= [[ZZPrivateChatPayModel alloc] initWithDictionary:data error:nil];
           payModel.isRequessSuccess = YES;
         }
        if (privateChatPayCallBack) {
            privateChatPayCallBack(payModel);
        }
        if (error) {
            [ZZHUD showTastInfoErrorWithString:error.message];
        }
    }];
}


/**
 上传给服务器关于该用户发送的违禁词
 
 @param uid 聊天的对象
 @param connect 聊天的内容
 @param privateChatPayCallBack  违禁词的次数
 */
+ (void)requestUserInfoWithUid:(NSString *)uid content:(NSString *)connect privateChatPay:(void (^)(NSInteger bannedWordNum))privateChatPayCallBack {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"touid"];
    [dic setObject:connect forKey:@"content"];
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/addbanchat",uid] params:dic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            if (privateChatPayCallBack) {
                NSInteger number = [data[@"times"] integerValue];
                privateChatPayCallBack(number);
            }
        }
    }];
}

/**
 私聊付费的么币充值提醒
 @param payChatModel
 @param CallBack 要充值了
 @param NoPayCallBack 不需要充值
 @param Nav  控制器
 */
+ (void)payMebiWithPayChatModel:(ZZPrivateChatPayModel *)payChatModel nav:(UINavigationController *)nav CallBack:(void(^)(void))CallBack NoPayCallBack:(void(^)(void))NoPayCallBack  vc:(UIViewController *)vc{
    if ([[ZZUserHelper shareInstance].loginer.mcoin integerValue] <=0) {
        [ZZActivityUrlNetManager loadH5ActiveWithViewController:vc isHaveReceived:NO callBack:^{
            [ZZPrivateChatPayManager payMebiWithPayChatModel:payChatModel nav:nav CallBack:^{
                if (CallBack) {
                    CallBack();
                }
            } NoPayCallBack:^{
                if (NoPayCallBack) {
                    NoPayCallBack();
                }
            } ];
        }];
        return;
    }
    [ZZPrivateChatPayManager payMebiWithPayChatModel:payChatModel nav:nav CallBack:^{
        if (CallBack) {
            CallBack();
        }
    } NoPayCallBack:^{
        if (NoPayCallBack) {
            NoPayCallBack();
        }
    } ];
}

/**
 私聊付费的么币充值提醒
 @param payChatModel
 @param CallBack 要充值了
 @param NoPayCallBack 不需要充值
 @param Nav  控制器
 */
+ (void)payMebiWithPayChatModel:(ZZPrivateChatPayModel *)payChatModel nav:(UINavigationController *)nav CallBack:(void(^)(void))CallBack NoPayCallBack:(void(^)(void))NoPayCallBack {

    if ([[ZZUserHelper shareInstance].loginer.mcoin integerValue] < [ZZUserHelper shareInstance].consumptionMebi) {
        [UIAlertController presentAlertControllerWithTitle:@"么币余额不足，充值后再继续和TA私信" message:nil doneTitle:@"立即充值" cancelTitle:@"取消" showViewController:nav completeBlock:^(BOOL isCancelled) {
            if (CallBack) {
                CallBack();
            }
            if (!isCancelled) {
                [MobClick event:Event_click_OneToOneChat_TopUp];
                ZZMeBiViewController *vc = [ZZMeBiViewController new];
                __strong typeof(nav)weakNav =nav;
                [vc setPaySuccess:^(ZZUser *paySuccesUser) {
                    __strong typeof(weakNav)strongNav =weakNav;
                    [ZZUserHelper shareInstance].consumptionMebi =0;
                    NSMutableArray<ZZViewController *> *vcs = [strongNav.viewControllers mutableCopy];
                    [vcs removeLastObject];
                    [strongNav setViewControllers:vcs animated:NO];
                }];
                [nav pushViewController:vc animated:YES];
            }
        }];
    }else{
        if (NoPayCallBack) {
            NoPayCallBack();
        }
    }
}
/**
 修改私聊付费的状态
 
 @param state 要修改的状态
 @param callBack 修改成功后的回调
 */
+ (void)modifyPrivateChatPayState:(int)state callBack:(void(^)(NSInteger type))callBack {
    [ZZHUD show];
    NSDictionary *dic = @{@"open_charge":@(state)};
    NSMutableDictionary *mutableParam = dic.mutableCopy;
    if (mutableParam[@"nickname_status"]) {
        [mutableParam removeObjectForKey:@"nickname_status"];
    }
    if (mutableParam[@"bio_status"]) {
        [mutableParam removeObjectForKey:@"bio_status"];
    }
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user2"] params:mutableParam next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
            [ZZHUD dismiss];
            BOOL paystate = [data[@"open_charge"] boolValue];
            if (callBack) {
                callBack(paystate);
            }
        }
        if (error) {
            if (callBack) {
                callBack(-1);
            }
            [ZZHUD showTastInfoErrorWithString:error.message];
        }
    }];
}
/**
 第一次进入聊天室请求私聊未读的消息
 
 @param uid 对方的uid
 @param CallBack wait_answerNumber  24小时过期的  answered 未过期的
 */
+ (void)requestUserInfoPrivateChatMessageWithUid:(NSString *)uid callBack:(void(^)(NSNumber* wait_answerNumber,NSNumber *answered))CallBack {
    
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/gettodaychatcount",uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
         NSLog(@"PY_请求私聊付费未读消息的接口%@",data);
        if (error) {
            [ZZHUD showTastInfoErrorWithString:error.message];
            if (CallBack) {
                CallBack(@(-1),@(-1));
            }
        }
        if (data) {
            NSNumber *wait_answer = data[@"wait_answer"];
            NSNumber *answered = data[@"answered"];
            if (CallBack) {
                CallBack(wait_answer,answered);
            }
        }
      
    }];
}
/**
 3.4.1 以后调用发送违禁词
 @param content 消息的内容
 @param CallBack 返回的结果 -1 发送的内容为空   0  通过   1 敏感词  2不通过 3 网络错误

 注 *   action  0：通过，1：嫌疑，2：不通过
 注 *当内容为空的时候  默认返回-1
 */
+ (void)verifyThatTheMessagesSentAreIllegalWithContent:(NSString *)content  callBack:(void(^)(NSNumber* resultNumber))CallBack {
    if (isNullString(content)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (CallBack) {
                CallBack(@(-1));
            }
        });
        return;
    }
    
    [ZZRequest requestWithtimeout:1 method:@"POST" path:@"/api/chat/text_detect" params:@{@"content":content} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        NSLog(@"PY_前十条检测违禁词的接口%@",data);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (error.code  == -1001) {
                    //当网络超过1秒就不在检测,直接通过
                    if (CallBack) {
                        CallBack(@(0));
                    }
                    return ;
                }
                [ZZHUD showTastInfoErrorWithString:error.message];
                if (CallBack) {
                    CallBack(@(3));
                }
            }
            if (data) {
                NSNumber *answered = data[@"action"];
                if (CallBack) {
                    CallBack(answered);
                }
            }
        });
        
    }];
}
/**
 3.4.1 之后的方法
 告诉服务端要封禁用户
 
 @param CallBack 服务端的封禁返回
 */
/**
 3.4.1 之后的方法
 告诉服务端要封禁用户
 
 @param CallBack 服务端的封禁返回
 */
+ (void)tellServerBannedUserWhenUserSendBanneWordTooMuchCallBack:(void(^)(NSString *banneReason,BOOL isBanner))CallBack {
    [ZZRequest method:@"POST" path:@"/api/user/ban" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        NSLog(@"PY_违禁词过多被封了%@",data);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [ZZHUD showTastInfoErrorWithString:error.message];
                if (CallBack) {
                    CallBack(nil,NO);
                }
            }
            if (data) {
                NSString *reason = data[@"reason"];
                if (CallBack) {
                    CallBack(reason,YES);
                }
            }
        });
        
    }];
}
/**
 根据当前聊天的用户获取消息的自己发送的消息的条数
 注 *这个是为了检测前十条消息是否违规
 @param uid 当前聊天的用户的uid
 @return 和当前聊天用户的自己发送消息的个数
 */
+ (NSInteger )questPrivateChatFeeISFirstTenWithUid:(NSString *)uid {
   
    __block  BOOL greaterThan = YES;
    __block  NSInteger number = 0;
    
    //先从本地数据库里面获取违禁词的个数,如果个数为空  就说明当前版本第一次和当前用户聊天,所以这个时候就需要从融云数据库获取以前聊天的个数
    NSString *key = [NSString stringWithFormat:@"getBannedNumber%@%@",[ZZUserHelper shareInstance].loginer.uid,uid];

    NSString *value = [ZZKeyValueStore getValueWithKey:key];
    if (value) {
        if ([value integerValue]>30) {
             NSLog(@"PY_提取过了前十条");
            return [value integerValue];
        }
    }
    
    NSArray *array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:uid count:30];
    if (array.count<=0) {
        //取不到数据说明,用户和别人没有聊过天
        return 0;
    }
    RCMessage *lastMessage =  array.lastObject;
    __block long messageId = lastMessage.messageId;
    while (greaterThan) {
        
        [array enumerateObjectsUsingBlock:^(RCMessage *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model isKindOfClass:[RCMessage class]]) {
        
                if (model.messageDirection == MessageDirection_SEND) {
                    number++;
                    if (number>30) {
                        *stop = YES;
                        greaterThan = NO;
                    }
                }
            }
        }];
     
        array = [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_PRIVATE targetId:uid oldestMessageId:messageId count:30];
        RCMessage *secondLastMessage =  array.lastObject;

         messageId = secondLastMessage.messageId;
        if (array.count<=0) {
            greaterThan = NO;
        }
    }
    [ZZKeyValueStore saveValue:@(number) key:key];
     NSLog(@"PY_第一次提取过了前十条");
    return number;
    
}


/**
 更改聊天付费消息的过期状态

 @param isReply 是否是回复的  YES  用户直接回复消息  NO  用户没回复消息,第一次进入聊天界面
 @param messageArray
 */
+ (void)updateMessageListQiPaoiWithISReply:(BOOL)isReply messageArray:(NSMutableArray *)messageArray callBack:(void(^)(BOOL isChange))callBack {
    BOOL isChange = NO;
    long long   lastReceivedTime =0 ;
    lastReceivedTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    for (int x = 0; x<messageArray.count; x++) {
        ZZChatBaseModel *model = messageArray[x];
        if (model.message.messageDirection == MessageDirection_SEND) {
            lastReceivedTime = model.message.receivedTime;
        }
        if ([self judgeUserMessageListIsOverdueWhenWithTime:lastReceivedTime isReply:isReply message:model.message]==NO) {
            isChange = YES;
        }
    }
    if (callBack) {
        callBack(isChange);
    }
}

/**
 根据当前的日期来修改用户接受到的过期消息的气泡显示

 @param message 当前接受到的消息
 @param receivedTime 接受消息的时间戳
 @param isReply  YES 回复消息  NO 是第一次进入房间
 注 *  extra * = PrivateChatPay_expire   //过期
      extra * = PrivateChatPay_already  //已读
      extra * = PrivateChatPay          //未读
 */
+ (BOOL )judgeUserMessageListIsOverdueWhenWithTime:(long long)receivedTime isReply:(BOOL)isReply message:(RCMessage *)message   {

    if (message.messageDirection == MessageDirection_RECEIVE ) {
        RCMessageContent *content = message.content;
        if ([content isKindOfClass:[RCTextMessage class]]) {
            RCTextMessage *textmessage = ( RCTextMessage *)content;
            NSString *extra =  [ZZUtils dictionaryWithJsonString:textmessage.extra][@"payChat"];
            if ([textmessage.extra isEqualToString:@"PrivateChatPay"] ||[extra isEqualToString:@"PrivateChatPay"]){
              return  [self updateExtraStateWithTime:receivedTime isReply:isReply Message:message];
            }
        }
      else  if ([content isKindOfClass:[RCVoiceMessage class]]) {
            RCVoiceMessage *videoMessage = ( RCVoiceMessage *)content;
            NSString *extra =  [ZZUtils dictionaryWithJsonString:videoMessage.extra][@"payChat"];
            if ([videoMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
               return [self updateExtraStateWithTime:receivedTime isReply:isReply Message:message];
            }
        }
       else if ([content isKindOfClass:[RCImageMessage class]]) {
            RCImageMessage *imageMessage = ( RCImageMessage *)content;
           NSString *extra =  [ZZUtils dictionaryWithJsonString:imageMessage.extra][@"payChat"];
            if ([imageMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
              return  [self updateExtraStateWithTime:receivedTime isReply:isReply Message:message];
            }
        }
     else   if ([content isKindOfClass:[RCLocationMessage class]]) {
            RCLocationMessage *locationMessage = ( RCLocationMessage *)content;
           NSString *extra =  [ZZUtils dictionaryWithJsonString:locationMessage.extra][@"payChat"];
            if ([locationMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
               return [self updateExtraStateWithTime:receivedTime isReply:isReply Message:message];
            }
        }
     else   if ([content isKindOfClass:[ZZGifMessageModel class]]) {
         ZZGifMessageModel *gifMessage = (ZZGifMessageModel *)content;
         NSString *extra =  [ZZUtils dictionaryWithJsonString:gifMessage.extra][@"payChat"];
         if ([gifMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]){
             return [self updateExtraStateWithTime:receivedTime isReply:isReply Message:message];
         }
     }
    }
    return NO;
    
}


/**
 更新状态
  YES  说明遇到了上次记录的地方了,就不再向下更新了
 */
+ (BOOL)updateExtraStateWithTime:(long long)receivedTime isReply:(BOOL)isReply Message:(RCMessage *)message  {
    if ([message.extra isEqualToString:@"PrivateChatPay_already"]||[message.extra isEqualToString:@"PrivateChatPay_expire"]) {
        return  YES;
    }

    if ((receivedTime - message.sentTime) >= 3600*24*1000) {
        [[RCIMClient sharedRCIMClient] setMessageExtra:message.messageId value:@"PrivateChatPay_expires"];
        message.extra = @"PrivateChatPay_expire";
        return NO;
    }
    if (isReply ) {
        [[RCIMClient sharedRCIMClient] setMessageExtra:message.messageId value:@"PrivateChatPay_already"];
        message.extra = @"PrivateChatPay_already";
        return NO ;
    }
    return NO;
}

@end
