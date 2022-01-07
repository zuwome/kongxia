//
//  ZZNewHomeViewController.m
//  naviTest
//
//  Created by MaoMinghui on 2018/8/15.
//  Copyright © 2018年 lql. All rights reserved.
//

#import "ZZNewHomeViewController.h"
#import "ZZTabBarViewController.h"
#import "ZZRentViewController.h"
#import "ZZFastChatVC.h"
#import "ZZCityViewController.h"
#import "ZZFilterViewController.h"
#import "ZZPayViewController.h"
#import "ZZMeBiViewController.h"
#import "ZZTopicClassifyViewController.h"
#import "ZZRecordViewController.h"
#import "ZZRegisterRentViewController.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSelfIntroduceVC.h"
#import "ZZChatVideoPlayerController.h"
#import "ZZUserChuzuViewController.h"
#import "ZZAllTopicsViewController.h"
#import "ZZUserEditViewController.h"
#import "ZZNewHomeNaviBar.h"
#import "ZZNewHomeTableView.h"
#import "ZZSecurityButton.h"
#import "ZZHomeNotificationInfoView.h"
#import "WBActionContainerView.h"
#import "ZZPublishOrderView.h"

#import "ZZRequestLiveStreamAlert.h"
#import "ZZLiveStreamEndAlert.h"
#import "ZZPublishingShineView.h"
#import "ZZRequestLiveStreamFailureAlert.h"
#import "ZZSkillSelectionView.h"

#import "ZZOrderLocationViewController.h"

#import "ZZNewHomeViewModel.h"
#import "ZZSnatchModel.h"
#import "ZZHomeModel.h"
#import "ZZCity.h"

#import "UINavigationController+WXSTransition.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "ZZFastRentManager.h"
#import "ZZSendVideoManager.h"
#import "ZZActivityUrlNetManager.h"
#import "kongxia-Swift.h"
#import "ZZRentalAgreementVC.h"
#import "ZZSettingPrivacyViewController.h"
#import "ZZUserRegistedGuidView.h"
#import "ZZUserShouldNotHideView.h"
#import "ZZCommissionIndexViewController.h"
#import "ZZRankIndexController.h"
#import "ZZKTVPlazaController.h"

@interface ZZNewHomeViewController () <CLLocationManagerDelegate, WBSendVideoManagerObserver, WBFastRentManagerObserver, ZZUserRegistedGuidViewDelegate>
//view
@property (nonatomic, strong) ZZNewHomeNaviBar *naviBar;        //头部导航
@property (nonatomic, strong) ZZNewHomeTableView *tableView;    //首页容器
@property (nonatomic, strong) ZZSecurityButton *securityBtn;    //紧急求助按钮
@property (nonatomic, strong) ZZHomeNotificationInfoView *notifyInfoView;   //推送未开启提示栏
@property (nonatomic, strong) WBActionContainerView *presentSlider; //闪租任务背景半透明容器
@property (nonatomic, strong) ZZPublishOrderView *publishView;  //闪租任务发布界面
@property (nonatomic, strong) ZZTaskPublishConfirmAlert *taskConfirmAlert;  //发布线下任务确认弹窗
@property (nonatomic, strong) ZZRequestLiveStreamAlert *requestAlertView;   //发布线上任务确认弹窗（1v1视频）
@property (nonatomic, strong) ZZLiveStreamEndAlert *liveEndAlert;   //任务发布失败弹窗（失败原因包括：无法发布任务、暂无达人抢任务、不再推荐此人、选择时间已用完、支付时间已过等）
@property (nonatomic, strong) ZZPublishingShineView *shineView; //发布任务后等待接单时的动效视图
@property (nonatomic, strong) ZZRequestLiveStreamFailureAlert *failureAlert;    //么币不足弹窗

// 女性用户注册引导
@property (nonatomic, strong) ZZUserRegistedGuidView *guideView;

// 取消隐身的
@property (nonatomic, strong) ZZUserShouldNotHideView *shouldNotHideView;

//viewModel
@property (nonatomic, strong) ZZNewHomeViewModel *viewModel;
//Props
@property (nonatomic, assign) BOOL isGetSysLoc; //GPS获取地址标识，防止定位代理多次调用，造成多次刷新
@property (nonatomic, assign) BOOL isFirstLoad; //记录第一次创建控制器标识
@property (nonatomic, assign) BOOL isOpenPush;  //是否开启推送
@property (nonatomic, assign) BOOL isNotLogin;  //进入App且还没登录
@property (nonatomic, assign) BOOL isUnderway;  // 当前是否处于发布任务中的状态
@property (nonatomic, assign) NSInteger taskCountDown;  //任务发布倒计时

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) AMapLocationManager *aMapManager;
@property (nonatomic, strong) NSTimer *waitSnatchTimer; //任务倒计时定时器

// 开发发任务的时间，记录主要用于退到后台，NSTimer不计时问题，便于实时刷新剩余时间
@property (nonatomic, strong) NSDate *publishDate;

@end

/**
 *  首页加载步骤：（首页内容、逻辑较多，故添加VM层，分担一部分视图相关逻辑）
 *  1.设置初始参数
 *  2.加载容器视图，内容视图尚不加载
 *  3.检查推送状态，
 *  3.配置viewModel，并获取之前保存的位置、筛选等信息，第一次初始化内容。其后位置、筛选信息等发生改变时会更新内容
 *  4.配置通知监听
 */
@implementation ZZNewHomeViewController

#pragma mark -- life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [ZZUtils managerUnread];    //获取未读消息个数
    
    [self checkPushStatus];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getSecurityStatus];   //是否需要显示紧急求助按钮
    [self.viewModel getTask];
    [self showSayHiView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ZZTabBarViewController sharedInstance] hideBubbleView];
    [[ZZTabBarViewController sharedInstance] hideRentBubble];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // FIXME:新定位，上传旧的定位可能会产生问题
    [ZZUserDefaultsHelper setObject:@"0" forDestKey:@"NewLocation"];
    
    [self setInitialData];
    [self createView];
    [self configViewModel];
    [self configNotification];
    [self loadH5_activeData];
    
    // 隐身恢复上线
    [self showNotHideView];
    
    [self showUserPrivateTerms];
}

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scrollToTop {
    [_viewModel subTableDidScrollToTop];
    [_tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (void)showUserPrivateTerms {
    [[UserPrivateTermsHelper shared] validateWithController:self];
}

- (void)showSayHiView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ZZSayHiHelper sharedInstance] showSayHiWithType:SayHiTypeGeneral canAlwaysShow:NO];
    });
}

/**
 *  隐身恢复上线
 */
- (void)showNotHideView {
    // 处于隐身状态中的    女性达人
    if (![[ZZUserHelper shareInstance] isLogin]) {
        return;
    }
    
    if ([ZZUserHelper shareInstance].loginer.gender != 2) {
        return;
    }

    if ([ZZUserHelper shareInstance].loginer.rent.show || [ZZUserHelper shareInstance].loginer.rent.status != 2) {
        return;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastShowNotHideViewDay = [userDefault objectForKey:@"LastShowNotHideViewDay"];
    
    if (![[ZZDateHelper shareInstance] isPassAWeek:lastShowNotHideViewDay]) {
        // 是否超过一周
        return;
    }
    
    _shouldNotHideView = [[ZZUserShouldNotHideView alloc] init];
    [self.view addSubview:_shouldNotHideView];
    
    [_shouldNotHideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(7.0);
        make.right.equalTo(self.view).offset(-7.0);
        make.bottom.equalTo(self.view).offset(-(TABBAR_HEIGHT + 7.0));
        make.height.equalTo(@55.0);
    }];
    
    WeakSelf
    _shouldNotHideView.comfireBlock = ^{
        [weakSelf.shouldNotHideView removeFromSuperview];
        weakSelf.shouldNotHideView = nil;
        // 去隐私界面
        [weakSelf goToPrivateSettingView];
    };
    
    _shouldNotHideView.cancelBlock = ^{
        [weakSelf.shouldNotHideView removeFromSuperview];
        weakSelf.shouldNotHideView = nil;
    };
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter.timeZone = [NSTimeZone localTimeZone];
    NSString *dateStr = [formatter stringFromDate:date];
    
    [userDefault setObject:dateStr forKey:@"LastShowNotHideViewDay"];
    [userDefault synchronize];
}

- (void)chuzhuAction {
    WEAK_SELF();
    BOOL canProceed = [UserHelper canApplyTalentWithBlock:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
        if (!success) {
            if (infoIncompleteType == 0) {
                // 去验证人脸
                if (!isCancel) {
                    [weakSelf gotoVerifyFace:NavigationTypeApplyTalent];
                }
            }
            else if (infoIncompleteType == 1) {
                // 去上传真实头像
                if (!isCancel) {
                    [weakSelf gotoUploadPicture:NavigationTypeApplyTalent];
                }
            }
        }
    }];
    
    if (!canProceed) {
        return;
    }
    
    if ([ZZUserHelper shareInstance].configModel.open_rent_need_pay_module) {   // 有开启出租收费
        if ([ZZUserHelper shareInstance].loginer.rent_need_pay) { //此人出租需要付费
            if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstProtocol]) { // 需要先去同意协议
                [self gotoRentalAgreementVC];
            }
            else {
                [self gotoUserChuZuVC];
            }
        }
        else {   //不需要付费（字段的值会根据用户是否是男性，大陆，是否已付费，老用户等条件）
            [self gotoUserChuZuVC];
        }
    }
    else {    // 没有开启出租收费功能
        [self gotoUserChuZuVC];
    }
}

#pragma mark - public Method
- (void)jumpToTasks:(NSDictionary *)taksDic {
    [self showDetails:nil taskType:[taksDic[@"to"] isEqualToString:@"pd"] ? TaskNormal : TaskFree];
}

#pragma mark -- Initial Config
- (void)setInitialData {
    // 初始化配置参数
    //添加监听
    [GetSendVideoManager() addObserver:self];
    [GetFastRentManager() addObserver:self];
    self.isFirstLoad = YES;
    if ([ZZUserHelper shareInstance].isLogin && [ZZUserHelper shareInstance].firstInstallAPP) {
        [ZZUtils isAllowLocation];
    } else {
        self.isNotLogin = YES;
    }
}

- (void)createView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.naviBar];
    [self.view addSubview:self.notifyInfoView];
}

- (void)configViewModel {
    WeakSelf
    self.viewModel = [[ZZNewHomeViewModel alloc] init];
    [self.viewModel setCtlsBindBlock:^(NSArray *ctls) {
        for (ZZViewController *ctl in ctls) {
            [weakSelf addChildViewController:ctl];
        }
    }];
    [self.viewModel setGotoUserPage:^(ZZUser *user, UIImageView *imgView) {
        [weakSelf gotoUserPageWithModel:user imgView:imgView];
    }];
    [self.viewModel setGotoFastChat:^{
        [weakSelf gotoFastChatVC];
    }];
    [self.viewModel setGotoShanzu:^{
        [weakSelf gotoShanZu];
    }];
    [self.viewModel setGotoRanks:^{
        [weakSelf gotoRanks];
    }];
    [self.viewModel setGotoTopicClassify:^(ZZHomeCatalogModel *topic) {
        [weakSelf gotoTopicClassify:topic];
    }];
    [self.viewModel setBannerClick:^(ZZHomeBannerModel *bannerModel) {
        [weakSelf bannerClick:bannerModel];
    }];
    [self.viewModel setGotoSpecialTopic:^(ZZHomeSpecialTopicModel *model) {
        [weakSelf gotoSpecialTopic:model];
    }];
    [self.viewModel setTapShowActivity:^{
        if ([[ZZUserHelper shareInstance] isLogin]) {
            if ([ZZUtils isBan]) {
                return;
            }
            [weakSelf showDetails:nil taskType:TaskFree];
        }
        else {
            [weakSelf gotoLoginView];
        }
        
    }];
    
    [self.viewModel setPostTaskCallback:^{
        if ([[ZZUserHelper shareInstance] isLogin]) {
            if ([ZZUtils isBan]) {
                return;
            }
            [ZZSkillSelectionView showsIn:weakSelf taskType:TaskNormal];
        }
        else {
            [weakSelf gotoLoginView];
        }
    }];
    
    [self.viewModel setShowLocationsCallback:^(ZZTask *task) {
        [weakSelf showLocation:task];
    }];
    
    [self.viewModel setSignupCallback:^(ZZTask *task) {
        if (![ZZUserHelper shareInstance].isLogin) {
            [weakSelf gotoLoginView];
        }
        else {
            [weakSelf showDetails:task taskType:TaskNormal];
        }
    }];
    
    [self.viewModel setShowRent:^{
        [weakSelf chuzhuAction];
    }];
    
    [self.viewModel setShowTaskFree:^{
        if (![ZZUserHelper shareInstance].isLogin) {
            [weakSelf gotoLoginView];
            return ;
        }
        [weakSelf showDetails:nil taskType:TaskFree];
    }];
    
    [self.viewModel setGotoPopularityRanks:^{
        [weakSelf gotoPopularityRanks];
    }];
    
    // 发布活动
    [self.viewModel setShowGoPublicTaskFree:^{
        if (![[ZZUserHelper shareInstance] isLogin]) {
            [weakSelf gotoLoginView];
            return ;
        }
        
        if ([ZZUtils isBan]) {
            return;
        }
        
        [UserHelper.loginer canPublish:TaskFree block:^(BOOL canPublish, ToastType failType, NSInteger actionIndex) {
            if (canPublish) {
//                [ZZSkillSelectionView showsIn:weakSelf taskType:TaskFree];
            }
            else {
                if (actionIndex == 1) {
                    if (failType == ToastActivityPublishFailDueToNotRent) {
                        // 跳转到我的界面
                        ZZTabBarViewController *rootVC = (ZZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                        [rootVC setSelectedIndex:3];
                    }
                    else if (failType == ToastActivityPublishFailDueToNotShow) {
                        // 跳转到设置隐私页面
                        [weakSelf goToPrivateSettingView];
                    }
                    else if (failType == ToastRealAvatarNotFound) {
                        // 去上传真实头像
                        [weakSelf gotoUploadPicture:NavigationTypePublishTask];
                    }
                }
            }
        }];
    }];
    
    [self getLastFilterValue];  //获取筛选数据，配置viewModel
    [self getLocation];         //获取地址，配置viewModel
}

- (void)configViewWithData {    //位置获取、数据筛选完毕，加载、更新首页视图数据
    if (!self.isFirstLoad) {
        [self reloadHomeData];
    }
    else {
        self.isFirstLoad = NO;
        [self.viewModel registerTableView:self.tableView];
    }
}

//加载h5的活动页
- (void)loadH5_activeData { //TODO -- 原首页方法，尚不知何用处
    [ZZActivityUrlNetManager loadH5ActiveWithViewController:self isHaveReceived:NO callBack:nil];
}

#pragma mark -- remotePush correlation
- (void)checkPushStatus {   //检查推送是否开启，未开启则显示提示栏
    if (![ZZUserHelper shareInstance].firstHomeGuide) { //首次加载有引导，不需要弹出
        return;
    }
    
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {
        self.isOpenPush = NO;
        [self showNotificationInfoView];
    }
    else {
        self.isOpenPush = YES;
        [self hideNotificationInfoView];
    }
    [self uploadUserNotificionStatus];
}

- (void)uploadUserNotificionStatus {    //上传用户是否开启了通知
    if ([ZZUserHelper shareInstance].isLogin) {
        BOOL open = YES;
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone) {
            open = NO;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *param = @{@"push_config":@{@"open_system_push":[NSNumber numberWithBool:open]}};
            ZZUser *user = [[ZZUser alloc] init];
            [user updateWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                
            }];
        });
    }
}

- (void)showNotificationInfoView {  //显示推送提示栏
    self.notifyInfoView.hidden = NO;
}

- (void)hideNotificationInfoView {  //隐藏推送提示栏
    self.notifyInfoView.hidden = YES;
}

//Notification & KVO
- (void)configNotification {

    [self.tableView addObserver:self
                     forKeyPath:@"contentOffset"
                        options:(NSKeyValueObservingOptionNew)
                        context:nil];
    
    
    // 用户注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRegister)
                                                 name:kMsg_UserDidRegister
                                               object:nil];
    
    // 用户登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogin)
                                                 name:kMsg_UserLogin
                                               object:nil];
    
    // 用户退出登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogout)
                                                 name:kMsg_UserDidLogout
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getLocation)
                                                 name:kMsg_UserDidLogout
                                               object:nil];
    
    // 收到新的派单通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNewPublishOrder) name:kMsg_NewPublishOrder
                                               object:nil];
    
    // 更新抢任务数目通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTaskRedPoint) name:kMsg_UpdateTaskSnatchCount
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAcceptOrder:) name:kMsg_SnatchPublishOrder
                                               object:nil];
    
    // 双击tab 刷新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tabbarRefresh) name:KMsg_TabbarRefreshNotification
                                               object:nil];
    
    // app 进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    // 用户出租信息发生变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userRentInfoDidChanged)
                                                 name:kMsg_UserRentInfoDidChanged
                                               object:nil];
}

#pragma mark -- Notification Implementation
- (void)userRentInfoDidChanged {
    [self reloadHomeData];
}

- (void)applicationBecomeActive {
//    [self getLocation];
    [self uploadUserNotificionStatus];
}

- (void)tabbarRefresh {
    if ([[UIViewController currentDisplayViewController] isKindOfClass: [self class]]) {
        if (![_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header beginRefreshing];
        }
    }
}

// KVO Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self.tableView] && [keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [[change objectForKey:@"new"] CGPointValue];
        CGFloat scale = MIN(MAX(offset.y, 0), NAVIGATIONBAR_HEIGHT) / NAVIGATIONBAR_HEIGHT;
        [self.naviBar resetBtnStyle:scale];
    }
}

// 注册触发
- (void)didRegister {
    if (![ZZUserHelper shareInstance].isLogin) {
        return;
    }
    [ZZRequest method:@"GET" path:@"/api/getFirstRentTip" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (!error && data) {
            _guideView = [[ZZUserRegistedGuidView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [self.view addSubview:_guideView];
            _guideView.delegate = self;
            [_guideView configureInfos:data];
        }
    }];
}

// 用户登录
- (void)userDidLogin {
    if (self.isNotLogin && [ZZUserHelper shareInstance].firstInstallAPP) {
        [ZZUtils isAllowLocation];
    }
    [ZZUserHelper shareInstance].firstInstallAPP = @"firstInstallAPP";
    self.isNotLogin = NO;
    [self getLocation];
    [self uploadUserNotificionStatus];
    
    [self showNotHideView];
}

// 用户退出登录
- (void)userDidLogout {
    [self reloadHomeData];
}

// 收到新的派单
- (void)receiveNewPublishOrder {
}

// 更新抢任务数目,更新导航上红点的显示，可能移至消息列表，届时删除此监听 -- TODO
- (void)updateTaskRedPoint {
}

- (void)receiveAcceptOrder:(NSNotification *)notification {
    [self clearTimerForWaitingSnatch];
    [self removeShineViews];
}

// 获取位置
- (void)getLocation {
    if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        // 在线且定位可用
        if ([ZZUserHelper shareInstance].cityName) {
            self.viewModel.cityName = [ZZUserHelper shareInstance].cityName;
            self.naviBar.cityName = self.viewModel.cityName;
        }
        
        [self configViewWithData];
        self.viewModel.haveGetLocation = NO;
        self.isGetSysLoc = NO;
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = 100;
        }
        [self.locationManager startUpdatingLocation];
    }
    else {
        self.viewModel.haveGetLocation = NO;
        self.viewModel.cityName = nil;
        self.naviBar.cityName = @"全国";
        [self configViewWithData];
    }
}

#pragma mark - ZZUserRegistedGuidViewDelegate
- (void)viewDidConfirm:(ZZUserRegistedGuidView *)view {
    if ([ZZUserHelper shareInstance].loginer.rent.status == 0) {
        if (UserHelper.loginer.faces.count == 0) {
            // 没有人工审核的头像
            [UIAlertController presentAlertControllerWithTitle:@"您需要使用本人正脸五官清晰照，才能获取达人资格，请前往上传真实头像"
                                                       message:nil
                                                     doneTitle:@"去上传"
                                                   cancelTitle:@"取消"
                                                 completeBlock:^(BOOL isCancelled) {
                                                     if (!isCancelled) {
//                                                         if (![UserHelper didHaveRealFace]) {
                                                             [self gotoVerifyFace:NavigationTypeApplicantForTalent];
//                                                         }
//                                                         else {
//                                                             [self gotoUploadPicture:NavigationTypeApplyTalent];
//                                                         }

                                                     }
                                                 }];
        
        }
        else {
            if ([UserHelper didHaveRealAvatar] || ([UserHelper isAvatarManualReviewing] && [UserHelper didHaveOldAvatar])) {
                    // 有真实头像,或者可用旧头像:跳转出租
                    [self gotoUserChuZuVC];
                }
            else {
                // 无真实头像
                if ([UserHelper isAvatarManualReviewing]) {
                    // 正在人工审核
                    [self gotoUserChuZuVC];
                }
                else {
                    // 没有人工审核的头像
                    [UIAlertController presentAlertControllerWithTitle:@"您需要使用本人正脸五官清晰照，才能获取达人资格，请前往上传真实头像"
                                                               message:nil
                                                             doneTitle:@"去上传"
                                                           cancelTitle:@"取消"
                                                         completeBlock:^(BOOL isCancelled) {
                                                             if (!isCancelled) {
                                                                 if (![UserHelper didHaveRealFace]) {
                                                                     [self gotoVerifyFace:NavigationTypeApplicantForTalent];
                                                                 }
                                                                 else {
                                                                     [self gotoUploadPicture:NavigationTypeApplyTalent];
                                                                 }

                                                             }
                                                         }];
                }
            }
        }
    }
}

#pragma mark -- CLLocationManagerDelegate & LocationReverse
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (self.isGetSysLoc) {
        return;
    }
    self.isGetSysLoc = YES;
    if ([ZZUserHelper shareInstance].isLogin) {
        [[ZZUserHelper shareInstance] updateUserLocationWithLocation:locations[0]];
    }
    
    [ZZUserHelper shareInstance].location = locations[0];
    [self.locationManager stopUpdatingLocation];
    [self reverseGeocodeLocation];
}

- (void)reverseGeocodeLocation {    //先用系统自带的逆地址解析
    __block BOOL haveCity = NO;
    if ([ZZUserHelper shareInstance].cityName) {
        haveCity = YES;
    }
    [ZZUserHelper shareInstance].isAbroad = NO;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location = [ZZUserHelper shareInstance].location;
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"locationerror = %@",error);
            [self gaodeReverseGeocodeLocation];
        } else {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *cityName = @"";
            if (placemark.locality) {
                cityName = placemark.locality;
            }
            else if (placemark.administrativeArea) {
                cityName = placemark.administrativeArea;
            }
            if ([self isSpecailProvince:cityName]) {
                cityName = placemark.subLocality;
            }
            if (![placemark.ISOcountryCode isEqualToString:@"CN"]) {
                [ZZUserHelper shareInstance].isAbroad = YES;
                cityName = placemark.country;
            }
            if (!isNullString(cityName)) {
                self.viewModel.haveGetLocation = YES;
                if (haveCity && ![cityName isEqualToString:[ZZUserHelper shareInstance].cityName]) {    //与之前记录的城市不同时
                    dispatch_async(dispatch_get_main_queue(), ^{
                        haveCity = NO;
                        self.viewModel.cityName = cityName;
                        self.naviBar.cityName = cityName;
                        [[ZZTabBarViewController sharedInstance] showBubbleView:2];
                        [ZZUserHelper shareInstance].cityName = cityName;
                        
                        // FIXME:新定位
                        [ZZUserDefaultsHelper setObject:@"1" forDestKey:@"NewLocation"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self configViewWithData];
                        });
                    });
                }
                if (!haveCity) {
                    self.viewModel.cityName = cityName;
                    self.naviBar.cityName = cityName;
                    [ZZUserHelper shareInstance].cityName = cityName;
                }
            }
        }
        
        // 城市改变则获取首页信息
        if (!haveCity) {
            // FIXME:新定位
            [ZZUserDefaultsHelper setObject:@"1" forDestKey:@"NewLocation"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self configViewWithData];
            });
        }
    }];
}

// 系统的没解析出来用高德的解析
- (void)gaodeReverseGeocodeLocation {
    __block BOOL haveCity = NO;
    if ([ZZUserHelper shareInstance].cityName) {
        haveCity = YES;
    }
    self.aMapManager = [[AMapLocationManager alloc] init];
    self.aMapManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.aMapManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSLog(@"locationerror = %@",error);
        } else {
            NSLog(@"regeocode = %@",regeocode);
            [_aMapManager stopUpdatingLocation];
            NSString *cityName = @"";
            if (regeocode.city) {
                cityName = regeocode.city;
            } else if (regeocode.province) {
                cityName = regeocode.province;
            }
            if ([self isSpecailProvince:cityName]) {
                cityName = regeocode.district;
            }
            if (!isNullString(cityName)) {
                self.viewModel.haveGetLocation = YES;
                if (!haveCity || ![cityName isEqualToString:[ZZUserHelper shareInstance].cityName]) {
                    haveCity = NO;
                    self.viewModel.cityName = cityName;
                    self.naviBar.cityName = cityName;
                }
                ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
                userHelper.cityName = cityName;
                userHelper.location = location;
            }
        }
        if (!haveCity) {    //城市改变则获取首页信息
            // FIXME:新定位
            [ZZUserDefaultsHelper setObject:@"1" forDestKey:@"NewLocation"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self configViewWithData];
            });
            
        }
    }];
}

//是否是特殊省份？
- (BOOL)isSpecailProvince:(NSString *)province {
    NSArray *array = @[@"新疆维吾尔自治区",@"海南省",@"湖北省",@"河南省"];
    if ([array containsObject:province]) {
        return YES;
    }
    return NO;
}

#pragma mark - WBFastRentManagerObserver
// 闪租发布任务发生变化: 1: 发布中  0: 取消发布
- (void)missionDidChangeWithUnderway:(NSString *)isUnderway {
    self.isUnderway = [isUnderway isEqualToString:@"1"];
}

#pragma mark -- data update
- (void)reloadHomeData {
    [self.viewModel requestData];
}

// 获取上次筛选配置
- (void)getLastFilterValue {
    if ([ZZUserHelper shareInstance].lastFilterSexValue) {
        self.viewModel.filterDict = @{@"gender":[ZZUserHelper shareInstance].lastFilterSexValue};
    }
}

// 保存最后一次筛选性别
- (void)updateLastFilterValue {
    NSString *value = [self.viewModel.filterDict objectForKey:@"gender"];
    [ZZUserHelper shareInstance].lastFilterSexValue = value;
}

#pragma mark -- method
/**
 *  是否显示紧急求助
 */
- (void)getSecurityStatus {
    if ([ZZUserHelper shareInstance].isLogin) {
        [ZZRequest method:@"GET" path:@"/api/user/emergency_help/status" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (data) {
                if ([[data objectForKey:@"emergency_help_status"] integerValue] == 1) {
                    self.securityBtn.hidden = NO;
                    self.securityBtn.orderId = [data objectForKey:@"order_id"];
                }
            }
        }];
    }
}

/**
 *  点击发布任务按钮
 */
- (void)publishTaskClick {
    if ([ZZUtils isConnecting]) {
        // 正在视频通话，任务中断
        return ;
    }
    if ([ZZUtils isBan]) {
        // 用户被封禁，任务取消
        return ;
    }
    
    [GetFastRentManager() syncUpdateMissionStatus:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (self.publishView.skill.type == 1) {    //线下任务
        if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstTaskPublishAlert]) {
            [window addSubview:self.taskConfirmAlert];
        }
        else {
            [self publishTask];
        }
    }
    else {    //线上任务（1v1视频）
        if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstPublishOrderAlert]) {
            [window addSubview:self.requestAlertView];
        }
        else {
            [self publishTask];
        }
    }
}

/**
 *  发布任务
 */
- (void)publishTask {
    [MobClick event:Event_click_publish];
    
    self.publishView.publishView.userInteractionEnabled = NO;
    if (!isNullString(self.publishView.locationModel.city)) {
        [self.publishView.param setObject:self.publishView.locationModel.city forKey:@"address_city_name"];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [ZZRequest method:@"POST" path:@"/api/pd/add" params:self.publishView.param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {   //新增派单
        self.publishView.publishView.userInteractionEnabled = YES;
        if (error) {
            if (error.code == 7001) {
                self.failureAlert.contentLabel.text = error.message;
                [window addSubview:self.failureAlert];
            }
            else if (error.code == 7002) {
                self.liveEndAlert.contentLabel.text = error.message;
                self.liveEndAlert.type = 1;
                [window addSubview:self.liveEndAlert];
            }
            else {
                [ZZHUD showErrorWithStatus:error.message];
            }
        }
        else {
            [self publishOrder:data];
        }
    }];
}

/**
 *  发布订单
 */
- (void)publishOrder:(id)data {
    //保存当前发布信息，取消次数，可取消最大次数（达到次数后，一定时间内不能发任务）。
    [ZZKeyValueStore saveValue:data[@"cancel_count_max"] key:[ZZStoreKey sharedInstance].cancel_count_max];
    [ZZKeyValueStore saveValue:data[@"cancel_count"] key:[ZZStoreKey sharedInstance].cancel_count];
    [ZZKeyValueStore saveValue:self.publishView.param key:[ZZStoreKey sharedInstance].publishSelections];
    //发单成功，等待接单，开启动效
    ZZSnatchDetailModel *model = [[ZZSnatchDetailModel alloc] initWithDictionary:data[@"pd"] error:nil];
    self.taskCountDown = model.valid_duration * 60;
    if (self.publishView.skill.type == 1) { //线下任务（最多可选择5人，需先支付1人的租金）
        [self gotoPayView:model];
    }
    else if (self.publishView.skill.type == 2) {  //线上任务（1v1视频）
        [self.presentSlider dismiss];
        [self addShineViews:model];
    }
    [self createTimerForWaitingSnatch];
}

#pragma mark - view corrletion
/**
 *  添加等待接单时的动效视图
 */
- (void)addShineViews:(ZZSnatchDetailModel *)model {
    [self removeShineViews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:self.shineView];
        self.shineView.type = model.type;
        [self.shineView animate];
        self.shineView.pId = model.id;
    });
}

/**
 *  移除等待接单时的动效视图
 */
- (void)removeShineViews {
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

#pragma mark -- timer
/**
 *  创建任务倒计时定时器
 */
- (void)createTimerForWaitingSnatch {
    if (self.waitSnatchTimer) {
        [self clearTimerForWaitingSnatch];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synconizeTaskCountDown) name:UIApplicationWillEnterForegroundNotification object:nil];
    self.publishDate = [NSDate new];
    self.shineView.during = 0;
    self.waitSnatchTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(waitSnatchTimerCycle) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.waitSnatchTimer forMode:NSRunLoopCommonModes];
}

/**
 *  等待接单循环
 */
- (void)waitSnatchTimerCycle {
    if (!self.isUnderway) {
        [self clearTimerForWaitingSnatch];
        return ;
    }
    self.taskCountDown--;
    [GetFastRentManager() syncUpdateRemainingTimeWithTime:INT_TO_STRING(self.taskCountDown)];
    self.shineView.during = self.taskCountDown;
    if (self.taskCountDown <= 0) {
        [ZZHUD showTaskInfoWithStatus:@"暂无合适达人抢您的任务"];
        [self removeShineViews];
        [self clearTimerForWaitingSnatch];
    }
}

/**
 *  发布任务期间，应用切换后，保持倒计时同步
 */
- (void)synconizeTaskCountDown {
    if (self.taskCountDown <= 0) {
        return ;
    }
    NSTimeInterval delta = [[NSDate new] timeIntervalSinceDate:self.publishDate];
    NSTimeInterval sum = self.publishView.skill.type == 1 ? 600 : 180;
    self.taskCountDown = sum - delta;   //剩余时间
}

- (void)clearTimerForWaitingSnatch {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [self.waitSnatchTimer invalidate];
    self.waitSnatchTimer = nil;
    self.publishDate = nil;
}

#pragma mark - page turn
- (void)gotoPopularityRanks {
    if ([ZZUtils isBan]) {
        return;
    }
    
    if (![[ZZUserHelper shareInstance] isLogin]) {
        [self gotoLoginView];
        return;
    }

    ZZRankIndexController *viewController = [[ZZRankIndexController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

/**
 *  发布活动跳转到全部技能的页面
*/
- (void)goToChooseSkillsView {
    ZZChooseSkillViewController *allSkills = [[ZZChooseSkillViewController alloc] init];
    allSkills.taskType = TaskFree;
    allSkills.title = @"选择你想开展的活动主题";
    allSkills.isFromSkillSelectView = YES;
    allSkills.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allSkills animated:YES];
}

/**
 *  跳转到个人隐私页面
 */
- (void)goToPrivateSettingView {
    ZZSettingPrivacyViewController *vc = [[ZZSettingPrivacyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.user = [ZZUserHelper shareInstance].loginer;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 * 出租信息
 */
- (void)gotoUserChuZuVC {
    [MobClick event:Event_click_me_rent];
    WeakSelf
    //未出租状态前往申请达人，其余状态进入主题管理
    if ([ZZUserHelper shareInstance].loginer.rent.status == 0) {
        ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
        registerRent.type = RentTypeRegister;
        [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
            ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
        [self.navigationController presentViewController:registerRent animated:YES completion:nil];
    }
    else {
        ZZSkillThemeManageViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if (![ZZUserHelper shareInstance].userFirstRent) {
        [ZZUserHelper shareInstance].userFirstRent = @"userFirstRent";
    }
}

/**
 * 出租协议
 */
- (void)gotoRentalAgreementVC {
    ZZRentalAgreementVC *vc = [ZZRentalAgreementVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 * 没有人脸，则验证人脸
 */
- (void)gotoVerifyFace:(NavigationType)type {
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:type inController:self];
    helper.user = [ZZUserHelper shareInstance].loginer;
    [helper start];
}

/**
 * 没有头像，则上传真实头像
 */
- (void)gotoUploadPicture:(NavigationType)type {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.type = type;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoRanks {
    if ([ZZUtils isBan]) {
        return;
    }
    
    if (![[ZZUserHelper shareInstance] isLogin]) {
        [self gotoLoginView];
        return;
    }
    
    ZZKTVPlazaController *vc = [[ZZKTVPlazaController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showDetails:(ZZTask *)task taskType:(TaskType)taskType {
    ZZTasksViewController *vc = [[ZZTasksViewController alloc] initWithTaskType:taskType];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showLocation:(ZZTask *)task {
    ZZOrderLocationViewController *controller = [[ZZOrderLocationViewController alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:task.address_lat longitude:task.address_lng];
    controller.location = location;
    controller.name = [NSString stringWithFormat:@"%@%@",task.city_name, task.address];
    controller.navigationItem.title = @"邀约地点";
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 * 跳转他人资料页
 */
- (void)gotoUserPageWithModel:(ZZUser *)user imgView:(UIImageView *)imgView {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.isFromHome = YES;
    controller.user = user;
    controller.uid = user.uid;
    [self.navigationController wxs_pushViewController:controller makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType = WXSTransitionAnimationTypeCustomZoom;
        transition.animationTime = 0.4;
        transition.startView  = imgView;
    }];
}

/**
 * 跳转视频咨询
 */
- (void)gotoFastChatVC {
    ZZFastChatVC *vc = [ZZFastChatVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 * 开启闪租任务，需登录
 */
- (void)gotoShanZu {
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
    }
    else {
        [self showDetails:nil taskType:TaskNormal];
    }
}

- (void)gotoTopicClassify:(ZZHomeCatalogModel *)topic {
    if (isNullString(topic.id)) {
        ZZAllTopicsViewController *allTopics = [[ZZAllTopicsViewController alloc] init];
        allTopics.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:allTopics animated:YES];
        return;
    }
    ZZTopicClassifyViewController *controller = [[ZZTopicClassifyViewController alloc] init];
    controller.topic = topic;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 * 跳转支付界面
 */
- (void)gotoPayView:(ZZSnatchDetailModel *)model {
    //TODO
    ZZPayViewController *controller = [[ZZPayViewController alloc] init];
    controller.pId = model.id;
    controller.type = PayTypeTask;
    controller.price = [[self.publishView.param objectForKey:@"price"] doubleValue];
    controller.hidesBottomBarWhenPushed = YES;
    controller.didPay = ^{  //支付回调
        [self addShineViews:model];
    };
    [self.presentSlider dismiss];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 * 跳转城市选择
 */
- (void)gotoChooseCity {
    [MobClick event:Event_click_home_choose_city];
    ZZCityViewController *controller = [[ZZCityViewController alloc] init];
    controller.selectedCity = ^(ZZCity *city) {
        if (city && ![self.naviBar.cityName isEqualToString:city.name]) {
            self.viewModel.cityName = city.name;
            self.viewModel.city = city;
            [self.naviBar setCityName:city.name];
            
            NSArray *coordinates = [city.center componentsSeparatedByString:@","];
            if (coordinates && coordinates.count == 2) {
                UserHelper.selectedLocation = [[CLLocation alloc] initWithLatitude:[coordinates.lastObject doubleValue] longitude: [coordinates.firstObject doubleValue]];
            }
            
            // FIXME:新定位
            [ZZUserDefaultsHelper setObject:@"1" forDestKey:@"NewLocation"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self configViewWithData];
            });
        }
    };
    ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:navCtl animated:YES completion:nil];
}

/**
 * 跳转用户搜索
*/
- (void)gotoSearchUser {
    ZZFilterViewController *controller = [[ZZFilterViewController alloc] init];
    controller.filter = self.viewModel.filterDict;
    controller.filterDone = ^(NSDictionary *params) {
        self.viewModel.filterDict = params;
        [self configViewWithData];
        [self updateLastFilterValue];
    };
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 * 充钱
 */
- (void)gotoRechargeBtnClick {
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    self.presentSlider.hidden = YES;
    __weak typeof(nav)weakNav = nav;
    WeakSelf
    ZZMeBiViewController *vc = [ZZMeBiViewController new];
    [vc setPaySuccess:^(ZZUser *paySuccesUser) {
        __strong typeof(weakNav)strongNav = weakNav;
        NSMutableArray<ZZViewController *> *vcs = [strongNav.viewControllers mutableCopy];
        [vcs removeLastObject];
        weakSelf.presentSlider.hidden = NO;
        [strongNav setViewControllers:vcs animated:NO];
    }];
    [vc setCallBlack:^{
        weakSelf.presentSlider.hidden = NO;
    }];
    [nav pushViewController:vc animated:YES];
}

- (void)gotoSpecialTopic:(ZZHomeSpecialTopicModel *)model {
    [self runtimePush:@"ZZLinkWebViewController" dic:@{@"urlString":model.url,@"isHideBar":@1} push:YES];
}

- (void)bannerClick:(ZZHomeBannerModel *)bannerModel {
    NSString *jsonString = [bannerModel.url stringByReplacingOccurrencesOfString:@"zwmscheme://" withString:@""];
    NSDictionary *dictionary = [ZZUtils dictionaryWithJsonString:jsonString];
    NSDictionary *aDict = [dictionary objectForKey:@"iOS"];
    
    if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"push"]) {
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:YES];
    } else if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"present"]) {
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:NO];
    }
}

- (void)runtimePush:(NSString *)vcName dic:(NSDictionary *)dic push:(BOOL)push {
    if ([vcName isEqualToString:@"ZZFastChatAgreementVC"]) {
        BOOL canProceed = [UserHelper canOpenQuickChatWithBlock:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
            if (infoIncompleteType == 2 || infoIncompleteType == 4) {
                if (!isCancel) {
                    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }];
        if (!canProceed) {
            return;
        }
    }
    //类名(对象名)
    NSString *class = vcName;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    
    // 创建对象(写到这里已经可以进行随机页面跳转了)
    id instance = [[newClass alloc] init];
    //下面是传值－－－－－－－－－－－－－－
    if (dic == nil || [dic isKindOfClass:[NSString class]]) {
        dic = @{};
    }
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([ZZUtils checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            [instance setValue:obj forKey:key];
        } else {
            NSLog(@"不包含key=%@的属性",key);
        }
    }];
    if ([instance isKindOfClass:[ZZRecordViewController class]]) {
        [ZZUtils checkRecodeAuth:^(BOOL authorized) {
            if (authorized) {
                [self navigationMethod:instance push:push];
            }
        }];
    }
    else if ([instance isKindOfClass:[ZZUserChuzuViewController class]]) {
        // 旧版出租类名，后台未做调整，延用
        // 未出租状态前往申请达人，其余状态进入主题管理
        if ([ZZUserHelper shareInstance].loginer.rent.status == 0) {
            WeakSelf
            ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
            registerRent.type = RentTypeRegister;
            [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
                ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }];
            [self.navigationController presentViewController:registerRent animated:YES completion:nil];
        }
        else {
            ZZSkillThemeManageViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        return;
    }
    else if ([instance isKindOfClass:[ZZSelfIntroduceVC class]]) {
//        BLOCK_SAFE_CALLS(self.touchRecordVideo);
    }
    else if ([instance isKindOfClass:[ZZChatVideoPlayerController class]]) {// 纯视频介绍页面
        ZZChatVideoPlayerController *playerVC = [[ZZChatVideoPlayerController alloc] init];
        playerVC.entrance = EntranceOthers;
        playerVC.videoUrl = [dic objectForKey:@"urlString"];
        [self presentViewController:playerVC animated:YES completion:nil];
    }
    else if ([instance isKindOfClass:[ZZCommissionIndexViewController class]]) {
        if (![ZZUtils isUserLogin]) {
            return;
        }
        [self navigationMethod:instance push:push];
    }
    else {
        [self navigationMethod:instance push:push];
    }
}

- (void)navigationMethod:(id)instance push:(BOOL)push {
    if (push) {
        UIViewController *ctl = (UIViewController *)instance;
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:instance animated:YES];
    }
    else {
        ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:instance];
        [self presentViewController:navCtl animated:YES completion:nil];
    }
}

#pragma mark - getter & setter
- (ZZNewHomeNaviBar *)naviBar {
    if (nil == _naviBar) {
        WeakSelf
        _naviBar = [[ZZNewHomeNaviBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        [_naviBar setTouchLocation:^{
            [weakSelf gotoChooseCity];
        }];
        [_naviBar setTouchSearch:^{
            [weakSelf gotoSearchUser];
        }];
    }
    return _naviBar;
}

- (ZZNewHomeTableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[ZZNewHomeTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
        _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
            [self reloadHomeData];
        }];
        
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

- (ZZSecurityButton *)securityBtn {
    if (!_securityBtn) {
        _securityBtn = [[ZZSecurityButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 57 - 15, SCREEN_HEIGHT - TABBAR_HEIGHT - 65 - 15, 57, 65.5)];
        _securityBtn.hidden = YES;
        [self.view addSubview:_securityBtn];
    }
    return _securityBtn;
}

- (ZZHomeNotificationInfoView *)notifyInfoView {
    if (nil == _notifyInfoView) {
        WeakSelf
        _notifyInfoView = [[ZZHomeNotificationInfoView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 40)];
        _notifyInfoView.hidden = YES;
        _notifyInfoView.callBack = ^{
            [weakSelf hideNotificationInfoView];
        };
    }
    return _notifyInfoView;
}

- (WBActionContainerView *)presentSlider {
    if (nil == _presentSlider) {
        _presentSlider = [[WBActionContainerView alloc] initWithView:self.publishView forHeight:self.publishView.frame.size.height];
        _presentSlider.maskViewClickEnable = NO;
    }
    return _presentSlider;
}

- (ZZPublishOrderView *)publishView {
    WeakSelf
    if (nil == _publishView) {
        
        CGFloat height = SCALE_SET(700);
        if (isIPhoneX) {
            height = SCALE_SET(850);
        }
        else if (isIPhoneXsMax) {
            height = SCALE_SET(950);
        }
        _publishView = [[ZZPublishOrderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        _publishView.touchPublish = ^{
            [weakSelf publishTaskClick];
        };
        
        [_publishView setDismissBlock:^{
            // 点击取消
            [weakSelf.presentSlider dismiss];
        }];
        
        [_publishView setPresentBlock:^{
            // 点击任务
            ZZPostTaskBasicInfoController *viewController = [[ZZPostTaskBasicInfoController alloc] initWithSkill:weakSelf.publishView.skill taskType:TaskFree];
            viewController.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        }];
    }
    return _publishView;
}

- (ZZTaskPublishConfirmAlert *)taskConfirmAlert {
    WeakSelf;
    if (!_taskConfirmAlert) {
        _taskConfirmAlert = [[ZZTaskPublishConfirmAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _taskConfirmAlert.touchSure = ^{
            [weakSelf publishTask];
        };
        _taskConfirmAlert.touchCancel = ^{
            [weakSelf clearTimerForWaitingSnatch];
        };
    }
    return _taskConfirmAlert;
}

- (ZZRequestLiveStreamAlert *)requestAlertView {
    WeakSelf;
    if (!_requestAlertView) {
        _requestAlertView = [[ZZRequestLiveStreamAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _requestAlertView.isPublish = YES;
        _requestAlertView.touchSure = ^{
            [weakSelf publishTask];
        };
        _requestAlertView.touchCancel = ^{
            [weakSelf clearTimerForWaitingSnatch];
        };
    }
    return _requestAlertView;
}

- (ZZLiveStreamEndAlert *)liveEndAlert {
    if (!_liveEndAlert) {
        _liveEndAlert = [[ZZLiveStreamEndAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _liveEndAlert;
}

- (ZZPublishingShineView *)shineView {
    if (!_shineView) {
        _shineView = [[ZZPublishingShineView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
        _shineView.during = _taskCountDown;
    }
    return _shineView;
}

- (ZZRequestLiveStreamFailureAlert *)failureAlert {
    WeakSelf;
    if (!_failureAlert) {
        _failureAlert = [[ZZRequestLiveStreamFailureAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _failureAlert.touchRecharge = ^{
            [weakSelf gotoRechargeBtnClick];
        };
    }
    return _failureAlert;
}

@end
