//
//  ZZPrivateChatPayManager.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//私聊付费管理类  当用户处于登录状态的情况下

#import <Foundation/Foundation.h>
#import "ZZPrivateChatPayModel.h"
@class RCMessage;
/**
 *  私聊付费管理类  当用户处于登录状态的情况下
 */
@interface ZZPrivateChatPayManager : NSObject



/**
 请求用户的私聊付费的模块

 @param uid 当前即将聊天的用户
 @param privateChatPayCallBack  私聊付费的回调
 */
+ (void)requestUserInfoAndSensitiveNumberWithUid:(NSString *)uid privateChatPay:(void(^)(ZZPrivateChatPayModel *payModel))privateChatPayCallBack;

/**
 
 私聊付费的请求
 
 @param uid 对方的uid
 @param completionCall 私聊付费的回调
 */
+ (void)requestUserInfoWithUid:(NSString *)uid privateChatPay:(void(^)(ZZPrivateChatPayModel *payModel))privateChatPayCallBack   ;



/**
 上传给服务器关于该用户发送的违禁词
 
 @param uid 聊天的对象
 @param connect 聊天的内容
 @param privateChatPayCallBack  违禁词的次数
 */
+ (void)requestUserInfoWithUid:(NSString *)uid content:(NSString *)connect privateChatPay:(void (^)(NSInteger bannedWordNum))privateChatPayCallBack;


/**
 私聊付费的么币充值提醒
 @param payChatModel
 @param CallBack 要充值了
 @param NoPayCallBack 不需要充值
@param Nav  控制器
 */
+ (void)payMebiWithPayChatModel:(ZZPrivateChatPayModel *)payChatModel nav:(UINavigationController *)nav CallBack:(void(^)(void))CallBack NoPayCallBack:(void(^)(void))NoPayCallBack  vc:(UIViewController *)vc;


/**
 修改私聊付费的状态

 @param state 要修改的状态
  @param callBack 修改成功后的回调
 */
+ (void)modifyPrivateChatPayState:(int)state callBack:(void(^)(NSInteger type))callBack;


/**
 进入聊天室请求私聊未读的消息

 @param uid 对方的uid
 @param CallBack wait_answerNumber  24小时过期的  answered 未过期的
 */
+ (void)requestUserInfoPrivateChatMessageWithUid:(NSString *)uid callBack:(void(^)(NSNumber* wait_answerNumber,NSNumber *answered))CallBack;


/**
 3.4.1 以后调用发送违禁词
 @param content 消息的内容
 @param CallBack 返回的结果 -1 发送的内容为空   0  通过   1 敏感词  2不通过 3 网络错误
 */
+ (void)verifyThatTheMessagesSentAreIllegalWithContent:(NSString *)content  callBack:(void(^)(NSNumber* resultNumber))CallBack;



/**
 3.4.1 之后的方法
 告诉服务端要封禁用户

 @param CallBack 服务端的封禁返回
 */
+ (void)tellServerBannedUserWhenUserSendBanneWordTooMuchCallBack:(void(^)(NSString *banneReason,BOOL isBanner))CallBack;



/**
 根据当前聊天的用户获取消息的自己发送的消息的条数
 注 *这个是为了检测前十条消息是否违规
 @param uid 当前聊天的用户的uid
 @return 和当前聊天用户的自己发送消息的个数
 */
+ (NSInteger )questPrivateChatFeeISFirstTenWithUid:(NSString *)uid;



/**
 更改聊天付费消息的过期状态
 
 @param isReply 是否是回复的  YES  用户直接回复消息  NO  用户没回复消息,第一次进入聊天界面
 @param messageArray  当前聊天的数据
 @param callBack Yes 有变更  需要刷新
 */
+ (void)updateMessageListQiPaoiWithISReply:(BOOL)isReply messageArray:(NSMutableArray *)messageArray callBack:(void(^)(BOOL isChange))callBack ;

@end
