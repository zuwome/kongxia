//
//  ZZMessageConnectModel.h
//  zuwome
//
//  Created by angBiu on 2017/7/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface ZZChatConnectModel : RCMessageContent <NSCoding>

/** 文本消息内容 */
@property(nonatomic, strong) NSString* content;
/** 类别 */
@property(nonatomic, assign) NSInteger type;//0、没有微信1、有微信

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end
