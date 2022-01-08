//
//  ZZChatCancelModel.h
//  zuwome
//
//  Created by MaoMinghui on 2018/9/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface ZZChatCancelModel : RCMessageContent <NSCoding>

@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) NSString *title;
/** 文本消息内容 */
@property(nonatomic, strong) NSString *content;
/** 附加信息 */
@property(nonatomic, copy) NSString *extra;
/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end
