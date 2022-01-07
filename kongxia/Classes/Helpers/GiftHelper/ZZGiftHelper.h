//
//  ZZGiftHelper.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Lottie/Lottie.h>

typedef NS_ENUM(NSInteger, GiftEntry) {
    GiftEntryNone,
    GiftEntryChat,
    GiftEntryKTV,
    GiftEntryIDPhoto,
};

@class ZZGiftModel;
@interface ZZGiftHelper : NSObject

@property (nonatomic, assign) GiftEntry entry;

@property (nonatomic, strong) ZZUser *user;

- (instancetype)initWithUser:(ZZUser *)user;

/*
 是否需要在聊天页面底部显示一个发送礼物的tipView
 */
- (BOOL)shouldShowChatGiftTipsView;

/*
 在赠送礼物的时候, 是否要显示提示框
 */
- (BOOL)shouldShowSendGiftTips;

/*
 么币是否充足
 */
- (BOOL)didHaveEnoughMoneyToSendGift:(ZZGiftModel *)model;

- (BOOL)shouldShowGiftIconAnimation:(NSString *)uid;

#pragma mark - Save/Edit Info

/*
 付款的时候不再显示发送的提示
 */
- (void)neverShowSendGiftTips;

- (void)addChatUser;

#pragma mark - 显示动画
/*
 显示动画
 */
- (void)showGiftsAnimationIn:(UIView *)view;

- (void)reciveANewGift:(RCMessage *)message showIn:(UIView *)view;

- (void)stopAnimations;

#pragma mark - 判断当前所有聊天未读的是否有礼物
/*
 启动APP 获取所有未读数据
 */
+ (void)checkIfUnreadMessagesHaveGifts;

/*
 获取到新一条信息, 判断是不是需要保存到数据库
 */
+ (void)recivedNewMessage:(RCMessage *)message completion:(void(^)(BOOL isComplete))completion;

/*
 进入聊天删除所有的礼物数据
 */
+ (void)clearUserMessageDataWith:(NSString *)userID;

+ (void)testSengGift;


#pragma mark - Request
/*
 获取礼物列表
 */
- (void)fetchGiftsListWithCompleteBlock:(void(^)(NSArray<ZZGiftModel *> *giftsArr))completeBlock;

/*
 发送礼物
*/
- (void)sendGift:(ZZGiftModel *)giftModel finishedBlock:(void(^)(BOOL isSuccess))finishedBlock;

@end


@interface ZZPrivateChatGiftView:  LOTAnimationView


@end
