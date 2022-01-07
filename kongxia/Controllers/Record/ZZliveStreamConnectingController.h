//
//  ZZliveStreamConnectingController.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/5.
//  Copyright © 2017年 TimoreYu. All rights reZZliveStreamConnectingControllerserved.
//

#import "ZZViewController.h"

#import "ZZMemedaModel.h"
#import "ZZRecordLabelModel.h"
#import "ZZTopicModel.h"
@class RCMessage;
/*
 * 男方等待页面
 */

@interface ZZliveStreamConnectingController : ZZViewController

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, assign) CGRect sourceRect;
@property (nonatomic, assign) BOOL showCancel;//是否是发起方
@property (nonatomic, assign) BOOL accept;

@property (nonatomic, strong) id data;//获取的房间数据临时保存，等待被动连接时使用

@property (nonatomic, copy) dispatch_block_t timeOut;
@property (nonatomic, copy) void (^noPenaltyBlock)(BOOL is);//因为对方10秒未接或挂断，不算发单人次数的回调
@property (nonatomic, copy) void (^connectVideoStar)(id data);//对方点了接通，我方可以开始连接视频房间
@property (nonatomic, strong) UIButton *stickerBtn;
@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, copy) void (^quxiao)(RCMessage *chatMessage,BOOL isSuccess);//长时间拨打视屏聊天后取消


- (void)show;
- (void)remove;

@end
