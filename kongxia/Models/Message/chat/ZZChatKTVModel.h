//
//  ZZChatKTVModel.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/16.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface ZZChatKTVModel : RCMessageContent <NSCoding>

@property(nonatomic,  strong) NSString *message;

@property(nonatomic,  strong) NSString *title;

/** 文本消息内容 */
@property(nonatomic,  strong) NSString *content;

/** 附加信息 */
@property(nonatomic,  copy) NSString *extra;

@property (nonatomic, copy) NSString *songUrl;

@property (nonatomic, copy) NSString *songStatus;

@property (nonatomic, assign) BOOL isSongPlaying;

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end

