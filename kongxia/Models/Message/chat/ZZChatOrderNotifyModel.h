//
//  ZZChaSensitiveWXModel.h
//  zuwome
//
//  Created by angBiu on 2017/5/16.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface ZZChatOrderNotifyModel : RCMessageContent

@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) NSString *title;
/** 文本消息内容 */
@property(nonatomic, strong) NSString *content;
/** 附加信息 */
@property(nonatomic, strong) NSString *extra;
/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end
