//
//  ZZChatMemedaModel.h
//  zuwome
//
//  Created by angBiu on 16/8/5.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
/**
 *  聊天界面么么答model
 */
@interface ZZChatMemedaModel : RCMessageContent <NSCoding>

/** 文本消息内容 */
@property(nonatomic, strong) NSString* content;
/** 附加信息 */
@property(nonatomic, strong) NSString* extra;
/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end
