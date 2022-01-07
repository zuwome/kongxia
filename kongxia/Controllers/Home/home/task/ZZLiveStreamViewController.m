//
//  ZZLiveStreamViewController.m
//  zuwome
//
//  Created by angBiu on 2017/7/3.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamViewController.h"
#import "ZZRechargeViewController.h"
#import "ZZRentViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZTaskChooseViewController.h"
#import "ZZRentAbroadLocationViewController.h"
#import "ZZPayViewController.h"
#import "ZZOrderLocationViewController.h"
#import "ZZVideoRuleVC.h"

#import "ZZLiveStreamTopView.h"
#import "ZZPublishOrderView.h"
#import "ZZSnatchOrderView.h"
#import "ZZRequestLiveStreamAlert.h"
#import "ZZRequestLiveStreamFailureAlert.h"
#import "ZZLiveStreamEndAlert.h"
#import "ZZPublishingShineView.h"
#import "ZZTaskPublishConfirmAlert.h"
#import "ZZUserEditViewController.h"
#import "ZZSnatchTaskSettingViewController.h"

#import "ZZSnatchModel.h"
#import "ZZFastRentManager.h"
#import "ZZFastRentManager.h"

#import "ZZSelfIntroduceVC.h"
#import "ZZPerfectPictureViewController.h"
#import "ZZCongratulationsAlertView.h"
#import "ZZCloseNotificationAlertView.h"
#import "ZZLiveStreamHelper.h"
#import "ZZSearchLocationController.h"

@interface ZZLiveStreamViewController () <UIScrollViewDelegate, WBFastRentManagerObserver>

@property (nonatomic, strong) ZZLiveStreamTopView *topView;
@property (nonatomic, strong) ZZScrollView *scrollView;
@property (nonatomic, strong) ZZPublishOrderView *publishView;
@property (nonatomic, strong) ZZSnatchOrderView *snatchView;
@property (nonatomic, strong) ZZRequestLiveStreamAlert *requestAlertView;//发单的弹窗
@property (nonatomic, strong) ZZTaskPublishConfirmAlert *taskConfirmAlert;//
@property (nonatomic, strong) ZZRequestLiveStreamFailureAlert *failureAlert;
@property (nonatomic, strong) ZZLiveStreamEndAlert *endAlert;//无法发布任务
@property (nonatomic, strong) ZZPublishingShineView *shineView;

@property (nonatomic, assign) BOOL isUnderway;  // 当前是否处于发布任务中的状态
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSDate *publishDate;//开发发任务的时间，记录主要用于退到后台，NSTimer不计时问题，便于实时刷新剩余时间

@end

@implementation ZZLiveStreamViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestAlertView) {
        [_requestAlertView removeFromSuperview];
    }
    if (_taskConfirmAlert) {
        [_taskConfirmAlert removeFromSuperview];
    }
    if (_failureAlert) {
        [_failureAlert removeFromSuperview];
    }
    if (_endAlert) {
        [_endAlert removeFromSuperview];
    }
    if (_shineView.cancelAlert) {
        [_shineView.cancelAlert removeFromSuperview];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"抢任务中心";
    [self createNavigationRightDoneBtn];

    [GetFastRentManager() addObserver:self];
    [self createViews];
    [self addNotification];
    [self getUnread];
}

- (void)createNavigationRightDoneBtn {
    [super createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn setTitle:@"通知设置" forState:(UIControlStateNormal)];
    [self.navigationRightDoneBtn setTitle:@"通知设置" forState:(UIControlStateHighlighted)];
    [self.navigationRightDoneBtn addTarget:self action:@selector(rightDoneBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)rightDoneBtnClick {
    ZZSnatchTaskSettingViewController *controller = [[ZZSnatchTaskSettingViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)createViews
{
    self.topView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT - 64 - _topView.height);
    self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [self.view sendSubviewToBack:self.scrollView];
    
    self.publishView.hidden = NO;
    self.snatchView.hidden = NO;
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAcceptOrder:) name:kMsg_SnatchPublishOrder object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSnatchCount) name:kMsg_UpdateTaskSnatchCount object:nil];
}

- (void)receiveNewPublishOrder
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_topView snatchBtnClick];
    });
}

- (void)getUnread
{
    [ZZUser getUserUnread:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            ZZUserUnread *userUnread = [[ZZUserUnread alloc] initWithDictionary:data error:nil];
            [ZZUserHelper shareInstance].unreadModel = userUnread;
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdateTaskSnatchCount object:nil];
            if ([[userUnread.pd objectForKey:@"have_ongoing_pd"] boolValue]) {
                ZZSnatchDetailModel *model = [[ZZSnatchDetailModel alloc] initWithDictionary:[userUnread.pd objectForKey:@"pd"] error:nil];
                if (model.count == 0) {
                    [self addShineViews:model];
                    _count = model.remain_time / 1000;
                    [self createTimer];
                }
            }
        }
    }];
}

// 默认选择1v1视频
- (void)defaultSelectVideo {
    ZZSkill *skill = [[ZZSkill alloc] init];
    skill.id = @"59644d1d2f17ad7a5f145544";
    skill.name = @"在线1对1视频";
    skill.type = 2;
    self.publishView.skill = skill;
}

#pragma mark - notification

- (void)receiveAcceptOrder:(NSNotification *)notification
{
    [self clearTimer];
    [self removeShineViews];
}
//更新抢任务数目
- (void)updateSnatchCount
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _topView.count = [ZZUserHelper shareInstance].unreadModel.pd_receive;
    });
}

#pragma mark - timer

- (void)createTimer
{
    //增加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRemainingTime)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    if (_timer) {
        [self clearTimer];
    }
    self.publishDate = [NSDate new];
    _shineView.during = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)updateRemainingTime {
    if (_count <= 0) {
        return;
    }
    NSTimeInterval delta = [[NSDate new] timeIntervalSinceDate:self.publishDate]; // 计算出相差多少秒
    
    NSTimeInterval sum = self.publishView.skill.type == 1 ? 600 : 180;
    _count = (sum - delta);//剩余时间
}

- (void)timerEvent {
    
    if (!self.isUnderway) {
        [self clearTimer];
        return;
    }
    _count--;
    [GetFastRentManager() syncUpdateRemainingTimeWithTime:INT_TO_STRING(_count)];
    self.shineView.during = _count;
    if (_count <= 0) {
        [ZZHUD showTaskInfoWithStatus:@"暂无合适达人抢您的任务"];
        [self removeShineViews];
        [self clearTimer];
    }
}

- (void)clearTimer
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];

    [_timer invalidate];
    _timer = nil;
    
    self.publishDate = nil;
}

#pragma mark - UIButtonMethod

- (void)publishBtnClick
{
    if ([ZZUtils isConnecting]) {
        return;
    }

    [GetFastRentManager() syncUpdateMissionStatus:YES];
    if ([ZZUtils isBan]) {
        return;
    }
    if ([ZZUtils isConnecting]) {
        return;
    }
    if (_publishView.skill.type == 1) {
        
        if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstTaskPublishAlert]) {
            [self.view.window addSubview:self.taskConfirmAlert];
        } else {
            [self request];
        }
    } else {
        if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstPublishOrderAlert]) {
            [self.view.window addSubview:self.requestAlertView];
        } else {
            [self request];
        }
    }
}

- (void)sureBtnClick
{
    [self request];
}

- (void)request
{
    // 发任务埋点
    [MobClick event:Event_click_publish];
    self.publishView.publishView.userInteractionEnabled = NO;
    NSLog(@"PYL_获取缓存的城市");
    if (!isNullString(self.publishView.locationModel.city)) {
        
        [self.publishView.param setObject:self.publishView.locationModel.city forKey:@"address_city_name"];
    }
    [ZZRequest method:@"POST" path:@"/api/pd/add" params:self.publishView.param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        self.publishView.publishView.userInteractionEnabled = YES;
        if (error) {
            if (error.code == 7001) {
                self.failureAlert.contentLabel.text = error.message;
                [self.view.window addSubview:self.failureAlert];
            } else if (error.code == 7002) {
                self.endAlert.contentLabel.text = error.message;
                self.endAlert.type = 1;
                [self.view.window addSubview:self.endAlert];
            } else {
                [ZZHUD showErrorWithStatus:error.message];
            }
        } else {
            [ZZKeyValueStore saveValue:[data objectForKey:@"cancel_count_max"] key:[ZZStoreKey sharedInstance].cancel_count_max];
            [ZZKeyValueStore saveValue:[data objectForKey:@"cancel_count"] key:[ZZStoreKey sharedInstance].cancel_count];
            [ZZKeyValueStore saveValue:self.publishView.param key:[ZZStoreKey sharedInstance].publishSelections];
            
            ZZSnatchDetailModel *model = [[ZZSnatchDetailModel alloc] initWithDictionary:[data objectForKey:@"pd"] error:nil];
            if (self.publishView.skill.type == 1) {
                [self gotoPayView:model];
            } else if (self.publishView.skill.type == 2) {
                [self addShineViews:model];
                [self createTimer];
            }
            _count = [[[data objectForKey:@"pd"] objectForKey:@"valid_duration"] integerValue]*60;
        }
    }];
}

- (void)addShineViews:(ZZSnatchDetailModel *)model
{
    [self removeShineViews];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.view addSubview:self.shineView];
//        self.shineView.type = model.type;
//        [self.shineView animate];
//        self.shineView.pId = model.id;
//    });
}

- (void)removeShineViews
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_shineView) {
            if (_shineView.cancelAlert) {
                [_shineView.cancelAlert removeFromSuperview];
            }
            [_shineView remove];
            _shineView = nil;
        }
    });
}

#pragma mark - navigation

- (void)gotoRechargeBtnClick
{
    ZZRechargeViewController *controller = [[ZZRechargeViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoUserPage:(NSString *)uid
{
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = uid;
    controller.isFromHome = YES;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoRuleWebView
{
    // 待开发
    ZZVideoRuleVC *vc = [ZZVideoRuleVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoTaskChooseView {
    
    NSString *skillId = _publishView.skill.id;
    ZZTaskChooseViewController *controller = [[ZZTaskChooseViewController alloc] init];
    controller.skillId = skillId;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    controller.selectedTask = ^(ZZSkill *skill) {
        _publishView.skill = skill;
    };
}

- (void)gotoLocationView {
    
    if ([ZZUserHelper shareInstance].isAbroad) {
        ZZRentAbroadLocationViewController *controller = [[ZZRentAbroadLocationViewController alloc] init];
        controller.selectPoiDone = ^(ZZRentDropdownModel *model) {
            [self getAddress:model];
        };
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        ZZSearchLocationController *vc = [[ZZSearchLocationController alloc] init];
        vc.title = @"选择邀约地点";
        vc.selectPoiDone = ^(ZZRentDropdownModel *model) {
            [self getAddress:model];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getAddress:(ZZRentDropdownModel *)model
{
    self.publishView.locationModel = model;
}

- (void)gotoPayView:(ZZSnatchDetailModel *)model
{
    ZZPayViewController *controller = [[ZZPayViewController alloc] init];
    controller.pId = model.id;
    controller.type = PayTypeTask;
    controller.price = [[self.publishView.param objectForKey:@"price"] doubleValue];
    controller.hidesBottomBarWhenPushed = YES;
    controller.didPay = ^{
        [self addShineViews:model];
        [self createTimer];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

//查看地图
- (void)gotoLocation:(CLLocation *)location address:(NSString *)address {
    ZZOrderLocationViewController *controller = [[ZZOrderLocationViewController alloc] init];
    controller.location = location;
    controller.name = address;
    controller.navigationItem.title = @"邀约地点";
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 没有头像，则上传真实头像
- (void)gotoUploadPicture:(NavigationType)type {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.type = type;
    vc.isShowTopUploadStatus = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WBFastRentManagerObserver

//  闪租发布任务发生变化: 1: 发布中  0: 取消发布
- (void)missionDidChangeWithUnderway:(NSString *)isUnderway {
    self.isUnderway = [isUnderway isEqualToString:@"1"];
}

#pragma mark - lazyload

- (ZZLiveStreamTopView *)topView {
    WeakSelf;
    if (!_topView) {
        _topView = [[ZZLiveStreamTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [self.view addSubview:_topView];
        
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-44);
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(@44);
        }];
        
        _topView.selectedIndex = ^(NSInteger index) {
            [weakSelf.scrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
        };
    }
    return _topView;
}

- (ZZScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[ZZScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
        [self.view addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(_topView.mas_bottom);
        }];
    }
    return _scrollView;
}

- (ZZPublishOrderView *)publishView
{
    WeakSelf;
    if (!_publishView) {
        _publishView = [[ZZPublishOrderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
//        [self.scrollView addSubview:_publishView];
        _publishView.touchPublish = ^{
            [weakSelf publishBtnClick];
        };
        _publishView.touchRule = ^{
            [weakSelf gotoRuleWebView];
        };
        _publishView.touchTaskChoose = ^{
            [weakSelf gotoTaskChooseView];
        };
        _publishView.touchLocation = ^{
            [weakSelf gotoLocationView];
        };
        [_publishView removeAllSubviews];
        [_publishView removeFromSuperview];
        _publishView = nil;
    }
    return _publishView;
}

- (ZZSnatchOrderView *)snatchView
{
    WeakSelf;
    if (!_snatchView) {
        _snatchView = [[ZZSnatchOrderView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
        [self.scrollView addSubview:_snatchView];
        _snatchView.gotoUserPage = ^(NSString *uid) {
            [weakSelf gotoUserPage:uid];
        };
        _snatchView.gotoLocationDetail = ^(CLLocation *location, NSString *address) {
            [weakSelf gotoLocation:location address:address];
        };
        [_snatchView setNoFaceBlock:^{
            // 没人脸
            BLOCK_SAFE_CALLS(weakSelf.noFaceBlock);
        }];
        [_snatchView setNoRealPictureBlock:^{
            // 没真实头像
            BLOCK_SAFE_CALLS(weakSelf.noRealPictureBlock);
        }];
        [_snatchView setGenderAbnormalBlock:^{
            // 性别异常，需要验证
            BLOCK_SAFE_CALLS(weakSelf.genderAbnormalBlock);
        }];
        [_snatchView setRentStatusNone:^{
            // 没有上架出租信息
            BLOCK_SAFE_CALLS(weakSelf.rentStatusNone);
        }];
        [_snatchView setRentStatusInvisible:^{
            // 有上架出租信息，但是出于隐身状态
            BLOCK_SAFE_CALLS(weakSelf.rentStatusInvisible);
        }];
        // 成为闪租达人
        [_snatchView setBecomeTalentNoFaceBlock:^(BOOL isShowWindow) {
        }];
        [_snatchView setIsShowCongratulationsBlock:^{
            // 恭喜您 弹窗
            ZZCongratulationsAlertView *alert = [[ZZCongratulationsAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [alert setDoneBlock:^{
                [weakSelf.snatchView detectNotification];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
        }];
    }
    return _snatchView;
}

- (ZZRequestLiveStreamAlert *)requestAlertView
{
    WeakSelf;
    if (!_requestAlertView) {
        _requestAlertView = [[ZZRequestLiveStreamAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _requestAlertView.isPublish = YES;
        _requestAlertView.touchSure = ^{
            [weakSelf sureBtnClick];
        };
        _requestAlertView.touchCancel = ^{
            [weakSelf clearTimer];
        };
    }
    return _requestAlertView;
}

- (ZZTaskPublishConfirmAlert *)taskConfirmAlert
{
    WeakSelf;
    if (!_taskConfirmAlert) {
        _taskConfirmAlert = [[ZZTaskPublishConfirmAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _taskConfirmAlert.touchSure = ^{
            [weakSelf request];
        };
        _taskConfirmAlert.touchCancel = ^{
            [weakSelf clearTimer];
        };
    }
    return _taskConfirmAlert;
}

- (ZZRequestLiveStreamFailureAlert *)failureAlert
{
    WeakSelf;
    if (!_failureAlert) {
        _failureAlert = [[ZZRequestLiveStreamFailureAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _failureAlert.touchRecharge = ^{
            [weakSelf gotoRechargeBtnClick];
        };
    }
    return _failureAlert;
}

- (ZZLiveStreamEndAlert *)endAlert
{
    if (!_endAlert) {
        _endAlert = [[ZZLiveStreamEndAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _endAlert;
}

- (ZZPublishingShineView *)shineView
{
    if (!_shineView) {
        _shineView = [[ZZPublishingShineView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
        _shineView.during = _count;
    }
    return _shineView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
