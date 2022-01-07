//
//  ZZSnatchOrderView.m
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSnatchOrderView.h"

#import "ZZSnatchOrderNotificationCell.h"
#import "ZZSnatchOrderCell.h"
#import "ZZDisturbTimeCell.h"
#import "ZZSnatchListCell.h"
#import "ZZDisturbTimePickerView.h"
#import "ZZSnatchEmptyView.h"
#import "ZZOnlineConfirmAlert.h"
#import "ZZOfflineConfirmAlert.h"
#import "ZZSnatchReceiveModel.h"
#import "ZZLiveStreamHelper.h"
#import "ZZSystemToolsManager.h"
#import "ZZSendVideoManager.h"
#import "ZZVideoUploadStatusView.h"
#import "ZZCloseNotificationAlertView.h"
#import "ZZLocalPushManager.h"
#import "ZZPayViewController.h"
#import "WBActionContainerView.h"
#import "ZZPublishOrderView.h"
#import "ZZRechargeViewController.h"
#import "ZZVideoRuleVC.h"
#import "ZZLinkWebViewController.h"
#import "ZZChatVideoPlayerController.h"

#import "ZZFastRentManager.h"
#import "ZZRequestLiveStreamAlert.h"
#import "ZZTaskPublishConfirmAlert.h"
#import "ZZRequestLiveStreamFailureAlert.h"
#import "ZZLiveStreamEndAlert.h"
#import "ZZPublishingShineView.h"
#import "AdView.h"
#import "ZZMeBiViewController.h"

@interface ZZSnatchOrderView () <UITableViewDelegate,UITableViewDataSource, UIWebViewDelegate, WBSendVideoManagerObserver, WBFastRentManagerObserver>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ZZSnatchReceiveModel *> *dataArray;

@property (nonatomic, strong) UIImageView *animateImgView;

@property (nonatomic, strong) NSMutableArray *deleteArray;//需要删除的数据
@property (nonatomic, strong) NSMutableArray *addArray;//需要添加的数据
@property (nonatomic, assign) BOOL isUpdatingData;//是否正在更新数据

@property (nonatomic, assign) BOOL snatching;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) ZZDisturbTimePickerView *pickerView;
@property (nonatomic, strong) UIView *tipsTopView;

@property (nonatomic, strong) UIImageView *snatchGuideImgView;
@property (nonatomic, strong) UIImageView *waitGuideImgView;

@property (nonatomic, strong) ZZOnlineConfirmAlert *onlineConfirmAlert;
@property (nonatomic, strong) ZZOfflineConfirmAlert *offlineConfirmAlert;
@property (nonatomic, strong) ZZRequestLiveStreamFailureAlert *failureAlert;
@property (nonatomic, strong) AdView *adView;

@property (nonatomic, strong) UIView *webContainerView;
@property (nonatomic, strong) UIButton *webButton;//成为闪租达人

@property (nonatomic, strong) ZZVideoUploadStatusView *model;
@property (nonatomic, strong) ZZSKModel *sk;//录制的达人视频，临时保存，更新成功后=nil
@property (nonatomic, assign) BOOL isUploading;//是否正在上传达人视频

@property (nonatomic, strong) UIView *publishButtonHeaderView;//第一个section HeaderView
@property (nonatomic, strong) UIView *publishButtonSuspensionView;//悬浮HeaderView
@property (nonatomic, strong) UIView *tableViewHeaderView;//banner
@property (nonatomic, assign) CGFloat tableViewHeaderHeight;//banner Height

@property (nonatomic, strong) WBActionContainerView *presentSlider;
@property (nonatomic, strong) ZZPublishOrderView *publishView;

@property (nonatomic, strong) ZZRequestLiveStreamAlert *requestAlertView;//发单的弹窗
@property (nonatomic, strong) ZZTaskPublishConfirmAlert *taskConfirmAlert;//
@property (nonatomic, strong) ZZLiveStreamEndAlert *endAlert;//无法发布任务
@property (nonatomic, strong) ZZPublishingShineView *shineView;

@property (nonatomic, assign) BOOL isUnderway;  // 当前是否处于发布任务中的状态
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSDate *publishDate;//开发发任务的时间，记录主要用于退到后台，NSTimer不计时问题，便于实时刷新剩余时间

@end

@implementation ZZSnatchOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [GetSendVideoManager() addObserver:self];
        [GetFastRentManager() addObserver:self];
        self.backgroundColor = kBGColor;
        
        _user = [ZZUserHelper shareInstance].loginer;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfoAndView) name:kMsg_UploadCompleted object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfoAndView) name:kMsg_UploadAuditFail object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidLogin:)
                                                     name:kMsg_UserLogin
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfoAndView) name:kMsg_UpdatedAvatar object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfoAndView) name:kMsg_UpdatedRentStatus object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfoAndView) name:kMsg_UpdatedGenderStatus object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePublishOrderIfNeed) name:kMsg_UpdatePublishOrderIfNeed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAcceptOrder:) name:kMsg_SnatchPublishOrder object:nil];

        [self createRobTaskUI];

//        if (_user.base_video.sk && _user.base_video.status == 1) {
//        } else {
//            [self createWebView];
//        }
        if (_user.banStatus) {//封禁用户
            [self createWebView];
        } else {//非封禁
            ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos_origin.firstObject;
            if (photo == nil || photo.face_detect_status != 3) {//非真实头像
                [self createWebView];
            } else if (_user.gender_status == 2) {//性别异常
                [self createWebView];
            } else if (_user.rent.status == 0) {//未出租
                [self createWebView];
            } else if (_user.rent.status == 2 && !_user.rent.show) {//已出租，但是隐身了
                [self createWebView];
            }
        }
    }
    return self;
}

// 监听登录
- (void)userDidLogin:(NSNotification *)notificatio {
    
    if ([ZZUserHelper shareInstance].isLogin) {
        _user = [ZZUserHelper shareInstance].loginer;
        self.dataArray = [NSMutableArray new];
        [self.tableView reloadData];
        [self updateUserInfoAndView];
    }
}

// 需要更新抢任务列表
- (void)updatePublishOrderIfNeed {
    [self loadData];
}

// 更新开通状态
- (void)updateUserInfoAndView {
    _user = [ZZUserHelper shareInstance].loginer;
    
    WEAK_SELF();
    if (_user.banStatus) {//封禁用户
        [self createWebView];
        return;
    } else {//非封禁
        ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos_origin.firstObject;
        if (photo == nil || photo.face_detect_status != 3) {//非真实头像
            [self createWebView];
            return;
        } else if (_user.gender_status == 2) {//性别异常
            [self createWebView];
            return;
        } else if (_user.rent.status == 0) {//未出租
            [self createWebView];
            return;
        } else if (_user.rent.status == 2 && !_user.rent.show) {//已出租，但是隐身了
            [self createWebView];
            return;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.webContainerView removeAllSubviews];
        [weakSelf.webContainerView removeFromSuperview];
        weakSelf.webContainerView = nil;
        weakSelf.tableView.scrollEnabled = YES;
        
        [weakSelf loadData];
    });
}


- (void)createRobTaskUI {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (!isNullString(_user.push_config.pd_push_begin_at)) {
            [self.param setObject:_user.push_config.pd_push_begin_at forKey:@"pd_push_begin_at"];
            [self.param setObject:_user.push_config.pd_push_end_at forKey:@"pd_push_end_at"];
        }
        if (!isNullString(_user.push_config.pd_push_begin_at)) {
            _timeString = [NSString stringWithFormat:@"%@至%@",_user.push_config.pd_push_begin_at,_user.push_config.pd_push_end_at];
        } else {
            _timeString = [NSString stringWithFormat:@"23:00至06:00"];
        }
        
        self.tableView.backgroundColor = kBGColor;
        
        // 悬浮 HeaderView
        self.publishButtonSuspensionView = [self createSectionPublishButtonView];
        [self addSubview:self.publishButtonSuspensionView];
        self.publishButtonSuspensionView.hidden = YES;
        [self.publishButtonSuspensionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@100);
        }];
        
        [self createFootRefresh];
        [self createTimer];
        [self loadData];
        [self addNotification];
        [self createTopTipsView];
    });
}

// 成为闪租达人View
- (void)createWebView {
//
//    _user = [ZZUserHelper shareInstance].loginer;
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        self.dataArray = [NSMutableArray new];
//        [self.tableView reloadData];
//        if (self.webContainerView) {// 如果已经存在当前的UI ，则不再重新创建, 只更新Btn状态
//
//            if (_user.banStatus) {//封禁用户
//                [self.webButton setTitle:@"您违反平台规则，已经被封禁" forState:(UIControlStateNormal)];
//                self.webButton.enabled = NO;
//
//            } else {//非封禁
//                ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos.firstObject;
//                if (photo == nil || photo.face_detect_status != 3) {//非真实头像
//                    [self.webButton setTitle:@"申请成为达人" forState:(UIControlStateNormal)];
//
//                } else if (_user.gender_status == 2) {//性别异常
//
//                    [self.webButton setTitle:@"申请成为达人" forState:(UIControlStateNormal)];
//
//                } else if (_user.rent.status == 0) {//未出租
//
//                    [self.webButton setTitle:@"申请成为达人" forState:(UIControlStateNormal)];
//
//                } else if (_user.rent.status == 2 && !_user.rent.show) {//已出租，但是隐身了
//                    [self.webButton setTitle:@"您当前出租状态为隐身中，请修改状态" forState:(UIControlStateNormal)];
//
//                }
//            }
//            return ;
//        }
//
//        // 增加H5遮罩之前，先把 header 可能没有就加上，并且禁止 滚动
//        if (![ZZUserHelper shareInstance].configModel.pd.hide_banner) {
//            self.tableViewHeaderView = [self createTableViewHeaderView];
//            self.tableView.tableHeaderView = self.tableViewHeaderView;
//        }
//
//        self.tableView.scrollEnabled = NO;
//
//        // 创建遮罩H5
//        self.webContainerView = [UIView new];
//        self.webContainerView.backgroundColor = [UIColor clearColor];
//        [self addSubview:self.webContainerView];
//        [self.webContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@(self.tableViewHeaderHeight + self.publishButtonSuspensionView.height));
//            make.leading.trailing.bottom.equalTo(@0);
//        }];
//
//        NSString *htmlString = [NSString stringWithFormat:@"http://7xwsly.com1.z0.glb.clouddn.com/shanzu2/index.html?v=1"];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlString]];
//
//        UIWebView *webView = [[UIWebView alloc] init];
//        webView.scalesPageToFit = YES;
//        webView.opaque = NO;
//        webView.delegate = self;
//        webView.backgroundColor = kBGColor;
//        webView.userInteractionEnabled = NO;
//        webView.scrollView.showsHorizontalScrollIndicator = NO;
//        webView.scrollView.scrollEnabled = YES;
//        webView.layer.masksToBounds = YES;
//        webView.layer.cornerRadius = 3.0f;
//        [webView loadRequest:request];
//
//        [self.webContainerView addSubview:webView];
//
//        self.webButton = [UIButton buttonWithType:UIButtonTypeCustom];
////        if (_user.base_video.status == 2) {
////            [self.webButton setTitle:@"达人视频未通过，重新上传" forState:(UIControlStateNormal)];
////        } else {
////            [self.webButton setTitle:@"成为闪租达人" forState:(UIControlStateNormal)];
////        }
//        [self.webButton setTitleColor:kBlackColor forState:UIControlStateNormal];
//        self.webButton.titleLabel.font = [UIFont systemFontOfSize:16];
//        self.webButton.backgroundColor = RGBCOLOR(244, 203, 7);
//        [self.webButton addTarget:self action:@selector(perfectVideoInformation) forControlEvents:UIControlEventTouchUpInside];
//        self.webButton.layer.masksToBounds = YES;
//        self.webButton.layer.cornerRadius = 3.0f;
//
//        if (_user.banStatus) {//封禁用户
//            [self.webButton setTitle:@"您违反平台规则，已经被封禁" forState:(UIControlStateNormal)];
//            self.webButton.enabled = NO;
//
//        } else {//非封禁
//            ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos.firstObject;
//            if (photo == nil || photo.face_detect_status != 3) {//非真实头像
//                [self.webButton setTitle:@"申请成为达人" forState:(UIControlStateNormal)];
//
//            } else if (_user.gender_status == 2) {//性别异常
//
//                [self.webButton setTitle:@"申请成为达人" forState:(UIControlStateNormal)];
//
//            } else if (_user.rent.status == 0) {//未出租
//                [self.webButton setTitle:@"申请成为达人" forState:(UIControlStateNormal)];
//
//            } else if (_user.rent.status == 2 && !_user.rent.show) {//已出租，但是隐身了
//                [self.webButton setTitle:@"您当前出租状态为隐身中，请修改状态" forState:(UIControlStateNormal)];
//            }
//        }
//        [self.webContainerView addSubview:self.webButton];
//
//        [self.webButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(@(-30));
//            make.leading.equalTo(@20);
//            make.trailing.equalTo(@(-20));
//            make.height.equalTo(@45);
//        }];
//
//        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@0);
//            make.bottom.equalTo(@(-5));
//            make.leading.equalTo(@5);
//            make.trailing.equalTo(@(-5));
//        }];
//    });
}

- (void)createTopTipsView {
    self.tipsTopView = [UIView new];
    self.tipsTopView.frame = CGRectMake(0, -25, SCREEN_WIDTH, 25);
    self.tipsTopView.alpha = 0.0f;
    self.tipsTopView.backgroundColor = [RGBCOLOR(236, 108, 100) colorWithAlphaComponent:0.9];
    
    UILabel *tips = [UILabel new];
    tips.text = @"为了让您获取更多收益，已为您开启任务通知";
    tips.textColor = [UIColor whiteColor];
    tips.font = [UIFont systemFontOfSize:13];
    tips.frame = CGRectMake(8, 0, SCREEN_WIDTH, 25);
    
    [self.tipsTopView addSubview:tips];
    [self addSubview:_tipsTopView];
}

// 开通点击事件
- (void)perfectVideoInformation {
    
    if (_isUploading) {
        [ZZHUD showErrorWithStatus:@"视频正在上传"];
        return;
    }
    [MobClick event:Event_click_Apply_talent];
    
    if (_user.banStatus) {//封禁用户
        
    } else {//非封禁
        ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos_origin.firstObject;
        if (photo == nil || photo.face_detect_status != 3) {//非真实头像
//            BLOCK_SAFE_CALLS(self.becomeTalentNoFaceBlock, NO);
            BLOCK_SAFE_CALLS(self.noRealPictureBlock);
        } else if (_user.gender_status == 2) {//性别异常
            BLOCK_SAFE_CALLS(self.genderAbnormalBlock);
        } else if (_user.rent.status == 0) {//未出租
            BLOCK_SAFE_CALLS(self.rentStatusNone);
        } else if (_user.rent.status == 2 && !_user.rent.show) {//已出租，但是隐身了
            BLOCK_SAFE_CALLS(self.rentStatusInvisible);
        }
    }
}

- (void)createTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)createTimer2
{
    //增加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRemainingTime2)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    if (_timer) {
        [self clearTimer2];
    }
    self.publishDate = [NSDate new];
    _shineView.during = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent2) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - WBFastRentManagerObserver

//  闪租发布任务发生变化: 1: 发布中  0: 取消发布
- (void)missionDidChangeWithUnderway:(NSString *)isUnderway {
    self.isUnderway = [isUnderway isEqualToString:@"1"];
}

- (void)timerEvent2 {
    
    if (!self.isUnderway) {
        [self clearTimer2];
        return;
    }
    _count--;
    [GetFastRentManager() syncUpdateRemainingTimeWithTime:INT_TO_STRING(_count)];
    self.shineView.during = _count;
    if (_count <= 0) {
        [ZZHUD showTaskInfoWithStatus:@"暂无合适达人抢您的任务"];
        [self removeShineViews];
        [self clearTimer2];
    }
}

- (void)updateRemainingTime2 {
    if (_count <= 0) {
        return;
    }
    NSTimeInterval delta = [[NSDate new] timeIntervalSinceDate:self.publishDate]; // 计算出相差多少秒
    
    NSTimeInterval sum = self.publishView.skill.type == 1 ? 600 : 180;
    _count = (sum - delta);//剩余时间
}

- (void)timerEvent
{
    for (ZZSnatchReceiveModel *model in self.dataArray) {
        if (model.pd_receive.remain_time_receiver != 0 ) {
            if (model.pd_receive.pd.type == 3 && model.pd_receive.status == 1) {
                // 线下单，已被抢
            } else {
                if (model.pd_receive.remain_time_receiver > 100) {
                    model.pd_receive.remain_time_receiver = model.pd_receive.remain_time_receiver - 100;
                } else {//倒计时结束
                    model.pd_receive.remain_time_receiver = 0;
                    model.pd_receive.status = 2;
                    
                    // 当前是登录状态
                    if ([ZZUserHelper shareInstance].isLogin) {
                        // 抢的单 等待超时了，发送一个本地推送告知达人
//                        NSDictionary *content = @{@"type" : @"100"};
//                        [GetLocalPushManager() localPushWithContent:content];
                    }
                }
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:OrderTimeCountNotification object:nil];
    [self updateUnreadCount];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kMsg_UserLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePublishOrder:) name:kMsg_ReceivePublishOrder object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePublishOrder:) name:kMsg_UpdateSnatchedPublishOrder object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptSantch:) name:kMsg_AcceptSnatchOrder object:nil];
}

#pragma mark - Data

- (void)loadData
{
    if (_user.banStatus) {//封禁用户
        return;
    } else {//非封禁
        ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos_origin.firstObject;
        if (photo == nil || photo.face_detect_status != 3) {//非真实头像
            return;
            
        } else if (_user.gender_status == 2) {//性别异常
            return;
        } else if (_user.rent.status == 0) {//未出租
            return;
            
        } else if (_user.rent.status == 2 && !_user.rent.show) {//已出租，但是隐身了
            return;
        }
    }

    [self pullRequest:nil];
}

- (void)pullRequest:(NSString *)sort_value
{
    NSDictionary *param = nil;
    if (sort_value) {
        param = @{@"sort_value":sort_value};
    }
    [ZZSnatchReceiveModel getMySantchReceiveList:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            NSMutableArray *array = [ZZSnatchReceiveModel arrayOfModelsFromDictionaries:data error:nil];
            if (sort_value) {
                [self.dataArray addObjectsFromArray:array];
            } else {
                self.dataArray = array;
            }
            if (array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            for (ZZSnatchReceiveModel *model in array) {
                if (model.pd_receive.status == 0) {
                    if ([self.dataArray containsObject:model]) {
                        NSInteger index = [self.dataArray indexOfObject:model];
                        [self showSnatchGuide:index];
                        break;
                    }
                } else if (model.pd_receive.status == 1) {
                    if ([self.dataArray containsObject:model]) {
                        NSInteger index = [self.dataArray indexOfObject:model];
                        [self showWaitGuide:index];
                        break;
                    }
                }
            }
            [self.tableView reloadData];
            [self sortingUpdate];
            [self removeFootRefresh];
        }
    }];
}

- (void)createFootRefresh
{
    if (!self.tableView.mj_footer) {
        WeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                ZZSnatchReceiveModel *lastModel = [weakSelf.dataArray lastObject];
                [weakSelf pullRequest:lastModel.sort_value];
            }];
        });
    }
}

- (void)removeFootRefresh
{
    if (_dataArray.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _tableView.mj_footer = nil;
            [self.tableView reloadData];
        });
    }
}

#pragma mark - 数据插入删除操作

- (void)addData:(ZZSnatchReceiveModel *)model
{
    if (_isUpdatingData) {
        [self.addArray addObject:model];
    } else {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:model];
        [self insertCells:array];
    }
    WEAK_SELF();
    [NSObject asyncWaitingWithTime:0.5f completeBlock:^{
        [weakSelf sortingUpdate];
    }];
}

- (void)insertCells:(NSMutableArray *)array
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(ZZSnatchReceiveModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArray insertObject:model atIndex:0];
        BOOL contain = NO;
        if ([self.addArray containsObject:model]) {
            [self.addArray removeObject:model];
            contain = YES;
        }
        if (contain) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.addArray.count - 1 - idx) inSection:1];
            [indexPaths addObject:indexPath];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [indexPaths addObject:indexPath];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [CATransaction begin];
        [CATransaction setCompletionBlock: ^{
            [self animationComplete];
            [self showSnatchGuide:0];
        }];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
        [CATransaction commit];
    });
}

- (void)deleteData:(ZZSnatchReceiveModel *)model
{
    if (_isUpdatingData) {
        [self.deleteArray addObject:model];
    } else {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:model];
        [self deleteCells:array];
    }
}

- (void)deleteCells:(NSMutableArray *)array
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(ZZSnatchReceiveModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.deleteArray insertObject:model atIndex:0];
        if ([self.deleteArray containsObject:model]) {
            [self.deleteArray removeObject:model];
        }
        if ([self.dataArray containsObject:model]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:model] inSection:1];
            [indexPaths addObject:indexPath];
        }
    }];
    [self.dataArray removeObjectsInArray:array];
    dispatch_async(dispatch_get_main_queue(), ^{
        [CATransaction begin];
        [CATransaction setCompletionBlock: ^{
            [self animationComplete];
        }];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [CATransaction commit];
    });
}

- (void)animationComplete
{
    self.isUpdatingData = NO;
    if (self.addArray.count) {
        self.isUpdatingData = YES;
        [self insertCells:self.addArray];
    } else if (self.deleteArray.count) {
        self.isUpdatingData = YES;
        [self deleteCells:self.deleteArray];
    }
    
    if (!self.isUpdatingData) {
        [self sortingUpdate];
    }
}

#pragma mark - notification

- (void)snatchOrder:(NSIndexPath *)indexPath
{
    if (_snatching) {
        return;
    }
    [self hideSnatchGuide];
    ZZSnatchReceiveModel *model = self.dataArray[indexPath.row];
    if (model.pd_receive.status == 0) {
        if ([ZZUtils isConnecting]) {
            return;
        }
        //抢任务埋点
        [MobClick event:Event_click_snatch_task];
        [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/pd_receive/%@/grab",model.pd_receive.id] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            _snatching = NO;
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                model.pd_receive.status = 1;
                model.pd_receive.remain_time_receiver = model.pd_receive.pd.valid_duration*60*1000;
                [ZZHUD showSuccessWithStatus:@"已抢任务，请等待对方选取"];
                
                if ([self.dataArray containsObject:model]) {
                    NSInteger index = [self.dataArray indexOfObject:model];
                    [self showWaitGuide:index];
                }
                [self updateUnreadCount];

            }
        }];
    }
}

- (void)receivePublishOrder:(NSNotification *)notification
{
    ZZSnatchReceiveModel *model = [[ZZSnatchReceiveModel alloc] initWithDictionary:notification.userInfo error:nil];
    if (model) {
        BOOL haveSameId = NO;   //防止对方发出订单时，接口和融云同时读取到订单信息，出现两个一样的单
        for (ZZSnatchReceiveModel *aModel in self.dataArray) {
            if ([model.pd_receive.id isEqualToString:aModel.pd_receive.id]) {
                haveSameId = YES;
                break;
            }
        }
        if (!haveSameId) {
            [self addData:model];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdateTaskSnatchCount object:nil];
        }
    }
    [self createFootRefresh];
}

- (void)updatePublishOrder:(NSNotification *)notification
{
    ZZSnatchModel *model = [[ZZSnatchModel alloc] initWithDictionary:notification.userInfo error:nil];
    for (ZZSnatchReceiveModel *aModel in self.dataArray) {
        if ([model.id isEqualToString:aModel.pd_receive.id]) {
            aModel.pd_receive.remain_time_receiver = 0;
            aModel.pd_receive.status = 2;
            aModel.pd_receive.pd.from.avatar = model.pd.from.avatar;
            aModel.pd_receive.pd.is_anonymous = model.pd.is_anonymous;
            aModel.pd_receive.pd.from.nickname = model.pd.from.nickname;
            [self sortingUpdate];
            break;
        }
    }
}

- (void)acceptSantch:(NSNotification *)notification
{
    NSInteger type = [[notification.userInfo objectForKey:@"type"] integerValue];
    if (type == 8 || type == 9001) {    //type：8.线下单被选 9001.线上单接受视频
        NSString *pdreceive_id = [notification.userInfo objectForKey:@"pdreceive_id"];
        NSInteger pd_type = [[notification.userInfo objectForKey:@"pd_type"] integerValue];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
        for (ZZSnatchReceiveModel *aModel in array) {
            if ([aModel.pd_receive.id isEqualToString:pdreceive_id]) {
                [self deleteData:aModel];
            } else if (aModel.pd_receive.status == 1 && pd_type == 2 && aModel.pd_receive.pd.type == 2) {
                aModel.pd_receive.status = 2;
            }
        }
        [self sortingUpdate];
    }
}

- (void)userDidLogin
{
    [self loadData];
}

- (UIView *)createTableViewHeaderView {
    CGFloat scale = SCREEN_WIDTH / 375.0f;
    self.tableViewHeaderHeight = 124.0f * scale;
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableViewHeaderHeight);

//    UIImageView *bannerImageView = [UIImageView new];
////    bannerImageView.image = [UIImage imageNamed:@""];
//    [bannerImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517159968330&di=0e79fa9ae461e17d921dbd7fc82e2d72&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F12%2F92%2F31%2F16X58PICcW2.jpg"] placeholderImage:nil options:(SDWebImageRetryFailed)];
//    [view addSubview:bannerImageView];
//    [bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.leading.trailing.bottom.equalTo(view);
//    }];
    WEAK_SELF();
    NSMutableArray<NSString *> *imgUrls = [NSMutableArray new];
    [[ZZUserHelper shareInstance].configModel.pd.banners enumerateObjectsUsingBlock:^(ZZBannersModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imgUrls addObject:obj.cover_url];
    }];
    
    self.adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableViewHeaderHeight) imageLinkURL:imgUrls placeHoderImageName:nil pageControlShowStyle:UIPageControlShowStyleCenter];
    _adView.pageControl.currentPageIndicatorTintColor = kYellowColor;
    [self.adView setCallBack:^(NSInteger index, NSString *imageURL) {
        [weakSelf bannerClickWithIndex:index];
    }];
    [view addSubview:_adView];
    return view;
}

- (IBAction)bannerClickWithIndex:(NSInteger)index {
    ZZBannersModel *model = [ZZUserHelper shareInstance].configModel.pd.banners[index];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    if (model.type == 1) { // 下载图片形式
        ZZVideoRuleVC *vc = [ZZVideoRuleVC new];
        vc.urlString = model.link_url;
        vc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:vc animated:YES];
    }
    else if (model.type == 2) { // H5 链接形式
        ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
        controller.urlString = model.link_url;
        controller.showShare = NO;
        controller.hidesBottomBarWhenPushed = YES;
        controller.isHideBar = YES;
        [nav pushViewController:controller animated:YES];
    }
    else if (model.type == 3) { // 视频展示形式
        ZZChatVideoPlayerController *playerVC = [[ZZChatVideoPlayerController alloc] init];
        playerVC.entrance = EntranceOthers;
        playerVC.videoUrl = model.link_url;
        [nav presentViewController:playerVC animated:YES completion:nil];
    }
}

- (UIView *)createSectionPublishButtonView {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    view.backgroundColor = kBGColor;
    
    UIView *shadowView = [UIView new];
    shadowView.frame = CGRectMake(5, 5, SCREEN_WIDTH - 10, 90);
    shadowView.backgroundColor = RGBCOLOR(190, 190, 190);
    shadowView.layer.shadowColor = RGBCOLOR(190, 190, 190).CGColor;//阴影颜色
    shadowView.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
    shadowView.layer.shadowOpacity = 0.5;//不透明度
    shadowView.layer.shadowRadius = 2.0f;
    shadowView.layer.cornerRadius = 4.0f;
    [view addSubview:shadowView];
    
    UIView *bgWhiteView = [UIView new];
    bgWhiteView.backgroundColor = [UIColor whiteColor];
    bgWhiteView.frame = CGRectMake(5, 5, SCREEN_WIDTH - 10, 90);
    bgWhiteView.layer.masksToBounds = YES;
    bgWhiteView.layer.cornerRadius = 3.0f;
    [view addSubview:bgWhiteView];
    
    self.animateImgView = [[UIImageView alloc] init];
    self.animateImgView.image = [UIImage imageNamed:@"icon_livestream_publish_bg"];
    self.animateImgView.alpha = 1;
    self.animateImgView.layer.cornerRadius = 55/2.0f;
    self.animateImgView.clipsToBounds = YES;
    [bgWhiteView addSubview:self.animateImgView];
    
    [self.animateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgWhiteView);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    UIButton *publishBtn = [[UIButton alloc] init];
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"icon_livestream_publish_bg"] forState:UIControlStateNormal];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    publishBtn.layer.cornerRadius = 55/2.0f;
    publishBtn.clipsToBounds = YES;
    [bgWhiteView addSubview:publishBtn];
    
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgWhiteView);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"闪租任务";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = kBlackColor;
    
    [bgWhiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(publishBtn.mas_trailing).offset(15);
        make.centerY.equalTo(publishBtn.mas_centerY);
    }];
    
    UIImageView *rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_rightBtn"]];
    [bgWhiteView addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-15));
        make.centerY.equalTo(publishBtn.mas_centerY);
        make.width.equalTo(@7.5);
        make.height.equalTo(@16.9);
    }];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.text = @"做什么";
    tipsLabel.textColor = kGrayTextColor;
    tipsLabel.font = [UIFont systemFontOfSize:15];
    [bgWhiteView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightImage.mas_centerY);
        make.trailing.equalTo(rightImage.mas_leading).offset(-10);
    }];
    
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.backgroundColor = [UIColor clearColor];
    [clickBtn addTarget:self action:@selector(publishClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgWhiteView addSubview:clickBtn];
    [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(bgWhiteView);
    }];
    
    [self beginAnimation];
    return view;
}

- (IBAction)publishClick:(id)sender {
    
    [self.presentSlider present];
    [self.publishView showTaskChooseIsAllDismiss:YES];
    
    [self.presentSlider dismiss];
}

- (void)beginAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.4]; // 结束时的倍率
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

#pragma mark - UITabelViewMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
//        return _user.push_config.pd_push ? 2:1;
//        return 1;
        return 0;
    } else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *notiFicationID = @"notification";
            ZZSnatchOrderNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:notiFicationID];
            cell.aSwitch.on = _user.push_config.pd_push;
            if (![GetSystemToolsManager() isOpenSystemNotification]) {
                cell.aSwitch.on = NO;
            }
            [cell.aSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
        else {
            ZZDisturbTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timecell"];
            cell.titleLabel.text = @"设置通知时间段";
            if (!isNullString(_user.push_config.pd_push_begin_at)) {
                _timeString = [NSString stringWithFormat:@"%@至%@",_user.push_config.pd_push_begin_at,_user.push_config.pd_push_end_at];
            }
            cell.contentLabel.text = _timeString;
            return cell;
        }
    } else {
        if (indexPath.row < self.dataArray.count) {
            ZZSnatchReceiveModel *model = self.dataArray[indexPath.row];
            WS(weakSelf);
            if (model.pd_receive.pd.type == 3) { // 线下单
                ZZSnatchListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
                [cell setData:model];
                __weak typeof(cell)weakCell = cell;
                cell.touchSnatch = ^{
                    [weakSelf touchSnatch:weakCell];
                };
                cell.touchLocation = ^{
                    [weakSelf touchLocation:weakCell];
                };
                cell.headImgView.touchHead = ^{
                    [weakSelf touchHead:weakCell];
                };
                return cell;
            } else { // 线上单
                static NSString *mycellID = @"mycell";
                ZZSnatchOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:mycellID];
                [cell setData:model];
                __weak typeof(cell)weakCell = cell;
                cell.headImgView.touchHead = ^{
                    [weakSelf touchHead:weakCell];
                };
                cell.touchSnatch = ^{
                    [weakSelf touchSnatch:weakCell];
                };
                
                return cell;
            }
        }
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return indexPath.row == 0? 70:50;
    } else {
        if (indexPath.row < self.dataArray.count) {
            ZZSnatchReceiveModel *model = self.dataArray[indexPath.row];
            if (model.pd_receive.pd.type == 3) {
                return [tableView fd_heightForCellWithIdentifier:@"list" cacheByIndexPath:indexPath configuration:^(ZZSnatchListCell *cell) {
                    [cell setData:model];
                }];
            } else {
                return 117;
            }
        }
        return 117;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        if (!_publishButtonHeaderView) {
//            _publishButtonHeaderView = [self createSectionPublishButtonView];
//        }
//        return _publishButtonHeaderView;
//    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 3)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 100;
//    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && _dataArray && _dataArray.count == 0) {
        return SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT;
    } else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 && _dataArray && _dataArray.count == 0) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
        
        ZZSnatchEmptyView *emptyView = [[ZZSnatchEmptyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, footView.height)];
        [footView addSubview:emptyView];
        
        return footView;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"contentOffset -- %.2f", scrollView.contentOffset.y);
//    NSLog(@"contentSize -- %.2f", scrollView.contentSize.height);
////    NSLog(@"222222");
//    if (self.tableViewHeaderView) {
//        
//        if (scrollView.contentOffset.y > self.tableViewHeaderHeight) {//当 tableViewHeaderView存在时，只会执行一次
//            
//            [self.tableViewHeaderView removeFromSuperview];
//            self.tableViewHeaderView = nil;
//            self.tableView.tableHeaderView = nil;
//            
//            [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y - self.tableViewHeaderHeight)];
//            scrollView.contentSize = CGSizeMake(0, scrollView.contentSize.height + 36);
//            scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top - 36, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
//            scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(scrollView.scrollIndicatorInsets.top - 36, scrollView.scrollIndicatorInsets.left, scrollView.scrollIndicatorInsets.bottom, scrollView.scrollIndicatorInsets.right);
//            
//            [self.tableView reloadData];
//            NSLog(@"contentOffset -- %.2f", scrollView.contentOffset.y);
//            NSLog(@"contentSize -- %.2f", scrollView.contentSize.height);
//            NSLog(@"应该只会执行一次...1111");
//        } else {
//            
//            self.publishButtonSuspensionView.hidden = YES;
//            _publishButtonHeaderView.hidden = NO;
//            
//        }
//    } else {
//        
//        if (scrollView.contentOffset.y > 36.0) {//显示悬浮HeaderView
//            NSLog(@"contentOffset -- %.2f", scrollView.contentOffset.y);
//            NSLog(@"contentSize -- %.2f", scrollView.contentSize.height);
//
//            NSLog(@"3333333");
//            self.publishButtonSuspensionView.hidden = NO;
//            _publishButtonHeaderView.hidden = YES;
//
//        } else {
//            
//            self.publishButtonSuspensionView.hidden = YES;
//            _publishButtonHeaderView.hidden = NO;
//        }
//        
//        if (![ZZUserHelper shareInstance].configModel.pd.hide_banner) {// 苹果审核期间，没有头部Header
//            
//            if (scrollView.contentOffset.y <= (-30.0)) {//用力一定的偏移量，则重新显示出 banner
//                self.tableViewHeaderView = [self createTableViewHeaderView];
//                self.tableViewHeaderView.alpha = 0.0f;
//                self.tableView.tableHeaderView = self.tableViewHeaderView;
//                
//                scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top + 36, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
//                scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(scrollView.scrollIndicatorInsets.top + 36, scrollView.scrollIndicatorInsets.left, scrollView.scrollIndicatorInsets.bottom, scrollView.scrollIndicatorInsets.right);
//                
//                [UIView animateWithDuration:0.4 animations:^{
//                    self.tableViewHeaderView.alpha = 1.0f;
//                    [self.tableView reloadData];
//                } completion:^(BOOL finished) {
//                }];
//            }
//        }
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [self.pickerView show:_timeString];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)touchHead:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZZSnatchReceiveModel *model = self.dataArray[indexPath.row];
    if (model.pd_receive.pd.is_anonymous == 2) {
        return;
    }
    if (_gotoUserPage) {
        _gotoUserPage(model.pd_receive.pd.from.uid);
    }
}

- (void)touchSnatch:(UITableViewCell *)cell
{
    if ([ZZUtils isConnecting]) {
        return;
    }
    
    WEAK_SELF();
    // 如果没有人脸
    if ([ZZUserHelper shareInstance].loginer.faces.count == 0) {

        BLOCK_SAFE_CALLS(self.noFaceBlock);
        return;
    }
    
    // 如果没有头像
    ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos_origin.firstObject;
    if (photo == nil || photo.face_detect_status != 3) {
        
        BLOCK_SAFE_CALLS(self.noRealPictureBlock);
        return;
    }

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZZSnatchReceiveModel *model = self.dataArray[indexPath.row];
    if (model.pd_receive.status == 1) {
        [ZZHUD showInfoWithStatus:@"已抢任务，请等待对方选取"];
        return;
    }
    if (model.pd_receive.pd.type == 2) {
        
        if ([ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstOnline]) {
            [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
                if (authorized) {
                    [weakSelf snatchOrder:indexPath];
                }
            }];
        } else {
            _onlineConfirmAlert = [[ZZOnlineConfirmAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _onlineConfirmAlert.touchSure =^{
                [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
                    if (authorized) {
                        [weakSelf snatchOrder:indexPath];
                    }
                }];
            };
            _onlineConfirmAlert.touchCancel =^{
                
            };
            [self.window addSubview:_onlineConfirmAlert];
        }
    } else {
        
        if ([ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstOffLine]) {
            [weakSelf snatchOrder:indexPath];
        } else {
            _offlineConfirmAlert = [[ZZOfflineConfirmAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _offlineConfirmAlert.touchSure =^{
                [weakSelf snatchOrder:indexPath];
            };
            _offlineConfirmAlert.touchCancel =^{
            };
            [self.window addSubview:_offlineConfirmAlert];
        }
    }
}

- (void)updateUnreadCount {
    
    __block NSInteger count = 0;
    [self.dataArray enumerateObjectsUsingBlock:^(ZZSnatchReceiveModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.pd_receive.status == 0 && obj.pd_receive.remain_time_receiver != 0) {
            count += 1;
        }
    }];
    [ZZUserHelper shareInstance].unreadModel.pd_receive = count;
    [[NSNotificationCenter defaultCenter] postNotificationName:KMsg_UpdateSnatchUnreadCount object:nil];
}

- (void)touchLocation:(ZZSnatchListCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZZSnatchReceiveModel *model = self.dataArray[indexPath.row];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[model.pd_receive.pd.address_lat floatValue] longitude:[model.pd_receive.pd.address_lng floatValue]];
    if (_gotoLocationDetail) {
        _gotoLocationDetail(location,model.pd_receive.pd.address);
    }
}

// 置顶操作
- (void)sortingUpdate {
//    置顶规则：
//    1、线下单状态为“抢”和“待”的全部置顶，1V1视频单插入到线下单之后
//    2、线下单状态为“已被抢”的，则取消置顶，移至“抢”和“待”订单下面。

    NSMutableArray<ZZSnatchReceiveModel *> *offlineGrab = [NSMutableArray new];     // 线下抢单
    NSMutableArray<ZZSnatchReceiveModel *> *offlineWait = [NSMutableArray new];     // 线下等待
    NSMutableArray<ZZSnatchReceiveModel *> *onlineGrab = [NSMutableArray new];      // 线上抢单
    NSMutableArray<ZZSnatchReceiveModel *> *onlineWait = [NSMutableArray new];      // 线上等待
    NSMutableArray<ZZSnatchReceiveModel *> *other = [NSMutableArray new];      // 其他
    [self.dataArray enumerateObjectsUsingBlock:^(ZZSnatchReceiveModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if (obj.pd_receive.pd.type == 3) {  // 线下
            
            if (obj.pd_receive.status == 0) {   // 可抢
                [offlineGrab addObject:obj];
            } else if (obj.pd_receive.status == 1) {    // 等待
                [offlineWait addObject:obj];
            } else {    // 其他
                [other addObject:obj];
            }
        } else {    // 线上
            if (obj.pd_receive.status == 0) {   // 可抢
                [onlineGrab addObject:obj];
            } else if (obj.pd_receive.status == 1) {    // 等待
                [onlineWait addObject:obj];
            } else {    // 其他
                [other addObject:obj];
            }
        }
    }];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:offlineGrab];
    [self.dataArray addObjectsFromArray:offlineWait];
    [self.dataArray addObjectsFromArray:onlineGrab];
    [self.dataArray addObjectsFromArray:onlineWait];
    [self.dataArray addObjectsFromArray:other];    
    WeakSelf
    dispatch_time_t afterTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
    dispatch_after(afterTime, dispatch_get_main_queue(), ^{
//        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdateTaskSnatchCount object:nil];
        [weakSelf.tableView reloadData];
        [weakSelf updateUnreadCount];
    });
}

#pragma mark - notification

- (void)receiveAcceptOrder:(NSNotification *)notification
{
    [self clearTimer2];
    [self removeShineViews];
}

#pragma mark -

- (void)switchDidChange:(UISwitch *)sender {
    
    WEAK_SELF();
    if ([GetSystemToolsManager() isOpenSystemNotification]) {
        if (!sender.isOn) {
            ZZCloseNotificationAlertView *alert = [[ZZCloseNotificationAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [alert setDoneBlock:^{
                BOOL isOn = sender.on;
                [weakSelf.param setObject:[NSNumber numberWithBool:isOn] forKey:@"pd_push"];
                ZZUser *model = [[ZZUser alloc] init];
                [model updateWithParam:@{@"push_config":weakSelf.param} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                        sender.on = !isOn;
                    } else {
                        _user = [[ZZUser alloc] initWithDictionary:data error:nil];
                        _user.push_config.pd_push = isOn;
                        [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
                        [weakSelf.tableView reloadData];
                    }
                }];
            }];
            [alert setCancelBlock:^{
                sender.on = YES;
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            return ;
        }
    }
    
    if (sender.isOn && ![GetSystemToolsManager() isOpenSystemNotification]) {
        [UIAlertController presentAlertControllerWithTitle:nil message:@"你现在无法收到抢任务通知。请到系统“设置”-“通知”-“空虾”中开启。" doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                if (UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:appSettings];
                }
            }
        }];
        sender.on = NO;
        return;
    }
    BOOL isOn = sender.on;
    [self.param setObject:[NSNumber numberWithBool:isOn] forKey:@"pd_push"];
    ZZUser *model = [[ZZUser alloc] init];
    [model updateWithParam:@{@"push_config":self.param} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            sender.on = !isOn;
        } else {
            _user = [[ZZUser alloc] initWithDictionary:data error:nil];
            _user.push_config.pd_push = isOn;
            [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            [self.tableView reloadData];
        }
    }];
}

- (void)updateNopushTime:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"至"];
    if (array.count == 2) {
        _param = [NSMutableDictionary dictionaryWithDictionary:[[ZZUserHelper shareInstance].loginer.push_config toDictionary]];
        [self.param setObject:array[0] forKey:@"pd_push_begin_at"];
        [self.param setObject:array[1] forKey:@"pd_push_end_at"];
        ZZUser *model = [[ZZUser alloc] init];
        [model updateWithParam:@{@"push_config":self.param} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
                [_tableView reloadData];
            } else {
                if (array.count == 2) {
                    _user = [ZZUserHelper shareInstance].loginer;
                    _user.push_config.pd_push_begin_at = array[0];
                    _user.push_config.pd_push_end_at = array[1];
                    [_param setObject:array[0] forKey:@"pd_push_begin_at"];
                    [_param setObject:array[1] forKey:@"pd_push_end_at"];
                    _timeString = [NSString stringWithFormat:@"%@至%@",_user.push_config.pd_push_begin_at,_user.push_config.pd_push_end_at];
                }
                [_tableView reloadData];
                [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            }
        }];
    }
}

- (void)detectNotification {

    if ([GetSystemToolsManager() isOpenSystemNotification]) {// 有开启的情况下，提示动画
        WEAK_SELF();
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.tipsTopView.mj_y = 0;
            weakSelf.tipsTopView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [NSObject asyncWaitingWithTime:5 completeBlock:^{
                [UIView animateWithDuration:0.4 animations:^{
                    weakSelf.tipsTopView.mj_y = -25;
                    weakSelf.tipsTopView.alpha = 0.0f;
                }];
            }];
        }];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIAlertController presentAlertControllerWithTitle:nil message:@"你现在无法收到抢任务通知。请到系统“设置”-“通知”-“空虾”中开启。" doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                if (!isCancelled) {
                    if (UIApplicationOpenSettingsURLString != NULL) {
                        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        [[UIApplication sharedApplication] openURL:appSettings];
                    }
                }
            }];
        });
    }
}

#pragma mark - 引导

- (void)showSnatchGuide:(NSInteger)index
{
    NSString *snatchGuide = [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstConnectSnatchGuide];
    if (isNullString(snatchGuide)) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGRect rect = [cell convertRect:cell.bounds toView:self.tableView];
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat topOffset = rect.origin.y + 18 - 52.5;
            if (rect.origin.y ==0) {
                 topOffset = 120 +18 -52;

            }
            _snatchGuideImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 115.5 - 15, topOffset + 206, 115.5, 52.5)];
            _snatchGuideImgView.image = [UIImage imageNamed:@"icon_livestream_guide_snatch"];
            _snatchGuideImgView.userInteractionEnabled = NO;
            [self.tableView addSubview:_snatchGuideImgView];
            _snatchGuideImgView.hidden = YES;
        });
        
        [ZZKeyValueStore saveValue:@"firstConnectSnatchGuide" key:[ZZStoreKey sharedInstance].firstConnectSnatchGuide];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideSnatchGuide];
        });
    }
}

- (void)hideSnatchGuide
{
    [_snatchGuideImgView removeFromSuperview];
}

- (void)showWaitGuide:(NSInteger)index
{
    NSString *waitGuide = [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstConnectWaitGuide];
    if (isNullString(waitGuide)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            CGRect rect = [cell convertRect:cell.bounds toView:self.tableView];
            CGFloat topOffset = rect.origin.y + 23;
            _waitGuideImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120.5 - 64.5, topOffset, 124, 41)];
            _waitGuideImgView.image = [UIImage imageNamed:@"icon_livestream_guide_wait"];
            _waitGuideImgView.userInteractionEnabled = NO;
            [self.tableView addSubview:_waitGuideImgView];
        });
        
        [ZZKeyValueStore saveValue:@"firstConnectWaitGuide" key:[ZZStoreKey sharedInstance].firstConnectWaitGuide];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideWaitGuide];
        });
    }
}

- (void)hideWaitGuide
{
    [_waitGuideImgView removeFromSuperview];
}

#pragma mark - WBSendVideoManagerObserver

- (void)videoStartSendingVideoUploadStatus:(ZZVideoUploadStatusView *)model {
    _isUploading = YES;
    _model = model;
}

// 视频发送进度
- (void)videoSendProgress:(NSString *)progress {
    _isUploading = YES;
}

// 视频发送完成
- (void)videoSendSuccessWithVideoId:(ZZSKModel *)sk {
    
    _sk = sk;
    _isUploading = NO;

    WEAK_SELF();
    // 闪租页面的录制达人视频 需要直接更新到User-服务器
    if (_model.isUploadAfterCompleted) {
        
        BOOL isShowCongratulations = _user.base_video.status == 0;//记录是否是第一次从闪租上传达人视频成功，则需要弹窗
        
        _user = [ZZUserHelper shareInstance].loginer;
        if (_sk) {// 如果达人视频上传成功的话，则保存的时候需要将 sk 整个Model一起上传
            _user.base_video.sk = sk;
            _user.base_video.status = 1;
        }
        
        [ZZHUD showWithStatus:@"更新信息"];
        [_user updateWithParam:[_user toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"更新成功"];
                NSError *err;
                ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:&err];
                [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadCompleted object:nil];
                [weakSelf.tableView reloadData];
                if (isShowCongratulations) {
                    BLOCK_SAFE_CALLS(self.isShowCongratulationsBlock);
                }
            }
        }];
    }
    
    _model = nil;
}

// 视频发送失败
- (void)videoSendFailWithError:(NSDictionary *)error {
    _isUploading = NO;
}

#pragma mark - lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[ZZSnatchListCell class] forCellReuseIdentifier:@"list"];
        [_tableView registerClass:[ZZSnatchOrderCell class] forCellReuseIdentifier:@"mycell"];
        [_tableView registerClass:[ZZSnatchOrderNotificationCell class] forCellReuseIdentifier:@"notification"];
        [_tableView registerClass:[ZZDisturbTimeCell class] forCellReuseIdentifier:@"timecell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (![ZZUserHelper shareInstance].configModel.pd.hide_banner) {
            self.tableViewHeaderView = [self createTableViewHeaderView];
            self.tableView.tableHeaderView = self.tableViewHeaderView;
        }
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return _tableView;
}

- (NSMutableArray<ZZSnatchReceiveModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)addArray
{
    if (!_addArray) {
        _addArray = [NSMutableArray array];
    }
    return _addArray;
}

- (NSMutableArray *)deleteArray
{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (NSMutableDictionary *)param
{
    if (!_param) {
        _param = [NSMutableDictionary dictionaryWithDictionary:[[ZZUserHelper shareInstance].loginer.push_config toDictionary]];
    }
    return _param;
}

- (ZZDisturbTimePickerView *)pickerView
{
    WeakSelf;
    if (!_pickerView) {
        _pickerView = [[ZZDisturbTimePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.window addSubview:_pickerView];
        
        _pickerView.chooseTime = ^(NSString *showString) {
            [weakSelf updateNopushTime:showString];
        };
    }
    return _pickerView;
}

- (WBActionContainerView *)presentSlider {
    if (!_presentSlider) {
        _presentSlider = [[WBActionContainerView alloc] initWithView:self.publishView forHeight:500];
        _presentSlider.maskViewClickEnable = NO;
    }
    return _presentSlider;
}

- (ZZPublishOrderView *)publishView
{
    WeakSelf;
    if (!_publishView) {
        _publishView = [[ZZPublishOrderView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 500, SCREEN_WIDTH, 500)];
//        [self.scrollView addSubview:_publishView];
        _publishView.touchPublish = ^{
            [weakSelf publishBtnClick];
        };
        _publishView.touchRule = ^{
//            [weakSelf gotoRuleWebView];
        };
        _publishView.touchTaskChoose = ^{
//            [weakSelf gotoTaskChooseView];
        };
        _publishView.touchLocation = ^{
//            [weakSelf gotoLocationView];
        };
        [_publishView setDismissBlock:^{
            [weakSelf.presentSlider dismiss];
        }];
        [_publishView setPresentBlock:^{
            [weakSelf.presentSlider present];
        }];
    }
    return _publishView;
}

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
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (_publishView.skill.type == 1) {
        
        if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstTaskPublishAlert]) {
            [window addSubview:self.taskConfirmAlert];
        } else {
            [self request];
        }
    } else {
        if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstPublishOrderAlert]) {
            [window addSubview:self.requestAlertView];
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
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [ZZRequest method:@"POST" path:@"/api/pd/add" params:self.publishView.param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        self.publishView.publishView.userInteractionEnabled = YES;
        if (error) {
            if (error.code == 7001) {
                self.failureAlert.contentLabel.text = error.message;
                [window addSubview:self.failureAlert];
            } else if (error.code == 7002) {
                self.endAlert.contentLabel.text = error.message;
                self.endAlert.type = 1;
                [window addSubview:self.endAlert];
            } else {
                [ZZHUD showErrorWithStatus:error.message];
            }
        } else {
            [self sendOrderData:data];
        }
    }];
}

/**
 发布订单
 */
- (void)sendOrderData:(id)data {
    [ZZKeyValueStore saveValue:[data objectForKey:@"cancel_count_max"] key:[ZZStoreKey sharedInstance].cancel_count_max];
    [ZZKeyValueStore saveValue:[data objectForKey:@"cancel_count"] key:[ZZStoreKey sharedInstance].cancel_count];
    [ZZKeyValueStore saveValue:self.publishView.param key:[ZZStoreKey sharedInstance].publishSelections];
    
    ZZSnatchDetailModel *model = [[ZZSnatchDetailModel alloc] initWithDictionary:[data objectForKey:@"pd"] error:nil];
    if (self.publishView.skill.type == 1) {
        [self gotoPayView:model];
    } else if (self.publishView.skill.type == 2) {
        [self.presentSlider dismiss];
        [self addShineViews:model];
        [self createTimer2];
    }
    _count = [[[data objectForKey:@"pd"] objectForKey:@"valid_duration"] integerValue]*60;
}

- (void)gotoPayView:(ZZSnatchDetailModel *)model
{
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    WEAK_SELF();
    ZZPayViewController *controller = [[ZZPayViewController alloc] init];
    controller.pId = model.id;
    controller.type = PayTypeTask;
    controller.price = [[self.publishView.param objectForKey:@"price"] doubleValue];
    controller.hidesBottomBarWhenPushed = YES;
    controller.didPay = ^{
        [self addShineViews:model];
        [self createTimer2];
    };
    [controller setBackBlock:^{
        [NSObject asyncWaitingWithTime:0.7 completeBlock:^{
            [weakSelf.presentSlider present];
        }];
    }];
    [self.presentSlider dismiss];
    [nav pushViewController:controller animated:YES];
}

// 查询么币余额
- (void)checkMeBiBalance {
    [ZZUserHelper requestMeBiAndMoneynext:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if ([[ZZUserHelper shareInstance].loginer.mcoin integerValue] < [ZZUserHelper shareInstance].configModel.priceConfig.one_card_to_mcoin.integerValue * [ZZUserHelper shareInstance].configModel.priceConfig.per_unit_cost_card.integerValue) {
            self.failureAlert.contentLabel.text = error.message;
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:self.failureAlert];
        } else {
            [self sureBtnClick];
        }
    }];
}

- (void)addShineViews:(ZZSnatchDetailModel *)model
{
    [self removeShineViews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addSubview:self.shineView];
        self.shineView.type = model.type;
        [self.shineView animate];
        self.shineView.pId = model.id;
    });
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

- (ZZRequestLiveStreamAlert *)requestAlertView
{
    WeakSelf;
    if (!_requestAlertView) {
        _requestAlertView = [[ZZRequestLiveStreamAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _requestAlertView.isPublish = YES;
        _requestAlertView.touchSure = ^{
//            [weakSelf checkMeBiBalance];
            [weakSelf sureBtnClick];
        };
        _requestAlertView.touchCancel = ^{
            [weakSelf clearTimer2];
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
            [weakSelf clearTimer2];
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

// 充钱
- (void)gotoRechargeBtnClick
{
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    self.presentSlider.hidden = YES;
    __weak typeof(nav)weakNav = nav;
    WS(weakSelf);
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

- (void)clearTimer2
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [_timer invalidate];
    _timer = nil;
    
    self.publishDate = nil;
}

@end
