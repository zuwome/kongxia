//
//  ZZChatGiftModel.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface ZZChatGiftModel : RCMessageContent <NSCoding>

@property(nonatomic,  strong) NSString *message;

@property(nonatomic,  strong) NSString *title;

/** 文本消息内容 */
@property(nonatomic,  strong) NSString *content;

/** 附加信息 */
@property(nonatomic,  strong) NSString *extra;

@property (nonatomic,   copy) NSString *icon;

@property (nonatomic,   copy) NSString *from_msg_a;

@property (nonatomic,   copy) NSString *from_msg_b;

@property (nonatomic,   copy) NSString *to_msg_a;

@property (nonatomic,   copy) NSString *to_msg_b;

@property (nonatomic,   copy) NSNumber *charm_num;

@property (nonatomic, copy) NSString *color;

@property (nonatomic, copy) NSString *lottie;

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end
