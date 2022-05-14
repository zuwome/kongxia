//
//  ZZUserCenterViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//
#import "ZZFastChatAgreementVC.h"
#import "ZZUserCenterViewController.h"
#import "ZZUserChuzuViewController.h"
#import "ZZRealNameListViewController.h"
#import "ZZSettingViewController.h"
#import "ZZFansViewController.h"
#import "ZZAttentionViewController.h"
#import "ZZVideoViewController.h"
#import "ZZTabBarViewController.h"
#import "ZZRentViewController.h"
#import "ZZUserLevelViewController.h"
#import "ZZOrderListViewController.h"
#import "ZZUserStatisDataViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZWXViewController.h"
#import "ZZPerfectPictureViewController.h"
#import "ZZRegisterRentViewController.h"
#import "ZZUserEditViewController.h"
#import "ZZMyCommissionsController.h"

#import "ZZRankIndexController.h"
#import "ZZMyKTVController.h"

#import "ZZUserCenterBaseCell.h"
#import "ZZUserCenterOrderCell.h"
#import "ZZUserCenterInfoCell.h"
#import "ZZUserCenterCountCell.h"
#import "ZZUserCenterRespondCell.h"
#import "ZZUserCenterRentGuideCell.h"
#import "ZZUserCenterNewFansView.h"
#import "ZZPopularityVC.h"
#import "ZZRentalAgreementVC.h"
#import "ZZServiceChargeVC.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZUserNotificationAlert.h"

#import "ZZMyWalletViewController.h"//新版的我的钱包
#import "ZZHelpCenterVC.h"//帮助中心
#import "ZZOpenSuccessVC.h"
#import "ZZChuZhuGuide.h"//出租的引导页

#import "ZZMyIntegralViewController.h"//我的积分
#import "ZZChatServerViewController.h"//在线客服

#import "CABasicAnimation+Ext.h"//动画
#import "JX_GCDTimerManager.h"

#import <SobotKit/SobotKit.h>

@interface ZZUserCenterViewController () <UITableViewDataSource,UITableViewDelegate, ZZUserCenterInfoCellDelegate, RealIDPresentViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZZUserCenterNewFansView *newfansView;
@property (nonatomic, strong) ZZUser *loginer;
@property (nonatomic, assign) BOOL hideChuzuRedPoint;
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, assign) BOOL pushHideBar;

@property (nonatomic,strong) UIButton *signInButton;//签到领取积分按钮

@property (nonatomic, assign) BOOL isLoadingInfos;

@property (nonatomic, assign) NSInteger unfinishedWechatOrderNum;

@property (nonatomic, assign) NSInteger orderNumbers;

@property (nonatomic, weak) ZZChatServerViewController *chatServerVC;

@end

@implementation ZZUserCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [ZZUtils managerUnread];
    [self manageRedView];
    if (_canLoad) {
        [self loadInfo];
    }
    if ([ZZUserHelper shareInstance].oAuthToken) {
        _loginer = [ZZUserHelper shareInstance].loginer;
        [self getUserUnread];
        [self fetchUnfinishWechatOrder];
    }
    _canLoad = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[ZZUserDefaultsHelper objectForDestKey:@"CloseNotificationWhenFirstRegisterRent"] boolValue]) {
        [self showNotificationAlert];
        [ZZUserDefaultsHelper setObject:@(NO) forDestKey:@"CloseNotificationWhenFirstRegisterRent"];
    }
    if (self.chatServerVC) {
        [self.chatServerVC left];
        self.chatServerVC = nil;
    }
}

/**
 注册cell
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ZZTabBarViewController sharedInstance] hideBubbleView];
    [[ZZTabBarViewController sharedInstance] hideRentBubble];
    if (_pushHideBar) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _pushHideBar = NO;
    }
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _unfinishedWechatOrderNum = -1;
    _orderNumbers = -1;
    _isLoadingInfos = NO;
    // Do any additional setup after loading the view.
    _loginer = [ZZUserHelper shareInstance].loginer;
    self.navigationItem.title = @"我";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createNavigationRightBtn];
    
    _canLoad = YES;
    [self createViews];
    [self fetchUnfinishWechatOrder];
    // 双击tab 刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarRefresh) name:KMsg_TabbarRefreshNotification object:nil];

}

#pragma mark -- Notification Implementation
- (void)tabbarRefresh {
    if ([[UIViewController currentDisplayViewController] isKindOfClass: [self class]]) {
        if (!_isLoadingInfos) {
            [self loadInfo];
        }
    }
}

- (void)showNotificationAlert {
    [ZZUserNotificationAlert showAlert];
}

/**
 当用户没有开通出租信息的时候
 */
- (void)firstGuideWhenUserNotApplyChuZhu {
    
    if (self.loginer && self.loginer.rent.status == 0) {
        NSString *key = [NSString stringWithFormat:@"%@,%@",@"ZZChuZhuGuideKey",_loginer.uid];
        NSString *string = [ZZKeyValueStore getValueWithKey:key];
        if (string) {
           return;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        WS(weakSelf);
        [ZZChuZhuGuide ShowChuZhuGuideWithShowView:cell goToApply:^{
            [weakSelf gotoUserChuZuVC];
        }];
        [ZZKeyValueStore saveValue:@"ZZChuZhuGuideKey" key:key];
    }
}

- (void)createNavigationRightBtn {
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, 0, 44, 44);
    [settingBtn setImage:[UIImage imageNamed:@"icon_user_setting"] forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"icon_user_setting"] forState:UIControlStateHighlighted];
    [settingBtn addTarget:self action:@selector(gotoSettingView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc]initWithCustomView:settingBtn];
    btnItem.width = kLeftEdgeInset;
    self.navigationItem.rightBarButtonItems = @[btnItem, rightBarButon];
}

#pragma mark - 签到按钮
- (void)creatLeftButton {
    if ([ZZUserHelper shareInstance].loginer.today_issign) {
        return;
    }
    _signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _signInButton.frame = CGRectMake(0, 0, 44, 44);
    [_signInButton setImage:[UIImage imageNamed:@"icQiandaoEffectWode"] forState:UIControlStateNormal];
    [_signInButton setImage:[UIImage imageNamed:@"icQiandaoEffectWode"] forState:UIControlStateHighlighted];
    _signInButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_signInButton addTarget:self action:@selector(goToMyIntegral) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc]initWithCustomView:_signInButton];
    btnItem.width = kLeftEdgeInset;
    self.navigationItem.leftBarButtonItems = @[btnItem, rightBarButon];
    
    WeakSelf
    [_signInButton.layer addAnimation:[CABasicAnimation jitterAnimaitionRepeatCount:4] forKey:@"signIn"];

    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"signInTime" timeInterval:4+4*0.3 queue:nil repeats:YES actionOption:AbandonPreviousAction action:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([ZZUserHelper shareInstance].loginer.today_issign) {
                [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"signInTime"];
                [weakSelf.signInButton.layer removeAnimationForKey:@"signIn"];
                return ;
            }
            [weakSelf.signInButton.layer addAnimation:[CABasicAnimation jitterAnimaitionRepeatCount:4] forKey:@"signIn"];
        });
    }];
}

- (void)createViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStyleGrouped];
    [self registCell];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    [self.view addSubview:_tableView];
    [self firstGuideWhenUserNotApplyChuZhu];
}

- (void)registCell {
    [self.tableView registerClass:[ZZUserCenterInfoCell class] forCellReuseIdentifier:@"infocell"];
    [self.tableView registerClass:[ZZUserCenterCountCell class] forCellReuseIdentifier:@"countcell"];
    [self.tableView registerClass:[ZZUserCenterOrderCell class] forCellReuseIdentifier:@"ordercell"];
    [self.tableView registerClass:[ZZUserCenterRentGuideCell class] forCellReuseIdentifier:@"rentguide"];
    [self.tableView registerClass:[ZZUserCenterRespondCell class] forCellReuseIdentifier:@"respond"];
    [self.tableView registerClass:[ZZUserCenterBaseCell class] forCellReuseIdentifier:@"basecell"];
}

#pragma mark - DATA
- (void)loadInfo {
    _isLoadingInfos = YES;
    [ZZUser loadUser:[ZZUserHelper shareInstance].loginerId param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        _isLoadingInfos = NO;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:nil];
            [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
            _loginer = user;
            [self reload];
            
            if ([ZZUserHelper shareInstance].userFansCount) {
                // 新增粉丝view
                NSInteger count = [[ZZUserHelper shareInstance].userFansCount integerValue];
                if (count < _loginer.follower_count) {
                    [self showNewfansViewWithCount:_loginer.follower_count - count];
                }
            }
            [ZZUserHelper shareInstance].userFansCount = [NSString stringWithFormat:@"%ld",_loginer.follower_count];
            
            // 判断审核头像是否失败,只显示一次
            NSString *isManualReviewing = [ZZUserDefaultsHelper objectForDestKey:@"isManualReviewing"];
            if (_loginer.avatar_manual_status == 3 && _loginer.rent.status == 1 && [isManualReviewing isEqualToString:@"1"]) {
                ZZPhoto *photo = _loginer.photos.firstObject;
                NSString *currentReviewedImg = [ZZUserDefaultsHelper objectForDestKey:@"currentReviewedImg"];
                if (![currentReviewedImg isEqualToString:photo.url]) {
                    [ZZInfoToastView showOnceWithType:ToastRealAvatarReviewFail action:^(NSInteger actionIndex, ToastType type) {
                        if (actionIndex == 1 && type == ToastRealAvatarReviewFail) {
                            [self gotoEditController];
                        }
                    }];
                    currentReviewedImg = photo.url;
                    [ZZUserDefaultsHelper setObject:currentReviewedImg forDestKey:@"currentReviewedImg"];
                }
                
                NSString *isManualReviewing = @"0";
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:isManualReviewing forKey: @"isManualReviewing"];
                [userDefaults synchronize];
            }
            
            [self fetchTotalMoney];
            [self firstGuideWhenUserNotApplyChuZhu];
        }
    }];
}

- (void)fetchTotalMoney {
    [ZZRequest method:@"GET" path:@"/api/getInviteUserTotal" params:@{@"uid": [ZZUserHelper shareInstance].loginer.uid} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            if ([data isKindOfClass:[NSArray class]] && [data count] > 0) {
                if ([data[0][@"_id"] isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
                    if ([data[0][@"total_money"] isKindOfClass:[NSNumber class]]) {
                        _loginer.totalCommissionIncome = [data[0][@"total_money"] doubleValue];
                        [_tableView reloadData];
                    }
                }
            }
        }
    }];
}

- (void)reload {
    _loginer = [ZZUserHelper shareInstance].loginer;
    [self manageRedView];
}

- (void)getUserUnread {
    [[ZZTabBarViewController sharedInstance] manageRedPoint];
    [_tableView reloadData];
}

- (void)fetchUnfinishWechatOrder {
    if (!UserHelper.configModel.wechat_new) {
        return;
    }
    
    [ZZRequest method:@"GET" path:@"/api/wechat/getWechatSeenCount" params:@{@"userId": UserHelper.loginerId} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (!error) {
            if ([data isKindOfClass: [NSDictionary class]]) {
                _unfinishedWechatOrderNum = [data[@"notCount"] integerValue];
                _orderNumbers = [data[@"total"] count];
            }
            else {
                _unfinishedWechatOrderNum = -1;
            }
            [_tableView reloadData];
        }
    }];
}

#pragma mark -
- (void)manageRedView {
    _hideChuzuRedPoint = YES;
    if (_loginer.rent.status != 2 && ![ZZUserHelper shareInstance].userFirstRent) {
        _hideChuzuRedPoint = NO;
    }
    [_tableView reloadData];
}

- (void)showNewfansViewWithCount:(NSInteger)count {
    if (_newfansView) {
        _newfansView.hidden = NO;
    } else {
        [_tableView addSubview:self.newfansView];
    }
    
    self.newfansView.titleLabel.text = [NSString stringWithFormat:@"%ld位新粉丝",count];
    CGFloat width = [self.newfansView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    
    self.newfansView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 160, width, 29);
    self.newfansView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.newfansView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.newfansView.alpha = 0;
            } completion:^(BOOL finished) {
                self.newfansView.hidden = YES;
            }];
        });
    }];
}

#pragma mark - RealIDPresentViewDelegate
- (void)showProtoclWithView:(RealIDPresentView *)view {
    [self refundView];
}

- (void)goVerifyFaceWithView:(RealIDPresentView *)view {
    [self gotoVerifyFace:NavigationTypeApplyTalent];
}

- (void)changePhotoWithView:(RealIDPresentView *)view {
    [self gotoUploadPicture:NavigationTypeApplyTalent title:@"更换头像" successMessage:@"提交成功，我们1个工作日内完成头像审核，现在您可以去编辑达人信息了"];
}

- (void)signUpRentWithView:(RealIDPresentView *)view {
    [self gotoUserChuZuVC];
}

- (void)editProfileWithView:(RealIDPresentView *)view {
    [self gotoEditController];
}

- (void)showRealView:(BOOL)isSignUpRent {
    RealIDPresentView *view = [RealIDPresentView showWithUser:[ZZUserHelper shareInstance].loginer isFromSignUpRent:isSignUpRent];
    view.delegate = self;
    [self.view.window addSubview:view];
}

- (void)cellWithRealFaceAction:(ZZUserCenterInfoCell *)cell {
    [self showRealView:NO];
}

#pragma mark - UITableViewMethod
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 10;
    }
    else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZZUserCenterInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infocell"];
            cell.delegate = self;
            [cell setData:_loginer];
            return cell;
        }
        else {
            ZZUserCenterCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countcell"];
            [cell setData:_loginer];
            cell.touchAttent = ^{
                [self gotoAttentView];
            };
            cell.touchFans = ^{
                [self gotoFansView];
            };
            cell.touchLevel = ^{
                [self gotoLevelView];
            };
            return cell;
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        ZZUserCenterOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordercell"];
        cell.selectOrder = ^(NSInteger index) {
            [self gotoOrderWithIndex:index];
        };
        [cell setData];
        return cell;
    }
    else if (indexPath.section == 2 && indexPath.row == 1) {
        if (_loginer.rent.status == 0 || _loginer.banStatus) {
            ZZUserCenterRentGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rentguide"];
            return cell;
        } else {
            ZZUserCenterRespondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"respond"];
            [cell setData:_loginer];
            return cell;
        }
    }
    else {
       if (indexPath.section == 3 && indexPath.row == 0 && _loginer.rent.status == 0) { // 没有出租信息不显示人气值
           return [UITableViewCell new];
       }
       else if (indexPath.section == 3 && indexPath.row == 6 && [ZZUtils isIdentifierAuthority:_loginer]) {
           return [UITableViewCell new];
       }
       else {
           ZZUserCenterBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basecell"];
           [cell setData:_loginer indexPath:indexPath hideRedPoint:_hideChuzuRedPoint];
           if (UserHelper.configModel.wechat_new) {
               if (indexPath.section == 3 && indexPath.row == 3) {
                   [cell setRedDot:_unfinishedWechatOrderNum];
               }
               else {
                   [cell setRedDot:-1];
               }
           }
           else {
                [cell setRedDot:-1];
           }
           
           return cell;
       }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                return 115;
            }
        } break;
        case 1: {
            if (indexPath.row == 1) {
                return 76;
            }
        } break;
        case 2: {
            if (indexPath.row == 1) {
                if (_loginer.rent.status == 0 || _loginer.banStatus) {
                    return [tableView fd_heightForCellWithIdentifier:@"rentguide" configuration:^(id cell) {
                        
                    }];
                }
            }
        } break;
        case 3: {
            if (indexPath.row == 0 && _loginer.rent.status == 0) { // 没有出租信息不显示人气值
                return 0;
            }
            if (indexPath.row == 1) {
                return 50;
            }
            if (indexPath.row == 6 && [ZZUtils isIdentifierAuthority:_loginer]) {
                return 0;
            }
        } break;
        default: break;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.1 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        return headView;
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 3 ? 10 : 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        return footView;
    } else {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        return footView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {//我的个人资料详情
            [self gotoUserPage];
        } break;
        case 1: {//我的档期
            [self gotoOrderWithIndex:4];
        } break;
        case 2: {
            if (indexPath.row == 0) {
                [self gotoChuzu];
            }
            else {
                if (_loginer.rent.status == 0 || _loginer.banStatus) {
                    _pushHideBar = YES;
                    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
                    controller.urlString = H5Url.kongXiaGuide;
                    controller.isHideBar = YES;
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                else {
                    //用户数据统计
                    ZZUserStatisDataViewController *controller = [[ZZUserStatisDataViewController alloc] init];
                    controller.urlString = [NSString stringWithFormat:@"%@/user/%@/stats/page",kBase_URL,_loginer.uid];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        } break;
        case 3: {
            switch (indexPath.row) {
                case 0: {
                    //人气值
                    [self gotoPopularity];
                } break;
                case 1: {
                    // 分佣
                    ZZUserCenterBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.redIntegralView.hidden = YES;
                    [self gotoCommissionViewController];
                } break;
                case 2: {
                    [self gotoWallet];
                } break;
                case 3: {
                    
                    if (UserHelper.configModel.wechat_new) {
                        if (self.orderNumbers == -1) {
                            [ZZWechatOrdersViewController fetchOrdersWithComplete:^(NSArray * _Nonnull ordersArray) {
                                if (ordersArray.count != 0) {
                                    [self gotoWXOrderViewController];
                                }
                                else {
                                    [self gotoWXViewController];
                                }
                            }];
                        }
                        else {
                            if (self.orderNumbers > 0) {
                                [self gotoWXOrderViewController];
                            }
                            else {
                                [self gotoWXViewController];
                            }
                        }
                    }
                    else {
                        [self gotoWXViewController];
                    }
                    
                    
                } break;
                case 4: {
                    [self gotoMyKTV];
                    break;
                }
                case 5: {
                    [self gotoMemeda];
                } break;
                
                case 6: {
                    [self gotoRealName];
                } break;
                case 7: {
                    [self gotoCustomService];
                } break;
                case 8: {
                    [self gotoChatServerView];
                } break;
                case 9: {
                    [self gotoHelpCenter];
                } break;
                
                default: break;
            }
        } break;
        default: break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UINavigation
- (void)gotoEditController {
    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoCommissionViewController {
    ZZMyCommissionsController *vc = [[ZZMyCommissionsController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 客服
 */
- (void)gotoChatServerView {
    [MobClick event:Event_click_zhichikefu];

//    //配置UI
//    ZCKitInfo *uiInfo = [ZCKitInfo new];
//    uiInfo.topViewBgColor = kGoldenRod;
//
//    [ZCSobotApi openZCChat:uiInfo with:self target:nil pageBlock:^(id  _Nonnull object, ZCPageBlockType type) {
//    } messageLinkClick:^BOOL(NSString * _Nonnull link) {
//        return YES;
//    }];
    [ZZServerHelper showServer];
}

/**
 高级客服经理
 */
- (void)gotoCustomService {
    ZZUserCustomsViewController *controller = [[ZZUserCustomsViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 帮助中心
 */
- (void)gotoHelpCenter {
    ZZHelpCenterVC *controller = [[ZZHelpCenterVC alloc] init];
    controller.urlString = H5Url.helpAndFeedback;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 人气值
 */
- (void)gotoPopularity {
    ZZPopularityVC *vc = [[ZZPopularityVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 我的积分
 */
- (void)goToMyIntegral {
    ZZMyIntegralViewController *vc = [[ZZMyIntegralViewController alloc]init];
    [MobClick event:Event_click_user_my_sign_in];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 个人信息详情
 */
- (void)gotoUserPage {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.user = _loginer;
    controller.uid = _loginer.uid;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 设置界面
 */
- (void)gotoSettingView {
    _canLoad = NO;
    [MobClick event:Event_click_me_setting];
    ZZSettingViewController *controller = [[ZZSettingViewController alloc] init];
    controller.user = _loginer;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 我的关注
 */
- (void)gotoAttentView {
    ZZAttentionViewController *controller = [[ZZAttentionViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.user = _loginer;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 我的粉丝
 */
- (void)gotoFansView {
    ZZFansViewController *controller = [[ZZFansViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.user = _loginer;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 用户等级
 */
- (void)gotoLevelView {
    ZZUserLevelViewController *controller = [[ZZUserLevelViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 我的钱包
- (void)gotoWallet {
    [MobClick event:Event_click_me_money];
    ZZMyWalletViewController *controller = [[ZZMyWalletViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.user = _loginer;
    [self.navigationController pushViewController:controller animated:YES];
}

// 跳转到我的微信订单
- (void)gotoWXOrderViewController {
    ZZWechatOrdersViewController *vc = [ZZWechatOrdersViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 跳转到我的微信
- (void)gotoWXViewController {
    
    // 判断当前操作是否需要做验证 add_wechat:微信操作
    BOOL canProceed = [UserHelper canProceedFollowingAction:NavigationTypeWeChat block:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
        
    }];
    if (!canProceed) {
        return;
    }

    [MobClick event:Event_click_usercenter_wx];
    ZZWXViewController *controller = [[ZZWXViewController alloc] init];
    controller.user = _loginer;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoMyKTV {
    ZZMyKTVController *controller = [[ZZMyKTVController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 实名认证
- (void)gotoRealName {
    [MobClick event:Event_click_me_realname];
    ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.user = _loginer;
    [self.navigationController pushViewController:controller animated:YES];
}

// 我的视频
- (void)gotoMemeda {
    [MobClick event:Event_click_usercenter_video];
    ZZVideoViewController *controller = [[ZZVideoViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 申请达人(出租自己)
- (void)gotoChuzu {
    if ([[ZZUserHelper shareInstance] didHaveRealAvatar]) {
        [self gotoUserChuZuVC];
    }
    else {
        if ([[ZZUserHelper shareInstance] isAvatarManualReviewing]) {
            if ([ZZUserHelper shareInstance].loginer.faces.count != 0) {
                [self gotoUserChuZuVC];
            }
            else {
                [self showRealView:YES];
            }
        }
        else {
            [self showRealView:YES];
        }
    }
}

// 出租协议
- (void)gotoRentalAgreementVC {
    ZZRentalAgreementVC *vc = [ZZRentalAgreementVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 出租信息
 */
- (void)gotoUserChuZuVC {
    [MobClick event:Event_click_me_rent];
    WeakSelf
    //未出租状态前往申请达人，其余状态进入主题管理
    if (self.loginer.rent.status == 0) {
        // 没有打开定位权限不给去添加技能
        if (![ZZUtils isAllowLocation]) {
            return;
        }
        
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
        [self manageRedView];
    }
}

// 提取方法 统一判断是否需要去完善头像/人脸
- (BOOL)isReturnWithType:(NavigationType)type {
    WEAK_SELF();
    // 如果没有人脸
    if ([ZZUserHelper shareInstance].loginer.faces.count == 0) {
        NSString *tips = @"";
        if (type == NavigationTypeApplyTalent) {
            tips = @"目前账户安全级别较低，将进行身份识别，否则无法发布出租信息";
        }
        else if (type == NavigationTypeWeChat) {
            tips = @"目前账户安全级别较低，将进行身份识别，否则无法设置微信号";
        }
        else if (type == NavigationTypeRealName) {
            tips = @"目前账户安全级别较低，将进行身份识别，否则无法实名认证";
        }
        
        [UIAlertController presentAlertControllerWithTitle:tips message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                // 去验证人脸
                [weakSelf gotoVerifyFace:type];
            }
        }];
        return YES;
    }
    
    // 如果没有头像
    ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos_origin.firstObject;
    if (photo == nil || photo.face_detect_status != 3) {
        if (type == NavigationTypeWeChat) {
            // 判断当前操作是否需要做验证 add_wechat:微信操作
            if ([[ZZUserHelper shareInstance].configModel.disable_module.no_have_real_avatar indexOfObject:@"add_wechat"] == NSNotFound) {
                return NO;
            }
        }
        if (type == NavigationTypeApplyTalent) {
            return NO;
        }
        NSString *tips = @"";
        if (type == NavigationTypeWeChat) {
            tips = @"您未上传本人正脸五官清晰照，无法设置微信号，请前往上传真实头像";
        }
        else if (type == NavigationTypeRealName) {
            tips = @"您未上传本人正脸五官清晰照，不能实名认证，请前往上传真实头像";
        }
        
        [UIAlertController presentAlertControllerWithTitle:tips message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                // 去上传真实头像
                [weakSelf gotoUploadPicture:type title:nil successMessage:nil];
            }
        }];
        return YES;
    }
    return NO;
}

- (void)refundView {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = [NSString stringWithFormat:@"%@%@",kBase_URL,@"/realAvator"];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 没有人脸，则验证人脸
- (void)gotoVerifyFace:(NavigationType)type {
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:type inController:self];
    helper.user = [ZZUserHelper shareInstance].loginer;
    [helper start];
}

// 没有头像，则上传真实头像
- (void)gotoUploadPicture:(NavigationType)type title:(NSString *)title successMessage:(NSString *)successMessage {
    ZZPerfectPictureViewController *vc = [[ZZPerfectPictureViewController alloc] initWithTitle:title successMessage:successMessage];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.type = type;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
我的档期
 */
- (void)gotoOrderWithIndex:(NSInteger)index {
    OrderListType _type = OrderListTypeAll;
    switch (index) {
        case 0: {
            [MobClick event:Event_click_me_order_ing];
            _type = OrderListTypeIng;
        } break;
        case 1: {
            _type = OrderListTypeComment;
            [MobClick event:Event_click_me_order_commenting];
        } break;
        case 2: {
            [MobClick event:Event_click_me_order_completed];
            _type = OrderListTypeDone;
        } break;
        default: {
            _type = OrderListTypeAll;
        } break;
    }
    ZZOrderListViewController *controller = [[ZZOrderListViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.type = _type;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Lazyload
- (ZZUserCenterNewFansView *)newfansView {
    if (!_newfansView) {
        _newfansView = [[ZZUserCenterNewFansView alloc] init];
        _newfansView.titleLabel.text = @"3位新粉丝";
    }
    return _newfansView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
