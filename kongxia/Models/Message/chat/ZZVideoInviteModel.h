//
//  ZZVideoInviteModel.h
//  kongxia
//
//  Created by qiming xiao on 2022/1/14.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>


@interface ZZVideoInviteModel : RCMessageContent <NSCoding>

@property(nonatomic,  strong) NSString *message;

@property(nonatomic,  strong) NSString *title;

/** 文本消息内容 */
@property(nonatomic,  strong) NSString *content;


/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end

