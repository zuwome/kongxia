//
//  ZZNewRentViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/10/9.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRentViewController.h"
#import "ZZRentInfoViewController.h"
#import "ZZRentDynamicViewController.h"
#import "ZZRemarkViewController.h"
#import "ZZUserEditViewController.h"
#import "ZZRentAttentionViewController.h"
#import "ZZRentFansViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZSkillDetailViewController.h"
#import "ZZPerfectPictureViewController.h"
#import "ZZRentMemedaViewController.h"
#import "ZZChatViewController.h"
#import "ZZMeBiViewController.h"
#import "ZZliveStreamConnectingController.h"
#import "ZZIDPhotoManagerViewController.h"
#import "ZZRentOrderInfoViewController.h"

#import "ZZRentPageNavigationView.h"
#import "ZZNewRentTableView.h"
#import "ZZRentPageHeadView.h"
#import "ZZRentPageTypeView.h"
#import "ZZRentPageBottomView.h"
#import "ZZRentChatBottomView.h"
#import "ZZRightShareView.h"
#import "ZZRequestLiveStreamAlert.h"
#import "ZZInfoToastView.h"

#import "ZZNewRentContainerCell.h"

#import "ZZChatCallIphoneManagerNetWork.h"
#import "ZZSendVideoManager.h"

@interface ZZRentViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate,ZZIDPhotoManagerViewControllerDelegate>

@property (nonatomic, assign) BOOL isSelf;              //是否是本人
@property (nonatomic, assign) BOOL isInBlackList;       //是否在黑名单中
@property (nonatomic, assign) CGFloat bottomHeight;     //底部栏高度
@property (nonatomic, assign) CGFloat itemBarHeight;    //选项栏高度
@property (nonatomic, assign) BOOL scrollLock;          //滑动锁
@property (nonatomic, assign) BOOL haveLoadBuyWX;       //已展示购买微信弹窗

@property (nonatomic, copy) NSDictionary *taskDic;
@property (nonatomic, strong) UserInfoReviewInfoCell *infoView;
@property (nonatomic) ZZRentInfoViewController *infoCtrl;
@property (nonatomic) ZZRentDynamicViewController *dynamicCtrl;
@property (nonatomic) ZZliveStreamConnectingController *connectingVC;

@property (nonatomic) ZZNewRentTableView *tableView;
@property (nonatomic) ZZRentPageHeadView *tableHeader;
@property (nonatomic) ZZRentPageTypeView *typeView;
@property (nonatomic) ZZRentPageNavigationView *naviBar;
@property (nonatomic) ZZRentPageBottomView *bottomView;
@property (nonatomic) ZZRentChatBottomView *fastChatBottomView;
@property (nonatomic) ZZRightShareView *shareView;
@property (nonatomic) ZZRequestLiveStreamAlert *requestAlertView;

@property (nonatomic) ZZNewRentContainerCell *containerCell;

@property (nonatomic, assign) BOOL isBan;

@end

@implementation ZZRentViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _source = SourcePersonalInfo;
    }
    return self;
}

// TODO:lifeCycle && NavigationDelegate
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = nil;
    [self getBanStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isFromHome && self.navigationController.viewControllers.count == 1) {
        self.tabBarController.tabBar.hidden = NO;
        self.navigationController.delegate = self;
    } else {
        //        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KMsg_CreateOrderNotification object:nil];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self initConfig];
    [MobClick event:Event_user_detail_info_tab];
    [self initControllers];
    [self createView];
    [self addObserver];
    [self reloadWithUid];   //获取最新的用户数据
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createOrderReload) name:KMsg_CreateOrderNotification object:nil];
}

- (void)createOrderReload {
    [self reloadWithUid];
}

- (void)initConfig {
    _isSelf = [self.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid];
    _bottomHeight = _isSelf ? 0 : (isIPhoneX ? 89 : 55);
    _itemBarHeight = 40;
}

- (void)createView {
    self.view.backgroundColor = kBGColor;
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = UIColor.redColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-_bottomHeight);
    }];
    [self.view addSubview:self.naviBar];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.height.equalTo(@(_bottomHeight));
    }];
    
    [self.view addSubview:self.fastChatBottomView];
    [self.fastChatBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.bottomView);
    }];
}

- (void)initControllers {
    [self addChildViewController:self.infoCtrl];
    [self addChildViewController:self.dynamicCtrl];
}

- (void)addObserver {
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(self.tableView)];
}

#pragma mark - network
/**
 查询是否是黑名单
 */
- (void)getBanStatus {
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:_uid success:^(int bizStatus) {
        if (bizStatus == 0) {
            _isBan = YES;
        } else {
            _isBan = NO;
        }
        NSLog(@"是否是黑名单%d",_isBan);
    } error:^(RCErrorCode status) {
        NSLog(@"查询失败");
    }];
}

- (void)reloadWithUid {
    if ([ZZUserHelper shareInstance].isLogin) {
        [ZZUser loadUser:_uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else if (data) {
                _user = [[ZZUser alloc] initWithDictionary:data error:nil];
                if ([data[@"rent"] isKindOfClass: [NSDictionary class]] && [data[@"rent"][@"city"] isKindOfClass: [NSDictionary class]]) {
                    _user.rent.city.cityId = data[@"rent"][@"city"][@"id"];
                }
                [self fetchTask];
                [self getUserStatus];
            }
        }];
    } else {
        [ZZUser getUnloginUserDetailWithUid:_uid dic:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else if (data) {
                _user = [[ZZUser alloc] initWithDictionary:data error:nil];
                [self getUserStatus];
            }
        }];
    }
}

- (void)fetchTask {
    if (_entryTarget == TargetNormalTaskPick || _entryTarget == TargetTonggaoPick) {
        [ZZRequest method:@"GET"
                     path:@"/api/pd/getPdRelationPoint"
                   params:@{
                            @"type": @2,
                            @"from": UserHelper.loginer.uid,
                            @"to": !isNullString(self.uid) ? self.uid : self.user.uid,
                            }
                     next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                         if (!error && data && ![data isKindOfClass:[NSNull class]]) {
                             _taskDic = data[@"pdGet"];
                             if (_taskDic && [_taskDic count] != 0) {

                                 [self.bottomView.rentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
                                 self.bottomView.rentBtn.backgroundColor = kYellowColor;
                                 [self.bottomView.rentBtn setTitle:@"选TA" forState:UIControlStateNormal];
                             }
                         }
                     }];
    }
}

- (void)getUserStatus {
    if (_entryTarget == TargetNormalTaskSignup) {
        [self.bottomView.rentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        self.bottomView.rentBtn.backgroundColor = kYellowColor;
    }
    else if (_entryTarget == TargetTonggaoPick) {
        [self.bottomView.rentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
         self.bottomView.rentBtn.backgroundColor = kYellowColor;
         [self.bottomView.rentBtn setTitle:@"马上选TA" forState:UIControlStateNormal];
    }
    else if (_taskDic && [_taskDic count] != 0) {
        [self.bottomView.rentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        self.bottomView.rentBtn.backgroundColor = kYellowColor;
        [self.bottomView.rentBtn setTitle:@"选TA" forState:UIControlStateNormal];
    }
    else if ((_user.rent.status == 2 && self.user.rent.show)) {
        if ([UserHelper isUsersAvatarManuallReviewing:_user]) {
            if ([UserHelper canShowUserOldAvatarWhileIsManualReviewingg:_user]) {
                [self.bottomView.rentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
                self.bottomView.rentBtn.backgroundColor = kYellowColor;
            }
            else {
                [self.bottomView.rentBtn setTitleColor:HEXCOLOR(0x979797) forState:UIControlStateNormal];
                self.bottomView.rentBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
            }
        }
        else {
            [self.bottomView.rentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
            self.bottomView.rentBtn.backgroundColor = kYellowColor;
        }
    }
    else {
        [self.bottomView.rentBtn setTitleColor:HEXCOLOR(0x979797) forState:UIControlStateNormal];
        self.bottomView.rentBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
    }
    if (_user.banStatus) {
        [UIAlertView showWithTitle:@"提示" message:@"该用户已被封禁!" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else if (_user.have_close_account) {
        [UIAlertView showWithTitle:@"提示" message:@"该用户已注销!" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else {
        [self getBlackListStatus];
        [self reloadUserInfo];
    }
    if (!_haveLoadBuyWX && _showWX) {
        self.infoCtrl.showWX = _showWX;
        _haveLoadBuyWX = YES;
    }
    if (_isFromFastChat) {
        [self.fastChatBottomView.fastChatRentBtn setBackgroundImage:[UIImage imageNamed:@"icRent"] forState:UIControlStateNormal];
        [self.fastChatBottomView.fastChatRentBtn setImage:[UIImage imageNamed:@"san_chat_Priv_Info"] forState:UIControlStateNormal];
    }
}
- (void)reloadUserInfo {    //界面数据更新
    self.naviBar.user = _user;
    self.naviBar.titleLabel.text = _user.nickname;
    self.typeView.videoCount = _user.video_count;
    [self.tableHeader setData:_user];
    [self.infoCtrl setData:_user];
    [self.infoCtrl setUser:_user];
    [self.dynamicCtrl setUser:_user];
}
- (void)updateUserInfo {
//    _user = [ZZUserHelper shareInstance].loginer;
//    ZZPhoto *photo = _user.photos.firstObject;
//    NSLog(@"image:%@", photo.url);
    [self reloadUserInfo];
}

- (void)getBlackListStatus {    //是否在黑名单
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:_uid success:^(int bizStatus) {
        _isInBlackList = bizStatus == 0 ? YES : NO;
    } error:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetY = [change[@"new"] CGPointValue].y;
        CGFloat maxOffset = SCREEN_WIDTH - NAVIGATIONBAR_HEIGHT;
        CGFloat naviOffset = MIN(MAX(0, offsetY), maxOffset);
        CGFloat naviScale = naviOffset / maxOffset;
        self.naviBar.bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:naviScale];
        if (naviScale <= 0.5) {
            self.naviBar.titleLabel.textColor = [UIColor whiteColor];
            self.naviBar.leftImgView.image = [UIImage imageNamed:@"icon_rent_left"];
            self.naviBar.rightImgView.image = [UIImage imageNamed:@"icon_rent_right"];
            self.naviBar.codeImgView.image = [UIImage imageNamed:@"icon_rent_code_white"];
        } else {
            self.naviBar.titleLabel.textColor = kBlackTextColor;
            self.naviBar.leftImgView.image = [UIImage imageNamed:@"back"];
            self.naviBar.rightImgView.image = [UIImage imageNamed:@"more"];
            self.naviBar.codeImgView.image = [UIImage imageNamed:@"icon_rent_code_black"];
        }
    }
}

/*
 选人
 */
- (void)pick:(NSDictionary *)task {
    NSMutableDictionary *param = @{
                                   @"from": UserHelper.loginer.uid,
                                   @"to": task[@"user"],
                                   @"pid": task[@"pd"],
                                   @"ptid":task[@"_id"],
                                   }.mutableCopy;
    [ZZHUD show];
    [ZZRequest method:@"POST"
                 path:@"/api/pd/confirmDaren"
               params:param
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                     [ZZHUD dismiss];
                     if (!error) {
                         [ZZHUD showSuccessWithStatus:@"选择成功"];
                         [self gotoChatView:NO];
                     }
                     else {
                         [ZZHUD showErrorWithStatus:error.message];
                     }
                 }];
}

/**
* 埋点 活动的查看微信和私信
*/
- (void)taskFreeBoughtWechat {
    if (_isTaskFree && _task) {
        if (isNullString(UserHelper.loginer.uid) || isNullString(_task.task._id)) {
            return;
        }
        NSDictionary *param = @{
                                @"pdgid" : _task.task._id,
                                @"from"  : UserHelper.loginer.uid,
                                @"type"  : @"wechat_pay",
                                };
        [ZZTasksServer checkWechatOrChat:param handler:nil];
    }
}

#pragma mark - tableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat cellOffset = [self.tableView rectForSection:1].origin.y - NAVIGATIONBAR_HEIGHT;
    if (offsetY >= cellOffset) {
        [scrollView setContentOffset:CGPointMake(0, cellOffset)];
        if (!_scrollLock) {
            _scrollLock = YES;
            self.infoCtrl.scrollLock = NO;
            self.dynamicCtrl.scrollLock = NO;
        }
    } else {
        if (_scrollLock) {
            [scrollView setContentOffset:CGPointMake(0, cellOffset)];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && _isSelf && [_user isInfoReviewing]) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [cell.contentView addSubview:self.tableHeader];
            return cell;
        }
        else {
            UserInfoReviewInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserInfoReviewInfoCell cellIdentifier] forIndexPath:indexPath];
            return cell;
        }
    } else {
        ZZNewRentContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:RentContainCellId forIndexPath:indexPath];
        [cell setMarginBottom:_bottomHeight];
        [cell setInfoCtrl:self.infoCtrl];
        [cell setDynamicCtrl:self.dynamicCtrl];
        [cell setDidScroll:^(CGFloat offsetX) {
            [self.typeView setLineOffset:offsetX];
        }];
        self.containerCell = cell;
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    return self.typeView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return SCREEN_WIDTH;
        }
        else {
            return 32;
        }
    }
    return SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - _itemBarHeight - _bottomHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark -- Actions
//naviBar Actions
- (void)naviBarLeftClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)naviBarRightClick {
    [MobClick event:Event_click_user_detail_more];
    [self.shareView show];
}

//shareView Actions
- (void)blackListClick {
    if (_isInBlackList) {
        [ZZUser removeBlackWithUid:_uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            }
            else if (data) {
                _isInBlackList = NO;
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                
                NSMutableArray<NSString *> *muArray = [[userDefault objectForKey:@"BannedVideoPeople"] mutableCopy];
                if (!muArray) {
                    muArray = @[].mutableCopy;
                }
                
                if ([muArray containsObject:_uid]) {
                    [muArray removeObject:_uid];
                }

                [userDefault setObject:muArray.copy forKey:@"BannedVideoPeople"];
                [userDefault synchronize];
                
            }
        }];
    } else {
        [ZZUser addBlackWithUid:_uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) { [ZZHUD showErrorWithStatus:error.message]; }
            else if (data) { _isInBlackList = YES; }
        }];
    }
}
- (void)gotoRemarkView {
    if (_isFromLive) {
        return;
    }
    ZZRemarkViewController *controller = [[ZZRemarkViewController alloc] init];
    controller.user = _user;
    [self.navigationController pushViewController:controller animated:YES];
}

//tableHeader Actions
- (void)attentBtnClick {
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_user_detail_follow];
    if (_user.follow_status == 0) {
        [_user followWithUid:_user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) { [ZZHUD showErrorWithStatus:error.message]; }
            else {
                [ZZHUD showSuccessWithStatus:@"关注成功"];
                _user.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                _tableHeader.attentView.follow_status = _user.follow_status;
            }
        }];
    } else {
        [_user unfollowWithUid:_user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) { [ZZHUD showErrorWithStatus:error.message]; }
            else {
                [ZZHUD showSuccessWithStatus:@"已取消关注"];
                _user.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                _tableHeader.attentView.follow_status = _user.follow_status;
            }
        }];
    }
}


- (void)gotoEditView {
    if (_isFromLive) {
        return;
    }
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    [MobClick event:Event_click_me_icon];
    
    WeakSelf;
    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
    controller.gotoUserPage = YES;
    controller.hidesBottomBarWhenPushed = YES;
    controller.editCallBack = ^{
        [weakSelf updateUserInfo];
    };
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)gotoUserAttentView {
    if (_isFromLive) {
        return;
    }
    [MobClick event:Event_user_detail_following_tab];
    ZZRentAttentionViewController *controller = [[ZZRentAttentionViewController alloc] init];
    controller.user = self.user;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)gotoUserFansView {
    if (_isFromLive) {
        return;
    }
    [MobClick event:Event_user_detail_follower_tab];
    ZZRentFansViewController *controller = [[ZZRentFansViewController alloc] init];
    controller.user = self.user;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)playVideo {
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.fromLiveStream = YES;
    controller.skId = self.user.base_video.sk.skId;
    controller.hidesBottomBarWhenPushed = YES;
    controller.isBaseVideo = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

//typeView Actions
- (void)selectType:(NSInteger)index {
    [self.containerCell.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:NO];
}

//rentInfo Actions
- (void)gotoSkillDetail:(ZZTopic *)topic {
    ZZSkillDetailViewController *controller = [[ZZSkillDetailViewController alloc] init];
    controller.user = _user;
    controller.topic = topic;
    controller.chooseType = _chooseType;
    controller.fromLiveStream = _isFromLive;
    if ([_user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        controller.type = SkillDetailTypePreview;
    }
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


/**
 *  私信聊天
 */
- (void)chatBtnClick {
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    if ([ZZUtils isBan]) {
        return;
    }
    _bottomView.chatBtn.userInteractionEnabled = NO;
    // 判断当前操作是否需要做验证
    WeakSelf
    
    if ([[ZZUserHelper shareInstance].configModel.disable_module.no_have_face indexOfObject:@"chat"] != NSNotFound) {
        // 如果没有人脸
        if ([ZZUserHelper shareInstance].loginer.faces.count == 0 && ![[ZZUserHelper shareInstance] isMale]) {
            [UIAlertController presentAlertControllerWithTitle:@"目前账户安全级别较低，将进行身份识别，否则不能聊天" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                weakSelf.bottomView.chatBtn.userInteractionEnabled = YES;
                if (!isCancelled) { // 去验证人脸
                    [weakSelf gotoVerifyFace:NavigationTypeChat];
                }
            }];
            return;
        }
    }
    [MobClick event:Event_user_detail_chat];
    
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/say_hi_status",_uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        _bottomView.chatBtn.userInteractionEnabled = YES;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            if ([[data objectForKey:@"say_hi_status"] integerValue] == 0 && ![[ZZUserHelper shareInstance] isMale]) {
                if (loginedUser.avatar_manual_status == 1) {
                    if (![loginedUser didHaveOldAvatar]) {
                        [UIAlertView showWithTitle:@"提示"
                                           message:@"打招呼需要上传本人五官正脸清晰照，您的头像还在审核中，暂不可打招呼"
                                 cancelButtonTitle:@"知道了"
                                 otherButtonTitles:nil
                                          tapBlock:nil];
                    }
                    else {
                        [self gotoChatView:NO];
                    }
                }
                else {
                    [UIAlertView showWithTitle:@"提示" message:[data objectForKey:@"msg"] cancelButtonTitle:@"放弃" otherButtonTitles:@[[data objectForKey:@"btn_text"]] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            NSInteger type = [[data objectForKey:@"type"] integerValue];
                            switch (type) {
                                case 1: {
                                    [self gotoUploadPicture:NavigationTypeChat];
                                    break;
                                }
                                case 2: {
                                    [self askBtnClick:YES];
                                    break;
                                }
                                default: break;
                            }
                        }
                    }];
                }
            }
            else {
                [self gotoChatView:NO];
            }
        }
    }];
}

- (void)gotoChatView:(BOOL)shouldShowGiftView {
    if (_source == SourceChat) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else {
        ZZChatViewController *controller = [[ZZChatViewController alloc] init];
        [ZZRCUserInfoHelper setUserInfo:_user];
        controller.user = _user;
        controller.nickName = _user.nickname;
        controller.uid = _user.uid;
        controller.portraitUrl = _user.avatar;
        controller.shouldShowGift = shouldShowGiftView;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)askBtnClick:(BOOL)isPrivate {   //发红包
    if (_isFromLive) {
        return;
    }
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    if ([ZZUtils isBan]) {
        return;
    }
    [self gotoChatView:YES];
}

/**
 *  租TA
 */
- (void)rentBtnClick {
    if (_isFromLive) {
        return;
    }
    
    // 未登录
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    
    // 被禁了
    if ([ZZUtils isBan]) {
        return;
    }
    
    // 未上架
    if (_user.rent.status == 2 && _user.rent.show) {
        
    }
    else {
        [ZZHUD showErrorWithStatus:@"对方非可邀约的达人身份"];
        return;
    }
    
    // 头像正在人工审核并且没有旧头像不能租
    if ([UserHelper isUsersAvatarManuallReviewing:_user] && ![UserHelper canShowUserOldAvatarWhileIsManualReviewingg:_user]) {
        return;
    }
    
    [MobClick event:Event_user_detail_add_order];
    if ([ZZUserHelper shareInstance].loginer && [ZZUserHelper shareInstance].loginer.avatarStatus == 0) {
        [UIAlertView showWithTitle:@"提示" message:@"本人头像不是自己的照片，请先去修改" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去修改"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }];
    } else {
        WEAK_SELF();
        // 判断当前操作是否需要做验证
        if ([[ZZUserHelper shareInstance].configModel.disable_module.no_have_face indexOfObject:@"add_order"] != NSNotFound) {
            if ([[ZZUserHelper shareInstance] isMale]) {
                ZZRentChooseSkillViewController *controller = [[ZZRentChooseSkillViewController alloc] init];
                controller.user = _user;
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
            else {
                // 如果没有人脸
                if ([ZZUserHelper shareInstance].loginer.faces.count == 0) {
                    [UIAlertController presentAlertControllerWithTitle:@"目前账户安全级别较低，将进行身份识别，否则无法下单" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                        weakSelf.bottomView.chatBtn.userInteractionEnabled = YES;
                        if (!isCancelled) { // 去验证人脸
                            [weakSelf gotoVerifyFace:NavigationTypeOrder];
                        }
                    }];
                    return;
                }
                // 如果没有真实头像
                if ([[ZZUserHelper shareInstance].configModel.disable_module.no_have_real_avatar indexOfObject:@"add_order"] == NSNotFound) {
                    ZZRentChooseSkillViewController *controller = [[ZZRentChooseSkillViewController alloc] init];
                    controller.user = _user;
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                else {
                    ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos_origin.firstObject;
                    if (photo == nil || photo.face_detect_status != 3) {
                        [UIAlertController presentAlertControllerWithTitle:@"您未上传本人正脸五官清晰照，无法下单，请前往上传真实头像" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                            weakSelf.bottomView.chatBtn.userInteractionEnabled = YES;
                            if (!isCancelled) { // 去上传真实头像
                                [weakSelf gotoUploadPicture:NavigationTypeOrder];
                            }
                        }];
                        return;
                    }
                    ZZRentChooseSkillViewController *controller = [[ZZRentChooseSkillViewController alloc] init];
                    controller.user = _user;
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }

        }
    }
}

- (void)chooseBtnClick {
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    if ([ZZUtils isBan]) {
        return;
    }
    if (_chooseType == 0) {
        if ([ZZUtils isConnecting]) {
            return;
        }
        if (_publishId) {
            if (_canConnect) {
                [self checkAuthorized];
            } else {
                [ZZHUD showErrorWithStatus:@"TA的选择时间已到，无法与对方视频"];
            }
        } else {
            if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstConnectAlert]) {
                [self.view addSubview:self.requestAlertView];
            } else {
                [self checkAuthorized];
            }
        }
    } else {
        if (_chooseType == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (_chooseSnatcher) {
            _chooseSnatcher();
        }
    }
}
//fastChatView Actions
- (void)videoConnectClick {
    [MobClick event:Event_click_other_Detail_FastCaht];
    if ([self isOpenCamera]) {
        [self callIphoneVideo];
    }
}
- (void)rentClick {
    [MobClick event:Event_click_other_Detail_Rent];
    [self goToChat];
}
#pragma mark -- chat
- (void)goToChat {
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    ZZChatViewController *controller = [[ZZChatViewController alloc] init];
    controller.uid = self.user.uid;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark -- online fast chat
//是否打开相机权限
- (BOOL)isOpenCamera {
    // 第一次打开App进入闪聊列表
    NSString *firstGoToChat = [NSString stringWithFormat:@"%@",[ZZStoreKey sharedInstance].firstGotoFastChat];
    WS(weakSelf);
    if (![ZZKeyValueStore getValueWithKey:firstGoToChat]) {
        [ZZKeyValueStore saveValue:@"1" key:firstGoToChat];
        AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
            [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
                NSLog(@"py_权限判断");
                [weakSelf callIphoneVideo];
            }];
        }
        return NO;
    } else {
        return YES;
    }
}
//点击1v1视频
- (void)callIphoneVideo {
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    if ([ZZUtils isConnecting]) {
        return;
    }
    WEAK_SELF();
    if ([[ZZUserHelper shareInstance].loginer.mcoin integerValue] < [ZZUserHelper shareInstance].configModel.priceConfig.one_card_to_mcoin.integerValue * [ZZUserHelper shareInstance].configModel.priceConfig.per_unit_cost_card.integerValue) {
        [UIAlertController presentAlertControllerWithTitle:kMsg_Mebi_NO message:nil doneTitle:@"充值" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                [MobClick event:Event_click_OneToOneChat_TopUp];
                ZZMeBiViewController *vc = [ZZMeBiViewController new];
                [vc setPaySuccess:^(ZZUser *paySuccesUser) {
                }];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        return;
    }
    [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
        if (authorized) {
            [weakSelf gotoRecodeWithOtherUser:_user];
            [weakSelf conncetAuthorizedWithOtherUser:_user];
        }
    }];
}
- (void)gotoRecodeWithOtherUser:(ZZUser *)user {
    WEAK_SELF();
    dispatch_async(dispatch_get_main_queue(), ^{    //对方
        _connectingVC = [ZZliveStreamConnectingController new];
        _connectingVC.user = user;
        _connectingVC.showCancel = YES;
        WEAK_OBJECT(user, weakUser);
        [_connectingVC setConnectVideoStar:^(id data) { // 先进入视频页面
            [weakSelf gotoFastChatConnectView:weakUser.uid data:data];
        }];
        [weakSelf.navigationController pushViewController:_connectingVC animated:NO];
        [_connectingVC show];
    });
}

- (void)conncetAuthorizedWithOtherUser:(ZZUser *)user {
    [ZZChatCallIphoneManagerNetWork callIphone:SureCallIphone_MeBiStyle roomid:nil uid:user.uid paramDic:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            if (![ZZLiveStreamHelper sharedInstance].isBusy) {
                dispatch_async(dispatch_get_main_queue(), ^{    //对方
                    _connectingVC.data = data;
                });
            }
        }
    }];
}

- (void)gotoFastChatConnectView:(NSString *)uid data:(id)data {
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

#pragma mark -- online fast rent
- (void)checkAuthorized {
    if ([ZZUtils isConnecting]) {
        return;
    }
    WeakSelf;
    [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
        if (authorized) {
            [weakSelf conncetAuthorized];
        }
    }];
}

- (void)conncetAuthorized {
    if ([ZZLiveStreamHelper sharedInstance].isBusy) {
        return;
    }
    if ([[ZZUserHelper shareInstance].loginer.mcoin integerValue] < [ZZUserHelper shareInstance].configModel.priceConfig.one_card_to_mcoin.integerValue * [ZZUserHelper shareInstance].configModel.priceConfig.per_unit_cost_card.integerValue) {
        WS(weakSelf);
        [UIAlertController presentAlertControllerWithTitle:kMsg_Mebi_NO message:nil doneTitle:@"充值" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                [MobClick event:Event_click_OneToOneChat_TopUp];
                ZZMeBiViewController *vc = [ZZMeBiViewController new];
                [vc setPaySuccess:^(ZZUser *paySuccesUser) {
                    NSMutableArray<ZZViewController *> *vcs = [weakSelf.navigationController.viewControllers mutableCopy];
                    [vcs removeLastObject];
                    [weakSelf.navigationController setViewControllers:vcs animated:NO];
                    [weakSelf startToVideoDialing];
                }];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        return;
    }
    [self startToVideoDialing];
}
//开始拨打视频
- (void)startToVideoDialing {
    self.bottomView.userInteractionEnabled = NO;
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        _connectingVC = [ZZliveStreamConnectingController new];
        _connectingVC.user = _user;
        _connectingVC.showCancel = YES;
        WEAK_OBJECT(_uid, weakUid);
        [_connectingVC setConnectVideoStar:^(id data) {
            // 先进入视频页面
            [weakSelf gotoConnectView:weakUid data:data];
        }];
        
        [weakSelf.navigationController pushViewController:_connectingVC animated:NO];
        [_connectingVC show];
    });
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (_uid) {
        [param setObject:_uid forKey:@"uid"];
    }
    if (_publishId) {
        [param setObject:_publishId forKey:@"pdreceive_id"];
    }
    [param setObject:@(YES) forKey:@"by_mcoin"];
    [ZZChatCallIphoneManagerNetWork callIphone:AcceptOrder_callIphoneStyle roomid:nil uid:_uid paramDic:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        self.bottomView.userInteractionEnabled = YES;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            if (![ZZLiveStreamHelper sharedInstance].isBusy) {
                _connectingVC.data = data;
            }
        }
    }];
}
- (void)gotoConnectView:(NSString *)uid data:(id)data {
    // 新版连视频
    WEAK_SELF();
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray<ZZViewController *> *vcs = [self.navigationController.viewControllers mutableCopy];
        [vcs removeLastObject];
        ZZLiveStreamConnectViewController *controller = [[ZZLiveStreamConnectViewController alloc] init];
        controller.uid = uid;
        controller.isDisableVideo = _connectingVC.stickerBtn.isSelected;
        [vcs addObject:controller];
        [weakSelf.navigationController setViewControllers:vcs animated:YES];
        // 再进行视频连接
        ZZLiveStreamHelper *helper = [ZZLiveStreamHelper sharedInstance];
        helper.isUseMcoin = YES;
        helper.targetId = uid;
        helper.data = data;
        [helper connect:^{
        }];
        helper.failureConnect = ^{
            [controller.navigationController popViewControllerAnimated:YES];
        };
    });
}

- (void)jumpToIDPhotoManagerView {
    if (_user.id_photo.status == 1) {
        [ZZHUD showTaskInfoWithStatus:@"证件照审核中，暂不可操作，请等待审核结果"];
        return;
    }
    ZZIDPhotoManagerViewController *vc = [[ZZIDPhotoManagerViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ZZIDPhotoManagerViewControllerDelegate
- (void)IDPhotoDidUpdated:(ZZIDPhotoManagerViewController *)viewController needRefresh:(BOOL)needRefresh {
    [self reloadWithUid];
}

#pragma mark -- Account Check
- (void)gotoVerifyFace:(NavigationType)type {   // 没有人脸，则验证人脸
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:type inController:self];
    helper.user = [ZZUserHelper shareInstance].loginer;
    helper.from = _user;
    [helper start];
}
- (void)gotoUploadPicture:(NavigationType)type {    // 没有头像，则上传真实头像
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.from = _user;
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- setter
- (void)setChooseType:(NSInteger)chooseType {
    _chooseType = chooseType;
    _bottomView.userInteractionEnabled = YES;
    NSString *btnTitle = @"";
    UIColor *titleColor = kBlackTextColor;
    UIColor *bgColor = kYellowColor;
    switch (chooseType) {
        case 1: {
            btnTitle = @"选TA";
            titleColor = HEXCOLOR(0xFC2F52);
            bgColor = [UIColor whiteColor];
        } break;
        case 2: {
            btnTitle = @"已选定";
            bgColor = kYellowColor;
        } break;
        case 3: {
            btnTitle = @"不可选";
            bgColor = HEXCOLOR(0xDCDCDC);
            _bottomView.userInteractionEnabled = NO;
        } break;
        default: break;
    }
    [_bottomView.chooseBtn setBackgroundColor:bgColor];
    [_bottomView.chooseBtn setTitle:btnTitle forState:(UIControlStateNormal)];
    [_bottomView.chooseBtn setTitleColor:titleColor forState:(UIControlStateNormal)];
}

#pragma mark - WBSendVideoManagerObserver
/**
 *  开始发送视频
 */
- (void)videoStartSendingVideoUploadStatus:(ZZVideoUploadStatusView *)model {
    NSLog(@"开始发送视频");
}

/**
 *  视频发送完成
 */
- (void)videoSendSuccessWithVideoId:(ZZSKModel *)sk {
    NSLog(@"视频发送成功");
//    [self reloadWithUid];
}

/**
 *  视频发送失败
 */
- (void)videoSendFailWithError:(NSDictionary *)error {
    NSLog(@"视频发送失败");
}

#pragma mark -- lazy load
- (ZZNewRentTableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[ZZNewRentTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[ZZNewRentContainerCell class] forCellReuseIdentifier:RentContainCellId];
        [_tableView registerClass:[UserInfoReviewInfoCell class] forCellReuseIdentifier:[UserInfoReviewInfoCell cellIdentifier]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HeaderCell"];
    }
    return _tableView;
}
- (ZZRentInfoViewController *)infoCtrl {
    if (nil == _infoCtrl) {
        WeakSelf
        _infoCtrl = [[ZZRentInfoViewController alloc] init];
        _infoCtrl.scrollLock = YES;
        _infoCtrl.source = _source;
        // 点击跳转微博
        [_infoCtrl setPushCallBack:nil];
        
        [_infoCtrl setPushBarHide:nil];
        
        // 底部上拉跳转到视频列表
        [_infoCtrl setScrollToDynamic:^{
            [weakSelf.typeView setSelectIndex:1];
        }];
        [_infoCtrl setGotoEdit:^{
            [weakSelf gotoEditView];
        }];
        [_infoCtrl setGotoSkillDetail:^(ZZTopic *topic) {
            [weakSelf gotoSkillDetail:topic];
        }];
        [_infoCtrl setScrollToTop:^{
            weakSelf.scrollLock = NO;
        }];
        [_infoCtrl setGoDate:^{
            [weakSelf rentBtnClick];
        }];
        
        _infoCtrl.gotoPhotoMangerView = ^{
            [weakSelf jumpToIDPhotoManagerView];
        };
        
        _infoCtrl.didBoughtWechatBlock = ^(BOOL didBoughtWechat) {
            if (didBoughtWechat) {
                [weakSelf taskFreeBoughtWechat];
            }
        };
    }
    return _infoCtrl;
}
- (ZZRentDynamicViewController *)dynamicCtrl {
    if (nil == _dynamicCtrl) {
        WeakSelf
        _dynamicCtrl = [[ZZRentDynamicViewController alloc] init];
        _dynamicCtrl.scrollLock = YES;
        [_dynamicCtrl setPushBarHide:nil];
        [_dynamicCtrl setBuyWxCallBack:^{
            [weakSelf.typeView setSelectIndex:0];
            weakSelf.infoCtrl.showWX = YES;
        }];
        [_dynamicCtrl setScrollToTop:^{
            _scrollLock = NO;
        }];
    }
    return _dynamicCtrl;
}
- (ZZRentPageHeadView *)tableHeader {
    if (nil == _tableHeader) {
        WeakSelf
        _tableHeader = [[ZZRentPageHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        [_tableHeader setTouchEdit:^{
            [weakSelf gotoEditView];
        }];
        [_tableHeader.attentView setTouchAttent:^{
            [weakSelf attentBtnClick];
        }];
        [_tableHeader setTouchAttentCount:^{
            [weakSelf gotoUserAttentView];
        }];
        [_tableHeader setTouchFansCount:^{
            [weakSelf gotoUserFansView];
        }];
        [_tableHeader setPlayVideo:^{
            [weakSelf playVideo];
        }];
    }
    return _tableHeader;
}
- (ZZRentPageTypeView *)typeView {
    if (nil == _typeView) {
        WeakSelf
        _typeView = [[ZZRentPageTypeView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, 40)];
        [_typeView setSelectType:^(NSInteger index) {
            [weakSelf selectType:index];
        }];
    }
    return _typeView;
}
- (ZZRentPageNavigationView *)naviBar {
    if (nil == _naviBar) {
        WeakSelf
        _naviBar = [[ZZRentPageNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        [_naviBar setTouchLeftBtn:^{
            [weakSelf naviBarLeftClick];
        }];
        [_naviBar setTouchRightBtn:^{
            [weakSelf naviBarRightClick];
        }];
        _naviBar.ctl = self;
    }
    return _naviBar;
}
- (ZZRentPageBottomView *)bottomView {
    if (nil == _bottomView) {
        WeakSelf
        _bottomView = [[ZZRentPageBottomView alloc] init];
        _bottomView.entryTarget = _entryTarget;
//        _bottomView.showSignUpBtn = _showSignUpBtn;
        [_bottomView setTouchChat:^{    //私信聊天
            [weakSelf chatBtnClick];
        }];
        [_bottomView setTouchAsk:^{     //发红包
            [weakSelf askBtnClick:NO];
        }];
        [_bottomView setSignup:^{
            // 报名
            if (![ZZUserHelper shareInstance].isLogin) {
                UITabBarController *tabs = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                UINavigationController *navCtl = [tabs selectedViewController];
                NSLog(@"PY_登录界面%s",__func__);
                [[LoginHelper sharedInstance] showLoginViewIn:navCtl];
                return ;
            }
            
            // 被封禁
            if ([ZZUtils isBan]) {
                return ;
            }
            
            if (_entryTarget == TargetNormalTaskSignup) {
                if ([UserHelper.loginer didHaveRealAvatar] || ([UserHelper.loginer didHaveOldAvatar] && [UserHelper.loginer isAvatarManualReviewing])) {
                    
                }
                else {
                    if ([UserHelper.loginer isAvatarManualReviewing]) {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"私信TA需要上传本人正脸五官清晰照您的头像正在人工审核中，请等待审核结果" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                        [alertController addAction:doneAction];
                        
                        UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                        if ([rootVC presentedViewController] != nil) {
                            rootVC = [UIAlertController findAppreciatedRootVC];
                        }
                        [rootVC presentViewController:alertController animated:YES completion:nil];
                    }
                    else {
                        [UIAlertController presentAlertControllerWithTitle:@"温馨提示"
                                                                   message:@"您未上传本人正脸五官清晰照，暂不可私信TA"
                                                                 doneTitle:@"去上传"
                                                               cancelTitle:@"取消"
                                                             completeBlock:^(BOOL isCancelled) {
                                                                 if (!isCancelled) {
                                                                     [weakSelf gotoUploadPicture:NavigationTypeSignUpForTask];
                                                                 }
                                                             }];
                    }
                    
                    return;
                }
                
                // 性别设置
                if ((weakSelf.task.task.gender != UserHelper.loginer.gender) && weakSelf.task.task.gender != 3) {
                    [ZZHUD showErrorWithStatus:@"Ta设置了性别限制，同性无法报名哦"];
                    return;
                }
                
                
                [ZZInfoToastView showWithType:ToastTaskConfirmSignUp task:weakSelf.task.task action:^(NSInteger actionIndex, ToastType type) {
                    NSMutableDictionary *param = @{
                                                   @"uid": UserHelper.loginer.uid,
                                                   @"pid": weakSelf.task.task._id,
                                                   }.mutableCopy;
                    
                    if (actionIndex == 1) {
                        [ZZHUD show];
                        [ZZTasksServer signupWithParams:param handler:^(ZZError *error, id data) {
                            [ZZHUD dismiss];
                            if (!error) {
                                [ZZHUD showSuccessWithStatus:@"报名成功，请等待对方选择 "];
                                NSMutableDictionary *userInfo = @{
                                                                  @"task": weakSelf.task,
                                                                  @"from": @"taskList",
                                                                  @"action": @(taskActionSignUp),
                                                                  @"currentListType": @(ListNone),
                                                                  }.mutableCopy;
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_TaskStatusDidChanged
                                                                                    object:nil
                                                                                  userInfo:userInfo];
                                [weakSelf.bottomView.rentBtn setTitleColor:HEXCOLOR(0x979797) forState:UIControlStateNormal];
                                weakSelf.bottomView.rentBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
                                weakSelf.bottomView.rentBtn.userInteractionEnabled = NO;
                                [weakSelf.bottomView.rentBtn setTitle:@"已报名" forState:UIControlStateNormal];
                            }
                            else {
                                [ZZHUD showErrorWithStatus:error.message];
                            }
                        }];
                    }
                    else {
                        [weakSelf gotoChatView:NO];
                    }
                }];
            }
            else if (_entryTarget == TargetActivitesRent) {
                [weakSelf rentBtnClick];
            }
            
        }];
        
        [_bottomView setTouchRent:^{    //马上预约
            if (_entryTarget == TargetTonggaoPick) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(controller:didPicked:)]) {
                    [weakSelf.delegate controller:weakSelf didPicked:weakSelf.user];
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else {
                if (_taskDic && [_taskDic count] > 0) {
                    [ZZInfoToastView showWithType:ToastTaskConfirmChoose keyStr:weakSelf.user.nickname action:^(NSInteger actionIndex, ToastType type) {
                        if (actionIndex == 1) {
                            [weakSelf pick:weakSelf.taskDic];
                        }
                    }];
                }
                else {
                    [weakSelf rentBtnClick];
                }
            }
        }];
        [_bottomView setTouchChoose:^{  //选ta（闪租选人）
            [weakSelf chooseBtnClick];
        }];
        _bottomView.fromLiveStream = _isFromLive;
        _bottomView.hidden = _isSelf ? YES : (_isFromFastChat ? YES : NO);
    }
    return _bottomView;
}
- (ZZRentChatBottomView *)fastChatBottomView {
    if (nil == _fastChatBottomView) {
        WeakSelf
        _fastChatBottomView = [[ZZRentChatBottomView alloc] init];
        _fastChatBottomView.hidden = _isSelf ? YES : (_isFromFastChat ? NO : YES);
        [_fastChatBottomView setVideoConnect:^{
            [weakSelf videoConnectClick];
        }];
        [_fastChatBottomView setRentNow:^{
            [weakSelf rentClick];
        }];
    }
    return _fastChatBottomView;
}
- (ZZRightShareView *)shareView {
    if (nil == _shareView) {
        [_shareView removeFromSuperview];
        _shareView = nil;
    }
        WeakSelf
        _shareView = [[ZZRightShareView alloc] initWithFrame:[UIScreen mainScreen].bounds withController:weakSelf shouldShowNotIntersted:NO blackList:![[ZZUserHelper shareInstance].loginer.uid isEqualToString:_uid] isBanned:_isBan];
        _shareView.isUser = YES;
        _shareView.banString = _isInBlackList ? @"取消拉黑" : @"拉黑";
        _shareView.shareUrl = [NSString stringWithFormat:@"%@/1.3/user/%@/page", kBase_URL,_user.uid];
        _shareView.shareTitle = [NSString stringWithFormat:@"%@正在「空虾」出租自己",_user.nickname];
        _shareView.shareContent = [NSString stringWithFormat:@"空虾国民经纪人，赶紧来邀约%@", _user.nickname];
        _shareView.shareImg = _tableHeader.shareImg;
        _shareView.uid = _user.uid;
        ZZPhoto *photo = [[ZZPhoto alloc] init];
        if (_user.photos.count) {
            photo = _user.photos[0];
        } else {
            photo.url = _user.avatar;
        }
        _shareView.userImgUrl = photo.url;
        _shareView.touchBan = ^{
            [weakSelf blackListClick];
        };
        _shareView.touchRemark = ^{
            [weakSelf gotoRemarkView];
        };
        
        _shareView.touchBlackList = ^{
            if (weakSelf.isBan) {
                [ZZUser removeBlackWithUid:weakSelf.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                    } else if (data) {
                        weakSelf.isBan = NO;
                    }
                }];
            }
            else {
                [ZZUser addBlackWithUid:weakSelf.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                    }
                    else if (data) {
                        weakSelf.isBan = YES;
                    }
                }];
            }
        };
        [self.view.window addSubview:_shareView];
    return _shareView;
}
- (ZZRequestLiveStreamAlert *)requestAlertView {
    WeakSelf;
    if (!_requestAlertView) {
        _requestAlertView = [[ZZRequestLiveStreamAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _requestAlertView.isPublish = NO;
        _requestAlertView.touchCancel = ^{
            
        };
        _requestAlertView.touchSure = ^{
            [weakSelf checkAuthorized];
        };
    }
    return _requestAlertView;
}


@end

@interface UserInfoReviewInfoCell ()

@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation UserInfoReviewInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - Layout
- (void)layout {
    UIView *colorView = [[UIView alloc] init];
    colorView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 32);
    [self.contentView addSubview:colorView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = colorView.bounds;
    
    gradient.colors = @[(id)RGBCOLOR(243, 150, 71).CGColor, (id)RGBCOLOR(239, 193, 71).CGColor];
    gradient.locations = @[@0.0, @1.0];
    
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    
    [colorView.layer addSublayer:gradient];
    
    [self.contentView addSubview:self.infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - getters and setters
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = UIColor.whiteColor;
        _infoLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.text = @"您提交的资料正在审核中，审核通过后生效";
    }
    return _infoLabel;
}

@end
