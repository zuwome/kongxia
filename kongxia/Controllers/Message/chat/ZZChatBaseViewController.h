//
//  ZZChatBaseViewController.h
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"

#import "ZZChatBoxView.h"

#import "ZZChatHelper.h"
#import "ZZChatUtil.h"
#import <RongIMLib/RongIMLib.h>
#import "ZZPrivateChatPayChatBoxView.h"
#import "ZZPrivateChatShowMoneyView.h"//私聊付费的金钱
#import "ZZPrivateChatPayMoneyView.h"//私聊付费的金币飞的效果
#import "ZZGiftsView.h"
#import "ZZGiftHelper.h"

@class ZZPrivateChatPayModel;
@interface ZZChatBaseViewController : ZZViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZZChatBoxView *boxView;
@property (nonatomic, strong) ZZChatHeadLodingView *headView;
@property (nonatomic, strong) ZZChatPacketInfoView *packetInfoView;
@property (nonatomic, strong) UIButton *customBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) ZZPrivateChatPayChatBoxView *payChatBoxView;//私聊付费的提示框
/**
 今日收益
 */
@property (nonatomic, strong) ZZPrivateChatShowMoneyView *showTodayEarnings;

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *portraitUrl;
@property (nonatomic, assign) CGFloat orderStatusHeight;//顶部订单状态高度
@property (nonatomic, assign) BOOL isRefresh;//是否在刷新数据
@property (nonatomic, assign) long long lastShowTime;//底部第一个显示的时间 --- 为了新加的消息是否显示时间
@property (nonatomic, assign) long long firstShowTime;//顶部显示的时间 -- 为了下拉加载数据时间显示
@property (nonatomic, strong) ZZOrder *order;
@property (nonatomic, assign) BOOL isFromOrderDetail;//防止订单详情与聊天界面一直页面叠加
@property (nonatomic, assign) BOOL viewDisappear;//视图消失
@property (nonatomic, assign) BOOL isPushingView;//是否正在跳转界面,防止比如头像快速点击两次
@property (nonatomic, assign) BOOL haveCreatedViews;
@property (nonatomic, strong) ZZChatStatusModel *statusModel;//能否聊天的Model
@property (nonatomic, strong) NSMutableArray *receiveArray;
@property (nonatomic, strong) ZZUser *user;

@property (nonatomic, strong) NSString *content;//红包内容
@property (nonatomic, strong) NSString *mid;//红包id
@property (nonatomic, assign) BOOL isInYellow;//红包是否违规
@property (nonatomic, assign) BOOL showPushName;
@property (nonatomic, strong) ZZPrivateChatPayModel *payChatModel;//当前聊天的用户的私聊收费的model

@property (nonatomic, assign) BOOL isFromRentOrder;//下订单跳过来的
@property (nonatomic, assign) BOOL notUpdateOrder;//不需要更新订单
@property (nonatomic, assign) BOOL isMessageBox;//是否是消息盒子的消息
@property (nonatomic, assign) BOOL isMessageBoxTo;//是否是消息盒子接收方
@property (nonatomic, assign) BOOL shouldSendHighlyReplyRequest;

@property (nonatomic, assign) BOOL haveLocalMessage;//是否有本地数据
@property (nonatomic, copy) dispatch_block_t updateMessageBox;//是否需要更新消息盒子（女方回复后消息盒子应该没了）
@property (nonatomic,copy) dispatch_block_t  evaluationCallBlack;//微信号评价

@property (nonatomic, strong) ZZGiftHelper *giftHelper;

@property (nonatomic, assign) GiftEntry giftEntry;

@property (nonatomic, assign) BOOL didSendGiftFromKTV;
;

- (void)initViews;
- (void)gotoUserPage:(BOOL)showWX;
- (void)gotoOrderDetail:(NSString *)orderId;
- (void)sendPacket:(NSString *)content mid:(NSString *)mid;

- (void)sendMySelfNotification:(NSString *)message;

- (void)sendInviteVideoChatMessage;
/**
 *  收到消息
 *
 *  @param message message
 */
- (void)didReceiveMessage:(RCMessage *)message;

/**
 *  发消息
 *
 *  @param model model
 */
- (void)didSendMessage:(ZZChatBaseModel *)model;

/**
 *  滚到底部
 */
- (void)scrollToBottom:(BOOL)nolimit finish:(void (^)(void))finish;

/**
 *  回收键盘
 */
- (void)endEditing;

- (void)gotoMemedaView;

- (void)addToBlack;

- (void)notifyOther;

- (void)gotoChatServerView;

- (void)addWeChat;

/**
 请求私聊付费接口
 */
- (void)privateChatPayManagerCallBack:(void(^)(ZZPrivateChatPayModel *payModel))privateChatPayCallBack ;

/*
 显示礼物的窗口
 */
- (void)showGiftView;

- (void)showGiftIconAnimations;

- (void)calCurrentMessageCounts;

- (void)updateStateIsFirstIntoRoom:(BOOL)isFirst;

- (void)liveStreamConnect;

- (void)showViewsWithAnimationWithShowKeyboard:(BOOL)showKeyboard keyboardY:(CGFloat)keyboardY;

- (void)hideViewsWithAnimation;

@end
