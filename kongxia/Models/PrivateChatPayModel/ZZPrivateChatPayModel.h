//
//  ZZPrivateChatPayModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//私聊付费的model

#import <JSONModel/JSONModel.h>

@interface ZZPrivateChatPayModel : JSONModel

#pragma mark - 3.7.5以及以上的版本
// 互粉状态
@property (nonatomic, assign) BOOL following_flag;

// 是否购买了优享邀约
@property (nonatomic, assign) BOOL wechat_flag;


@property (nonatomic, copy) NSString *a_following_text;


@property (nonatomic, copy) NSString *a_wechat_text;


@property (nonatomic, copy) NSString *b_following_text;


@property (nonatomic, copy) NSString *b_wechat_text;

#pragma mark - 3.7.6以下的版本
/**
当前服务器是否允许客户端开启私聊付费的功能
 注:YES 允许开启  NO 不允许开启
 */
@property(nonatomic,assign) BOOL isOpenChatPay;


/**
 当前用户的性别
 */
@property(nonatomic,assign,readonly) int gender;//性别1男 2女


/**
 服务端是否允许客户端开启私聊付费接口
 注* YES 客户端可以开通私聊付费  NO 不能开启
 */
@property(nonatomic,assign) BOOL globaChatCharge;


/**
 当前聊天的用户是否开启了私聊付费功能
  注* YES 当前用户开启了私聊付费  NO 当前用户没有开启私聊付费
 */
@property(nonatomic,assign) BOOL open_charge;


/**
 当前聊天用户的版本号
 */
@property(nonatomic,strong) NSString * chatUserVersion;


/**
当前聊天的用户版本号是否过低
 注*  和3.4.0 版本作对比  ,比3.4.0版本低的返回为 Yes  否则为NO
 */
@property(nonatomic,assign,readonly) BOOL chatUserVersionIsLow;

/**
 是否处于订单过程中
  注* YES 是订单过程中不收费
 */
@property(nonatomic,assign) BOOL ordering;


/**
是否互粉
 注* YES 是互粉 NO 不是互粉
 */
@property(nonatomic,assign) BOOL bothfollowing;


/**
 是否私聊收费
 注* YES 是收费  No不收费
 */
@property(nonatomic,assign,readonly) BOOL isPay;


/**
 服务器是否返回了接口
 注 * 必须收到服务端的返回客户端才可以发送消息,防止服务端没有返回直接发送
 */
@property(nonatomic,assign) BOOL isRequessSuccess;



/**
 当前用户聊天的工具栏是否改变
 */
@property(nonatomic,assign) BOOL isChange;

/**
 当前用户当日已经发送的敏感词的个数
 */
@property(nonatomic,assign) NSInteger timesNumber;

/**
已经过期的未读消息
 */
@property(nonatomic,assign) NSInteger wait_answerCout;
/**
已经回复的数据
 */
@property(nonatomic,assign) NSInteger answeredCout;

/**
目前没有回复的
 */
@property(nonatomic,assign) NSInteger unReadCout;

/**
是否是第一次进入
 */
@property(nonatomic,assign) BOOL isFirst;


/**
 是否是陌生人
 */
@property(nonatomic,assign) BOOL isStrangerFirst;


/**
 版本是否大于等于3.4.3  是就开启违禁词检测
 YES 是  NO 不是
 */
@property(nonatomic,assign) BOOL isThanCheckVersion;

@end
