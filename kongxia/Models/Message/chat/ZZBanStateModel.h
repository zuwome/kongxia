//
//  ZZBanStateModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/**
 表示用户被封禁了
 */
@interface ZZBanStateModel : RCMessageContent

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
