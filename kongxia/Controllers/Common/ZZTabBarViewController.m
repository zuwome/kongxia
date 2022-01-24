//
//  ZZTabBarViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

/** 用于捕捉挂断的*/
#import "ZZDateHelper.h"
/** 用于捕捉挂断的*/
#import <YYModel.h>
#import "ZZMyIntegralViewController.h"

#import "ZZTabBarViewController.h"
#import "ZZNewHomeViewController.h"
#import "ZZLiveStreamViewController.h"

#import "ZZUserCenterViewController.h"
#import "ZZNavigationController.h"
#import "ZZSignUpS3ViewController.h"
#import "ZZMessageListViewController.h"
#import "ZZFindViewController.h"
#import "ZZRecordViewController.h"
#import "ZZLiveStreamConnectViewController.h"
#import "ZZLiveStreamPublishingViewController.h"
#import "ZZTaskSnatchListViewController.h"
#import "ZZLiveStreamAcceptController.h"
#import "ZZUserDefaultsHelper.h"
#import "ZZTabbarBtn.h"
#import "ZZAuthorityView.h"
#import "ZZTabbarBubbleView.h"
#import "ZZUserErrorInfoAlertView.h"
#import "ZZUpdateAlertView.h"
#import "ZZliveStreamConnectingView.h"
#import "ZZLiveStreamAcceptView.h"
#import "ZZLiveStreamSnatchedAlert.h"
#import "ZZTaskPayAlert.h"
#import "ZZChatManagerNetwork.h"

#import <RongIMKit/RongIMKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UITabBar+Badge.h"
#import "ZZRecordManager.h"
#import "ZZChatUtil.h"
#import "ZZDownloadHelper.h"
#import "ZZFileHelper.h"
#import "SSZipArchive.h"
#import "ZZUnreadPublishModel.h"
#import "ZZliveStreamConnectingController.h"

#import "ZZLocalPushManager.h"
#import "ZZFastRentManager.h"
#import "ZZTaskCancelConfirmAlert.h"
#import "ZZVideoConnectTopView.h"
#import "ZZOrderNotificationHelper.h"
#import "ZZShanChatNotificationHelper.h"
#import "ZZChatCallIphoneManagerNetWork.h"//连麦管理类
#import "ZZBanStateModel.h"
#import "ZZCompleteIntegralTopView.h"
#import "ZZTabbarRentBubbleView.h"

#import "ZZCommossionManager.h"

#import "ZZChatGiftModel.h"
#import "ZZGiftHelper.h"


@interface ZZTabBarViewController ()<RCIMUserInfoDataSource,RCIMReceiveMessageDelegate, WBFastRentManagerObserver>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ZZTabbarBtn *tempBtn;
@property (nonatomic, strong) UIImageView *shineImgView;
@property (nonatomic, strong) ZZTabbarBtn *menuBtn;
@property (nonatomic, strong) ZZTabbarBubbleView *bubbleView;
@property (nonatomic, strong) ZZTabbarRentBubbleView *rentBubble;
@property (nonatomic, strong) ZZLiveStreamSnatchedAlert *snatchedAlert;
@property (nonatomic, copy)   NSString *remainingTime;    // 任务剩余时间，用于传递到选择达人页面
@property (nonatomic, strong) ZZliveStreamConnectingController *connectingVC;

@property (nonatomic, assign) NSInteger connectCount;
@property (nonatomic, copy) NSDictionary *logParam;
@property (nonatomic, assign) BOOL shouldUploadLog;
@property (nonatomic, assign) BOOL gettingUnread;
@property (nonatomic, assign) BOOL isLogout;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) BOOL haveLoadUnread;
@property (nonatomic, assign) BOOL isUnderway;  // 当前是否处于发布任务中的状态
@property (nonatomic, assign) ZZRecordViewController *recordViewController;
@end

@implementation ZZTabBarViewController

// 单例
+ (instancetype)sharedInstance {
    __strong static id sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self createViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogin:)
                                                 name:kMsg_UserLogin
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogout:)
                                                 name:kMsg_UserDidLogout
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getUnread)
                                                 name:kMsg_PushNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidRegister)
                                                 name:kMsg_UserDidRegister
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getUserInfo)
                                                 name:kMsg_UserErrorInfo
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessageBox)
                                                 name:kMsg_ReceiveMessageBox
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveConnectNofication:)
                                                 name:kMsg_ConnectPushNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newPublishOrderNofication:)
                                                 name:kMsg_NewPublishOrder
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserBalanceAndMcoinIfNeededNofication:) name:kMsg_PublicRecharge
                                               object:nil];
    [self getUnread];
    if ([ZZUserHelper shareInstance].isLogin && [ZZUserHelper shareInstance].IMToken) {
        [self connectIMByToken:[ZZUserHelper shareInstance].IMToken];
    }
    else if ([ZZUserHelper shareInstance].isLogin) {
        [self userDidLogin:nil];
    }
    if ([ZZUserHelper shareInstance].isLogin) {
        [self getUserInfo];
    }
    
    // 获取系统配置信息
    [self fetchSystemConfig];
    
    [ZZUserHelper shareInstance].unreadModel = [[ZZUserUnread alloc] init];
    
    [self getUploadToken];
    
    // 校验是否有人给自己发起视频
    [self checkSomebodyCalledIfNeeded];
    
    [GetFastRentManager() addObserver:self];
    
    [self showBubbleView:1];
    
}

#pragma mark - createViews
- (void)createViews {
    _neoHomeCtl = [[ZZNewHomeViewController alloc] init];

    ZZNavigationController *homeNavCtl = [[ZZNavigationController alloc] initWithRootViewController:_neoHomeCtl];
    
    ZZFindViewController *findCtl = [[ZZFindViewController alloc] init];
    ZZNavigationController *findNavCtl = [[ZZNavigationController alloc] initWithRootViewController:findCtl];
    
    ZZMessageListViewController *chatCtl = [[ZZMessageListViewController alloc] init];
    ZZNavigationController *chatNavCtl = [[ZZNavigationController alloc] initWithRootViewController:chatCtl];
    
    ZZUserCenterViewController *userCtl = [[ZZUserCenterViewController alloc] init];
    ZZNavigationController *userNavCrl = [[ZZNavigationController alloc]initWithRootViewController:userCtl];
    
    self.viewControllers = @[homeNavCtl, findNavCtl, chatNavCtl, userNavCrl];
    self.selectedIndex = 0;
    
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5" andAlpha:1]];
    
    [self createTabbarBtns];
}

+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
//    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CIImage *croppedImage = [result imageByCroppingToRect:[result extent]];
//    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
//    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
//    CGImageRelease(outImage);
    return [[UIImage alloc] initWithCIImage:croppedImage];
}

- (void)createTabbarBtns {
    NSInteger KBtnHeight = TABBAR_HEIGHT;

    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KBtnHeight)];
//    _bgView.backgroundColor = HEXCOLOR(0x18181d);
//    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIImage *image = [UIImage imageFromColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    UIImage *image2 = [ZZTabBarViewController coreBlurImage:image withBlurNumber:0.02];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image2];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KBtnHeight);
    [_bgView addSubview:imageView];
    [self.tabBar addSubview:_bgView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height);
    [_bgView addSubview:effectView];
    
    // 创健按钮
    NSArray *normalImgArr = @[@"icon_tabbar_11",
                              @"icon_tabbar_21",
                              @"icon_tabbar_31",
                              @"icon_tabbar_41"];
    NSArray *selectImgArr = @[@"icon_tabbar_13",
                              @"icon_tabbar_23",
                              @"icon_tabbar_33",
                              @"icon_tabbar_43"];
    NSArray *titleArray = @[@"主页",@"发现",@"消息",@"我的"];
    
    CGFloat KBtnWidth = SCREEN_WIDTH/5.0;
    
    CGFloat titleWidth = [NSString findWidthForText:@"哈哈" havingWidth:SCREEN_WIDTH andFont:[UIFont systemFontOfSize:10.0]];//[ZZUtils widthForCellWithText:@"哈哈" fontSize:10];
    
    for (int i = 0; i < normalImgArr.count; i ++) {
        ZZTabbarBtn *sBtn = [ZZTabbarBtn buttonWithType:UIButtonTypeCustom];
        [sBtn setImage:[UIImage imageNamed:normalImgArr[i]] forState:UIControlStateNormal];
        [sBtn setImage:[UIImage imageNamed:selectImgArr[i]] forState:UIControlStateSelected];
        [sBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [sBtn setTitle:titleArray[i] forState:UIControlStateSelected];
        [sBtn setTitleColor:HEXCOLOR(0x9D9D9D) forState:UIControlStateNormal];
        [sBtn setTitleColor:kYellowColor forState:UIControlStateSelected];
        sBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [sBtn setImageEdgeInsets:UIEdgeInsetsMake(7, titleWidth/2.0, 23, -titleWidth/2.0)];
        [sBtn setTitleEdgeInsets:UIEdgeInsetsMake(26, -9.5, 0, 9.5)];
        sBtn.tag = 100 + i;
        
        [sBtn addTarget:self
                 action:@selector(tabbarBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
        [sBtn addTarget:self
                 action:@selector(tabbatBtnClickTwice:)
       forControlEvents:UIControlEventTouchDownRepeat];
        
        [_bgView addSubview:sBtn];
        if (i<2) {
            sBtn.frame = CGRectMake(KBtnWidth*i, 1, KBtnWidth, 49);
        } else {
            sBtn.frame = CGRectMake(KBtnWidth*(i+1),  1, KBtnWidth, 49);
        }
        if (i ==0) {
            sBtn.selected = YES;
            _tempBtn = sBtn;
        }
    }
    
    [_bgView addSubview:self.menuBtn];
    
    _shineImgView = [[UIImageView alloc] init];
    _shineImgView.contentMode = UIViewContentModeBottom;
    _shineImgView.image = [UIImage imageNamed:@"icon_tabbar_bottom"];
    _shineImgView.userInteractionEnabled = NO;
    [_bgView addSubview:_shineImgView];
    
    [_shineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bgView.mas_bottom);
        make.left.mas_equalTo(_bgView.mas_left);
        make.size.mas_equalTo(CGSizeMake(KBtnWidth, KBtnHeight));
    }];
}

// 校验是否有人给自己发起视频
- (void)checkSomebodyCalledIfNeeded {
    [NSObject asyncWaitingWithTime:1.0 completeBlock:^{
        if ([ZZUserHelper shareInstance].isLogin) {
            
            [ZZRequest method:@"GET" path:@"/api/user/wait_accept/room" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                
                if (error) {
                    
                } else {
                    NSDictionary *aDict = (NSDictionary *)data;
                    if (aDict.allKeys.count == 0) {
                        return ;
                    }
                    NSInteger type = [[aDict objectForKey:@"type"] integerValue];
                    if (type == 4) {//闪租单被接受了
                        NSString *pdreceive_id = [aDict objectForKey:@"pdreceive_id"];
                        if (!isNullString(pdreceive_id)) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_AcceptSnatchOrder object:nil userInfo:aDict];
                        }
                    }
                    [self checkAuthority:aDict isFromNotification:NO];
                }
            }];
        }
    }];
}

#pragma mark - UIButtonMethod
- (void)setSelectIndex:(NSInteger)index {
    WEAK_SELF();
    ZZTabbarBtn *btn = (ZZTabbarBtn *)[_bgView viewWithTag:(100+index)];
    [weakSelf tabbarBtnClick:btn];
}

- (void)tabbatBtnClickTwice:(ZZTabbarBtn *)sender {
    if (_tempBtn == sender) {
        NSLog(@"hello i'm clicked twice");
        [[NSNotificationCenter defaultCenter] postNotificationName:KMsg_TabbarRefreshNotification
                                                            object:nil
                                                          userInfo:nil];
    }
}

- (void)tabbarBtnClick:(ZZTabbarBtn *)sender {
    //    [self hideMenuView];
    WEAK_SELF();
    if (_tempBtn == sender) {
        return;
    }
    
    if (!_isLogout) {
        if (sender.tag - 100 != 1 && sender.tag - 100 != 0) {
            if (![weakSelf canClickBtn]) {
                return;
            }
        }
        
        switch (sender.tag - 100) {
            case 0: {
                [MobClick event:Event_click_home_tab];
            }
                break;
            case 1: {
                [MobClick event:Event_click_discovery_tab];
            }
                break;
            case 2: {
                if ([ZZUserHelper shareInstance].oAuthToken && ![ZZUserHelper shareInstance].IMToken) {
                    [weakSelf userDidLogin:nil];
                }
                [MobClick event:Event_click_chat_tab];
            }
                break;
            case 3: {
                [self getUnread];
                [MobClick event:Event_click_me_tab];
            }
                break;
            default:
                break;
        }
    }
    
    [weakSelf managerTabbar];
    _tempBtn.selected = NO;
    _tempBtn.showImgView.hidden = YES;
    
    for (int i=0; i<4; i++) {
        ZZTabbarBtn *btn = (ZZTabbarBtn *)[_bgView viewWithTag:100 + i];
        if (btn != sender) {
            btn.showImgView.hidden = YES;
        }
    }
    
    sender.selected = YES;
    _tempBtn = sender;
    
    NSInteger index = sender.tag - 100;
    weakSelf.selectedIndex = index;
    
    if (index >= 2) {
        [weakSelf shineAnimation:index+1];
    }
    else {
        [weakSelf shineAnimation:index];
    }
    _isLogout = NO;
}

- (void)shineAnimation:(NSInteger)index {
    WEAK_SELF();
    CGFloat width = SCREEN_WIDTH/5.0;
    _shineImgView.alpha = 0;
    CGFloat offset = index*width;
    [_shineImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgView.mas_left).offset(offset);
    }];
    
    if (_animating) {
        [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(shine) object:nil];
    }
    _animating = YES;
    [weakSelf performSelector:@selector(shine) withObject:nil afterDelay:0.5];
}

- (void)shine {
    [UIView animateWithDuration:0.3 animations:^{
        self.shineImgView.alpha = 1;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

- (BOOL)canClickBtn {
    WEAK_SELF();
    if ([weakSelf haveLogin]) {
        if ([[ZZUserHelper shareInstance].loginer isFemailAndPhotoReview]) {
            [weakSelf gotoLiveCheck];
            return NO;
        }
        else if ([self showUserErrorInfoAlertView]) {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return NO;
    }
}

//中间菜单按钮
- (void)menuBtnClick {
    [MobClick event:Event_click_menu_tab];
    if (![self canClickBtn]) {
        return;
    }
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLogin];
        return;
    }
    [self managerTabbar];
    
    if (!self.menuBtn.selected) {
        [self gotoRecordView];
    }
}

- (void)managerTabbar {
    WEAK_SELF();
    if (weakSelf.selectedIndex == 0) {

    }
}

- (BOOL)haveLogin {
    WEAK_SELF();
    if (![ZZUserHelper shareInstance].oAuthToken) {
        [weakSelf gotoLogin];
        return NO;
    }
    return YES;
}

#pragma mark - IMMethod
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    if (userId) {
        [ZZUserHelper getUserMiniInfo:userId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (data) {
                RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:data[@"nickname"] portrait:data[@"avatar"]];
                completion(user);
            }
        }];
    }
}

- (void)connectIMByToken:(NSString *)token {
    //初始化融云SDK
    [[RCIM sharedRCIM] connectWithToken:token dbOpened:^(RCDBErrorCode code) {
        
    } success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        NSString *versions = [RCIM getVersion];
        NSLog(@"Version is %@", versions);
        [RCIM sharedRCIM].receiveMessageDelegate = self;
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        RCUserInfo *info = [[RCUserInfo alloc] init];
        info.name = [ZZUserHelper shareInstance].loginer.nickname;
        info.userId = [ZZUserHelper shareInstance].loginer.uid;
        info.portraitUri = [ZZUserHelper shareInstance].loginer.avatar;
        [RCIM sharedRCIM].currentUserInfo = info;
        [self manageUnreadCountWithCount:0];

        [ZZGiftHelper checkIfUnreadMessagesHaveGifts];
    } error:^(RCConnectErrorCode errorCode) {
        if (errorCode == RC_CONN_TOKEN_INCORRECT) {
            [self getIMToken];
            _shouldUploadLog = YES;
            NSMutableDictionary *param = [@{@"type":@"融云token失效"} mutableCopy];
            if ([ZZUserHelper shareInstance].IMToken) {
                [param setObject:[ZZUserHelper shareInstance].IMToken forKey:@"imtoken"];
            }
            if ([ZZUserHelper shareInstance].loginer.uid) {
                _logParam = @{
                    @"uid":[ZZUserHelper shareInstance].loginer.uid,
                    @"content":[ZZUtils dictionaryToJson:param] ?: @""
                };
                if ([ZZUserHelper shareInstance].unreadModel.open_log) {
                    [self uploadLog:_logParam];
                }
            }
        }
        else {
            _shouldUploadLog = YES;
            NSMutableDictionary *param = [@{@"type":@"融云登录错误",
                                            @"status":[NSNumber numberWithInteger:errorCode]} mutableCopy];
            if ([ZZUserHelper shareInstance].IMToken) {
                [param setObject:[ZZUserHelper shareInstance].IMToken forKey:@"imtoken"];
            }
            if ([ZZUserHelper shareInstance].loginer.uid) {
                _logParam = @{
                    @"uid":[ZZUserHelper shareInstance].loginer.uid,
                    @"content":[ZZUtils dictionaryToJson:param] ?: @""
                };
                if ([ZZUserHelper shareInstance].unreadModel.open_log) {
                    [self uploadLog:_logParam];
                }
            }
        }
    }];
}

//上传錯误log
- (void)uploadLog:(NSDictionary *)param {
    if ([ZZUserHelper shareInstance].unreadModel.open_log) {
        [ZZUserHelper uploadLogWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (data) {
                _shouldUploadLog = NO;
            }
        }];
    }
}

- (void)userDidLogin:(NSNotification *)sender {
    _connectCount = 0;
    [self getUnread];
    [self getIMToken];
    [self getUserInfo];
}

- (void)userDidLogout:(NSNotification *)sender {
    [[RCIM sharedRCIM] logout];
    
    _isLogout = YES;
    ZZTabbarBtn *btn = (ZZTabbarBtn *)[_bgView viewWithTag:100];
    [self tabbarBtnClick:btn];
    
    ZZTabbarBtn *chatBtn = (ZZTabbarBtn *)[_bgView viewWithTag:102];
    chatBtn.badgeView.hidden = YES;
    
    ZZTabbarBtn *userBtn = (ZZTabbarBtn *)[_bgView viewWithTag:103];
    userBtn.badgeView.hidden = YES;
    userBtn.redPointView.hidden = YES;
}

- (void)userDidRegister {
    // 保存下来所有在这一台手机c注册的用户的UID, 用于判断是否要弹出小窗口提示
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSArray *usersArr = [userDefault objectForKey:@"UserRetegiteredArr"];
    
    NSMutableArray *usersMArr = usersArr.mutableCopy;
    if (!usersMArr) {
        usersMArr = @[].mutableCopy;
    }
    
    if (![usersMArr containsObject:[ZZUserHelper shareInstance].loginer.uid]) {
        [usersMArr addObject:[ZZUserHelper shareInstance].loginer.uid];
    }
    
    [userDefault setObject:usersMArr.copy forKey:@"UserRetegiteredArr"];
    [userDefault synchronize];
}

#pragma mark - RCIMReceiveMessageDelegate - 融云实时消息回调
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.content isKindOfClass:[RCCommandMessage class]]) {
        RCCommandMessage *model = (RCCommandMessage *)message.content;
        if (model.data) {
            NSDictionary *aDict = [ZZUtils dictionaryWithJsonString:model.data];
            NSInteger type = [[aDict objectForKey:@"type"] integerValue];
            NSLog(@"PY_当前接受_%ld",type);
            NSString *extra = aDict[@"extra"];
            if ([extra isEqualToString:@"banUser"]) {
                // 封禁用户
                NSLog(@"PY_当前已经接受到的融云消息");
                //表示用户被封禁了
                ZZBanModel *model = [[ZZBanModel alloc]init];
                model.reason = aDict[@"content"];
                model.cate = aDict[@"cate"];
                ZZUser *user =  [ZZUserHelper shareInstance].loginer;
                user.banStatus = YES;
                user.ban = model;
                [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                [ZZBanedHelper showBan:user];
                return;
            }
            else if ([extra isEqualToString:@"unbanUser"]) {
                // 解封用户
                NSLog(@"PY_当前已经接受到的融云消息");
                //表示用户被封禁了
                ZZBanModel *model = [[ZZBanModel alloc]init];
                model.reason = aDict[@"content"];
                ZZUser *user =  [ZZUserHelper shareInstance].loginer;
                user.banStatus = NO;
                user.ban = nil;
                [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                return;
            }
            switch (type) {
                case 1:  {
                    // 收到消息盒子
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PushNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ReceiveMessageBox object:nil];
                    break;
                }
                case 2:  {
                    // 收到派单
                    [self getUnread];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ReceivePublishOrder object:nil userInfo:aDict];
                    [self showRentBubble];
                    [GetLocalPushManager() localPushWithContent:aDict];
                    break;
                }
                case 3: {
                    // 派单被女方抢了
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_SnatchPublishOrder object:nil userInfo:aDict];
                    [GetLocalPushManager() localPushWithContent:aDict];
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self showSnatchedAlert:aDict];
                    });
                    break;
                }
                case 4:
                case 5: {
                    if (type == 4) {
                        // 闪租单被接受了
                        NSString *pdreceive_id = [aDict objectForKey:@"pdreceive_id"];
                        if (!isNullString(pdreceive_id)) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_AcceptSnatchOrder object:nil userInfo:aDict];
                        }
                    }
                    [GetLocalPushManager() localPushWithContent:aDict];
                    [self checkAuthority:aDict isFromNotification:NO];
                    break;
                }
                case 6:  {
                    // 取消订单
                     [ZZLocalPushManager cancelLocalNotificationWithKey:[ZZLocalPushManager sendOrders]];
                    [self getUnread];
                    // 更新派单
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdateSnatchedPublishOrder object:nil userInfo:[aDict objectForKey:@"pd_receive"]];
                    break;
                }
                case 7:{
                    // 发单方列表女方被抢更新
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdatePublishingList object:nil userInfo:[aDict objectForKey:@"pd_receive"]];
                    break;
                }
                case 8:{
                    // 女方抢单男方接受了
                    NSString *pdreceive_id = [aDict objectForKey:@"pdreceive_id"];
                    if (!isNullString(pdreceive_id)) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_AcceptSnatchOrder object:nil userInfo:aDict];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ZZSnatchDetailModel *model = [ZZSnatchDetailModel yy_modelWithJSON:[aDict objectForKey:@"pd"]];
                        if (model.id) {
                            ZZTaskPayAlert *alert = [[ZZTaskPayAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                            alert.model = model;
                            alert.type = 4;
                            [self.view.window addSubview:alert];
                        }
                    });
                    break;
                }
                case 9:{
                    // 视频违规挂断通知(涉黄等)
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_VideoBrokeRules object:nil userInfo:aDict];
                    break;
                }
                case 10:{
                    // 达人视频审核失败，本地先更新失败状态，更新闪租页面
                    ZZUser *user = [ZZUserHelper shareInstance].loginer;
                    user.base_video.status = 2;
                    user.base_video.status_text = aDict[@"status_text"];
                    [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadAuditFail object:nil userInfo:aDict];
                    break;
                }
                case 11: {
                    // 达人视频上传，并保存用户信息完成
                    ZZUser *user = [ZZUserHelper shareInstance].loginer;
                    user.base_video.status = 1;
                    [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadCompleted object:nil userInfo:aDict];
                    break;
                }
                case 12: {
                    //代表闪聊视频审核不通过（达人视频）
                    ZZUser *user = [ZZUserHelper shareInstance].loginer;
                    user.base_video.status = 2;
                    user.base_video.status_text = aDict[@"status_text"];
                    [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_FastChatFail object:nil userInfo:aDict];
                    break;
                }
                case 21:{
                    // 公众号充值的回调，通知客户端要去更新么币余额
                       [GetLocalPushManager() localPushWithContent:aDict];//发起本地通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PublicRecharge object:nil userInfo:aDict];
                    break;
                }
                case 28:{
                    NSLog(@"%@",aDict);
                    break;
                }
                case 29:{
                    NSLog(@"%@",aDict);
                    break;
                }
                case 100:{
                    //男方发起连麦后取消
                    [self accepedDisconnect];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_CancelConnect object:nil userInfo:aDict];
                    if ([ZZLocalPushManager runningInBackground]) { //如果处于后台，存储本地一个标志，告知对方已经取消
                        [ZZLocalPushManager cancelLocalNotificationWithKey:[ZZLocalPushManager callIphoneKey]];
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kMsg_CancelConnect];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    }
                    if (GetSoundToolsManager().isVibrate) {
                        [GetSoundToolsManager() stopAlertSound];
                    }
                    break;
                }
                case 101:{
                    //拒绝连麦
                    NSDictionary *param = @{@"uid":message.targetId};
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_RefuseConnect object:nil userInfo:param];
                    break;
                }
                case 102:{
                    //当前正在通话中
                    NSDictionary *param = @{@"uid":message.targetId};
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_BusyConnect object:nil userInfo:param];
                    break;
                }
                case 103:{
                    // 接单方一定时间没有露脸
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_NoFaceTimeout object:nil userInfo:aDict];
                    NSLog(@"%@", aDict);
                    break;
                }
                case 104: {
                    // 对方点了接通视频，我方可以开始连接视频
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ConnectVideoStar object:nil userInfo:aDict];
                    break;
                }
                case 201: {
                    // type== 201 但是对方视频电话忙碌中 就不要凑热闹了
                 [GetLocalPushManager() localPushWithContent:aDict];
                [ZZShanChatNotificationHelper localPushNotificationMessageDic:aDict tabbarViewController:self];
                    break;
                }
                case 301: {
                     NSLog(@"PY_任务积分 %@", aDict[@"content"]);
                    [self showTaskOfIntegralString:aDict[@"content"]];
                    break;
                }
                case 302: {
                    if ([ZZLocalPushManager runningInBackground]) { //如果处于后台，存储本地一个标志，告知对方已经取消
                        [[ZZLocalPushManager sharedInstance ] localPushWithContent:aDict];;
                    }
                    break;
                }
                case 1000: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ChangePriceSuccessView *sv = [[ChangePriceSuccessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                        [[UIApplication sharedApplication].keyWindow addSubview:sv];
                    });   
                    break;
                }
                case 4008:
                case 4009: {
                    // 申请达人
                    [[ZZCommossionManager manager] showRemindView:aDict action:^(NSInteger action) {
                        if (action == 0) {
                            // 达人
                            ZZTabBarViewController *controller = [ZZTabBarViewController sharedInstance];
                            if (controller.selectedIndex != 3) {
                                [[ZZTabBarViewController sharedInstance] setSelectIndex:3];
                            }
                        }
                        else {
                            // 微信
                            ZZWXViewController *controller = [[ZZWXViewController alloc] init];
                            controller.hidesBottomBarWhenPushed = YES;
                            [[UIViewController currentDisplayViewController].navigationController pushViewController:controller animated:YES];
                        }
                    }];
                    break;
                }

                case 9001: {
                    // 线上视频接受时
                    NSString *pdreceive_id = [aDict objectForKey:@"pdreceive_id"];
                    if (!isNullString(pdreceive_id)) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_AcceptSnatchOrder object:nil userInfo:aDict];
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }
    else {
       [[ZZTabBarViewController sharedInstance] managerAppBadge];
        //把旧的微信提示删除掉
        if (![ZZChatUtil isAviableMessage:message]) {
            [[RCIMClient sharedRCIMClient] deleteMessages:@[@(message.messageId)]];
            return;
        }
        NSDictionary *aDict = @{@"message":message,
                                @"left":[NSNumber numberWithInt:left]};
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ReceiveMessage object:nil userInfo:aDict];
        [self manageUnreadCountWithCount:0];
        
        // 判断是不是礼物的
        [ZZGiftHelper recivedNewMessage:message completion:^(BOOL isComplete) {
             [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ReceiveGiftChatMessage object:nil userInfo:aDict];
        }];
        
        if ([message.content isKindOfClass:[RCTextMessage class]] && message.conversationType == ConversationType_PRIVATE) {
            RCTextMessage *text = (RCTextMessage *)message.content;
            
            // 判断当前收到的信息, 判断当前文本信息是否可能为账号，如是账号则判处警告
            BOOL itMightBeAnAccount = [text.content wechatAlipayAccountCheck];
            if (itMightBeAnAccount) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ZZChatReportModel *finishModel = [ZZChatReportModel messageWithContent:@"为保障双方利益，请不要通过微信、支付宝等第三方支付方式进行交易，透漏第三方联系方式或未通过平台查看微信，将面临50元/次罚款及封禁处罚，若涉嫌引导平台外交易，可立即匿名截屏举报"];
                    finishModel.title = @"立即匿名截屏举报";
                    RCMessage *newMessage = [[RCIMClient sharedRCIMClient] insertIncomingMessage:ConversationType_PRIVATE targetId:message.targetId senderUserId:message.targetId receivedStatus:ReceivedStatus_READ content:finishModel sentTime:message.sentTime+100];
                    NSDictionary *aDict = @{@"message":newMessage,
                                            @"left":[NSNumber numberWithInt:left]};
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ReceiveMessage object:nil userInfo:aDict];
                });
            }
        }
    }
}

- (BOOL)onRCIMCustomAlertSound:(RCMessage *)message {
    if (![[ZZUserHelper shareInstance].currentChatUid isEqualToString:message.targetId]) {
        [self vibrationAndSound];
    }
    return YES;
}

- (void)vibrationAndSound {
    if ([ZZUserHelper shareInstance].loginer.push_config.chat) {
        if ([ZZUserHelper shareInstance].loginer.push_config.need_sound) {
            AudioServicesPlaySystemSound(1007);
        }
        if ([ZZUserHelper shareInstance].loginer.push_config.need_shake) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
}

//本地推送设置
- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName {

     NSLog(@"PY_在线的情况下走的融云的推送");
    if (![ZZUserHelper shareInstance].loginer.push_config.push_hide_name) {
        if (![message.content isKindOfClass:[ZZChatConnectModel class]]) {
            if ([message.objectName isEqualToString:@"Message_Order"]) {
                [ZZOrderNotificationHelper localPushNotificationMessage:message];
                return  YES;
            }
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate date];
            notification.soundName=UILocalNotificationDefaultSoundName;
            notification.alertBody = @"收到一条新的信息";
            notification.repeatInterval = 0;
            notification.userInfo = @{@"rc":@{@"fId":[ZZUserHelper shareInstance].loginer.uid,
                                              @"tId":message.targetId,
                                              @"oName":message.objectName,
                                              @"mId":[NSNumber numberWithLong:message.messageId]}};
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            });
            
            return YES;
        }
    }
    return NO;
}

- (void)receiveMessageBox {
    [self vibrationAndSound];
}

#pragma mark - 连麦
- (void)showSnatchedAlert:(NSDictionary *)aDict {
    ZZPublishModel *model = [[ZZPublishModel alloc] initWithDictionary:[aDict objectForKey:@"pd_graber"] error:nil];
    if (!_snatchedAlert && ![ZZUtils isConnecting]) {
        UINavigationController *navCtl = self.selectedViewController;
        BOOL contain = NO;
        for (UIViewController *ctl in navCtl.viewControllers) {
            if ([ctl isKindOfClass:[ZZTaskSnatchListViewController class]]) {
                contain = YES;
                break;
            }
            if ([ctl isKindOfClass:[ZZLiveStreamPublishingViewController class]]) {
                contain = YES;
                break;
            }
        }
        if (!contain) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.snatchedAlert.aDict = aDict;
                if (model.pd.type == 2) {
                    self.snatchedAlert.contentLabel.text = @"已经有达人抢了您的1V1在线视频任务，快来选择达人吧";
                } else if (model.pd.type == 3) {
                    self.snatchedAlert.contentLabel.text = @"已有达人抢了您的任务，快来选择达人吧";
                }
            });
        }
    }
}

- (void)closeSnatchedAlert:(NSDictionary *)aDict {
    [_snatchedAlert removeFromSuperview];
    _snatchedAlert = nil;
    ZZPublishModel *model = [[ZZPublishModel alloc] initWithDictionary:[aDict objectForKey:@"pd_graber"] error:nil];
    [self gotoLiveStreamPublishingView:model.pd];
}

- (void)receiveConnectNofication:(NSNotification *)notification {
    NSDictionary *aDcit = notification.userInfo;
    [self checkAuthority:aDcit isFromNotification:YES];
}

- (void)newPublishOrderNofication:(NSNotification *)notification {
    WEAK_SELF()
    [NSObject asyncWaitingWithTime:2.0 completeBlock:^{
        [weakSelf showShanZhu];
    }];
}

// 公众号充值成功回调，需要更新么币和余额
- (void)updateUserBalanceAndMcoinIfNeededNofication:(NSNotification *)notification {
    
    if (![ZZUserHelper shareInstance].isLogin) {
        return;
    }
    //请求并且更新么币
    [ZZUserHelper requestMeBiAndMoneynext:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZUserHelper shareInstance].consumptionMebi = 0;
    }];
}

- (void)showShanZhu {
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *navCtl = self.selectedViewController;
        [navCtl popToRootViewControllerAnimated:NO];
        [self setSelectIndex:2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoLiveSteam];
        });
    });
}

/**
 *  跳转到抢任务列表
 */
- (void)gotoLiveSteam {
    ZZLiveStreamViewController *controller = [[ZZLiveStreamViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.selectedViewController pushViewController:controller animated:YES];
}

- (void)checkAuthority:(NSDictionary *)aDict isFromNotification:(bool)isFromNotification {
    ZZUser *user = [[ZZUser alloc] initWithDictionary:[aDict objectForKey:@"user"] error:nil];
    if ([[aDict objectForKey:@"user"] isKindOfClass:[NSString class]]) {
        user = [[ZZUser alloc] initWithDictionary:[ZZUtils dictionaryWithJsonString:[aDict objectForKey:@"user"]] error:nil];
    }
    
    if ([ZZLiveStreamHelper sharedInstance].isTryingConnecting) {
        return;
    }
    
    if (isFromNotification) {
        [ZZLiveStreamHelper sharedInstance].isTryingConnecting = YES;
    }
    
    if ([ZZLiveStreamHelper sharedInstance].isBusy) {
         NSLog(@"PY_当前用户忙");
        // 如果有人发起视频，当前处于忙的状态，则向发起者告知忙状态。
        [ZZUtils sendCommand:@"busy" uid:user.uid param:@{@"type":@"102"}];
        [self updateStatusWithData:aDict];
        [ZZLiveStreamHelper sharedInstance].isTryingConnecting = NO;
    }
    else {
        [self showConnectingView:aDict];
    }
    
}

// 客户端发送完忙type=102消息之后，需要告知服务端，本次的 room_id 可以销毁了。
- (void)updateStatusWithData:(NSDictionary *)data {
    if (!data) {
        return;
    }
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/status", [data objectForKey:@"room_id"]] params:@{@"type" : @"busy"} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
        }
    }];
}

- (void)showConnectingView:(NSDictionary *)aDict {
    //回收全局键盘
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    });
    ZZUser *user = [[ZZUser alloc] initWithDictionary:[aDict objectForKey:@"user"] error:nil];
    if ([[aDict objectForKey:@"user"] isKindOfClass:[NSString class]] || !user) {
        user = [[ZZUser alloc] initWithString:[aDict objectForKey:@"user"] error:nil];
    }
    NSInteger type = [[aDict objectForKey:@"type"] integerValue];
    ZZLiveStreamHelper *helper = [ZZLiveStreamHelper sharedInstance];
    helper.targetId = user.uid;
    helper.data = aDict;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (type == 18) {//这里 18 永远不可能进来，所有视频被调起的情况都在 else 中

        }
        else {
            //type == 4 闪租连接中要需要显示 接通、挂断按钮
            
            // type == 4 ，说明 闪租单被接受，走真实融云 (在后台的情况)
            // type == 19, 说明 闪租单被接受，走融云小米 (杀死进来的情况)
            // type == 5 说明其他情况被调起的视频，走真实融云 (在后台的情况)
            // type == 20 说明其他情况被调起的视频，走融云小米 (杀死进来的情况)
            WEAK_SELF();
            if (type == 4 || type == 9) {// 闪租情况
                [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
                    if (authorized) {
                        [weakSelf gotoAcceptVCWithUser:user count:0];
                    } else {
                        [weakSelf refuseToAcceptWithUser:user];
                    }
                }];
            }
            else {
                // 其他情况
                
                ZZVideoConnectTopView *videoConnectTopView = [ZZVideoConnectTopView new];
                videoConnectTopView.frame = CGRectMake(0, -180, SCREEN_WIDTH, 180);
                videoConnectTopView.alpha = 1.0f;
                videoConnectTopView.user = user;
                WEAK_OBJECT(videoConnectTopView, weakVideoConnectTopView);
                [videoConnectTopView setGotoWaitingBlock:^{// 进入录制等待页面
                    [ZZLiveStreamHelper sharedInstance].isTryingConnecting = NO;
                    [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
                        if (authorized) {//有权限
                            [weakSelf recyclingAnimateView:weakVideoConnectTopView completed:^{
                                // 进入等待页面
                                [weakSelf gotoAcceptVCWithUser:user count:weakVideoConnectTopView.count];
                                [weakVideoConnectTopView dismiss];
                            }];
                        } else {//没有权限
                            [weakSelf recyclingAnimateView:weakVideoConnectTopView completed:^{
                                [weakSelf refuseToAcceptWithUser:user];
                                [weakVideoConnectTopView dismiss];
                            }];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{//防重复点击，内部设为 NO
                            weakVideoConnectTopView.userInteractionEnabled = YES;
                        });
                    }];
                }];
                [videoConnectTopView setHangUpButtonBlock:^{
                    [ZZLiveStreamHelper sharedInstance].isTryingConnecting = NO;
                    // 挂断
                    [weakSelf recyclingAnimateView:weakVideoConnectTopView completed:^{
                        [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/user/notify", [ZZLiveStreamHelper sharedInstance].room_id] params:@{@"type" : Refuse_Type} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                            [ZZLiveStreamHelper sharedInstance].isBusy = NO;
                        }];
                        [weakVideoConnectTopView dismiss];
                    }];
                }];
                
                [videoConnectTopView setThroughButtonBlock:^{
                    [ZZLiveStreamHelper sharedInstance].isTryingConnecting = NO;
                    [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
                        if (authorized) { // 有权限
                            [weakSelf recyclingAnimateView:weakVideoConnectTopView completed:^{
                                // 接通
                                [ZZLiveStreamHelper sharedInstance].user = user;
                                // 点击接通视频，需要告诉对方可以开始连接房间
                                [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/user/notify", [ZZLiveStreamHelper sharedInstance].room_id] params:@{@"type" : Through_Type} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                    [ZZLiveStreamHelper sharedInstance].isBusy = YES;
                                }];
                                if (weakSelf.menuBtn.selected) {
                                    [weakSelf.recordViewController dismissView];
                                }
                                // 接通
                                [weakSelf gotoConnectView:user.uid isFromAcceptVC:NO];
                                [weakVideoConnectTopView dismiss];
                            }];
                        } else { // 没有权限
                            [weakSelf recyclingAnimateView:weakVideoConnectTopView completed:^{
                                [weakSelf refuseToAcceptWithUser:user];
                                [weakVideoConnectTopView dismiss];
                            }];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{//防重复点击，内部设为 NO
                            weakVideoConnectTopView.userInteractionEnabled = YES;
                        });
                    }];
                }];
                
                [[UIApplication sharedApplication].keyWindow addSubview:videoConnectTopView];
                [UIView animateWithDuration:0.4 animations:^{
                    videoConnectTopView.mj_y = isIPhoneX ? (30.0f) : (0.0f);
                    videoConnectTopView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    });
}

// 收回
- (void)recyclingAnimateView:(ZZVideoConnectTopView *)view completed:(void (^)(void))completed {
    dispatch_async(dispatch_get_main_queue(), ^{
        view.shadowView.image = nil;
        [UIView animateWithDuration:0.4 animations:^{
            view.mj_y = -180;
            view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            BLOCK_SAFE_CALLS(completed);
        }];
    });
}

#pragma  mark -   积分任务
- (void)showTaskOfIntegralString:(NSString *)string {
    //发出通知告诉用户刷新积分界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTask" object:nil userInfo:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ZZCompleteIntegralTopView *topView = [[ZZCompleteIntegralTopView alloc]initWithFrame:CGRectMake(7.5, isIPhoneX ?56:32, SCREEN_WIDTH- 15, 70)];
        topView.taskString = string;
        WeakSelf
        __block BOOL isLook =NO;;
        topView.lookDetail = ^{
            isLook = YES;
             [weakSelf gotoMyIntegral];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:topView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!isLook) {
                    [topView dissMiss];
            }
        
        });
    });
}

- (void)gotoMyIntegral {
    ZZMyIntegralViewController *controller = [[ZZMyIntegralViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
  
    WEAK_OBJECT(controller, weakController);
    UINavigationController *navCtl = self.selectedViewController;
    [navCtl pushViewController:weakController animated:NO];
}

// 拒绝视频
- (void)refuseToAcceptWithUser:(ZZUser *)user {
    //拒接 走服务器接口
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/user/notify", [ZZLiveStreamHelper sharedInstance].room_id] params:@{@"type" : Refuse_Type} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZLiveStreamHelper sharedInstance].isBusy = NO;
    }];
}

// 进入等待页面
- (void)gotoAcceptVCWithUser:(ZZUser *)user count:(NSInteger)count {
    WEAK_SELF();
    [ZZLiveStreamHelper sharedInstance].isBusy = YES;
    ZZLiveStreamAcceptController *controller = [[ZZLiveStreamAcceptController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.user = user;
    controller.isValidation = YES;
    controller.count = count;
    
    WEAK_OBJECT(controller, weakController);
    controller.touchAccept = ^ {
        [ZZHUD showWithStatus:@"连接中..."];
        [weakSelf acceptConnect:weakController user:user];
    };
    UINavigationController *navCtl = self.selectedViewController;
    [navCtl pushViewController:weakController animated:NO];
}

- (void)acceptConnect:(ZZLiveStreamAcceptController *)controller user:(ZZUser *)user {
    [ZZHUD dismiss];
    [self gotoConnectView:user.uid isFromAcceptVC:YES];
}

- (void)accepedDisconnect {
    // 接起方
    if ([ZZLiveStreamHelper sharedInstance].acceped) {
        // 还没有
        [ZZHUD dismiss];
        // 还没有接起视频就被挂断，要主动调用声网 disconnect
        if (![ZZLiveStreamHelper sharedInstance].connecting) {
            [ZZLiveStreamHelper sharedInstance].noSendFinish = YES;
            [ZZUserDefaultsHelper setObject:@"后台校验一个连接状态挂断" forDestKey:[ZZDateHelper getCurrentDate]];

            [[ZZLiveStreamHelper sharedInstance] disconnect];
        }
    }
}

// 从等待页面进入1V1视频页面
- (void)gotoConnectView:(NSString *)uid isFromAcceptVC:(BOOL)isFrom {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UINavigationController *navCtl = self.selectedViewController;
        NSMutableArray<ZZViewController *> *vcs = [navCtl.viewControllers mutableCopy];
        if (isFrom) {
            [vcs removeLastObject];
        }
        
        ZZLiveStreamConnectViewController *controller = [[ZZLiveStreamConnectViewController alloc] init];
        controller.acceped = YES;
        controller.uid = uid;
        controller.hidesBottomBarWhenPushed = YES;
        [vcs addObject:controller];
        [navCtl setViewControllers:vcs animated:YES];
        [ZZLiveStreamHelper sharedInstance].acceped = YES;
        [[ZZLiveStreamHelper sharedInstance] connect:^{
       
        }];
        [ZZLiveStreamHelper sharedInstance].failureConnect = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                //            [controller remove];
                [controller.navigationController popViewControllerAnimated:YES];
                [ZZHUD dismiss];
            });
        };
    });
}

- (UIView *)judgeCurrentShowViewIsRecordViewController {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
    return frontView;
}

#pragma mark - data
- (void)getIMToken {
    if (_connectCount == 3) {
        return;
    }
    _connectCount++;
    [ZZUser getIMToken:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            [ZZUserHelper shareInstance].IMToken = data[@"token"];
            [self connectIMByToken:[ZZUserHelper shareInstance].IMToken];
        }
    }];
}

- (void)getUploadToken {
    if ([ZZUserHelper shareInstance].isLogin) {
        [ZZRequest method:@"GET" path:@"/api/qiniu/token" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (data) {
                [ZZUserHelper shareInstance].uploadToken = [data objectForKey:@"upload_token"];
            }
        }];
    }
}

- (void)getUserInfo {
    WEAK_SELF();
    [ZZUser loadUser:[ZZUserHelper shareInstance].loginerId param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:nil];
            [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
            
            [weakSelf showUserErrorInfoAlertView];
        }
    }];
}

// 获取系统配置信息
- (void)fetchSystemConfig {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/system/config"] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            ZZSystemConfigModel* model = [[ZZSystemConfigModel alloc] initWithDictionary:data error:nil];

            model.open_rent_need_pay_module = NO;
            [ZZUserDefaultsHelper setObject:model.wechat forDestKey:@"WeiXinPingJia"];//存储微信评价的差评理由
            [ZZUserHelper shareInstance].configModel = model;
            
            // 下载价格配置信息
            [[ZZUserHelper shareInstance].configModel fetchPriceConfig:NO
                                                      inViewController:nil
                                                                 block:nil];
            
            // 查看是否有新的版本
            if (model.version.haveNewVersion) {
                ZZUpdateAlertView *alertView = [[ZZUpdateAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [self.view.window addSubview:alertView];
            }
            
            NSString *questionVersion = [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].questionVersion];
            if (![questionVersion isEqualToString:model.question_sticker_version]) {
                [self downloadQuestionZip];
            }
            
        }
    }];
}

- (void)downloadQuestionZip {
    NSString *zipPath = [ZZFileHelper createPathWithChildPath:@"question"];
    [ZZDownloadHelper downloadWithUrl:[ZZUserHelper shareInstance].configModel.question_sticker_down_link cachesPath:zipPath progress:^(NSProgress *downloadProgress) {
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            [ZZFileHelper removeFileAtPath:[ZZFileHelper createPathWithChildPath:question_savepath]];
            BOOL success = [SSZipArchive unzipFileAtPath:[filePath path] toDestination:[ZZFileHelper createPathWithChildPath:question_savepath] overwrite:YES password:nil error:&error delegate:nil];
            if (success) {
                [ZZKeyValueStore saveValue:[ZZUserHelper shareInstance].configModel.question_sticker_version key:[ZZStoreKey sharedInstance].questionVersion];
            } else {
                NSMutableDictionary *param = [@{@"type":@"问题贴纸解压失败"} mutableCopy];
                if (error.code) {
                    [param setObject:[NSNumber numberWithBool:error.code] forKey:@"errorCode"];
                }
                if ([ZZUserHelper shareInstance].isLogin) {
                    NSDictionary *aDict = @{@"uid":[ZZUserHelper shareInstance].loginer.uid,
                                            @"content":[ZZUtils dictionaryToJson:param]};
                    [self uploadLog:aDict];
                }
            }
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:[filePath path] error:nil];
        } else {
            NSMutableDictionary *param = [@{@"type":@"问题贴纸下载失败"} mutableCopy];
            if (error.code) {
                [param setObject:[NSNumber numberWithBool:error.code] forKey:@"errorCode"];
            }
            if ([ZZUserHelper shareInstance].isLogin) {
                NSDictionary *aDict = @{@"uid":[ZZUserHelper shareInstance].loginer.uid,
                                        @"content":[ZZUtils dictionaryToJson:param]};
                [self uploadLog:aDict];
            }
        }
    }];
}

- (void)getUnread {
    WEAK_SELF();
    if ([ZZUserHelper shareInstance].oAuthToken && !_gettingUnread) {
        _gettingUnread = YES;
        [ZZUser getUserUnread:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            _gettingUnread = NO;
            if (data) {
                ZZUserUnread *userUnread = [[ZZUserUnread alloc] initWithDictionary:data error:nil];
                [ZZUserHelper shareInstance].unreadModel = userUnread;
                if (userUnread.have_system_red_packet) {
                    [weakSelf getUserInfo];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf manageRedPoint];
                    [weakSelf managerAppBadge];
                    [weakSelf.rentBubble setRentCount:userUnread.pd_receive];
                });
                if ([ZZUserHelper shareInstance].unreadModel.open_log && _shouldUploadLog) {
                    [weakSelf uploadLog:_logParam];
                }
                if ([userUnread.system_msg integerValue]>0 || [userUnread.hd integerValue]>0|| [userUnread.reply integerValue]>0) {
                    [ZZUserHelper shareInstance].updateMessageList = YES;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdateMessageBox object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdateTaskSnatchCount object:nil];
                [weakSelf manageUnreadCountWithCount:0];
                if (!_haveLoadUnread) {
                    ZZSnatchDetailModel *model = [[ZZSnatchDetailModel alloc] initWithDictionary:[userUnread.pd objectForKey:@"pd"] error:nil];
                    if ([[userUnread.pd objectForKey:@"have_ongoing_pd"] boolValue] && model.count > 0) {
//                        ZZSnatchDetailModel *model = [[ZZSnatchDetailModel alloc] initWithDictionary:[userUnread.pd objectForKey:@"pd"] error:nil];
//                        [weakSelf gotoLiveStreamPublishingView:model];
                    }
                }
                _haveLoadUnread = YES;
            }
        }];
    }
}

#pragma mark - 角标红点数字
- (void)managerAppBadge {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"PY_%s获取未读的消息个数",__func__);
          [UIApplication sharedApplication].applicationIconBadgeNumber = [ZZUserHelper shareInstance].unreadModel.order_ongoing_count + [ZZUserHelper shareInstance].unreadModel.my_answer_mmd_count+ [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_CUSTOMERSERVICE)]] + (int)[ZZUserHelper shareInstance].unreadModel.say_hi.count+[[ZZUserHelper shareInstance].unreadModel.system_msg intValue]+[[ZZUserHelper shareInstance].unreadModel.reply intValue]+[[ZZUserHelper shareInstance].unreadModel.hd intValue];
    });
}

- (void)manageUnreadCountWithCount:(int)redCount {
    if (redCount<=0) {
         redCount = 0;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"PY_%s获取未读的消息个数",__func__);

        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_CUSTOMERSERVICE)]]
        + (int)[ZZUserHelper shareInstance].unreadModel.say_hi.count
        + [[ZZUserHelper shareInstance].unreadModel.system_msg intValue]
        + [[ZZUserHelper shareInstance].unreadModel.reply intValue]
        + [[ZZUserHelper shareInstance].unreadModel.hd intValue]
        + (int)[ZZUserHelper shareInstance].unreadModel.pd_receive;
        count = count - redCount;

        ZZTabbarBtn *btn = (ZZTabbarBtn *)[_bgView viewWithTag:102];
        btn.redPointView.hidden = YES;
        btn.badgeView.hidden = YES;
        if (count > 0) {
            btn.badgeView.count = count;
            btn.badgeView.hidden = NO;
        }
    });
}

- (void)manageRedPoint {
    ZZTabbarBtn *userBtn = (ZZTabbarBtn *)[_bgView viewWithTag:103];
    
    userBtn.redPointView.hidden = YES;
    NSInteger count = [ZZUserHelper shareInstance].unreadModel.order_ongoing_count + [ZZUserHelper shareInstance].unreadModel.my_answer_mmd_count;
    if (count > 0) {
        userBtn.badgeView.count = count;
        userBtn.badgeView.hidden = NO;
    } else {
        userBtn.badgeView.hidden = YES;
        if ([ZZUserHelper shareInstance].unreadModel.my_answer_mmd || [ZZUserHelper shareInstance].unreadModel.order_commenting || [ZZUserHelper shareInstance].unreadModel.order_done) {
            userBtn.redPointView.hidden = NO;
        } else {
            userBtn.redPointView.hidden = YES;
        }
    }
}

#pragma mark - 引导、弹窗这些
- (void)showGuideView {
    if ([ZZUserHelper shareInstance].firstHomeGuide) {
        return;
    }
    
    // 第一次打开App不显示，先拿掉
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAuthorityView];
    });
    
    [ZZUserHelper shareInstance].firstHomeGuide = @"firstHomeGuide";
}

//权限弹窗
- (void)showAuthorityView {
    WEAK_SELF();
    if (![ZZUserHelper shareInstance].firstHomeGuide) {
        return;
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ZZAuthorityView *authorityView = [[ZZAuthorityView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [weakSelf.view.window addSubview:authorityView];
        });
    }
}

- (void)coverBtnClick:(UIButton *)sender {
    [sender.superview removeFromSuperview];
    [self showAuthorityView];
}

- (void)resetMenuBtn {
    self.menuBtn.selected = NO;
    self.menuBtn.showImgView.hidden = YES;
    NSInteger index = self.selectedIndex;
    ZZTabbarBtn *btn = (ZZTabbarBtn *)[self.bgView viewWithTag:100+index];
    btn.selected = YES;
    _tempBtn = btn;
    if (index >= 2) {
        index = index + 1;
    }
    [self shineAnimation:index];
}

- (BOOL)shouldShowBubble:(NSInteger)type {
    
    if (type != 1) {
        return YES;
    }
    
    if (![[ZZUserHelper shareInstance] isLogin]) {
        return NO;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    // 显示过了的用户
    NSArray *showBubblesUsersArr = [userDefault objectForKey:@"ShowBubblesUsersArr"];
    
    // 所有在改手机注册的用户
    NSArray *userRetegiteredArr = [userDefault objectForKey:@"UserRetegiteredArr"];
    
    if (!userRetegiteredArr || userRetegiteredArr.count == 0 || ![userRetegiteredArr containsObject:[ZZUserHelper shareInstance].loginer.uid]) {
        return NO;
    }
    
    NSMutableArray *showedUsersArr = showBubblesUsersArr.mutableCopy;
    if (!showedUsersArr) {
       showedUsersArr = @[].mutableCopy;
    }
    
    if (!showedUsersArr || showedUsersArr.count == 0) {
        if (!isNullString([ZZUserHelper shareInstance].loginer.uid)) {
            [showedUsersArr addObject:[ZZUserHelper shareInstance].loginer.uid];
            [userDefault setObject:showedUsersArr.copy forKey:@"ShowBubblesUsersArr"];
            [userDefault synchronize];
        }
        return YES;
    }
        
    if ([showBubblesUsersArr containsObject:[ZZUserHelper shareInstance].loginer.uid]) {
        return NO;
    }
    
    if (!isNullString([ZZUserHelper shareInstance].loginer.uid)) {
        [showedUsersArr addObject:[ZZUserHelper shareInstance].loginer.uid];
        [userDefault setObject:showedUsersArr.copy forKey:@"ShowBubblesUsersArr"];
        [userDefault synchronize];
    }
    
    return YES;
}

- (void)showBubbleView:(NSInteger)type {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideBubbleView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (![self shouldShowBubble:type]) {
                return;
            }
            
            switch (type) {
                case 1:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.bubbleView.type = type;
                        [self.view addSubview:self.bubbleView];
                       CGSize size = [_bubbleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                       self.bubbleView.bounds = CGRectMake(0, 0, size.width, size.height);
                       _bubbleView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT - TABBAR_HEIGHT - size.height/2.0);
                    });
                }
                    break;
                case 2: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UINavigationController *navCtl = self.selectedViewController;
                        if (navCtl.viewControllers.count == 1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.bubbleView.type = type;
                                [self.view addSubview:self.bubbleView];
                                CGSize size = [_bubbleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                                self.bubbleView.bounds = CGRectMake(0, 0, size.width, size.height);
                                _bubbleView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT - TABBAR_HEIGHT - size.height/2.0);
                            });
                            
                        }
                    });
                }
                    break;
                default:
                    break;
            }
        });
    });
}

- (void)hideBubbleView {
    if (_bubbleView) {
        [_bubbleView removeFromSuperview];
    }
}

- (void)showRentBubble {
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *nav = [ZZTabBarViewController sharedInstance].selectedViewController;
        if (nav.viewControllers.count < 2) {   //在跟视图才显示
            self.rentBubble.isShowSign = YES;
        }
    });
}

- (void)hideRentBubble {
    self.rentBubble.hidden = YES;
}

//用户錯误信息（昵称和头像）
- (BOOL)showUserErrorInfoAlertView {
    ZZUser *user = [ZZUserHelper shareInstance].loginer;
    NSRange range = [[ZZUserHelper shareInstance].loginer.avatar rangeOfString:@"person-flat.png"];
    
    if ((isNullString(user.avatar) || range.location != NSNotFound) && !user.isAvatarManualReviewing) {
        ZZUserErrorInfoAlertView *alertView = [[ZZUserErrorInfoAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        alertView.user = user;
        return YES;
    }
    if (isNullString(user.nickname)) {
        return YES;
    }
    return NO;
    
}

#pragma mark - Navagation
- (void)gotoLogin {
    NSLog(@"PY_登录界面%s",__func__);
    [[LoginHelper sharedInstance] showLoginViewIn:self];
}

- (BOOL)gotoLiveCheck {
    NSRange range = [[ZZUserHelper shareInstance].loginer.avatar rangeOfString:@"person-flat.png"];
    NavigationType type;
    if (![ZZUserHelper shareInstance].loginer.avatar || range.location != NSNotFound) {
        type = NavigationTypeNoPhotos;
    } else {
        type = NavigationTypeHavePhotos;
    }

    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:type inController:self];
    helper.user = [ZZUserHelper shareInstance].loginer;
    [helper start];
    return NO;
}

- (BOOL)gotoUploadPhoto {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ZZSignUpS3ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CompleteUserInfo"];
    vc.faces = [NSMutableArray arrayWithArray:[ZZUserHelper shareInstance].loginer.faces];
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.isPush = YES;
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *navCtl = [self selectedViewController];
    [navCtl pushViewController:vc animated:YES];
    return NO;
}

- (void)gotoRecordView {
    [ZZUtils checkRecodeAuth:^(BOOL authorized) {
        if (authorized) {
            [self showRecordView];
        }
    }];
}

- (void)showRecordView {
    if ([ZZUtils isBan]) {
        return;
    }
    _tempBtn.selected = NO;
    _tempBtn = nil;
    self.menuBtn.selected = YES;
    [self shineAnimation:2];
    ZZRecordViewController *controller = [[ZZRecordViewController alloc] init];
    self.recordViewController = controller;
    ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navCtl animated:YES completion:nil];
    WeakSelf
    controller.viewDismiss = ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf resetMenuBtn];
        strongSelf.recordViewController = nil;
    };
}

- (void)gotoLiveStreamPublishingView:(ZZSnatchDetailModel *)model {
    WEAK_SELF();
    if (!weakSelf.isUnderway && [weakSelf.remainingTime isEqualToString:@"0"]) {
        // 处理延迟
        return;
    }
    
    [[UIApplication sharedApplication].keyWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ZZTaskCancelConfirmAlert class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    if (model.type == 2) {
        if ( [ZZUserHelper shareInstance].isJumpPublish) {
            return;
        }
        [ZZUserHelper shareInstance].isJumpPublish = YES;
        ZZLiveStreamPublishingViewController *controller = [[ZZLiveStreamPublishingViewController alloc] init];
        controller.timeoutCount = model.valid_duration;
        controller.pId = model.id;
        controller.uid = model.from.uid;
        controller.remainingTime = weakSelf.remainingTime == nil ? model.remain_time / 1000  : [weakSelf.remainingTime integerValue];   // 线上任务剩余时间
        controller.hidesBottomBarWhenPushed = YES;
        ZZNavigationController *navCtl = weakSelf.selectedViewController;
        [navCtl pushViewController:controller animated:YES];
    } else if (model.type == 3) {
        ZZTaskSnatchListViewController *controller = [[ZZTaskSnatchListViewController alloc] init];
        controller.validate_count = model.valid_duration;
        controller.totalDuring = model.remain_time/100;
        controller.snatchModel = model;
        controller.hidesBottomBarWhenPushed = YES;
        ZZNavigationController *navCtl = weakSelf.selectedViewController;
        [navCtl pushViewController:controller animated:YES];
    }
}

#pragma mark - lazyload
- (ZZTabbarBtn *)menuBtn {
    if (!_menuBtn) {
        CGFloat width = SCREEN_WIDTH/5.0;
        _menuBtn = [[ZZTabbarBtn alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width)/2.0, 0, width, 49)];
        [_menuBtn setImage:[UIImage imageNamed:@"icon_tabbar_record_n"] forState:UIControlStateNormal];
        [_menuBtn setImage:[UIImage imageNamed:@"icon_tabbar_record_p"] forState:UIControlStateSelected];
        [_menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}

- (ZZTabbarBubbleView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [[ZZTabbarBubbleView alloc] init];
    }
    return _bubbleView;
}

- (ZZLiveStreamSnatchedAlert *)snatchedAlert {
    WeakSelf;
    if (!_snatchedAlert) {
        _snatchedAlert = [[ZZLiveStreamSnatchedAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view.window addSubview:_snatchedAlert];
        
        [self.view.window endEditing:YES];
        _snatchedAlert.touchSure = ^(NSDictionary *aDict){
            [weakSelf closeSnatchedAlert:aDict];
        };
    }
    return _snatchedAlert;
}

- (ZZTabbarRentBubbleView *)rentBubble {
    if (nil == _rentBubble) {
        _rentBubble = [[ZZTabbarRentBubbleView alloc] init];
        UIView *tabbarBtn = [_bgView viewWithTag:102];
        _rentBubble.pointX = tabbarBtn.center.x;
        _rentBubble.hidden = YES;
        [self.view addSubview:_rentBubble];
        [_rentBubble mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@-30);
            make.bottom.equalTo(@(-TABBAR_HEIGHT));
        }];
    }
    return _rentBubble;
}

#pragma mark - WBFastRentManagerObserver methods
- (void)missionDidChangeWithUnderway:(NSString *)isUnderway {
    self.isUnderway = [isUnderway isEqualToString:@"1"];
    if (!self.isUnderway) {
        self.remainingTime = @"0";
    }
}

- (void)remainingTimeDidChangeWithTime:(NSString *)time {
    self.remainingTime = time;
}

@end
