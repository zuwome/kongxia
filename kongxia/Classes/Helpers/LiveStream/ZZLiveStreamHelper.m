//
//  ZZLiveStreamHelper.m
//  zuwome
//
//  Created by angBiu on 2017/7/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamHelper.h"

#import <RongIMLib/RongIMLib.h>
#import "ZZChatConnectModel.h"
#import "ZZChatBaseModel.h"
#import "ZZVideoPreProcessing.h"
#import "JX_GCDTimerManager.h"
#import <RongIMKit/RongIMKit.h>
#import "ZZChatUtil.h"
#import "ZZConnectFloatWindow.h" //缩小的视频
#define TIMEOUT     (@"TIMEOUT")
@interface ZZLiveStreamHelper () <AgoraRtcEngineDelegate>

@property (nonatomic, copy) Authorized authorized;
@property (nonatomic, copy) Success success;
@property (nonatomic, assign) NSUInteger noFaceTime;//记录未露脸的时间，
@property (nonatomic, assign) BOOL isShowRefund;//挂断的时候是否需要显示申请退款，当2分钟内，达人方连续15秒未出镜，则为YES

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) UIView *maskBlackView;

@property (nonatomic, assign) BOOL isFirstFire;//这个参数是给达人使用的。当用户提前关闭了镜头，会导致达人不执行计时器

@property (nonatomic, assign) BOOL isFirstCloseCamera;//这个参数给达人使用。记录每次视频，用户是否第一次关闭镜头，则达人要自动显示自己
@property (nonatomic,assign) NSUInteger lastTxBytes  ,lastRxBytes; //上次发送的数据字节数,上次接受的数据字节数,连续几次回调数据一样的次数

@end

@implementation ZZLiveStreamHelper

// 单例
+ (ZZLiveStreamHelper *)sharedInstance
{
    __strong static ZZLiveStreamHelper *sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _count = 1;
    }
    
    return self;
}

- (void)checkAuthority:(Authorized)authorized
{
    _authorized = authorized;
    [self checkoutVideoAuth];
}

- (void)checkoutVideoAuth
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self checkoutAudioAuth];
            } else {
                if (_authorized) {
                    _authorized(NO);
                }
            }
        }];
    } else if ([ZZUtils isAllowCamera]) {
        [self checkoutAudioAuth];
    } else {
        if (_authorized) {
            _authorized(NO);
        }
    }
}

- (void)checkoutAudioAuth
{
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioAuthStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                if (_authorized) {
                    _authorized(YES);
                }
            } else {
                if (_authorized) {
                    _authorized(NO);
                }
            }
        }];
    } else if ([ZZUtils isAllowAudio]) {
        if (_authorized) {
            _authorized(YES);
        }
    } else {
        if (_authorized) {
            _authorized(NO);
        }
    }
}

- (void)setData:(id)data
{
    _data = data;
    _acceped = NO;
    _isBusy = YES;
    _roomName = [data objectForKey:@"room_name"];
    _room_id = [data objectForKey:@"room_id"];
    _channel_key = [data objectForKey:@"channel_key"];
    _streamUrl = [data objectForKey:@"pili_publish_url"];
    _by_mcoin = [[data objectForKey:@"by_mcoin"] boolValue];
    NSLog(@"%@",_streamUrl);
    NSLog(@"channel_key： %@", _channel_key);
    NSLog(@"room_id: %@",_room_id);
    NSLog(@"room_name : %@", _roomName);
    NSLog(@"by_mcoin : %d", _by_mcoin);
}

- (void)connect:(Success)success
{
    _isBusy = YES;
    _noSendFinish = NO;
    _disconnected = NO;
    _during = 0;
    _money = 0;
    _success = success;
    _isShowRefund = NO;
    _isRefundClick = NO;
    _connecting = NO;
    
    _isUserJoinSuccess = NO;
    self.isUserReason = NO;
    if (_acceped) {
        //用于判断当对方挂断自己一直没发送数据,如果是达人先默认是自己的责任,当自己有视频流发出的时候,就变成别人的
      self.isUserReason = YES;
    }
    self.countByTes = 0;
    self.lastTxBytes = 0;
    WeakSelf
    [self.agoraKit joinChannelByToken:_channel_key channelId:_roomName info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        NSLog(@"PY_收到远程_成功回调");
        weakSelf.isConnectCompleted = NO;
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [weakSelf connectSuccessCreate];
        [ZZVideoPreProcessing registerVideoPreprocessing:_agoraKit];
        [self startRtmpStreaming];
    }];
}

- (void)startRtmpStreaming {
    
//    AgoraLiveTranscoding *coding = [AgoraLiveTranscoding defaultTranscoding];
//    [coding setSize:CGSizeMake(640, 480)];
//    [_agoraKit setLiveTranscoding:coding];
//    [_agoraKit startRtmpStreamWithTranscoding:_streamUrl transcoding:coding];
    [_agoraKit startRtmpStreamWithoutTranscoding:_streamUrl];
}

- (void)connectSuccessCreate {
    self.noFaceTime = 0;//计时变量
    
    [ZZLiveStreamHelper startHeartbeatWithRoom_id:self.room_id];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFaceType:) name:kMsg_NoFaceTimeout object:nil];
}

- (void)receiveFaceType:(NSNotification *)notification {
    
    NSInteger timeOut = [[notification.userInfo objectForKey:TIMEOUT] integerValue];
    if (timeOut == 0) {
        _showFaceType = ZZLiveStreamShowFaceTypeHas;
    } else if (timeOut == 5) {
        _showFaceType = ZZLiveStreamShowFaceTypeFiveSeconds;
    } else if (timeOut == 30) {
        _showFaceType = ZZLiveStreamShowFaceTypeFifteenSeconds;
        if (!_acceped) {
            self.isShowRefund = YES;
        }
    } else if (timeOut == NSNotFound) {
        _showFaceType = ZZLiveStreamShowFaceTypeHas;
    }
    BLOCK_SAFE_CALLS(self.liveStreamShowFaceBlock, _acceped, _showFaceType);
}

- (void)disconnect {
    if (self.isConnectCompleted) {// 防止多次调用当前 disconnect 方法，只有当 self.isConnectCompleted连成功时才能调用一次 disconnect
        return;
    }
    _isUserReason = NO;
    self.isConnectCompleted = YES;
    _lowBalance = NO;
    _isBusy = NO;
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:MeBiIphone_Key];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_remoteView removeFromSuperview];
        _remoteView = nil;
    });
    [[ZZConnectFloatWindow shareInstance] remove:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_preview removeFromSuperview];
        _preview = nil;
    });
    
    _isUserJoinSuccess = NO;
    
    [self removeMaskBlackView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.showFaceType = ZZLiveStreamShowFaceTypeHas;
    
    self.isFirstCloseCamera = NO;
    
    _count += 1;
    WeakSelf;
   
    [_agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        [ZZVideoPreProcessing deregisterVideoPreprocessing:weakSelf.agoraKit];
        weakSelf.agoraKit = nil;
    }];
    [_agoraKit stopRtmpStream:_streamUrl];
    
    if (!_noSendFinish) {
        if (_acceped) {// 达人方
            if (self.by_mcoin) {// 对方是走么币
                [self sendFinishRequest2];
            }
        } else {// 用户方
            if (self.isUseMcoin) {// 是使用么币计费
                [self sendFinishRequest2];
            }
        }
    }
    _connecting = NO;
    // 初始化值，一定要放这里
    _noSendFinish = NO;
    _isUseMcoin = NO;
    _by_mcoin = NO;
}

- (void)toggleCamera
{
    [self.agoraKit switchCamera];
}

- (void)timerEvent {
    
    _during++;
    NSInteger minute = _during/60;
    
    // 实时监测人脸，并回调及发送
    [self realTimeMonitoringFace];
    
    if (_acceped) {
        if (_during == 30) {
            [ZZUtils sendCommand:@"ShowFace" uid:_uid param:@{@"type": @"103",
                                                              TIMEOUT : @"30"
                                                              }];
        }
    }
    
    if (self.isUseMcoin) {  // 使用么币计费

        if (!_acceped) {

            // 用户 需要回调计时
            BLOCK_SAFE_CALLS(self.timerCallBack);//时间回调

            [self mCoinBilling];
        }
    } else {    // 使用余额计费
        
        NSInteger beginPrice = 5;   //前2分钟5元
        NSInteger extraPrice = 2;   //每加1分钟 增加2元
        if ([ZZUserHelper shareInstance].configModel.skill) {
            beginPrice = [ZZUserHelper shareInstance].configModel.skill.begin_price;
            extraPrice = [ZZUserHelper shareInstance].configModel.skill.extra_price;
        }
        if (minute < 2) {
            _money = beginPrice;
        } else {
            _money = beginPrice + (minute - 1)*extraPrice;
        }
        if (_timerCallBack) {
            _timerCallBack();
        }
        _lowBalance = NO;
        if (!_acceped) {
            if ([ZZUtils liveStreamIsLowBalance:_money + 6]) {
                if (_lowBalanceCallBack) {
                    _lowBalanceCallBack();
                }
                _lowBalance = YES;
                if (_delegate && [_delegate respondsToSelector:@selector(connectLowBalance)]) {
                    [_delegate connectLowBalance];
                }
            }
            if ([ZZUtils liveStreamIsLowBalance:_money]) {
                _money = _money - 2;
                if (_noMoneyCallBack) {
                    _noMoneyCallBack();
                }
                if (_delegate && [_delegate respondsToSelector:@selector(connectNoMoney)]) {
                    [_delegate connectNoMoney];
                }
            }
        }
    }
}

// 使用MCoin结算 只有发起方才会扣钱
- (void)mCoinBilling {
    // 用户 需要回调计时
    BLOCK_SAFE_CALLS(self.timerCallBack);//时间回调
    
    // 价格配置信息
    ZZPriceConfigModel *priceConfig = [ZZUserHelper shareInstance].configModel.priceConfig;
    
    // 用户账户下的么币
    NSNumber *userMcoin = [ZZUserHelper shareInstance].loginer.mcoin;
    
    // 多少分钟结算一次
    NSInteger billingInterval = priceConfig.settlement_unit.integerValue;
    
    // 每次结算需要多少张咨询卡
    NSInteger cardsPerInterval = priceConfig.per_unit_cost_card.integerValue;
    
    // 每张咨询卡多少么币
    NSInteger mcoinPerCard = priceConfig.one_card_to_mcoin.integerValue;
    
    // 每X分钟需要多少么币
    NSInteger mcoinPerInterval = mcoinPerCard * cardsPerInterval;
    
    // 总共可以看的分钟数
    NSInteger totalMin = userMcoin.integerValue / mcoinPerInterval;
    
//    NSLog(@"账户下的么币 %ld", (long)[userMcoin integerValue]);
//    NSLog(@"每%ld分钟需要%ld张咨询卡,每张咨询卡%ld么币,一共需要%ld么币", billingInterval, cardsPerInterval, mcoinPerCard, mcoinPerInterval);
//    NSLog(@"最大时长: %ld, 当前时长: %ld", totalMin * 60, (long)_during);
    
    // 账户的么币余额一共可以聊天 averageMcoin * billingInterval * 60 秒
    // 一共可以聊多少秒
    if (_during < totalMin * billingInterval * 60) {
        // 么币足够的情况下（包括快没有）
        
        if (_during < totalMin * billingInterval * 60 - 60) {
            // 么币在充足的情况下，实时回调
            BLOCK_SAFE_CALLS(self.enoughMcoinBlock);
        }
        
        if (_during == totalMin * billingInterval * 60 - 60) {
            // 快没么币的前60秒
            BLOCK_SAFE_CALLS(self.lowMcoinBlock);
            if (_delegate && [_delegate respondsToSelector:@selector(connectLowMcoin)]) {
                [_delegate connectLowMcoin];
            }
        }
        if (_during == totalMin * billingInterval * 60 - 30) {
            // 快没么币的前30秒
            BLOCK_SAFE_CALLS(self.lowMcoinBlock);
            if (_delegate && [_delegate respondsToSelector:@selector(connectLowMcoin)]) {
                [_delegate connectLowMcoin];
            }
        }
    }
    else {
        // 账户下没有么币不够
        BLOCK_SAFE_CALLS(self.noMcoinBlock);
        if (_delegate && [_delegate respondsToSelector:@selector(connectNoMcoin)]) {
            [_delegate connectNoMcoin];
        }
    }
}

- (void)realTimeMonitoringFace {
    
    // 是接受方
    if (_acceped) {
        if (_during == 30) {
            [ZZUtils sendCommand:@"ShowFace" uid:_uid param:@{@"type": @"103",
                                                              TIMEOUT : @"30"
                                                              }];
        }
    }
}

- (void)hasFace {
    
    self.showFaceType = ZZLiveStreamShowFaceTypeHas;
    [ZZUtils sendCommand:@"ShowFace" uid:_uid param:@{@"type": @"103",
                                                      TIMEOUT : @"0"
                                                      }];
    BLOCK_SAFE_CALLS(self.liveStreamShowFaceBlock, _acceped, ZZLiveStreamShowFaceTypeHas);
    self.noFaceTime = 0;
}

#pragma mark - AgoraRtcEngineDelegate

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOccurError:(AgoraErrorCode)errorCode
{
    _noSendFinish = YES;
    [self disconnect];
    
    NSLog(@"ytl_连接有错误 %ld", (long)errorCode);

    dispatch_async(dispatch_get_main_queue(), ^{
        if (_failureConnect) {
            _failureConnect();
        }
    });
}


/**
 判断用户自己是否发送了视频流
 作用:当自己是达人方,当收到对方离开房间的时候,自己依旧没发送任何的视频流  告诉服务端是自己的责任
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine localVideoStats:(AgoraRtcLocalVideoStats*)stats {
    
    if (stats.sentBitrate>0) {
        if (self.acceped) {
            NSLog(@"PY_达人用户发送了视频流");

            self.isUserReason = NO;
        }
    }
}

/**
 该回调定期上报 Rtc Engine 的运行时的状态，每两秒触发一次。
 stats:
 duration: 通话时长，累计值
 txBytes: 发送字节数，累计值
 rxBytes: 接收字节数，累计值
 */
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine reportRtcStats:(AgoraChannelStats * _Nonnull)stats {
    
    if (self.lastTxBytes==stats.txBytes) {
        self.countByTes +=1;
        if (self.countByTes==7) {
            //如果连续14秒没有推流,同时为达人就告诉服务器是,达人自己的问题,不过理论上这永远都不会运行 因为你都断网了能告诉服务器么?除非声网挂了 哈哈哈
            if (_acceped) {
                self.isUserReason = YES;
            }
        }
        if (self.countByTes>7) {
            //说明定时器这时候没有检测到,但是已经16秒了  要挂断的
            if (self.failureNetConnect) {
                self.failureNetConnect();
            }
        }
    }
    else{
        self.countByTes = 0;
    }
    self.lastTxBytes = stats.txBytes;
    NSLog(@"PY_远程用户的音频事件  发送的字节数%ld  接收的字节%ld",stats.txBytes,stats.rxBytes);
}

// 远程用户的第一帧的事件被成功解码
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed
{
    self.isUserJoinSuccess = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid = uid;
        videoCanvas.view = self.remoteView;
        videoCanvas.renderMode = AgoraVideoRenderModeHidden;
        [self.agoraKit setupRemoteVideo:videoCanvas];
        
        if (!_acceped) {
            // 用户设置是否扬声器外放状态
            if ([self.agoraKit isSpeakerphoneEnabled]) {
                [self.agoraKit setEnableSpeakerphone:YES];
            } else {
                [self.agoraKit setEnableSpeakerphone:NO];
            }
        }
        
        _connecting = YES;
        if (_success) {
            NSLog(@"ytl_画面成功解析...%@", [NSDate new]);
            _success();
        }
        if (!_acceped) {//用户方成功解析第一帧画面，则调用begin
            self.isConnectCompleted = NO;
            [self startConnectRequest];
        }
        BLOCK_SAFE_CALLS(self.connectCompleted);

    });
}
/**
 对方用户离线回调 (didOfflineOfUid)
 
 @param uid 对方用户的Uid
 @param reason 用户离线、退出、或者卡死。
 */
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
     NSLog(@"PY_用户离线、退出、或者卡死");
    _disconnected = YES;
    _connecting = NO;
    
    if (_finishConnect) {
        NSLog(@"对方挂断了。。。");
        _finishConnect();
    }
    NSLog(@"ytl_结束了...");
    if (_delegate && [_delegate respondsToSelector:@selector(connectFinish)]) {
        [_delegate connectFinish];
    }
}

/**
 
 *远程用户连接的事件。
 注*对方连接
 @param uid uid远程用户id。
 @param elapsed 从会话开始运行时间(ms)。
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    
    NSLog(@"PY_收到远程消息_远程用户连接id%lu 会话时间%ld",(unsigned long)uid,elapsed);
    //如果远端用户是达人的那么就需要获取画面第一帧才标明进入房间
    if (_acceped) {
        //自己是达人,对方是用户
        self.isUserJoinSuccess = YES;
    }
}
/**
 获取远程用户声音的第一帧
 
 @param uid 远程用户的声音
 @param elapsed 会话开始运行时间
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteAudioFrameOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    NSLog(@"PY_收到远程消息_收到远程用户的第一个音频帧 会话的人的id%lu 以及会话开始时间%ld",(unsigned long)uid,elapsed);
    if (_acceped) {//如果达人方解析了声音，则开始计费
        _connecting = YES;//对于达人而言，有声音就可以算连成功了
        self.isConnectCompleted = NO;
        [self startConnectRequest];
        
        // 设置是否扬声器外放状态
        if ([self.agoraKit isSpeakerphoneEnabled]) {
            [self.agoraKit setEnableSpeakerphone:YES];
        } else {
            [self.agoraKit setEnableSpeakerphone:NO];
        }
        
    }
}

// 用户停止/重新发送视频回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid {
    if (_acceped) {
        /*
         Yes: 该用户已暂停发送其视频流
         No: 该用户已恢复发送其视频流
         */
        if (muted) {//对方关闭摄像头，则遮罩
            [self closeCamera];
        } else {
            [self removeMaskBlackView];
        }
    }
}

- (void)closeCamera {
    
    if (self.maskBlackView) {
        return;
    }
    
    if (!self.isFirstCloseCamera) {// 第一次关闭镜头
        self.isFirstCloseCamera = YES;
        
        BLOCK_SAFE_CALLS(self.firstCloseCameraBlock);
    }
    self.maskBlackView = [UIView new];
    self.maskBlackView.backgroundColor = [UIColor blackColor];
    [self.remoteView addSubview:self.maskBlackView];
    [self.maskBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
    
    UIImageView *headerImageView = [UIImageView new];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:_user.avatar] placeholderImage:nil options:(SDWebImageRetryFailed)];
    [self.maskBlackView addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.maskBlackView);
        make.width.height.equalTo(self.maskBlackView.mas_height);
    }];
    
    UIView *bgBlackView = [UIView new];
    bgBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.maskBlackView addSubview:bgBlackView];
    [bgBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
    
    UILabel *tips = [UILabel new];
    tips.textColor = [UIColor whiteColor];
    tips.text = @"对方已关闭镜头";
    tips.font = [UIFont systemFontOfSize:15];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.numberOfLines = 0;
    [bgBlackView addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgBlackView.mas_centerY);
        make.leading.equalTo(@5);
        make.trailing.equalTo(@(-5));
    }];
}

- (void)removeMaskBlackView {
    [self.maskBlackView removeAllSubviews];
    [self.maskBlackView removeFromSuperview];
    self.maskBlackView = nil;
}

/**
 告诉服务器可以扣费了
 */
- (void)startConnectRequest
{
    if (isNullString([ZZLiveStreamHelper sharedInstance].roomName)) {
        return;
    }
    NSLog(@"PY_收到远程消息_告诉服务器可以扣费了");
       [self chatVideoTime];//同时开启倒计时
    [ZZRequest method:@"POST" path:@"/api/link_mic/begin" params:@{@"room_name":[ZZLiveStreamHelper sharedInstance].roomName} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            
        }
    }];
}


/**
 挂断获取金钱
 */
- (void)getUserMoney {
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"Delay" timeInterval:0.1f queue:nil repeats:NO actionOption:AbandonPreviousAction action:^{
        [ZZUser loadUser:[ZZUserHelper shareInstance].loginerId param:nil next:^(ZZError *error, id userData, NSURLSessionDataTask *task) {
            if ([userData isKindOfClass:[NSDictionary class]]) {
                ZZUser *user = [ZZUser yy_modelWithJSON:(NSDictionary *)userData];
                [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                NSLog(@"更新之后的么币 : %d", [user.mcoin intValue]);
                [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"Delay"];
            }
            
        }];
    }];
}


// 走么币 获取服务端提示
- (void)sendFinishRequest2 {
    __block NSString *string = @"";
    NSInteger cancelBy = 0;
    if (_acceped) {
        if (_disconnected) {//对方挂断

            cancelBy = 1;
        } else if (_during < 120) {
            cancelBy = 2;
        } else {
            cancelBy = 2;

        }
    } else {
        if (_disconnected) {//对方挂断或者对方都没有进入房间
            if (_during < 120) {
                cancelBy = 2;
            } else {
                cancelBy = 2;
            }
        } else {
            cancelBy = 1;
        }
    }
    
    NSMutableDictionary *param = [@{@"room_name":_roomName} mutableCopy];
    if (cancelBy != 0) {
        [param setObject:[NSNumber numberWithInteger:cancelBy] forKey:@"cancel_by"];
    }
    [ZZLiveStreamHelper endHeartBeat];
    // 用户方调用 接口
    [ZZRequest method:@"POST" path:@"/api/link_mic/finish2"
               params:param
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                     if (error) {
                         [ZZHUD showErrorWithStatus:error.message];
                     } else {
                         if (!_acceped) {
                             //                [self sendTextMessage];
                             [ZZUserHelper shareInstance].updateMessageList = YES;
                             
                             string = [data objectForKey:@"admin_tip"];
                         } else {
                             string = [data objectForKey:@"user_tip"];
                         }
                         NSLog(@"提示文案 --- %@", string);
                         [self getUserMoney];
                         if (!isNullString(string)) {
                             [ZZHUD showInfoWithStatus:string];
                         }
                     }
    }];
}


- (void)sendTextMessage
{
    NSInteger minute = _during/60;
    NSInteger second = _during%60;
    RCTextMessage *content = [RCTextMessage messageWithContent:[NSString stringWithFormat:@"本次视频%ld分%ld秒，共%ld元，快来进一步了解吧",minute,second,_money]];
    if (!_acceped) {
        // 必须是点举报申请退款、并且达人方有连续15秒未出镜
        if (self.isRefundClick && self.isShowRefund && _during <= 120) {

            content = [RCTextMessage messageWithContent:[NSString stringWithFormat:@"本次视频%ld分%ld秒，共0元，快来进一步了解吧",minute,second]];
        }
    }
    
    __block RCMessage *message = [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:_targetId content:content pushContent:nil pushData:nil success:^(long messageId) {
        ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
        model.message = message;
        model.showTime = NO;
        NSDictionary *aDict = @{@"message":model};
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_SendMessage object:nil userInfo:aDict];
        [self sendCustomMessage];
    } error:^(RCErrorCode nErrorCode, long messageId) {
    }];
}

- (void)sendCustomMessage
{
    NSInteger minute = _during/60;
    NSInteger second = _during%60;
    ZZChatConnectModel *content = [ZZChatConnectModel messageWithContent:[NSString stringWithFormat:@"本次视频%ld分%ld秒，共%ld元，快来进一步了解吧",minute,second,_money]];
    if (!_acceped) {
        // 必须是点举报申请退款、并且达人方有连续15秒未出镜
        if (self.isRefundClick && self.isShowRefund && _during <= 120) {

            content = [ZZChatConnectModel messageWithContent:[NSString stringWithFormat:@"本次视频%ld分%ld秒，共0元，快来进一步了解吧",minute,second]];
        }
    }
      content.type = _haveWX ? 1:0;
    __block RCMessage *message = [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:_targetId content:content pushContent:nil pushData:nil success:^(long messageId) {
        ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
        model.message = message;
        model.showTime = NO;
        NSDictionary *aDict = @{@"message":model};
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_SendMessage object:nil userInfo:aDict];
    } error:^(RCErrorCode nErrorCode, long messageId) {
        
    }];
    _haveWX = NO;
}

#pragma mark - lazyload

- (AgoraRtcEngineKit *)agoraKit
{
    if (!_agoraKit) {
        AgoraRtcEngineConfig *config = [[AgoraRtcEngineConfig alloc] init];
        config.appId = AgoraAppId;
//        config.areaCode = GlobalSettings.shared.area.rawValue;
        
        AgoraLogConfig *logconfig = [[AgoraLogConfig alloc] init];
        logconfig.level = AgoraLogLevelInfo;
        config.logConfig = logconfig;
        
        _agoraKit = [AgoraRtcEngineKit sharedEngineWithConfig:config delegate:self];
        [_agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
        [_agoraKit setClientRole:AgoraClientRoleBroadcaster];
        [_agoraKit enableVideo];
        AgoraVideoEncoderConfiguration *encoderConfig = [[AgoraVideoEncoderConfiguration alloc] initWithSize:CGSizeMake(640, 320)
                                                                                                   frameRate:AgoraVideoFrameRateFps24
                                                                                                     bitrate:AgoraVideoBitrateStandard
                                                                                             orientationMode:AgoraVideoOutputOrientationModeFixedPortrait];
        encoderConfig.mirrorMode = AgoraVideoMirrorModeDisabled;
        [_agoraKit setVideoEncoderConfiguration:encoderConfig];
        
        AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid = 0;
        videoCanvas.view = self.preview;
        videoCanvas.renderMode = AgoraVideoRenderModeHidden;
        [_agoraKit setupLocalVideo:videoCanvas];
    }
    return _agoraKit;
}

- (UIView *)preview
{
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _preview.clipsToBounds = YES;
    }
    return _preview;
}

- (UIView *)remoteView {
    if (!_remoteView) {
        _remoteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _remoteView.clipsToBounds = YES;
    }
    return _remoteView;
}

- (void)chatVideoTime {
    WeakSelf
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:MeBiIphone_Key timeInterval:1 queue:nil repeats:YES actionOption:AbandonPreviousAction action:^{
        [weakSelf timerEvent];
    }];
}

#pragma mark - 连麦心跳
/**
 开始心跳
 */
+ (void)startHeartbeatWithRoom_id:(NSString *)room_id {
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:SecondCheckHeartbeat timeInterval:30 queue:nil repeats:YES actionOption:AbandonPreviousAction action:^{
        [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/online",room_id] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
             NSLog(@"PY_心跳%@%@",data,error);
        }];
    }];
}

/**
 结束心跳
 */
+ (void)endHeartBeat {
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:SecondCheckHeartbeat];
}
@end

