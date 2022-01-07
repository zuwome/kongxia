//
//  ZZWeiChatEvaluationModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/2/26.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 付款的项目
typedef NS_ENUM(NSInteger, PaymentType) {
    // 微信
    PaymentTypeWX,

    // 证件照
    PaymentTypeIDPhoto,
    
    // 礼物
    PaymentTypeGift,
    
    // KTV礼物
    PaymentTypeKTVGift,
};

// 渠道
typedef NS_ENUM(NSInteger, BuySource) {
    // 个人信息页
    SourcePersonalInfo,
    
    // 聊天
    SourceChat,
    
    // Tasks
    SourceTask,
    
    SourceKTV,
};

@interface ZZWeiChatEvaluationModel : NSObject

@property (nonatomic, assign) BuySource source;

// 付款的项目
@property (nonatomic, assign) PaymentType type;

// 付款金额
@property (nonatomic, assign) double mcoinForItem;

@property (assign, nonatomic) BOOL fromLiveStream;//只显示底部跟她视频

/**
 是否已经评价
 YES:已经评价
 */
@property(nonatomic,assign,readonly) BOOL isPingJia;

/**
 是否已经购买
 */
@property(nonatomic,assign,readonly) BOOL isBuy;

@property (nonatomic,assign,readonly)NSInteger wechat_comment_score;//1差评 5好评

/**
 已经查看的人数
 */
@property(nonatomic,assign,readonly) NSInteger lookNumber;

/**
将要查看的微信号的用户的user
 */
@property(nonatomic,strong) ZZUser *user;


/**
 用户自己的手机号
 */
@property (nonatomic,strong,readonly) NSString *userIphoneNumber;

@end
