//
//  ZZChatUtil.h
//  zuwome
//
//  Created by angBiu on 2016/11/10.
//  Copyright © 2016年 zz. All rights reserved.
//

typedef NS_ENUM(NSUInteger,ChatCellType) {
    ChatCellTypeText,
    ChatCellTypeVoice,
    ChatCellTypeImage,
    ChatCellTypeCall,
    ChatCellTypeCallVideo,
    ChatCellTypeLoacation,
    ChatCellTypeRealTimeStart,
    ChatCellTypeRealTimeEnd,
    ChatCellTypePacket,
    ChatCellTypeOrderInfo,
    ChatCellTypeNofitication,
    ChatCellTypeWechatPay,//微信号评价购买
    ChatCellTypeConnect,
    ChatCellTypeDefault,
    ChatCellTypeGif,
    ChatCellTypeTaskFree,
    ChatCellTypeSightVideo,
    ChatCellTypeGift,
    ChatCellTypeKTV,
};

typedef NS_ENUM(NSUInteger,ChatCellLongPressType) {
    ChatCellLongPressTypeDelete,                //删除
    ChatCellLongPressTypeDeleteAndReoprt,       //删除和举报
    ChatCellLongPressTypeDeleteAndCopy,         //删除和复制
    ChatCellLongPressTypeDeleteAndCopyAndReport,//删除和复制和举报
    ChatCellLongPressTypeDeleteAndRecall,       //删除和撤回
    ChatCellLongPressTypeAll                    //删除、复制、撤回
};

#import <Foundation/Foundation.h>

#import "ZZChatHelper.h"
#import "ZZUserInfoModel.h"

@interface ZZChatUtil : NSObject

//长按是否有显示菜单
+ (BOOL)canShowMenu:(ZZChatBaseModel *)model;

//获取cell的identifier
+ (NSString *)getIdentifierStringWithMessage:(ZZChatBaseModel *)model;

//获取cell的type(继承基类basecell的归为一类 default)
+ (ChatCellType)getCellTypeWithMessage:(ZZChatBaseModel *)model;

+ (ChatCellLongPressType)getCellLongPressTypeWithMessage:(ZZChatBaseModel *)model;

+ (NSString *)getInfoStringWithString:(NSString *)string;

+ (CGFloat)getCellHeightWithModel:(ZZChatBaseModel *)model;

+ (NSString *)getSensitiveStringWithString:(NSString *)content;

+ (NSString *)getThirdPayInfoStringWithString:(NSString *)string;

+ (NSString *)thirdInfoString;

+ (NSString *)oldPayInfoString;

+ (NSString *)newThirdInfoString;

/**
 是否是微信敏感词---用来插入 查看对方微信号 功能
 */
+ (BOOL)isWxSensitiveString:(NSString *)content;

+ (BOOL)isAviableMessage:(RCMessage *)message;

/**
 是否要发送已读回执

 @retur
 */
+ (BOOL)shouldSendReadStatus:(RCMessage *)message;

/**
 消息列表显示的文本
 */
+ (id)getMessageListContent:(RCConversation *)model userInfo:(ZZUserInfoModel *)userInfo;

+ (BOOL)isFiveContinuityLetterOrNumber:(NSString *)string;//是否连续5个字母或者数字

+ (NSString *)getPushContent:(BOOL)showPushName;
/**
 自定义视频挂断消息
 */
+ (NSString *)getPushVideoContent;

/**
 收到消息判断是否是阅后即焚消息
 */
+ (BOOL)isReceiveBurnReadedMessage:(ZZChatBaseModel *)model;

/**
 已读回执发送方来判断是否是阅后即焚消息
 */
+ (BOOL)isBurnAfterReadMessage:(ZZChatBaseModel *)model;

/**
 加载的消息判断是否是阅后即焚
 */
+ (BOOL)isLocalBurnReadedMessage:(ZZChatBaseModel *)model;


/**
 是否是私聊未读消息  用于会话列表
 */
+ (BOOL)isUpdatePrivChatMessage:(RCMessageContent *)content;

/**
 是否是私聊未读消息

 */
+ (BOOL)isPrivChatMessage:(ZZChatBaseModel *)model;

#pragma mark - 判断聊天的消息是否有礼物


@end
