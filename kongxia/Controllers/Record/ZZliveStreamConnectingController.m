
//
//  ZZliveStreamConnectingController.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/5.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

/** 用于捕捉挂断的*/
#import "ZZDateHelper.h"
/** 用于捕捉挂断的*/
#import "ZZliveStreamConnectingController.h"
#import "ZZliveStreamHeadView.h"
#import "ZZLiveStreamConnectCancelAlert.h"
#import "ZZLiveStreamHelper.h"

#import "ZZRecordBtnView.h"
#import "ZZRecordChooseView.h"
#import "WZBCountdownLabel.h"
#import "ZZCenterButton.h"
#import "ZZRecordTopicTitleView.h"
#import "ZZRecordTopicView.h"
#import "ZZRecordProgressView.h"
#import "ZZRecordBottomView.h"
#import "ZZRecordQuestionGuideView.h"
#import "PhotoAlbumViewController.h"
#import "ZZSelectPhotoManager.h"

#import "ZZFileHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "ZZLiveStreamConnectTopView.h"
#import <RongIMLib/RongIMLib.h>
#import "ZZYLabel.h"
#import "ZZVideoMessage.h"

#import "ZZChatStatusModel.h" //判断是不是打招呼的
#import "ZZChatManagerNetwork.h"
#import "WBReachabilityManager.h"
#import "ZZCallIphoneVideoManager.h"

#import "ZZChatCallIphoneManagerNetWork.h"//拨打电话的管理类
#import "JX_GCDTimerManager.h"

#import "ZZCameraFilterView.h"

@interface ZZliveStreamConnectingController () <GPUImageVideoCameraDelegate,ZZRecordChooseDelegate,ZZRecordProgressViewDelegate, WBSelectPhotoManagerObserver,ZZCameraFilterViewDelegate,AgoraRtcEngineDelegate>
{
    GPUImageUIElement   *uiElementInput;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *preView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) ZZliveStreamHeadView *headView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIImageView *animateImgView;

@property (nonatomic, strong) ZZLiveStreamConnectCancelAlert *alert;
@property (nonatomic, strong) ZZLiveStreamConnectTopView *topView;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat yScale;

@property (nonatomic, strong) ZZRecordChooseView *chooseView;
@property (nonatomic, strong) UIImageView *dynamicImgView;
//@property (nonatomic, strong) ZZRecordQuestionGuideView *questionGuideView;
@property (nonatomic, strong) UIView *closeCameraMask;// 关闭镜头的黑色遮罩层
@property (nonatomic, strong) UIImageView *cameraBtnImageView;

@property (nonatomic, strong) NSMutableArray *labelArray;//话题array

@property (nonatomic, strong) GPUImageStillCamera *videoCamera;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageView *previewView;
@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, strong) NSURL *exportURL;


@property (nonatomic, strong) GPUImageAlphaBlendFilter *blendFilter;
@property (nonatomic, strong) NSDictionary *topicDict;
@property (nonatomic, strong) NSArray *questionArray;
@property (nonatomic, strong) NSArray *questionImgArray;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, assign) BOOL isFirstQuestion;
@property (nonatomic, assign) CGFloat timeScale;
@property (nonatomic, assign) NSInteger lastImgIndex;

@property (nonatomic, strong) ZZYLabel *titleLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) ZZCameraFilterView *filterView;
@property (nonatomic, strong) AgoraBeautyOptions *filterOption;
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) AgoraRtcVideoCanvas *canvas;
@end

@implementation ZZliveStreamConnectingController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];

    [self closeRightHandGestures];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self closeRightHandGestures];
    
    [self.view bringSubviewToFront:self.chooseView];
    [[ZZCallIphoneVideoManager shared] beginRing];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self openRightHandGestures];
    if (_agoraKit) {
        [self releaseAgoraKit];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self openRightHandGestures];
}

- (void)releaseObject {
    [[ZZCallIphoneVideoManager shared] stopRing];
    [WZBCountdownLabel remove];
    _videoCamera = nil;
    _movieWriter = nil;
    _previewView = nil;
    _blendFilter = nil;
    
    [[JX_GCDTimerManager sharedInstance]  cancelTimerWithName:CallIphone_Key];
}

- (void)openRightHandGestures {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseObject];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)closeRightHandGestures {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refuseNotification:) name:kMsg_RefuseConnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBusy:) name:kMsg_BusyConnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectVideoStarNotification:) name:kMsg_ConnectVideoStar object:nil];

    if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstInitEnableVideo]) {
        // 第一次等待视频，默认帮助用户操作一次
        [ZZKeyValueStore saveValue:@"firstInitEnableVideo" key:[ZZStoreKey sharedInstance].firstInitEnableVideo];
         // 默认开启镜头
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kEnableVideoKey];
        // 默认关闭镜头
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self setupUI];
    [self loadAgoraKit];
    
    // 上一次是否关闭镜头
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kEnableVideoKey]&&!self.accept) {
        [self closeCameraClick];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)releaseAgoraKit {
    [_agoraKit disableVideo];
//    [_agoraKit leaveChannel:nil];
    [_agoraKit enableLocalVideo:NO];
    _agoraKit = nil;
    [self releaseObject];
}

- (void)loadAgoraKit {
    _agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:AgoraAppId delegate:self];
//    [_agoraKit setChannelProfile: AgoraChannelProfileCommunication];
    [_agoraKit enableVideo];

    AgoraVideoEncoderConfiguration *configure = [[AgoraVideoEncoderConfiguration alloc] init];
    configure.frameRate = AgoraVideoFrameRateFps24;
    configure.bitrate = AgoraVideoBitrateStandard;
    configure.orientationMode = AgoraVideoOutputOrientationModeAdaptative;
    configure.dimensions = AgoraVideoDimension1280x720;
    [_agoraKit setVideoEncoderConfiguration:configure];
    
    [_agoraKit setClientRole:AgoraClientRoleAudience];
    [_agoraKit startPreview];
    
    self.preView.translatesAutoresizingMaskIntoConstraints = NO;
    _canvas = [[AgoraRtcVideoCanvas alloc] init];
    _canvas.uid = 0;
    _canvas.view = self.preView;
    _canvas.renderMode = AgoraVideoRenderModeHidden;
    
    [_agoraKit setupLocalVideo:_canvas];
    [_agoraKit enableLocalVideo:YES];
}

- (void)setupUI {
    self.view.backgroundColor = HEXACOLOR(0x000000, 0.9);
    self.bgView.hidden = YES;
    [self.view addSubview:self.preView];
    self.cancelBtn.hidden = NO;
    [self timingCharging];
    self.chooseView.hidden = NO;
}

/**
 计时收费
 */
- (void)timingCharging {
    WS(weakSelf);
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:CallIphone_Key timeInterval:0.1 queue:nil repeats:YES actionOption:AbandonPreviousAction action:^{
        [weakSelf timerEvent];
    }];
}

- (void)connectVideoStarNotification:(NSNotification *)notification {
    NSString *uid = [notification.userInfo objectForKey:@"uid"];
    WEAK_SELF();
    if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:uid]) {
        [self releaseAgoraKit];
        BLOCK_SAFE_CALLS(weakSelf.connectVideoStar, _data);
        //        [self releaseObject];
    }
}

- (void)setData:(id)data {
    _data = data;
    [ZZLiveStreamHelper sharedInstance].isBusy = YES;
}

- (void)setUser:(ZZUser *)user {
    _user = user;
}

- (void)setShowCancel:(BOOL)showCancel {
    _showCancel = showCancel;
}

- (void)show {
    if (CGRectIsNull(_sourceRect)) {
        CGFloat offset = (SCREEN_HEIGHT/667.0)*104-SafeAreaBottomHeight;
        CGFloat width = _scale*295;
        UIImageView *tempImgView = [[UIImageView alloc] initWithFrame:_sourceRect];
        [tempImgView sd_setImageWithURL:[NSURL URLWithString:_user.avatar]];
        [self.view addSubview:tempImgView];
        
        CGRect targetRect = CGRectMake((SCREEN_WIDTH - width)/2, offset, width, width);
        
        [UIView animateWithDuration:0.3 animations:^{
            tempImgView.frame = targetRect;
        } completion:^(BOOL finished) {
            self.bgView.hidden = NO;
            [tempImgView removeFromSuperview];
        }];
    }
    else {
        self.bgView.hidden = NO;
    }
}

- (void)remove {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZZLiveStreamHelper sharedInstance].isBusy = NO;
        [self releaseObject];
        [self.navigationController popViewControllerAnimated:YES];
        [_filterView hide];
        _filterView = nil;
    });
}

#pragma mark - 通知
- (void)refuseNotification:(NSNotification *)notification {
    WEAK_SELF();
    NSString *uid = [notification.userInfo objectForKey:@"uid"];
    [ZZLiveStreamHelper sharedInstance].isBusy = YES;
    if ([uid isEqualToString:_user.uid]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = NO;
            BLOCK_SAFE_CALLS(self.noPenaltyBlock, YES);
            self.statusLabel.text = @"对方拒接或不在线\n本次连接将不收取费用";
            [self userSendVideoMessageWhenDaRenRefuse];
            [weakSelf updateStatus];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self cancelRequest:NO];
        });
    }
}

- (void)receiveBusy:(NSNotification *)notification {
    NSString *uid = [notification.userInfo objectForKey:@"uid"];
    [ZZLiveStreamHelper sharedInstance].isBusy = YES;
    if ([uid isEqualToString:_user.uid]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statusLabel.text = @"对方已接任务或不在线\n下次选TA要快哦";
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancelRequest:NO];
            });
        });
    }
}

#pragma mark -
- (void)timerEvent {
    _count++;
    
    if (_count == 100) {//当连接中为10秒的时候
        BLOCK_SAFE_CALLS(self.noPenaltyBlock, YES);
    }
    
    // 600 = 60秒 = 1分钟 等待超时时间
    if (_count > 600) {
        _count = 600;
        if (_timeOut) {
            _timeOut();
        }
        [[JX_GCDTimerManager sharedInstance]  cancelTimerWithName:CallIphone_Key];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_accept) {
                self.statusLabel.text = @"连线超时";
            } else {
                BLOCK_SAFE_CALLS(self.noPenaltyBlock, YES);
                self.statusLabel.text = @"对方拒接或不在线\n本次连接将不收取费用";
            }
            self.view.userInteractionEnabled = NO;
            [self userRefuseWithType:@"1"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZZLiveStreamHelper sharedInstance].isBusy = NO;
            [ZZLiveStreamHelper sharedInstance].noSendFinish = YES;
            [[ZZLiveStreamHelper sharedInstance] disconnect];
            
            [ZZUserDefaultsHelper setObject:@"超时挂断" forDestKey:[ZZDateHelper getCurrentDate]];
            [self remove];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headView.progress =  1 - _count/600.0;
        });
    }
}

/**
 不是直接拒绝接受视频的挂断
 */
- (void)userRefuseWithType:(NSString *)type {
     [ZZChatManagerNetwork sendVideoMessageWithDestinationUidString:self.user.uid withType:type sendType:nil chatContent:@"我暂时无法接通你的视频邀请，留言给我吧！看到后第一时间回复你哦！"];
}

/**
 女方拒绝接受视屏
 */
- (void)userSendVideoMessageWhenDaRenRefuse {
    [ZZChatManagerNetwork sendVideoMessageWithDestinationUidString:self.user.uid withType:@"3" sendType:@"男方代替女方发消息" chatContent:@"我暂时不方便接通你的视频邀请，留言给我吧！空闲时我第一时间回复你哦！"];
}

- (void)beginAnimation {
    [self.animateImgView.layer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:2.0]; // 结束时的倍率
    animation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.5;
    group.removedOnCompletion = NO;
    group.repeatCount = HUGE_VALF;
    group.animations = @[animation,opacityAnimation];
    
    [self.animateImgView.layer addAnimation:group forKey:@"group"];
}

- (void)cancelBtnClick {
    [MobClick event:Event_click_User_Video_Cancel];
    WeakSelf;
    _alert = [[ZZLiveStreamConnectCancelAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_alert];
    _alert.touchCancel = ^{
        
        if (!GetReachabilityManager().isReachable) {
            [ZZHUD showErrorWithStatus:@"网络异常，请检查"];
            return ;
        }
        [weakSelf updateStatus];
        [weakSelf cancelRequest:YES];
        NSLog(@"PY_当前的时间%ld",(long)weakSelf.count);
        if (weakSelf.count>=100) {
            //大于10秒的才发消息
            [weakSelf  userRefuseWithType:@"2"];
        }
    };
}

- (void)updateStatus {
    if (!_data) {
        return;
    }
    
    [ZZChatCallIphoneManagerNetWork callIphoneUpdateStateWithRoomid:_data[@"room_id"] callIphoneStyleString:@"cancel"];
}

- (void)cancelRequest:(BOOL)sendMessage {
    [ZZLiveStreamHelper sharedInstance].noSendFinish = YES;
    [[ZZLiveStreamHelper sharedInstance] disconnect];
    [ZZUserDefaultsHelper setObject:@"取消挂断" forDestKey:[ZZDateHelper getCurrentDate]];

    [self remove];

    if (sendMessage) {
        if (!_data) {
            return;
        }
        [ZZChatCallIphoneManagerNetWork  callIphone:Cancel_CallIphoneStyle roomid:_data[@"room_id"] uid:nil paramDic:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [ZZLiveStreamHelper sharedInstance].isBusy = NO;
        }];
      
    }
}

//#pragma mark - GPUImageVideoCameraDelegate
//- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
//    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    UIDeviceOrientation iDeviceOrientation = [[UIDevice currentDevice] orientation];
//    BOOL mirrored = (self.videoCamera.cameraPosition == AVCaptureDevicePositionFront && self.videoCamera.horizontallyMirrorFrontFacingCamera) || (self.videoCamera.cameraPosition == AVCaptureDevicePositionBack && self.videoCamera.horizontallyMirrorRearFacingCamera);
//
//    cv_rotate_type cvMobileRotate;
//    switch (iDeviceOrientation) {
//        case UIDeviceOrientationPortrait:
//            cvMobileRotate = CV_CLOCKWISE_ROTATE_90;
//            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_0;
//            break;
//
//        case UIDeviceOrientationLandscapeLeft:
//            cvMobileRotate = mirrored ? CV_CLOCKWISE_ROTATE_180 : CV_CLOCKWISE_ROTATE_0;
//            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_270;
//            break;
//
//        case UIDeviceOrientationLandscapeRight:
//            cvMobileRotate = mirrored ? CV_CLOCKWISE_ROTATE_0 : CV_CLOCKWISE_ROTATE_180;
//            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_90;
//            break;
//
//        case UIDeviceOrientationPortraitUpsideDown:
//            cvMobileRotate = CV_CLOCKWISE_ROTATE_270;
//            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_180;
//            break;
//
//        default:
//            cvMobileRotate = CV_CLOCKWISE_ROTATE_0;
//            break;
//    }
//}

#pragma mark - ZZRecordChooseDelegate
- (void)chooseView:(id)chooseView isViewUp:(BOOL)isViewUp {
    if (!isViewUp) {
        [self showViews];
    }
}

#pragma mark - ZZRecordProgressViewDelegate
- (void)progressView:(ZZRecordProgressView *)progressView videoDurationLongEnough:(BOOL)enough {

}

- (void)videoReachMaxDuration {
}

#pragma mark - ZZCameraFilterViewDelegate
- (void)view:(ZZCameraFilterView *)view filterOptions:(AgoraBeautyOptions *)options {
    [_agoraKit setBeautyEffectOptions:YES options:options];
}

#pragma mark - UIButtonMethod
- (void)stickerBtnClick {
    [MobClick event:Event_click_record_sticker];
    [self hideViews];
    [self.chooseView viewUp];
    [self hideStickerRedPoint];
}

// 显示美颜
- (void)showFilters {
    _filterView = [ZZCameraFilterView show];
    _filterView.delegate = self;
}

// 关闭或开启镜头
- (void)enableVideoClick {
    
    // 有 kEnableVideoKey 值，说明当前处于开启镜头状态
    if (self.stickerBtn.isSelected) {//开启镜头操作
        self.stickerBtn.selected = NO;
        self.titleLabel.text = @"关闭镜头";
        self.cameraBtnImageView.image = [UIImage imageNamed:@"icConnectCloseCamera"];

        [self openCameraClick];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kEnableVideoKey];
        [[NSUserDefaults standardUserDefaults] synchronize];



    } else {//关闭镜头操作
        [MobClick event:Event_click_Video_Close_Lens];
        self.stickerBtn.selected = YES;
        self.titleLabel.text = @"开启镜头";
        self.cameraBtnImageView.image = [UIImage imageNamed:@"icConnectOpenCamera"];

        [self closeCameraClick];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kEnableVideoKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [SVProgressHUD setMinimumDismissTimeInterval:3.0f];
        [SVProgressHUD setMaximumDismissTimeInterval:6.0f];
        [SVProgressHUD showInfoWithStatus:@"您已关闭镜头，对方将不会看到您"];
    }
}

// 开启镜头
- (void)openCameraClick {
    [self.closeCameraMask removeFromSuperview];
    self.closeCameraMask = nil;
}

// 关闭镜头
- (void)closeCameraClick {
    self.closeCameraMask = [UIView new];
    self.closeCameraMask.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.closeCameraMask.backgroundColor = [UIColor blackColor];
    
    [self.preView addSubview:self.closeCameraMask];
    
    UIImageView *userHeader = [UIImageView new];
    userHeader.frame = CGRectMake(-(SCREEN_HEIGHT - SCREEN_WIDTH) / 2.0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT);
    [userHeader sd_setImageWithURL:[NSURL URLWithString:_user.avatar] placeholderImage:nil options:(SDWebImageRetryFailed)];
    userHeader.contentMode = UIViewContentModeScaleAspectFill;
    [self.closeCameraMask addSubview:userHeader];
    
    UIView *bgView = [UIView new];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.closeCameraMask addSubview:bgView];
}

- (void)hideStickerRedPoint {
    [ZZUserHelper shareInstance].lastStickersVersion = self.chooseView.stickerVersion;
}

#pragma mark - private
- (void)hideViews {
    self.cancelBtn.hidden = YES;
    self.stickerBtn.hidden = YES;
    self.bottomView.hidden = YES;
}

- (void)showViews {
    self.cancelBtn.hidden = NO;
    self.stickerBtn.hidden = NO;
    self.bottomView.hidden = NO;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self bottomItemsDown];
}

- (void)bottomItemsDown {
    if (self.chooseView.isViewUp) {
        [self.chooseView viewDown];
    }

}

- (void)backConfigInfomation {
    ZZRecordConfigModel *model = [[ZZRecordConfigModel alloc] init];
    [ZZUserHelper shareInstance].recordConfigModel = model;
}

#pragma mark - Lazyload
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_bgView];
        
        _scale = SCREEN_WIDTH/375.0;
        if (_scale > 1) {
            _scale = 1;
        }
        _yScale = SCREEN_HEIGHT/667.0;
        if (_yScale > 1) {
            _yScale = 1;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headView.hidden = YES;
        });
        
        
        [_bgView addSubview:self.topView];
        self.topView.user = _user;
        CGFloat height = [_topView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
        _topView.height = height ;
        _topView.isConnectHeader = YES;
        _topView.accept = NO;
        
        [self beginAnimation];
    }
    return _bgView;
}

- (UIView *)preView {
    if (!_preView) {
        _preView = [[UIView alloc] initWithFrame:self.bgView.bounds];
    }
    return _preView;
}

- (ZZliveStreamHeadView *)headView {
    if (!_headView) {
        
        CGFloat offset = (SCREEN_HEIGHT/667.0)*104;
        CGFloat width = _scale*295;
        _headView = [[ZZliveStreamHeadView alloc] init];
        [_bgView addSubview:_headView];
        
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top).offset(offset);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
    }
    return _headView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:24*_scale];
        [_bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_headView.mas_top).offset(-_yScale*20);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
        }];
    }
    return _nameLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize:16];
        _statusLabel.numberOfLines = 0;
        [_bgView addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bgView.mas_centerY);
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
        }];
    }
    return _statusLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        self.bottomView = [[UIView alloc] init];
        [_bgView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_bgView);
            make.height.equalTo(@230);
        }];
    
        ZZYLabel *label = [ZZYLabel new];
        label.text = @"取消";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:17];
        label.outlineColor = RGBCOLOR(173, 173, 177);
        label.outlineWidth = 1.0f;
        [_bottomView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-40));
            make.centerX.equalTo(_bottomView.mas_centerX);
        }];
        
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"icon_livestream_publish_bg2"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bottomView);
            make.bottom.mas_equalTo(_bottomView.mas_bottom).offset(-73);
            make.size.mas_equalTo(CGSizeMake(69, 69));
        }];
        
        
        // 打开关闭镜头
        [_bottomView addSubview:self.filterBtn];
        [_bottomView addSubview:self.stickerBtn];
//        [_stickerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_cancelBtn);
//            make.bottom.equalTo(_cancelBtn.mas_top).offset(-40.0);
//            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 100) / 4.0, 60));
//        }];
        
    }
    return _cancelBtn;
}

- (UIButton *)stickerBtn {
    if (!_stickerBtn) {
        CGFloat width = (SCREEN_WIDTH - 100) / 4.0;
        CGFloat offset = (SCREEN_WIDTH - width * 2) / 3;
        
        _stickerBtn = [[UIButton alloc] initWithFrame:CGRectMake(offset * 2 + width, 0, width, 60)];
        [_stickerBtn addTarget:self action:@selector(enableVideoClick) forControlEvents:UIControlEventTouchUpInside];
        _stickerBtn.selected = YES;
        
        self.titleLabel = [[ZZYLabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _titleLabel.text = @"开启镜头";
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.outlineWidth = 1.0f;
        _titleLabel.outlineColor = RGBCOLOR(173, 173, 177);
        
        [_stickerBtn addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_stickerBtn.mas_centerX);
            make.bottom.mas_equalTo(_stickerBtn.mas_bottom).offset(-10);
        }];
        
        self.cameraBtnImageView = [[UIImageView alloc] init];
        self.cameraBtnImageView.userInteractionEnabled = NO;
        self.cameraBtnImageView.tag = 100;
        [_stickerBtn addSubview:self.cameraBtnImageView];
        
        [self.cameraBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_stickerBtn.mas_centerX);
            make.bottom.mas_equalTo(_titleLabel.mas_top).offset(-8);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        // 初始化状态
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kEnableVideoKey]) {
            _stickerBtn.selected = NO;
            _titleLabel.text = @"关闭镜头";
            self.cameraBtnImageView.image = [UIImage imageNamed:@"icConnectCloseCamera"];
        } else {
            _stickerBtn.selected = YES;
            _titleLabel.text = @"开启镜头";
            self.cameraBtnImageView.image = [UIImage imageNamed:@"icConnectOpenCamera"];
        }
    }
    return _stickerBtn;
}

- (UIButton *)filterBtn {
    if (!_filterBtn) {
        CGFloat width = (SCREEN_WIDTH - 100) / 4.0;
        CGFloat offset = (SCREEN_WIDTH - width * 2) / 3;
        
        _filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(offset, 0, width, 60)];
        [_filterBtn addTarget:self action:@selector(showFilters) forControlEvents:UIControlEventTouchUpInside];
        _filterBtn.selected = YES;
        
        ZZYLabel *titleLabel = [[ZZYLabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        titleLabel.text = @"美颜";
        titleLabel.userInteractionEnabled = NO;
        titleLabel.outlineWidth = 1.0f;
        titleLabel.outlineColor = RGBCOLOR(173, 173, 177);
        
        [_filterBtn addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_filterBtn.mas_centerX);
            make.bottom.mas_equalTo(_filterBtn.mas_bottom).offset(-10);
        }];
        
        UIImageView *cameraBtnImageView = [[UIImageView alloc] init];
        cameraBtnImageView.userInteractionEnabled = NO;
        cameraBtnImageView.image = [UIImage imageNamed:@"icMeiyan"];
        cameraBtnImageView.tag = 100;
        [_filterBtn addSubview:cameraBtnImageView];
        
        [cameraBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_filterBtn.mas_centerX);
            make.bottom.mas_equalTo(titleLabel.mas_top).offset(-8);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
    }
    return _filterBtn;
}

- (ZZLiveStreamConnectTopView *)topView {
    if (!_topView) {
        _topView = [[ZZLiveStreamConnectTopView alloc] initWithFrame:CGRectMake(0, SafeAreaBottomHeight, SCREEN_WIDTH - 50, 10)];
    }
    return _topView;
}

@end
