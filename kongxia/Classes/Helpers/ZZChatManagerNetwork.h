//
//  ZZChatManagerNetwork.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/12.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZChatManagerNetwork : NSObject

/**
 1v1视频发送挂断的聊天消息
 
 @param uidString 对方的uid
 @param type  1对方忙   2我主动取消  3对方拒绝 
 @pram sendType  女方 (女方不能发送type为3的消息盒子)  other 不管
  @param chatContent 消息的内容
 */
+(void)sendVideoMessageWithDestinationUidString:(NSString *)uidString withType:(NSString *)type sendType:(NSString *)sendType chatContent:(NSString *)chatContent ;

/**
 为了避免招呼丢失,这里做个处理,获取招呼并插入本地数据库
 
 
 注*因为以前做的是如果用户删除会话,聊天消息也跟着删除,所以这边做个是否第一次拉取,是就不再拉,但是这个有个bug 就是用户卸载了,如果原来的那个用户接着给他发消息,他会发现以前的打招呼的消息还存在
 @param targetId 要获取的对方的id
 @param callIsloadSuccess 加载成功的回调

 */

+ (void)getMessageWithTargetId:(NSString *)targetId isloadSuccess:(void(^)(BOOL success))callIsloadSuccess;
@end
