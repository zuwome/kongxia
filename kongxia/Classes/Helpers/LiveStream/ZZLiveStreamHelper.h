//
//  ZZLiveStreamHelper.h
//  zuwome
//
//  Created by angBiu on 2017/7/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import <AgoraRtcKit/AgoraRtcChannel.h>


@protocol ZZLiveStreamHelperDelegate <NSObject>

@optional

- (void)connectSucess;
- (void)connectFinish;
- (void)connectFailure;
- (void)connectLowBalance;//余额不足回调
- (void)connectNoMoney;//没有余额
- (void)connectTimeUpdate;
- (void)connectGetRemoteView;

- (void)connectLowMcoin;//么币不足
- (void)connectNoMcoin;//没有么币

@end

typedef void(^Success)(void);
typedef void(^Authorized)(BOOL authorized);

typedef NS_ENUM(NSUInteger, ZZLiveStreamShowFaceType) {
    
    ZZLiveStreamShowFaceTypeHas ,               //有人脸
    ZZLiveStreamShowFaceTypeFiveSeconds ,        //5秒未露
    ZZLiveStreamShowFaceTypeFifteenSeconds     //15秒未露
};

#define Refuse_Type     (@"101")//达人拒接type
#define Through_Type    (@"104")//达人接通type

#define Cancel_Type     (@"100")//用户取消视频Type

#define CallIphone_Key (@"CallIphoneKey") //拨打电话的定时器
#define MeBiIphone_Key (@"MeBiCallIphoneKey") //视频聊天的定时器
#define SecondCheckHeartbeat (@"SecondCheckHeartbeatKey") //心跳
#define FaceLevel_Key       (@"FaceLevel_Key")//瘦脸等级
#define EyeLevel_key        (@"EyeLevel_key")//瘦眼等级
#define BeautyLevel_Key     (@"BeautyLevel_Key")//美颜等级
#define Sticker_Key         (@"Sticker_Key")//贴纸

#define CODE_SHIELDING      (6001)  //被对方拉黑 code
#define CODE_BANNED         (6002)  //已被封禁 code

@interface ZZLiveStreamHelper : NSObject

@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) UIView *remoteView;
@property (nonatomic, strong) UIView *preview;

@property (nonatomic, assign) NSInteger during;
@property (nonatomic, assign) NSInteger money;

@property (nonatomic, strong) id data;

@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) NSString *channel_key;
@property (nonatomic, strong) NSString *streamUrl;
@property (nonatomic, assign) BOOL by_mcoin;//发起视频方 是否使用么币计费
@property (nonatomic, copy) NSString *uid;//对方uid

@property (nonatomic, assign) BOOL noSendFinish;
@property (nonatomic, assign) BOOL acceped;//是否是接受方
@property (nonatomic, assign) BOOL isBusy;//是否忙
@property (nonatomic, assign) BOOL isTryingConnecting;//
@property (nonatomic, assign) BOOL connecting;
@property (nonatomic, assign) BOOL haveWX;
@property (nonatomic, assign) BOOL lowBalance;//金额过低

@property (nonatomic, assign) BOOL isUseMcoin;//是否使用么币计费

@property (nonatomic, assign) BOOL isRefundClick;// 是否是点击申请退款或举报
@property (nonatomic, assign) BOOL isConnectCompleted;//是否已经调用过一次 disconnect，防止多次调用 disconnect

@property (nonatomic, copy) dispatch_block_t finishConnect;//完成连接
@property (nonatomic, copy) dispatch_block_t timerCallBack;//定时器回调. 每秒
@property (nonatomic, copy) dispatch_block_t lowBalanceCallBack;//余额不足回调
@property (nonatomic, copy) dispatch_block_t noMoneyCallBack;//没钱回调
@property (nonatomic, copy) dispatch_block_t failureConnect;//连接错误回调
@property (nonatomic, copy) dispatch_block_t failureNetConnect;//连续16秒没有回调挂断

/**
 声网 2秒钟回调一次,如果15秒内连续回调7次 都是同样的数据表示用户连接断掉
 */
@property (nonatomic,assign) NSUInteger countByTes;
@property (nonatomic, assign) BOOL disconnected;//是否是被挂断的，获其他原因:用户离线、退出、或者卡死。

@property (nonatomic, copy) void (^lowMcoinBlock)(void);//么币不足回调
@property (nonatomic, copy) void (^noMcoinBlock)(void);//没有么币了回调
@property (nonatomic, copy) void (^enoughMcoinBlock)(void);//充值之后么币足够的回调
@property (nonatomic, copy) void (^firstCloseCameraBlock)(void);//第一次关闭镜头的回调

@property (nonatomic, copy) void (^connectCompleted)(void);//完成连接另一个监听，不传值。与 - (void)connect:(Success)success 区分

@property (nonatomic, assign) ZZLiveStreamShowFaceType showFaceType;
@property (nonatomic, copy) void (^liveStreamShowFaceBlock)(BOOL acceped, ZZLiveStreamShowFaceType type);//人脸检测回调状态

@property (nonatomic, weak) id<ZZLiveStreamHelperDelegate>delegate;

@property (nonatomic, strong) ZZUser *user;//连接时，对方user
@property (nonatomic, assign) BOOL isUserJoinSuccess;//这个参数给连麦使用。记录点接通后，对方用户15秒内成功加入房间，没有的话则自己会退出
@property (nonatomic, assign) BOOL isUserReason;//当自己是达人的时候,同时没有发送任何视频流  告诉服务端是自己的责任

// 单例
+ (ZZLiveStreamHelper *)sharedInstance;

- (void)checkAuthority:(Authorized)authorized;
- (void)connect:(Success)success;
- (void)disconnect;

- (void)toggleCamera;

- (void)closeCamera;

@end
