//
//  ZZStoreKey.h
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZStoreKey : NSObject

// 单例
+ (ZZStoreKey *)sharedInstance;

@property (nonatomic, strong) NSString *homeVideoDataCache;//首页的视频缓存
@property (nonatomic, strong) NSString *uploadFailureVideo;//上传失败的视频
@property (nonatomic, strong) NSString *firstinstallapp;//首次加载app
@property (nonatomic, strong) NSString *homeRefreshView;//首页新鲜x弹窗
@property (nonatomic, strong) NSString *findAttentGuide;//发现页关注新位置引导
@property (nonatomic, strong) NSString *messageListUserInfo;//消息列表用户信息
@property (nonatomic, strong) NSString *firstMyWxGuide;//我的微信号第一次引导
@property (nonatomic, strong) NSString *firstHomeWxGuide;//微信第一次引导
@property (nonatomic, strong) NSString *questionVersion;//真心话版本
@property (nonatomic, strong) NSString *firstQuestionGuide;//录制问题第一次引导
@property (nonatomic, strong) NSString *firstPublishOrderAlert;//发布发单是否不在提醒
@property (nonatomic, strong) NSString *firstConnectAlert;//个人页发起视频是否不在提醒
@property (nonatomic, strong) NSString *firstDeletePublishAlert;//选择达人界面第一次删掉某人提示
@property (nonatomic, strong) NSString *cancel_count_max;//今天已取消次数
@property (nonatomic, strong) NSString *cancel_count;//每天能取消的总次数
@property (nonatomic, strong) NSString *firstConnectSnatchGuide;//第一次抢任务引导
@property (nonatomic, strong) NSString *firstConnectWaitGuide;//第一次抢任务成功后等待引导
@property (nonatomic, strong) NSString *publishSelections;//第一次抢任务成功后等待引导
@property (nonatomic, strong) NSString *firstTaskPublishAlert;//第一次发布线下任务弹窗提示
@property (nonatomic, strong) NSString *firstTaskSnatchListAlert;//第一次在任务列表弹窗
@property (nonatomic, strong) NSString *firstHomeTaskHotGuide;//首页闪租hot标识
@property (nonatomic, strong) NSString *firstTaskCancelConfirmAlert;//首页闪租hot标识
@property (nonatomic, strong) NSString *firstConnectSuccessGuide;//第一次连麦成功弹窗
@property (nonatomic, strong) NSString *firstOnline;//第一次抢线上单
@property (nonatomic, strong) NSString *firstOffLine;//第一次抢线下单
@property (nonatomic, strong) NSString *firstProtocol;//第一次同意出租协议
@property (nonatomic, strong) NSString *firstInitEnableVideo;//第一次初始化是否开启镜头
@property (nonatomic, strong) NSString *firstFastVideo;//第一次发布闪聊
@property (nonatomic, strong) NSString *firstCloseTopView;//关闭过一次topView就不再显示
@property (nonatomic, strong) NSString *firstGotoFastChat;//第一次进入闪聊列表
@property (nonatomic, strong) NSString *firstShanZuTipView;//第一次选择达人，给予可长按提示
@property (nonatomic, strong) NSString *firstVideoTipView;//第一次提醒对方可以视频

// 普通的通告/邀约
@property (nonatomic, strong) NSString *publicTask;

// 活动
@property (nonatomic, strong) NSString *publicFreeTask;


@property (nonatomic, copy) NSString *filterOptions;

@property (nonatomic, strong) NSString *adInfo;

@property (nonatomic, strong) NSString *chatGiftShowed;

@end
