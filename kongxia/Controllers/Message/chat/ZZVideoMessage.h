//
//  ZZVideoMessageCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/8.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//自定义融云的视频消息

#import <RongIMLib/RongIMLib.h>
//#import <RongIMLib/RCMessageContent.h>
//#import <RongIMLib/RCMessageContentView.h>

@interface ZZVideoMessage : RCMessageContent<NSCoding,RCMessageContentView>
/** 文本消息内容 */
@property(nonatomic, strong) NSString* content;
/** 拒绝消息的类型(男方的角度来看) 1 对方忙碌 2主动取消   3 主动拒绝*/
@property(nonatomic, strong) NSString* videoType;
//消息的发送者
@property(nonatomic, strong) NSString* sendVideoUid;


/**
 消息的来源: shanChat :闪聊 oneToOne :1v1
 */
@property(nonatomic, strong) NSString* videoMessageSourceType;
/**
 * 附加信息
 */
@property(nonatomic, copy) NSString* extra;


/**
 用于展示的内容
 */
@property(nonatomic, strong,readonly)NSString *showContent;
/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;


@end

