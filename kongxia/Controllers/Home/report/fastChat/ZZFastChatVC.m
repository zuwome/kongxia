//
//  ZZFastChatVC.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/28.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZActivityUrlNetManager.h"

#import "ZZDateHelper.h"

#import "ZZFastChatVC.h"
#import "ZZFastChatCell.h"
#import "ZZFastChatManager.h"
#import "ZZFastChatModel.h"
#import "ZZLiveStreamHelper.h"
#import "ZZPublishModel.h"
#import "ZZFastConfirmAlert.h"

#import "ZZCallRecordsVC.h"
#import "ZZFastChatSettingVC.h"
#import "ZZFastChatAgreementVC.h"
#import "ZZliveStreamConnectingController.h"
#import "ZZLiveStreamConnectViewController.h"
#import "ZZRentViewController.h"
#import "LSPaoMaView.h"
#import "ZZMeBiViewController.h"
#import "ZZChatServerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZZSanChatGuide.h"//闪聊引导页
#import "ZZChatCallIphoneManagerNetWork.h"//连麦管理类
#import "ZZUserEditViewController.h"

#define HEADER_IMAGEURL_UNLOGIN (@"http://7xwsly.com1.z0.glb.clouddn.com/qchat_intro.jpeg")//未登录、未开通URL
#define HEADER_IMAGEURL_LOGIN   (@"http://7xwsly.com1.z0.glb.clouddn.com/qchat_how_to_open.jpeg")//已登录、已开通URL
#define HEADER_IMAGE_SCALE      (345.0f / 135.0f)   //头部的Image比例

#define SHowSanPromptString @"目前不在闪聊推荐中,立即设置上推荐"
@interface ZZFastChatVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ZZFastChatModel *> *models;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, strong) ZZliveStreamConnectingController *connectingVC;
@property (nonatomic, strong) ZZFastConfirmAlert *fastConfirmAlert;

@property (nonatomic, strong) UIView *topView;//顶部提示view
@property (nonatomic, strong) UIButton *paomaView;//跑马的
@end

@implementation ZZFastChatVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([ZZUserHelper shareInstance].isLogin) {
        self.user = [ZZUserHelper shareInstance].loginer;
    }
    [self createNavigationRightDoneBtn];
    NSLog(@"%@ -- 1", self);
    if ([self isShowTopView]) {
        self.topView.height = 40 ;
        if (![ZZUserHelper shareInstance].loginer.push_config.qchat_push) {
            [self.paomaView setTitle:SHowSanPromptString forState:UIControlStateNormal] ;
        }else{
            [self.paomaView setTitle:SHowSanPromptString forState:UIControlStateNormal] ;
        }
    }else{
        self.topView.height = 0 ;
    }
    NSLog(@"%@ -- 2", self);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"视频咨询";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogin:)
                                                 name:kMsg_UserLogin
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openFastChatSuccess:)
                                                 name:kMsg_OpenFastChat
                                               object:nil];
    [GetFastChatManager() addObserver:self];
    [self setupUI];
    [self sendRequest];
}

/**
 是否打开相机权限
 */
- (BOOL)isOpenCameraWith:(NSIndexPath *)indexPath  {
    // 第一次打开App进入闪聊列表
    NSString *firstGoToChat = [NSString stringWithFormat:@"%@",[ZZStoreKey sharedInstance].firstGotoFastChat];
    WS(weakSelf);
    if (![ZZKeyValueStore getValueWithKey:firstGoToChat]) {
        [ZZKeyValueStore saveValue:@"1" key:firstGoToChat];
        AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (videoAuthStatus != AVAuthorizationStatusAuthorized) {
            [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
                NSLog(@"py_权限判断");
            [weakSelf connectWithIndePath:indexPath];

            }];
        }
        return NO;
    }
    else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"释放了 %@", [self class]);
    REMOVE_ALL_MSG();
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[ZZFastChatCell class] forCellReuseIdentifier:[ZZFastChatCell reuseIdentifier]];
    }
    return _tableView;
}

- (NSMutableArray<ZZFastChatModel *> *)models {
    if (!_models) {
        _models = [NSMutableArray new];
    }
    return _models;
}

- (ZZUser *)user {
    if (!_user) {
        _user = [ZZUserHelper shareInstance].loginer;
    }
    return _user;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        _topView.backgroundColor = HEXCOLOR(0xF9F3D0);

        _paomaView = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 40, 40)];
        _paomaView.titleLabel.font = [UIFont systemFontOfSize:14];
        [_paomaView setTitleColor:HEXCOLOR(0xDDA200) forState:UIControlStateNormal];
//        _paomaView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_paomaView addTarget:self action:@selector(fastChatSettingClick) forControlEvents:UIControlEventTouchUpInside];

        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(SCREEN_WIDTH - 45, 0, 45, 40);
        [closeBtn setImage:[UIImage imageNamed:@"icCloseNoticeShanliao"] forState:UIControlStateNormal];
        closeBtn.contentMode = UIViewContentModeCenter;
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_paomaView];
        [_topView addSubview:closeBtn];
    }
    return _topView;
}

#pragma mark - Private methods
// 登录成功之后
- (void)userDidLogin:(NSNotification *)notificatio {
    if ([ZZUserHelper shareInstance].isLogin) {
        self.user = [ZZUserHelper shareInstance].loginer;
        [self createNavigationRightDoneBtn];
        [self getHeadData];
        if ([self isShowTopView]) {
            self.topView.height = 40 ;
            if (![ZZUserHelper shareInstance].loginer.push_config.qchat_push) {
                [self.paomaView setTitle:@"您当前不在闪聊列表，进入设置重新设置" forState:UIControlStateNormal] ;
            }else{
                 [self.paomaView setTitle:@"您设置的在线时间不在当前时间内，重新设置可出现在列表" forState:UIControlStateNormal] ;
            }
        }
        else{
            self.topView.height = 0 ;
        }
        self.topView.hidden = [self isShowTopView] ? NO : YES;
    }
}

// 开通闪聊成功 刷新页面数据 及 UI
- (void)openFastChatSuccess:(NSNotification *)notificatio {
    self.user = [ZZUserHelper shareInstance].loginer;
    [self createNavigationRightDoneBtn];
    [self getHeadData];
}

- (void)setupUI {
    [self createNavigationRightDoneBtn];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.bottom.equalTo(@(0));
    }];
}

// 创建/更新 right Button
- (void)createNavigationRightDoneBtn {
    
    self.navigationItem.rightBarButtonItem = nil;
    if ([ZZUserHelper shareInstance].isLogin) {
        
        if ([ZZUserHelper shareInstance].loginer.open_qchat) {  // 已经申请开通闪聊
            if ([ZZUserHelper shareInstance].loginer.base_video.status == 2) {
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"通话记录" target:self selector:@selector(callRecordsClick)];
            } else {
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"设置" target:self selector:@selector(fastChatSettingClick)];
            }
        } else {
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"通话记录" target:self selector:@selector(callRecordsClick)];
        }
    } else {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"通话记录" target:self selector:@selector(callRecordsClick)];
    }
}

// 通话记录
- (void)callRecordsClick {
    if (![ZZUserHelper shareInstance].isLogin) {//去登陆
        [self gotoLoginView];
        return;
    }
    ZZCallRecordsVC *vc = [ZZCallRecordsVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

// 广场设置
- (void)fastChatSettingClick {
    ZZFastChatSettingVC *vc = [ZZFastChatSettingVC new];
//    vc.isShow = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// header 点击事件
- (void)topImageClick:(UIButton *)sender {
    BOOL canProceed = [UserHelper canOpenQuickChatWithBlock:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
        if (!isCancel) {
            ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
    if (!canProceed) {
        return;
    }
    ZZFastChatAgreementVC *vc = [ZZFastChatAgreementVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

// 关闭弹窗
- (void)closeBtnClick:(UIButton *)sender {
//     关闭过不再弹窗
    [[NSUserDefaults standardUserDefaults] setObject:@"firstCloseTopView" forKey:[ZZStoreKey sharedInstance].firstCloseTopView];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.topView.height = 0 ;
    [ZZUserHelper shareInstance].firstCloseTopView = YES;
    self.topView.hidden = YES;
}

// 是否需要显示 TopView
- (BOOL)isShowTopView {
    
    if (![ZZUserHelper shareInstance].isLogin) {
        return NO;
    }
     //之前点过关闭，则不再显示
    if ([ZZUserHelper shareInstance].firstCloseTopView) {
        return NO;
    }
    if (! [self isSanChatOnLine]) {
        return YES;
    }
    return NO;
}

- (BOOL)isSanChatOnLine {
    if ([ZZUserHelper shareInstance].loginer.push_config.qchat_push) {
        //如果用户在闪聊广场,同时为女性用户且时间处于闪聊开放时间段就显示
        NSDateFormatter *dateFormat = [ZZDateHelper shareInstance].formatter;
        [dateFormat setDateFormat:@"HH:mm"];
        NSDate *start = [dateFormat dateFromString:[ZZUserHelper shareInstance].loginer.push_config.qchat_push_begin_at];
        NSDate *expire = [dateFormat dateFromString:[ZZUserHelper shareInstance].loginer.push_config.qchat_push_end_at];
        NSDate *today = [NSDate date];
        NSString *todayStr = [dateFormat stringFromDate:today];//将日期转换成字符串
        today = [dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
        if ([expire compare:start] == NSOrderedDescending) {
            //当天
            if (([expire compare:today]==NSOrderedDescending)&&([start compare:today]==NSOrderedAscending)) {
                return YES;
            }
            
            return NO;
        }else if ([expire compare:start] == NSOrderedAscending) {
            //设置跨天的
            if ([self judgeDayAndNightWithStartTime:self.user.push_config.qchat_push_begin_at endTime:@"23:59"]) {
                return YES;
            } else if ([self judgeDayAndNightWithStartTime:@"00:00" endTime:self.user.push_config.qchat_push_end_at]) {
                return YES;
            } else {
                return NO;
            }
            NSLog(@"PY_当前用户的设置时间段为跨天");
            
        }else{
            
            return YES;
            NSLog(@"PY_当前用户的设置时间段为全天");
        }
    }
    return NO;
}

- (BOOL)judgeDayAndNightWithStartTime:(NSString *)startString endTime:(NSString *)endString {
    //获取当前时间
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat =  [ZZDateHelper shareInstance].formatter;
    // 时间格式,建议大写    HH 使用 24 小时制；hh 12小时制
    [dateFormat setDateFormat:@"HH:mm"];
    
    NSString *todayStr = [dateFormat stringFromDate:today];//将日期转换成字符串
    today = [dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    // strar 格式 "5:30"  end: "19:08"
    NSDate *start = [dateFormat dateFromString:startString];
    NSDate *expire = [dateFormat dateFromString:endString];

    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

#pragma mark - 上下拉刷新回调
- (void)sendRequest {
    WeakSelf;
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getHeadData];
    }];
//    _tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
//        [weakSelf getFootData];
//    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)getHeadData {
    [self.tableView.mj_footer resetNoMoreData];
    NSMutableDictionary *aDcit = [@{} mutableCopy];
    if ([ZZUserHelper shareInstance].location) {
        CLLocation *location = [ZZUserHelper shareInstance].location;
        [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
        [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lng"];
    }
    WEAK_SELF();
    [GetFastChatManager() asyncFetchFastChatListWithParam:aDcit completeBlock:^(ZZError *error, NSMutableArray<ZZFastChatModel *> *models, NSURLSessionDataTask *task) {
        [weakSelf headerCallBack:error models:models task:task];
    }];
}

- (void)getFootData {
    if (self.models.count) {
        WEAK_SELF();
//        NSMutableDictionary *aDcit = [@{@"sortValue" : self.users.lastObject.sortValue} mutableCopy];
        NSMutableDictionary *aDcit = [@{} mutableCopy];
        if ([ZZUserHelper shareInstance].location) {
            CLLocation *location = [ZZUserHelper shareInstance].location;
            [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
            [aDcit setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lng"];
        }
        ZZFastChatModel *model = self.models.lastObject;
        if (model.sort_value) {
            [aDcit setObject:model.sort_value forKey:@"sort_value"];
            [aDcit setObject:model.current_type forKey:@"current_type"];
        }
        [GetFastChatManager() asyncFetchFastChatListWithParam:aDcit completeBlock:^(ZZError *error, NSMutableArray<ZZFastChatModel *> *models, NSURLSessionDataTask *task) {
            [weakSelf footerCallBack:error models:models task:task];
        }];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)headerCallBack:(ZZError *)error models:(NSMutableArray<ZZFastChatModel *> *)models task:(NSURLSessionDataTask *)task {
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
    } else {
        self.models = models;
        if (self.models.count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [_tableView reloadData];
    }
    [_tableView.mj_header endRefreshing];
}

- (void)footerCallBack:(ZZError *)error models:(NSMutableArray<ZZFastChatModel *> *)models task:(NSURLSessionDataTask *)task {
    [_tableView.mj_footer endRefreshing];
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
    } else {
        if (models.count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.models addObjectsFromArray:models];
            [_tableView reloadData];
        }
    }
}

- (void)fastChatConnectWithIndePath:(NSIndexPath *)indexPath {
    // 先去判断价格配置存不存在，存在继续，不存在着重试
    if (![[ZZUserHelper shareInstance].configModel isPriceConfigExit]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[ZZUserHelper shareInstance].configModel fetchPriceConfig:YES inViewController:self block:^(BOOL isComplete) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (isComplete) {
                [self fastChatConnectWithIndePath:indexPath];
            }
        }];
        return;
    }
    
    [MobClick event:Event_click_FastChat_VideoConnect];
    WEAK_SELF();
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }

    if ([ZZUserHelper shareInstance].loginer.banStatus) {
        [UIAlertController presentAlertControllerWithTitle:@"您已被封禁，请联系在线客服" message:nil doneTitle:@"联系客服" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                ZZChatServerViewController *chatService = [[ZZChatServerViewController alloc] init];
                chatService.conversationType = ConversationType_CUSTOMERSERVICE;
                chatService.targetId = kCustomerServiceId;
                chatService.title = @"客服";
                chatService.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController :chatService animated:YES];
            }
        }];
        return;
    }
    
    if ([ZZUtils isConnecting]) {
        return;
    }
    [ZZHUD show];
    [ZZUserHelper requestMeBiAndMoneynext:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [weakSelf updateMcoinAfterWithIndePath:indexPath];
    }];
}

- (void)updateMcoinAfterWithIndePath:(NSIndexPath *)indexPath {
    if ([[ZZUserHelper shareInstance].loginer.mcoin integerValue] <= 0) {
        NSString *urlKey = [NSString stringWithFormat:@"%@",self.user.uid];
        NSString *urlValue =  [ZZKeyValueStore  getValueWithKey:urlKey];
        if (urlValue) {
            [ZZActivityUrlNetManager loadH5ActiveWithViewController:self isHaveReceived:YES callBack:^{
                [self indexPathWithIndePath:indexPath];
            }];
        }else{
            [ZZActivityUrlNetManager loadH5ActiveWithViewController:self isHaveReceived:NO callBack:^{
                [self indexPathWithIndePath:indexPath];
            }];
             return;
        }
    }
    [self indexPathWithIndePath:indexPath];
}

- (void)indexPathWithIndePath:(NSIndexPath *)indexPath {
    NSInteger totalMoney = [ZZUserHelper shareInstance].configModel.priceConfig.one_card_to_mcoin.integerValue * [ZZUserHelper shareInstance].configModel.priceConfig.per_unit_cost_card.integerValue;
    if ([[ZZUserHelper shareInstance].loginer.mcoin integerValue] < totalMoney) {
        [UIAlertController presentAlertControllerWithTitle:kMsg_Mebi_NO message:nil doneTitle:@"充值" cancelTitle:@"取消" showViewController:self.navigationController completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                [MobClick event:Event_click_FastChat_TopUp];
                ZZMeBiViewController *vc = [ZZMeBiViewController new];
                WS(weakSelf);
                [vc setPaySuccess:^(ZZUser *paySuccesUser) {
                    [weakSelf connectWhenUserClickCallVideoWithIndePath:indexPath];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
     
        return;
    }
    [self connectWhenUserClickCallVideoWithIndePath:indexPath];
}

- (void)connectWhenUserClickCallVideoWithIndePath:(NSIndexPath *)indexPath {
    if ([ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstFastVideo]) {
        [self connectWithIndePath:indexPath];
    }
    else {
        [self showFastConfirmAlert:indexPath];
    }
}

- (void)connectWithIndePath:(NSIndexPath *)indexPath {
    WEAK_SELF();
    //对方user信息
    ZZUser *otherInfo = self.models[indexPath.row].user;
    [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
        if (authorized) {
            [weakSelf gotoRecodeWithOtherUser:otherInfo];
            [weakSelf conncetAuthorizedWithOtherUser:otherInfo];
        }
    }];
}

- (void)gotoRecodeWithOtherUser:(ZZUser *)user {
    WEAK_SELF();
    //对方
    dispatch_async(dispatch_get_main_queue(), ^{
        _connectingVC = [ZZliveStreamConnectingController new];
        _connectingVC.user = user;
        _connectingVC.showCancel = YES;
        WEAK_OBJECT(user, weakUser);
        [_connectingVC setConnectVideoStar:^(id data) {
            // 先进入视频页面
            [weakSelf gotoConnectView:weakUser.uid data:data];
        }];
        
        [weakSelf.navigationController pushViewController:_connectingVC animated:NO];
        [_connectingVC show];
    });
}

- (void)conncetAuthorizedWithOtherUser:(ZZUser *)user {
    [ ZZChatCallIphoneManagerNetWork callIphone:SureCallIphone_MeBiStyle roomid:nil uid:user.uid paramDic:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (error.code == CODE_SHIELDING || error.code == CODE_BANNED) {
                _connectingVC.view.userInteractionEnabled = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSObject asyncWaitingWithTime:1.5 completeBlock:^{
                        [_connectingVC.navigationController popViewControllerAnimated:YES];
                    }];
                });
            }
        } else {
            if (![ZZLiveStreamHelper sharedInstance].isBusy) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //对方
                    _connectingVC.data = data;
                });
            }
        }
    }];
}

- (void)gotoConnectView:(NSString *)uid data:(id)data {
    WEAK_SELF();
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [_connectingView remove];
        
        NSMutableArray<ZZViewController *> *vcs = [self.navigationController.viewControllers mutableCopy];
        [vcs removeLastObject];
        
        ZZLiveStreamConnectViewController *controller = [[ZZLiveStreamConnectViewController alloc] init];
        controller.uid = uid;
        controller.isDisableVideo = _connectingVC.stickerBtn.isSelected;
        [vcs addObject:controller];
        [weakSelf.navigationController setViewControllers:vcs animated:YES];
        
        // 再进行视频连接
        ZZLiveStreamHelper *helper = [ZZLiveStreamHelper sharedInstance];
        helper.targetId = uid;
        helper.data = data;
        helper.isUseMcoin = YES;
        [helper connect:^{
        }];
        helper.failureConnect = ^{
            [controller.navigationController popViewControllerAnimated:YES];
        };
    });
}

/**
 *  视频咨询价格弹窗
 */
- (void)showFastConfirmAlert:(NSIndexPath *)indexPath {
    WEAK_SELF();
    _fastConfirmAlert = [[ZZFastConfirmAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _fastConfirmAlert.touchSure =^{
        if ([ZZUtils isBan]) {
            return;
        }
        BOOL isOpen  = [weakSelf isOpenCameraWith:indexPath];
        if (isOpen) {
            [weakSelf connectWithIndePath:indexPath];
        }
        [MobClick event:Event_click_FastChat_VideoCompleted];
    };
    _fastConfirmAlert.touchCancel =^{
        [MobClick event:Event_click_FastChat_VideoRefused];
    };
    [self.view addSubview:_fastConfirmAlert];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF();
    ZZFastChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ZZFastChatCell reuseIdentifier] forIndexPath:indexPath];
    [cell setupWithModel:self.models[indexPath.row]];
    [cell setFastChatBlock:^{
        [weakSelf fastChatConnectWithIndePath:indexPath];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [UIView new];
//    view.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30, (SCREEN_WIDTH - 30) / HEADER_IMAGE_SCALE + 25);
//    view.backgroundColor = [UIColor whiteColor];
//
//    UIImageView *introduceImageView = [UIImageView new];
//
//    if ([ZZUserHelper shareInstance].isLogin) {
//        if ([ZZUserHelper shareInstance].loginer.open_qchat) {
//            if ([ZZUserHelper shareInstance].loginer.base_video.status == 2) {
//                [introduceImageView sd_setImageWithURL:[NSURL URLWithString:HEADER_IMAGEURL_UNLOGIN] placeholderImage:nil options:(SDWebImageRetryFailed)];
//            } else {
//                [introduceImageView sd_setImageWithURL:[NSURL URLWithString:HEADER_IMAGEURL_LOGIN] placeholderImage:nil options:(SDWebImageRetryFailed)];
//            }
//        } else {
//            [introduceImageView sd_setImageWithURL:[NSURL URLWithString:HEADER_IMAGEURL_UNLOGIN] placeholderImage:nil options:(SDWebImageRetryFailed)];
//        }
//    } else {
//        [introduceImageView sd_setImageWithURL:[NSURL URLWithString:HEADER_IMAGEURL_UNLOGIN] placeholderImage:nil options:(SDWebImageRetryFailed)];
//    }
//    introduceImageView.layer.masksToBounds = YES;
//    introduceImageView.layer.cornerRadius = 4.0f;
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor clearColor];
//    [btn addTarget:self action:@selector(topImageClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    [view addSubview:introduceImageView];
//    [view addSubview:btn];
//
//    [introduceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@15);
//        make.bottom.equalTo(view.mas_bottom).offset(-5);
//        make.leading.trailing.equalTo(view);
//    }];
//
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@10);
//        make.leading.trailing.bottom.equalTo(view);
//    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;// (SCREEN_WIDTH - 30) / HEADER_IMAGE_SCALE + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:Event_click_other_Detail];
    if ([ZZUtils isBan]) {
        return;
    }
    
    ZZUser *user = self.models[indexPath.row].user;
    if (user) {
        ZZRentViewController *controller = [[ZZRentViewController alloc] init];
        controller.uid = user.uid;
        if (![user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
            controller.isFromFastChat = YES;
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
