//
//  ZZChatTaskFreeMOdel.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/13.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface ZZChatTaskFreeModel : RCMessageContent <NSCoding>

@property(nonatomic, strong) NSString *message;

@property(nonatomic, strong) NSString *title;
/** 文本消息内容 */
@property(nonatomic, strong) NSString *content;
/** 附加信息 */
@property(nonatomic, copy) NSString *extra;

@property (nonatomic, copy) NSDictionary *pdg;

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end
