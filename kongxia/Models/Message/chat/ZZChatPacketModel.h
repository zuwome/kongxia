//
//  ZZChatPacketModel.h
//  zuwome
//
//  Created by angBiu on 16/9/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
/**
 *  聊天界面红包model
 */
@interface ZZChatPacketModel : RCMessageContent <NSCoding>

@property (nonatomic, strong) NSString *mmd_id;
/** 文本消息内容 */
@property(nonatomic, strong) NSString* content;
/** 附加信息 */
@property(nonatomic, copy) NSString* extra;
/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end
