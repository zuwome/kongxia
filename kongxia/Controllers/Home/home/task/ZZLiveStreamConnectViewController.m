//
//  ZZLiveStreamConnectViewController.m
//  zuwome
//
//  Created by angBiu on 2017/7/14.
//  Copyright © 2017年 zz. All rights reserved.
//

/** 用于捕捉挂断的*/
#import "ZZDateHelper.h"
/** 用于捕捉挂断的*/

#import "ZZLiveStreamConnectViewController.h"
#import "ZZRechargeViewController.h"
#import "ZZLiveStreamPublishingViewController.h"
#import "ZZRentViewController.h"

#import "ZZLiveStreamConnectTopView.h"
#import "ZZLiveStreamConnectBottomView.h"
#import "ZZRecordChooseView.h"
#import "ZZConnectFloatWindow.h"
#import "ZZLiveStreamConnectTimeView.h"
#import "ZZLiveStreamVideoAlert.h"
#import "ZZLiveStreamReportAlert.h"
#import "ZZVideoAppraiseVC.h"
#import "ZZCameraFilterView.h"

#import "ZZReportModel.h"
#import "ZZLiveStreamHelper.h"
#import "WBActionContainerView.h"
#import "ZZMeBiViewController.h"

#import "ZZLocalPushManager.h"
#import "JX_GCDTimerManager.h"
#import "WBReachabilityManager.h"

#define VIDEO_CONNECT_CHECK     (@"VIDEO_CONNECT_CHECK")//连接校验
#define ONLINE_KEY              (@"ONLINE_KEY")//校验心跳包，是否在线

@interface ZZLiveStreamConnectViewController () <ZZRecordChooseDelegate, ZZCameraFilterViewDelegate>

@property (nonatomic, strong) UIView *remoteView;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) ZZLiveStreamConnectTopView *topView;
@property (nonatomic, strong) UIButton *narrowBtn;
@property (nonatomic, strong) ZZLiveStreamConnectBottomView *bottomView;
@property (nonatomic, strong) ZZRecordChooseView *chooseView;
@property (nonatomic, strong) UIView *currentShortView;//当前小窗口
@property (nonatomic, strong) ZZLiveStreamConnectTimeView *timeView;
@property (nonatomic, strong) ZZLiveStreamVideoAlert *cancelAlert;//取消的弹窗
@property (nonatomic, strong) ZZLiveStreamVideoAlert *cancelRefundAlert;//取消带有申请退款弹窗
@property (nonatomic, strong) UIViewController *pastCtl;
@property (nonatomic, strong) UIImageView *shapeImageView;
@property (nonatomic, strong) WBActionContainerView *presentSlider;
@property (nonatomic, strong) UIView *closeCameraMask;// 关闭镜头的黑色遮罩层

@property (nonatomic, strong) ZZCameraFilterView *filterView;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) CGRect sourceRect;
@property (nonatomic, assign) BOOL leave;
@property (nonatomic, assign) BOOL viewDidApper;
@property (nonatomic, assign) BOOL haveLoad;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isShowAlert;//是否显示着鉴黄弹窗
@property (nonatomic, assign) BOOL isShowRefund;//挂断的时候是否需要显示申请退款，当2分钟内，达人方连续15秒未出镜，则为YES
@property (nonatomic, assign) BOOL isShowFingerAnimation;//是否正在显示手指动画，开始显示时YES，5秒后为NO
@property (nonatomic, assign) BOOL isCommentsNeed;//挂断视频之后，是否需要弹窗评价窗口

@property (nonatomic, strong) UITapGestureRecognizer *recognizer;//小窗口点击对象
@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, assign) BOOL isShowLowMcoin;//是否正在显示么币不足提示
@property (nonatomic, assign) BOOL isShowLowBalance;//是否正在显示余额不足提示

@property (nonatomic, assign) BOOL isShowCommentsView;//当前是否显示着评价窗口
@property (nonatomic,assign) BOOL isHideNav;

@end

@implementation ZZLiveStreamConnectViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        _isHideNav = YES;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    if (_leave) {
        [[ZZConnectFloatWindow shareInstance] remove:NO];
        [self.view addSubview:_remoteView];
        [ZZConnectFloatWindow shareInstance].rechargeing = NO;
        
        [self.view sendSubviewToBack:_remoteView];
        if (_currentShortView == _previewView) {
            _remoteView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } else {
            _remoteView.frame = _sourceRect;
            [self.view sendSubviewToBack:_previewView];
        }
        _leave = NO;
    }
}

//出现之后
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
 
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];

    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    _remoteView.userInteractionEnabled = YES;
    if (!_haveLoad) {
        _haveLoad = YES;
    }
    _viewDidApper = YES;
    
    WEAK_SELF();
    if ([ZZLiveStreamHelper sharedInstance].disconnected) { // 做一个校验，当发起时候时处于后台，对方接通 ，再挂断的时候，此时在回到前台，需要在这里做一个校验，对方已挂断，自己也要挂断，
        
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:ONLINE_KEY];
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:VIDEO_CONNECT_CHECK];

        dispatch_async(dispatch_get_main_queue(), ^{
            [NSObject asyncWaitingWithTime:0.5f completeBlock:^{
                [ZZUserDefaultsHelper setObject:@"后台校验一个连接状态挂断" forDestKey:[ZZDateHelper getCurrentDate]];

                [[ZZLiveStreamHelper sharedInstance] disconnect];
                [weakSelf clearTimer];
                // 添加头像 UI
                [weakSelf endAddUserHeaderImageView];
                
                if (!self.isShowCommentsView) {// 当前没有评价框
                    weakSelf.isShowCommentsView = YES;
                    [ZZLiveStreamHelper sharedInstance].isBusy = YES;
                    [weakSelf.presentSlider present];
                }
            }];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    if (_isHideNav) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    if ([ZZConnectFloatWindow shareInstance].rechargeing) {
        [self addFloatWindow];
        _remoteView.userInteractionEnabled = NO;
    }
    _viewDidApper = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoBrokeRules:) name:kMsg_VideoBrokeRules object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkConnectStatus)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    [self createViews];
    [self loadData];
    [self managerViewControllers];
    [self createTimer];
    [self videoConnectCheck];
//    [self addObserverOnline];
    
    if (_acceped) {
        self.isCommentsNeed = NO;
    } else {
        self.isCommentsNeed = YES;//默认用户方需要评价，但后面如果用户举报了，则不需要
        self.isShowCommentsView = NO;
    }
}

// 进入前台 校验一个连接状态
- (void)checkConnectStatus {
    
    if (!self.acceped) {
        WEAK_SELF();
        if ([ZZLiveStreamHelper sharedInstance].disconnected) {
            
            [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:ONLINE_KEY];
            [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:VIDEO_CONNECT_CHECK];

            dispatch_async(dispatch_get_main_queue(), ^{
                [NSObject asyncWaitingWithTime:0.5f completeBlock:^{
                    [ZZUserDefaultsHelper setObject:@"校验一个连接状态挂断" forDestKey:[ZZDateHelper getCurrentDate]];

                    [[ZZLiveStreamHelper sharedInstance] disconnect];
                    [weakSelf clearTimer];
                    // 添加头像 UI
                    [weakSelf endAddUserHeaderImageView];
                    
                    if (!self.isShowCommentsView) {// 当前没有评价框
                        weakSelf.isShowCommentsView = YES;
                        [ZZLiveStreamHelper sharedInstance].isBusy = YES;
                        [weakSelf.presentSlider present];
                    }
                }];
            });
        }
    }
}

- (void)videoConnectCheck {
    // 每 15秒 做个校验
    WEAK_SELF();

    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:VIDEO_CONNECT_CHECK timeInterval:15.0f queue:nil repeats:YES actionOption:AbandonPreviousAction action:^{
        [weakSelf closeVideo];
    }];
    //连续16秒没有回调挂断,同时定时器也没跑到
    [ZZLiveStreamHelper sharedInstance] .failureNetConnect = ^{
        [weakSelf closeVideo];
    };
}

/**
 挂断视频
 */
- (void)closeVideo {
    //收到对方没有加入同时不是自己的责任就告诉服务端是对方的责任  导致的挂断
    if (![ZZLiveStreamHelper sharedInstance].isUserJoinSuccess&&![ZZLiveStreamHelper sharedInstance].isUserReason) {//用户未加入
        [ZZLiveStreamHelper sharedInstance].disconnected = YES;//则断开标识
    }
    if (_acceped) {// 达人
        // 没有连接（声音） 或者 已断开
        if (![ZZLiveStreamHelper sharedInstance].connecting || [ZZLiveStreamHelper sharedInstance].disconnected) {
            self.isCommentsNeed = NO;//需要评价
            [ZZUserDefaultsHelper setObject:@"达人没有画面" forDestKey:[ZZDateHelper getCurrentDate]];
            [self hideView];
        }
        if ([ZZLiveStreamHelper sharedInstance].countByTes>=7) {
            NSLog(@"PY_视屏连麦网路断掉");
            self.isCommentsNeed = NO;//需要评价
            [self hideView];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZZHUD showTaskInfoWithStatus:@"网络错误"];
            });
            [ZZUserDefaultsHelper setObject:@"达人没有网络" forDestKey:[ZZDateHelper getCurrentDate]];
        }
    } else {// 用户
        // 没有连接（画面） 或者 已断开
        if (![ZZLiveStreamHelper sharedInstance].connecting || [ZZLiveStreamHelper sharedInstance].disconnected) {
            self.isCommentsNeed = YES;//需要评价
            [self hideView];
            [ZZUserDefaultsHelper setObject:@"用户没有画面" forDestKey:[ZZDateHelper getCurrentDate]];
        }
        if ([ZZLiveStreamHelper sharedInstance].countByTes>=7) {
            NSLog(@"PY_视屏连麦网路断掉");
            self.isCommentsNeed = NO;//需要评价
            [self hideView];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZZHUD showTaskInfoWithStatus:@"网络错误"];
            });
            [ZZUserDefaultsHelper setObject:@"达人没有网络" forDestKey:[ZZDateHelper getCurrentDate]];
        }
    }
}
// 监听在线状态，是否帐号在其他地方登陆
- (void)addObserverOnline {
    
    WEAK_SELF();
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:ONLINE_KEY timeInterval:15.0f queue:nil repeats:YES actionOption:AbandonPreviousAction action:^{
        
        if (![ZZLiveStreamHelper sharedInstance].room_id) {//处理极端情况，room_id 为空的情况，防止崩溃
            [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:ONLINE_KEY];
            return ;
        }
        [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/online", [ZZLiveStreamHelper sharedInstance].room_id] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error.code == 1111) {//表示帐号在其他地方登陆了
                weakSelf.isCommentsNeed = NO;//不需要评价
                [ZZUserDefaultsHelper setObject:@"在线监听" forDestKey:[ZZDateHelper getCurrentDate]];

                [weakSelf hideView];
                // 这种情况下，需要弹窗提示
                [NSObject asyncWaitingWithTime:1.0f completeBlock:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_NoticeToWindows object:nil];
                }];
                [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:ONLINE_KEY];
            }
        }];
    }];
}

- (void)createViews
{
    WeakSelf;
    [self.view addSubview:self.previewView];
    _currentShortView = self.previewView;
    
    self.isShowAlert = NO;
    self.isShowRefund = NO;
    ZZLiveStreamHelper *helper = [ZZLiveStreamHelper sharedInstance];
    helper.acceped = _acceped;
    helper.uid = _uid;
    
    [helper setConnectCompleted:^{
        [_tipsLabel removeFromSuperview];
        _tipsLabel = nil;
        //连上之后，再判断是否关闭镜头
        if (!_acceped) {
            if (weakSelf.isDisableVideo) {//关闭镜头
                [weakSelf closeCameraClick];
                
            } else {//开启镜头
            }
        }
    }];
    
    [self addRemoteView];   // 添加视频窗口
    helper.finishConnect = ^{//断开了连接（可能是对方挂断，也可能是自动挂断，网络不好等）
        if (!weakSelf.acceped) {//被对方挂断
            weakSelf.isCommentsNeed = YES;//需要评价
        }
        [ZZUserDefaultsHelper setObject:@"对方不在了断开了链接" forDestKey:[ZZDateHelper getCurrentDate]];

        [weakSelf hideView];
    };
    helper.timerCallBack = ^{
        [weakSelf updateTime];
    };
    [helper setFirstCloseCameraBlock:^{
        if (_acceped) {
            [_tipsLabel removeFromSuperview];
            _tipsLabel = nil;
            
            [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
                [weakSelf tap:weakSelf.recognizer];
            }];
        }
    }];
    helper.lowBalanceCallBack = ^{//快没钱
        weakSelf.isShowLowBalance = YES;
        [weakSelf hideBottomAlert:NO];
        [weakSelf showAllViews];
    };
    helper.noMoneyCallBack = ^{//没钱了
        if (!weakSelf.acceped) {//用户方钱包没钱的时候，挂断需要弹评价窗口
            weakSelf.isCommentsNeed = YES;
        }
        [ZZUserDefaultsHelper setObject:@"没钱了挂断" forDestKey:[ZZDateHelper getCurrentDate]];

        [weakSelf hideView];
    };
    
    [helper setLiveStreamShowFaceBlock:^(BOOL acceped, ZZLiveStreamShowFaceType type) {
        [weakSelf showTipsWithAcceped:acceped type:type];
    }];
    
    [helper setLowMcoinBlock:^{//么币快不足的时候
            weakSelf.isShowLowMcoin = YES;
            [weakSelf hideLowMcoinAlert:NO];
            [weakSelf showAllViews];
      }];
    [helper setEnoughMcoinBlock:^{//么币足够的情况
        self.isShowLowMcoin = NO;
        [weakSelf hideLowMcoinAlert:YES];
    }];
    [helper setNoMcoinBlock:^{//没有么币了
        [ZZUserDefaultsHelper setObject:@"没么币了系统挂断" forDestKey:[ZZDateHelper getCurrentDate]];

        [weakSelf hideView];
    }];

    self.isShowFingerAnimation = NO;
    self.topView.hidden = YES;
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.narrowBtn];
    [self.view addSubview:self.shapeImageView];//手指头
    
    if (!_acceped) {
        //当用户为拨打方
        if (self.isDisableVideo) {//关闭镜头
            [self closeCameraClick];
            [helper.agoraKit muteLocalVideoStream:YES];
            [helper.agoraKit enableLocalVideo:NO]; // 初始化页面的时候，如果有关闭镜头必须调用这个，才能防止前1~2秒还可以看到自己！
        } else {//开启镜头
             [helper.agoraKit enableLocalVideo:YES];
        }
    }else{
        //用户为接受方
          [helper.agoraKit enableLocalVideo:YES];
    }
}

- (void)addRemoteView {
    
    UIView *remoteView = [ZZLiveStreamHelper sharedInstance].remoteView;
    remoteView.backgroundColor = [UIColor blackColor];
    self.remoteView = remoteView;
    self.remoteView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.remoteView.clipsToBounds = YES;
    [self.view addSubview:self.remoteView];
    self.timeView.hidden = NO;
    [self.view sendSubviewToBack:self.remoteView];
    
    if (![ZZLiveStreamHelper sharedInstance].connecting) {
        [self.view addSubview:self.tipsLabel];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
        }];
    }
    
    _remoteView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_remoteView addGestureRecognizer:recognizer];
    _remoteView.tag = 6666;
    UIPanGestureRecognizer *moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSmallVideoPan:)];
    [_remoteView addGestureRecognizer:moveRecognizer];
}

- (void)showTipsWithAcceped:(BOOL)acceped type:(ZZLiveStreamShowFaceType)type {
    
    WEAK_SELF();
    if (type == ZZLiveStreamShowFaceTypeHas) {
        

    } else if (type == ZZLiveStreamShowFaceTypeFiveSeconds) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (acceped) {
                [ZZHUD showInfoWithStatus:@"请面对镜头 🙂"];
            } else {
            }
        });
    } else if (type == ZZLiveStreamShowFaceTypeFifteenSeconds) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tips = acceped ? @"长期未面对镜头,可能会无法获得收益 ☹️" : @"对方如未出镜,请点击举报 😤";
            [ZZHUD showInfoWithStatus:tips];
            //用户方，提示举报
            if (!acceped) {
                self.isShowRefund = YES;
                [self showAllViews];
                weakSelf.isShowFingerAnimation = YES;
                [self showShapeImageViewAnimation];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.isShowFingerAnimation = NO;
                });
            }
        });
    }
}

#pragma mark - Timer

/**
 10秒计时为了让UI隐藏
 */
- (void)createTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)timerEvent
{
    //当前界面在前台而且,超过10秒就让他上下按钮隐藏
    if (_viewDidApper) {
        _count++;
        if (_count > 10) {
            if (!self.isShowFingerAnimation) {
                if (self.isShowLowBalance) {
                    return;
                }
                if (self.isShowLowMcoin) {
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideAllViews];
                });
            }
        }
    }
}

- (void)clearTimer
{
    [_timer invalidate];
    _timer = nil;
}

// 开启镜头
- (void)openCameraClick {
    ZZLiveStreamHelper *helper = [ZZLiveStreamHelper sharedInstance];
    [helper.agoraKit enableLocalVideo:YES];
    
    [self.closeCameraMask removeFromSuperview];
    self.closeCameraMask = nil;

}

// 关闭镜头
- (void)closeCameraClick {
    self.closeCameraMask = [UIView new];
    self.closeCameraMask.backgroundColor = [UIColor blackColor];
    [self.previewView addSubview:self.closeCameraMask];
    [self.closeCameraMask setNeedsLayout];
    [self.closeCameraMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
    [self.closeCameraMask layoutIfNeeded];
    
    [self.previewView bringSubviewToFront:self.closeCameraMask];
    
    UIImageView *headerImageView = [UIImageView new];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:[ZZUserHelper shareInstance].loginer.avatar] placeholderImage:nil options:(SDWebImageRetryFailed)];
    [self.closeCameraMask addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.closeCameraMask);
        make.width.height.equalTo(self.closeCameraMask.mas_height);
    }];
    
    UIView *bgBlackView = [UIView new];
    bgBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.closeCameraMask addSubview:bgBlackView];
    [bgBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
    
    UILabel *tips = [UILabel new];
    tips.textColor = [UIColor whiteColor];
    tips.text = @"您已关闭镜头";
    tips.font = [UIFont systemFontOfSize:15];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.numberOfLines = 0;
    [bgBlackView addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgBlackView.mas_centerY);
        make.leading.equalTo(@5);
        make.trailing.equalTo(@(-5));
    }];

    [SVProgressHUD setMinimumDismissTimeInterval:3.0f];
    [SVProgressHUD setMaximumDismissTimeInterval:6.0f];
    [ZZHUD showInfoWithStatus:@"您已关闭镜头，对方将不会看到您"];
}

#pragma mark -

- (void)updateTime
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timeView.during = [ZZLiveStreamHelper sharedInstance].during;
        [self.view bringSubviewToFront:self.timeView];
        if (_cancelAlert) {
            [self updateCancelAlert];
        }
    });
}

- (void)updateCancelAlert
{
    self.cancelAlert.during = [ZZLiveStreamHelper sharedInstance].during;
    self.cancelAlert.money = [ZZLiveStreamHelper sharedInstance].money;
}

- (void)loadData
{
    WEAK_SELF();
    [ZZRequest method:@"GET" path:@"/api/link_mic_success/info" params:@{@"uid":_uid} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _user = [ZZUser yy_modelWithJSON:[data objectForKey:@"user"]];
            self.topView.hidden = NO;
            self.topView.user = _user;
            self.topView.localLabel.text = [data objectForKey:@"distance"];
            
            CGFloat height = [_topView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
            _topView.height = height ;
            
            UIImageView *bgImgView = [[UIImageView alloc] init];
            bgImgView.image = [UIImage imageNamed:@"icon_rent_topbg1"];
            [self.view addSubview:bgImgView];
            
            [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.mas_equalTo(self.view);
                make.bottom.mas_equalTo(_topView.mas_bottom);
            }];
            
            ZZUser *loginer = [ZZUserHelper shareInstance].loginer;

            if ([ZZLiveStreamHelper sharedInstance].isUseMcoin) {
                
                
            } else {
                
                loginer.balance = [[data objectForKey:@"login_user"] objectForKey:@"balance"];
                [[ZZUserHelper shareInstance] saveLoginer:[loginer toDictionary] postNotif:NO];
                if ([ZZUtils compareWithValue1:loginer.balance value2:[NSNumber numberWithInteger:11]] == NSOrderedAscending) {
                    weakSelf.isShowLowBalance = YES;
                    [self hideBottomAlert:NO];
                    [weakSelf showAllViews];

                } else {
                    [self hideBottomAlert:YES];
                }
            }
            self.topView.follow_status = _user.follow_status;
            if (_user.have_wechat_no && !_user.can_see_wechat_no) {
                [ZZLiveStreamHelper sharedInstance].haveWX = YES;
            } else {
                [ZZLiveStreamHelper sharedInstance].haveWX = NO;
            }
        }
    }];
}



- (void)managerViewControllers
{
    BOOL haveCtl = NO;
    NSInteger index = 0;
    for (UIViewController *ctl in self.navigationController.viewControllers) {
        if ([ctl isKindOfClass:[ZZLiveStreamPublishingViewController class]]) {
            index = [self.navigationController.viewControllers indexOfObject:ctl];
            haveCtl = YES;
            break;
        }
    }
    
    NSInteger count = self.navigationController.viewControllers.count;
    if (haveCtl) {
        _pastCtl = self.navigationController.viewControllers[index - 1];//视频返回时 不停留在选择达人页
    } else {
        _pastCtl = self.navigationController.viewControllers[count-2];//其他默认返回前一页
    }
}

- (void)hideBottomAlert:(BOOL)hide
{
    if (!_acceped) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bottomView.alertLabel.text = @"余额不足 即将挂断 请立即充值";
            self.bottomView.alertBgView.hidden = hide;
        });
    }
}

- (void)hideLowMcoinAlert:(BOOL)hide {
    if (!_acceped) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bottomView.alertLabel.text = @"么币不足 即将挂断 请立即充值";
            self.bottomView.alertBgView.hidden = hide;
        });
    }
}

#pragma mark - UIButtonMethod
// 显示美颜
- (void)showFilters {
    _filterView = [ZZCameraFilterView show];
    _filterView.delegate = self;
}

- (void)stickerBtnClick
{
    _count = 0;
    self.bottomView.hidden = YES;
    [self.chooseView viewUp];
}

- (void)beautyBtnClick
{
    _count = 0;
    self.bottomView.hidden = YES;
}

- (void)rechargeBtnClick
{
    [MobClick event:Event_click_Video_TopUp];
    if ([ZZLiveStreamHelper sharedInstance].isUseMcoin) {
        
        [ZZConnectFloatWindow shareInstance].rechargeing = YES;

        ZZMeBiViewController *vc = [ZZMeBiViewController new];
        [vc setPaySuccess:^(ZZUser *paySuccesUser) {
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        _count = 0;
        WeakSelf;
        [ZZConnectFloatWindow shareInstance].rechargeing = YES;
        ZZRechargeViewController *controller = [[ZZRechargeViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        controller.rechargeCallBack = ^{
            if ([ZZLiveStreamHelper sharedInstance].lowBalance) {
                weakSelf.isShowLowBalance = YES;
                [weakSelf hideBottomAlert:NO];
                [weakSelf showAllViews];
                [NSObject asyncWaitingWithTime:6.0f completeBlock:^{

                }];
            } else {
                [weakSelf hideBottomAlert:YES];
            }
        };
    }
}

- (void)cancelBtnClick
{
    if (_acceped) {//达人方
        [self.view addSubview:self.cancelAlert];
        if ([ZZLiveStreamHelper sharedInstance].by_mcoin) {// 对方是使用么币
            
            self.cancelAlert.type = 9;
        } else {
            
            if ([ZZLiveStreamHelper sharedInstance].during < 120) {
                self.cancelAlert.type = 2;
            } else {
                self.cancelAlert.type = 3;
            }
            [self updateCancelAlert];
        }
    } else if ([ZZLiveStreamHelper sharedInstance].during < 120) {//用户方 2分钟内
        if (self.isShowRefund) {//达人有连续15秒未露脸的弹窗
            if ([ZZLiveStreamHelper sharedInstance].isUseMcoin) {//使用的是么币消费
                
                [self.view addSubview:self.cancelRefundAlert];
                self.cancelRefundAlert.type = 7;
            } else {//使用的是余额
                
                [self.view addSubview:self.cancelRefundAlert];
                self.cancelRefundAlert.type = 5;
            }
        } else {//正常挂断
            if ([ZZLiveStreamHelper sharedInstance].isUseMcoin) {//使用的是么币消费
                [self.view addSubview:self.cancelAlert];
                self.cancelAlert.type = 6;

            } else {//使用的是余额
                [self.view addSubview:self.cancelAlert];
                self.cancelAlert.type = 4;
            }
        }
    } else {//用户方
        if (!self.acceped) {//用户方2分钟之后主动挂断视频，需要评价弹窗
            self.isCommentsNeed = YES;
        }
        [ZZUserDefaultsHelper setObject:@"用户方主动挂断" forDestKey:[ZZDateHelper getCurrentDate]];

        [self hideView];
    }
}

- (void)cameraBtnClick {
    ZZLiveStreamHelper *helper = [ZZLiveStreamHelper sharedInstance];
    [helper.agoraKit switchCamera];
}

// 开启镜头
- (void)enableVideoClick {
    
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kEnableVideoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    ZZLiveStreamHelper *helper = [ZZLiveStreamHelper sharedInstance];
    [helper.agoraKit muteLocalVideoStream:NO];
}

// 关闭镜头
- (void)disableVideoClick {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kEnableVideoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    ZZLiveStreamHelper *helper = [ZZLiveStreamHelper sharedInstance];
    [helper.agoraKit muteLocalVideoStream:YES];//关闭镜头
}

// 断开视频View 及 关闭计时器
- (void)hideView {
    _remoteView = nil;
    _previewView = nil;
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:ONLINE_KEY];
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:VIDEO_CONNECT_CHECK];
    WEAK_SELF();
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZZUserDefaultsHelper setObject:@"断开视屏挂断" forDestKey:[ZZDateHelper getCurrentDate]];

        [[ZZLiveStreamHelper sharedInstance] disconnect];
        [weakSelf clearTimer];
        
        if (!weakSelf.acceped) {//用户方
            if (weakSelf.isCommentsNeed) {//是否需要弹出评价窗口
                
                if ([ZZLocalPushManager runningInForeground]) {//在前台的话才弹评价窗, 后台不弹窗，防止从后台进来做是否挂断的校验出错
                    [weakSelf endAddUserHeaderImageView];

                    weakSelf.isShowCommentsView = YES;
                    [ZZLiveStreamHelper sharedInstance].isBusy = YES;//正在评价的话，当前还是忙的状态
                    [weakSelf.presentSlider present];
                }
            } else {//直接下一步
                [weakSelf gotoNextPageAnimated:YES];
            }
        } else {//达人方 直接下一步
            [weakSelf gotoNextPageAnimated:YES];
        }
    });
}

// 挂断视频后下一页去哪（逻辑分离）
- (void)gotoNextPageAnimated:(BOOL)animated {
    WEAK_SELF();
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZZLiveStreamHelper sharedInstance].isBusy = NO;
          [self managerViewControllers];
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([NSStringFromClass([_pastCtl class]) isEqualToString:NSStringFromClass([viewController class])]) {
                NSLog(@"PY_当前控制器");
                [weakSelf.navigationController popToViewController:_pastCtl animated:animated];
            }
        }
    });
}

// 挂断时 添加对方的头像到当前视频页面
- (void)endAddUserHeaderImageView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view removeAllSubviews];
    
    UIImageView *headerImageView = [UIImageView new];//对方头像
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:_user.avatar] placeholderImage:nil options:(SDWebImageRetryFailed)];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.width.height.equalTo(self.view.mas_height);
    }];
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    _count = 0;
    if (self.bottomView.hidden) {
        [self showAllViews];

    } else {
        [self hideAllViews];
    }
    if (!_acceped) {
        [self.bottomView hideAllView];//收回UI
    }
    if (self.chooseView.isViewUp) {
        self.bottomView.hidden = NO;
        [self.chooseView viewDown];
    }
    
    NSTimeInterval during = 0.3;
    if (!_animating) {
        if (recognizer.view == _remoteView && _remoteView == _currentShortView) {
            _animating = YES;
            [UIView animateWithDuration:during animations:^{
                _remoteView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                _animating = NO;
                [self.view sendSubviewToBack:_remoteView];
                _previewView.frame = _sourceRect;
                _currentShortView = _previewView;
                [self.timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.currentShortView.mas_centerX);
                    make.bottom.equalTo(self.currentShortView.mas_bottom).with.offset(-8);
                    make.height.equalTo(@20);
                }];
      
            }];
        } else if (recognizer.view == _previewView && _previewView == _currentShortView) {
            _animating = YES;
            [UIView animateWithDuration:during animations:^{
                _previewView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                _animating = NO;
                [self.view sendSubviewToBack:_previewView];
                _currentShortView = _remoteView;
                [self.timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.currentShortView.mas_centerX);
                    make.bottom.equalTo(self.currentShortView.mas_bottom).with.offset(-8);
                    make.height.equalTo(@20);
                }];
                _remoteView.frame = _sourceRect;
            }];
        }
    }
}

- (void)attentBtnClick
{
    _count = 0;
    _topView.attentBtn.userInteractionEnabled = NO;
    if (_user.follow_status == 0) {
        [_user followWithUid:_user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            _topView.attentBtn.userInteractionEnabled = YES;
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"关注成功"];
                _user.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                _user.follower_count++;
                self.topView.follow_status = _user.follow_status;
            }
        }];
    } else {
        [_user unfollowWithUid:_user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            _topView.attentBtn.userInteractionEnabled = YES;
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"已取消关注"];
                _user.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                if (_user.following_count) {
                    _user.following_count--;
                }
                self.topView.follow_status = _user.follow_status;
            }
        }];
    }
}

- (void)reportBtnClick {
    _count = 0;
    NSMutableArray *reasons = [NSMutableArray arrayWithArray:@[@"对方未出镜",@"恶意骚扰、不文明语言",@"淫秽色情",@"本人与资料内容不符"]];
    if (_acceped || [ZZLiveStreamHelper sharedInstance].during < 30) {
        [reasons removeObjectAtIndex:0];
    }
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:reasons tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        WeakSelf;
        if (buttonIndex < reasons.count) {
            if (buttonIndex != reasons.count) {
                NSString *reason = reasons[buttonIndex];
                ZZLiveStreamReportAlert *alert = [[ZZLiveStreamReportAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [self.view addSubview:alert];
                alert.touchReport = ^{
                    if (!weakSelf.acceped) {//用户方如果是举报方式挂断，则不需要评价弹窗，服务端自动给 2星 差评
                        weakSelf.isCommentsNeed = NO;
                    }
                    [weakSelf reportRequest:reason];
                };
            }
        }
    }];
}

- (void)reportRequest:(NSString *)reason
{
    WEAK_SELF();
    [ZZHUD showWithStatus:@"正在上传记录"];
    [ZZReportModel reportWithParam:@{@"room":[ZZLiveStreamHelper sharedInstance].room_id,
                                     @"content":reason,
                                     @"report_status" : (self.isShowRefund && [reason isEqualToString:@"对方未出镜"])? @"2" : @"1"
                                     }
                               uid:_uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"谢谢您的举报，我们将在2个工作日解决!"];
            [NSObject asyncWaitingWithTime:1.0f completeBlock:^{
                [ZZLiveStreamHelper sharedInstance].isRefundClick = [reason isEqualToString:@"对方未出镜"] ? YES : NO;
                [ZZUserDefaultsHelper setObject:@"举报挂断" forDestKey:[ZZDateHelper getCurrentDate]];
                [weakSelf hideView];
            }];
        }
    }];
}

- (void)narrowBtnClick
{
    if ([ZZLiveStreamHelper sharedInstance].lowBalance) {
        return;
    }
    [self clearTimer];
    
    [self managerViewControllers];
    NSLog(@"PY_点击切换视屏控制器窗口%@  控制器的数组%@", NSStringFromClass([_pastCtl class]),self.navigationController.viewControllers);

    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([NSStringFromClass([_pastCtl class]) isEqualToString:NSStringFromClass([viewController class])]) {
            [self.navigationController popToViewController:_pastCtl animated:YES];
            [self addFloatWindow];
        }
    }
}

- (void)addFloatWindow
{
    _remoteView.userInteractionEnabled = NO;
    
    ZZConnectFloatWindow *floatWindow = [ZZConnectFloatWindow shareInstance];
    floatWindow.callIphoneViewController = self;
    floatWindow.acceped = _acceped;
    floatWindow.uid = _uid;
    floatWindow.frame = CGRectMake(_sourceRect.origin.x, 64, _sourceRect.size.width, _sourceRect.size.height);
    [floatWindow addSubview:_remoteView];
    _remoteView.frame = CGRectMake(0, 0, _sourceRect.size.width, _sourceRect.size.height);
    [[ZZConnectFloatWindow shareInstance] show];
    self.smallVideoChangeBigVideo = NO ;
    _leave = YES;
}

- (void)showShapeImageViewAnimation {
    WEAK_SELF();
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.shapeImageView.mj_y = 96 + SafeAreaBottomHeight;
        weakSelf.shapeImageView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [weakSelf shakeAnimation];
        [NSObject asyncWaitingWithTime:5.0f completeBlock:^{
            weakSelf.shapeImageView.alpha = 0.0f;
        }];
    }];
}

- (void)shakeAnimation {
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    moveAnimation.duration = 0.8f;
    moveAnimation.fromValue = [NSNumber numberWithFloat:-5];
    moveAnimation.toValue = [NSNumber numberWithFloat:5];
    moveAnimation.repeatCount = HUGE_VALF;
    moveAnimation.autoreverses = YES;
    [self.shapeImageView.layer addAnimation:moveAnimation forKey:nil];
}

- (void)hideAllViews {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topView.hidden = YES;
        self.narrowBtn.hidden = YES;
        self.bottomView.hidden = YES;
        [self.bottomView hideAllView];
        self.bottomView.alertBgView.hidden = YES;
        self.shapeImageView.alpha = 0.0f;
    });
}

- (void)showAllViews
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.topView.user) {
            self.topView.hidden = NO;
        }
        if (self.isShowLowBalance || self.isShowLowMcoin) {
            self.bottomView.alertBgView.hidden = NO;
        }
        self.narrowBtn.hidden = NO;
        self.bottomView.hidden = NO;
    });
}

- (void)videoBrokeRules:(NSNotification *)notification {

    if (self.isShowAlert) {
        return;
    }
    self.isShowAlert = YES;
    WEAK_SELF();
    if (!self.acceped) {//被鉴黄自动挂断的，用户方也需要评价弹窗。
        self.isCommentsNeed = YES;
    }
    [weakSelf hideView];
    [ZZUserDefaultsHelper setObject:@"鉴黄自动挂断的" forDestKey:[ZZDateHelper getCurrentDate]];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"由于视频通话有违规内容，系统自动挂断，如有疑问请咨询在线客服" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
          [self managerViewControllers];
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([NSStringFromClass([_pastCtl class]) isEqualToString:NSStringFromClass([viewController class])]) {
                [weakSelf.navigationController popToViewController:_pastCtl animated:YES];
            }
        }
    }];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - ZZCameraFilterViewDelegate
- (void)view:(ZZCameraFilterView *)view filterOptions:(AgoraBeautyOptions *)options {
    [[ZZLiveStreamHelper sharedInstance].agoraKit setBeautyEffectOptions:YES options:options];
}

#pragma mark - ZZRecordChooseDelegate
- (void)chooseView:(ZZRecordChooseView *)chooseView isViewUp:(BOOL)isViewUp {
    
}

- (void)pushUserDetailWithUser:(ZZUser *)user {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.isFromHome = NO;
    controller.user = user;
    controller.uid = user.uid;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - lazyload
- (UIImageView *)shapeImageView {
    if (!_shapeImageView) {
        _shapeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shape"]];
        _shapeImageView.frame = CGRectMake(117, 110 + SafeAreaBottomHeight, 29, 38);
        _shapeImageView.contentMode = UIViewContentModeCenter;
        _shapeImageView.alpha = 0.0f;
    }
    return _shapeImageView;
}

- (UIView *)previewView
{
    if (!_previewView) {
        NSInteger width = 100*(SCREEN_WIDTH / 375);
        NSInteger height = width * (SCREEN_HEIGHT / SCREEN_WIDTH);
        _previewView = [ZZLiveStreamHelper sharedInstance].preview;
        _previewView.frame = CGRectMake(SCREEN_WIDTH - width - 15, 15+SafeAreaBottomHeight, width, height);
        _previewView.clipsToBounds = YES;
        
        self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSmallVideoPan:)];
        _previewView.tag = 8888;
        [_previewView addGestureRecognizer:recognizer];
        
        [_previewView addGestureRecognizer:self.recognizer];
        
        _sourceRect = _previewView.frame;
    }
    return _previewView;
}

- (ZZLiveStreamConnectTimeView *)timeView
{
    if (!_timeView) {
        _timeView = [[ZZLiveStreamConnectTimeView alloc] initWithFrame:CGRectZero];
        _timeView.layer.cornerRadius = 10;
        _timeView.userInteractionEnabled = NO;
        [self.view addSubview:_timeView];
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.currentShortView.mas_centerX);
            make.bottom.equalTo(self.currentShortView.mas_bottom).with.offset(-8);
            make.height.equalTo(@20);
        }];
       }
    return _timeView;
}

- (ZZLiveStreamConnectTopView *)topView
{
    WeakSelf;
    if (!_topView) {
        _topView = [[ZZLiveStreamConnectTopView alloc] initWithFrame:CGRectMake(0, SafeAreaBottomHeight, SCREEN_WIDTH - _sourceRect.size.width - 15, 10)];
        _topView.touchAttent = ^{
            [weakSelf attentBtnClick];
        };
        _topView.touchReport = ^{
            [weakSelf reportBtnClick];
        };
        [_topView setUserDetailBlock:^(ZZUser *user){
            [weakSelf pushUserDetailWithUser:user];
        }];
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (ZZLiveStreamConnectBottomView *)bottomView
{
    WeakSelf;
    if (!_bottomView) {

        _bottomView = [[ZZLiveStreamConnectBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200 -SafeAreaBottomHeight, SCREEN_WIDTH, 200+SafeAreaBottomHeight)];
        if (!_acceped) {
            _bottomView.isEnableVideo = _isDisableVideo ? NO : YES;
        }
        _bottomView.acceped = _acceped;
        _bottomView.touchRecharge = ^{
            [weakSelf rechargeBtnClick];
        };
        _bottomView.touchCancel = ^{
            [weakSelf cancelBtnClick];
        };
        _bottomView.touchCameraBlock = ^{
            [weakSelf cameraBtnClick];
        };
        [_bottomView setTouchEnableVideo:^{//开启镜头
            [weakSelf openCameraClick];
            [weakSelf enableVideoClick];
        }];
        [_bottomView setTouchDisableVideo:^{//关闭镜头
            [weakSelf closeCameraClick];
            [weakSelf disableVideoClick];
        }];
        
        [_bottomView setShowFilter:^{
            [weakSelf showFilters];
        }];
    }
    return _bottomView;
}

- (ZZRecordChooseView *)chooseView
{
    if (!_chooseView) {
        _chooseView = [[ZZRecordChooseView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 206+SafeAreaBottomHeight)];
        _chooseView.delegate = self;
    }
    return _chooseView;
}

- (ZZLiveStreamVideoAlert *)cancelAlert {
    WeakSelf;
    if (!_cancelAlert) {
        _cancelAlert = [[ZZLiveStreamVideoAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _cancelAlert.touchRight = ^{
            if (!weakSelf.acceped) {//用户方2分钟内主动挂断视频，需要评价弹窗
                weakSelf.isCommentsNeed = YES;
            }
            [ZZUserDefaultsHelper setObject:@"主动挂断1" forDestKey:[ZZDateHelper getCurrentDate]];

            [weakSelf hideView];
        };
    }
    return _cancelAlert;
}

- (ZZLiveStreamVideoAlert *)cancelRefundAlert {
    WEAK_SELF();
    if (!_cancelRefundAlert) {
        _cancelRefundAlert = [[ZZLiveStreamVideoAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _cancelRefundAlert.touchLeft = ^{
            //申请退款
            [weakSelf reportBtnClick];
        };
        _cancelRefundAlert.touchRight = ^{
            if (!weakSelf.acceped) {//用户方2分钟内主动挂断视频，需要评价弹窗
                weakSelf.isCommentsNeed = YES;
            }
            [ZZUserDefaultsHelper setObject:@"主动挂断" forDestKey:[ZZDateHelper getCurrentDate]];

            //结束视频
            [weakSelf hideView];
        };
    }
    return _cancelRefundAlert;
}

//TODO:视频最小化按钮
- (UIButton *)narrowBtn
{
    if (!_narrowBtn) {
        _narrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - _sourceRect.size.width - 15 - 5 - 40, _sourceRect.origin.y+SafeAreaBottomHeight, 40, 40)];
        [_narrowBtn addTarget:self action:@selector(narrowBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *narrowImgView = [[UIImageView alloc] init];
        narrowImgView.image = [UIImage imageNamed:@"icon_livestream_narrow"];
        narrowImgView.userInteractionEnabled = NO;
        [_narrowBtn addSubview:narrowImgView];
        
        [narrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_narrowBtn.mas_top).with.offset(SafeAreaBottomHeight);
            make.right.mas_equalTo(_narrowBtn.mas_right).offset(-10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _narrowBtn;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [UILabel new];
        _tipsLabel.text = @"画面马上就来";
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.font = [UIFont systemFontOfSize:15];
    }
    return _tipsLabel;
}

- (WBActionContainerView *)presentSlider {
    if (!_presentSlider) {
        WEAK_SELF();
        ZZVideoAppraiseVC *vc = [[ZZVideoAppraiseVC alloc] init];
        vc.roomId = [ZZLiveStreamHelper sharedInstance].room_id;
        [vc setCancelBlock:^{
            [weakSelf.presentSlider dismiss];
            weakSelf.isShowCommentsView = NO;
            [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
                [weakSelf gotoNextPageAnimated:NO];
            }];
        }];
        [vc setCommentsSuccessBlock:^{
            [weakSelf.presentSlider dismiss];
            weakSelf.isShowCommentsView = NO;
            [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
                [weakSelf gotoNextPageAnimated:NO];
            }];
        }];
        _presentSlider = [[WBActionContainerView alloc] initWithViewController:vc forHeight:ISiPhone5 ? (SCREEN_HEIGHT / 2.0) + 100 : (SCREEN_HEIGHT / 2.0) + 50];
    }
    return _presentSlider;
}

- (void)dealloc
{
    _remoteView.userInteractionEnabled = NO;
}
- (void)setSmallVideoChangeBigVideo:(BOOL)smallVideoChangeBigVideo {
    if (_smallVideoChangeBigVideo !=smallVideoChangeBigVideo) {
        _smallVideoChangeBigVideo =smallVideoChangeBigVideo;
        [self createTimer];
        
    }
}

#pragma mark - 移动小视频窗口


- (void)moveSmallVideoPan:(UIPanGestureRecognizer *)recognizer {
    if (!_currentShortView) {
        return;
    }
    if (recognizer.view.tag != _currentShortView.tag) {
        return;
    }
    CGPoint point = [recognizer locationInView:recognizer.view.superview];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"PY_当前移动的_最开始的%@",NSStringFromCGPoint(point));
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (!isnan(point.x) && !isnan(point.y)) {
                _currentShortView.center = CGPointMake(point.x, point.y);
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (_currentShortView.top < 15 + SafeAreaBottomHeight) {
               _currentShortView.top = 15 + SafeAreaBottomHeight;
            }
            else if (_currentShortView.top > SCREEN_HEIGHT - _currentShortView.height - TABBAR_HEIGHT) {
                _currentShortView.top = SCREEN_HEIGHT - _currentShortView.height;
            }
            if (_currentShortView.left < 0) {
               _currentShortView.left = 0;
            }
            else if (_currentShortView.left > SCREEN_WIDTH - _currentShortView.width) {
                _currentShortView.left = SCREEN_WIDTH - _currentShortView.width;
            }
            break;
        }
        default:
            break;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
