//
//  ZZChatOrderInfoModel.h
//  zuwome
//
//  Created by angBiu on 16/10/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface ZZChatOrderInfoModel : RCMessageContent <NSCoding>

@property (nonatomic, strong) NSString *order_id;
@property(nonatomic, strong) NSString *title;
/** 文本消息内容 */
@property(nonatomic, strong) NSString *content;

/** 订单的附加信息 */
@property(nonatomic, strong) NSString *typeContent;

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end
