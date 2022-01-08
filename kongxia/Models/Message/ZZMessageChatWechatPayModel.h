//
//  ZZMessageChatWechatPayModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface ZZMessageChatWechatPayModel : RCMessageContent

@property (nonatomic, assign)NSNumber *pay_type;//1.付款方 2.赚钱方  
@property(nonatomic, strong) NSString *title;
/** 文本消息内容 */
@property(nonatomic, strong) NSString *content;
/** 附加信息 */
@property(nonatomic, copy) NSString *extra;

@property (nonatomic, copy) NSString *wechatseenId;

@property (nonatomic, copy) NSString *info;

/** 订单的附加信息 */
@property(nonatomic, strong) NSString *typeContent;

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;
@end
