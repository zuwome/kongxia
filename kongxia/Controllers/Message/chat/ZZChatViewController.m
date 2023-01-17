//
//  ZZChatViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatViewController.h"
#import "ZZChatServerViewController.h"
#import "ZZTaskSnatchListViewController.h"
#import "ZZWXViewController.h"
#import "ZZTaskDetailViewController.h"
#import "ZZPrivateChatPayManager.h"//私聊付费
#import "ZZDateHelper.h"
#import "ZZChatCheckPushView.h"
#import "ZZCheckWXView.h"
#import "ZZChatTaskView.h"
#import "ZZGifMessageModel.h"

#import "ZZOpenNotificationGuide.h"//打开推送的提示
#import "ZZOrderTalentShowViewController.h"
#import "ZZNewOrderRefundOptionsViewController.h" //新的退款流程的优化界面
#import <SobotKit/SobotKit.h>
#import "ZZMessageBoxModel.h"

@interface ZZChatViewController () <InviteVideoChatViewDelegate>{
    BOOL                        _isBan;
    BOOL                        _isFrom;
    BOOL                        _loadAnswer;
    BOOL                        _firstTimeCheck;
}

@property (nonatomic, strong) ZZChatOrderStatusView *statusView;
@property (nonatomic, strong) ZZChatCheckPushView *pushView;
@property (nonatomic, strong) ZZChatTopView *topView;
@property (nonatomic, strong) ZZChatTaskView *topTaskView;
@property (nonatomic, strong) ZZChatOrderDealView *dealView;
@property (nonatomic, strong) ZZChatStatusSheetView *sheetView;
@property (nonatomic, strong) ZZChatPacketAlertView *packetAlertView;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) ZZOrderTimeLineView *timeLineView;
@property (nonatomic, assign) BOOL haveLoadViews;
@property (nonatomic, assign) BOOL haveGetUserInfo;

@property (nonatomic, strong) MBProgressHUD *hub;

@property (nonatomic, strong) RCMessage *latestMessage;

@property (nonatomic, strong) ZZCheckWXView *wxCopyView;

@property (nonatomic, strong) InviteVideoChatView *inviteChatView;

@end

@implementation ZZChatViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _shouldShowWeChat = NO;
        _shouldShowGift = NO;
    }
    return self;
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getChatStatus];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 主动去获取一下系统配置
    [ZZSystemConfigModel fetchSysConfigWithCompleteHandler:^(BOOL isSuccess) {
        if (isSuccess) {
            [self updateStateIsFirstIntoRoom:YES];
        }
    }];
    
    // 获取账户余额余额
    [ZZUserHelper updateTheBalanceNext:nil];
    
    // 获取通告
    [self fetchTask];
    
    _haveLoadViews = YES;
    self.notUpdateOrder = NO;
    self.viewDisappear = NO;
    
    if ([ZZUserHelper shareInstance].loginer.gender == 2) {
        [self showInviteView];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.viewDisappear = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_sheetView) {
        [_sheetView removeFromSuperview];
    }
    
    if (_dealView) {
        [_dealView removeFromSuperview];
    }

    if (_lastMessage) {
        ZZChatBaseModel *chatModel = (ZZChatBaseModel *)[self.dataArray firstObject];
        if (chatModel ==nil) {
            return;
        }
        RCMessage *chatLastMessage = chatModel.message;
        _lastMessage(chatLastMessage);
    }
    
    _shouldShowWeChat = NO;
    _shouldShowGift = NO;
    [self.giftHelper stopAnimations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstTimeCheck = YES;
    [self getBanStatus];
    WS(weakSelf);
    [self privateChatPayManagerCallBack:^(ZZPrivateChatPayModel *payModel) {
        [weakSelf getChatStatus];
    }];

    [self createRightBtn];
    [self managerViewControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadOrder)
                                                 name:kMsg_UpdateOrder
                                               object:nil];
    self.evaluationCallBlack = ^{
        __strong typeof(weakSelf)Strong = weakSelf;
        Strong. haveGetUserInfo = NO;
        [Strong getUserInfo];
    };
    
    //用户自己的
    if ([self.uid isEqualToString:self.lastMessageSendId]) {
        [ ZZOpenNotificationGuide showShanChatPromptWhenUserFirstIntoViewController:nil heightProportion:0.46 showMessageTitle:@"及时收到TA的消息" showImageName:@"open_Notification_ women"];
    }
    else if([[ZZUserHelper shareInstance].loginer.uid isEqualToString:self.lastMessageSendId]){
        [ ZZOpenNotificationGuide showShanChatPromptWhenUserFirstIntoViewController:nil heightProportion:0.46 showMessageTitle:@"及时收到TA回复你的消息" showImageName:@"open_Notification_ men"];
    }
}

- (void)boxViewTopDidChange {
    [super boxViewTopDidChange];
    
    if (_inviteChatView == nil) {
        return;
    }
    _inviteChatView.bottom = self.payChatBoxView.hidden ? self.boxView.top - 10 : self.payChatBoxView.top - 10;
}

- (void)showInviteView {
    if (_inviteChatView == nil) {
        _inviteChatView = [[InviteVideoChatView alloc] init];
        _inviteChatView.frame = CGRectMake(self.view.width - 150 - 10, self.payChatBoxView.hidden ? self.boxView.top - 50 - 10 : self.payChatBoxView.top - 50 - 10, 150, 50);
        [_inviteChatView showPriceWithPrice:[[ZZUserHelper shareInstance].configModel.priceConfig.per_unit_get_money floatValue]];
        _inviteChatView.delegate = self;
    }
    [self.view addSubview:_inviteChatView];
}

- (void)configureTaskFreeModel:(ZZTaskModel *)taskModel {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
        model.userModifyIdentifer = @"TaskFreeCell";
        model.info = taskModel;
        [self.dataArray insertObject:model atIndex:0];
        [self.tableView reloadData];
        if(self.dataArray.count > 0){
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    });
}

/**
 查询是否是黑名单
 */
- (void)getBanStatus {
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:self.uid success:^(int bizStatus) {
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

- (void)createRightBtn {
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    
    self.customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [self.customBtn setImage:[UIImage imageNamed:@"icon_customerserveice"] forState:UIControlStateNormal];
    [self.customBtn addTarget:self action:@selector(gotoChatServerView) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.customBtn];
    
    self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 44)];
    [self.moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [self.moreBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.moreBtn];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    btnItem.width = -16;
    UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[btnItem, rightBarButon];
}

- (void)showWechatView {
    _shouldShowWeChat = NO;
    WEAK_SELF();
    self.wxCopyView = [ZZCheckWXView new];
    self.wxCopyView.wxNumber = self.user.wechat.no ?: @"100101010";
    [self.wxCopyView setCopyWXBlock:^{
        [UIActionSheet showInView:weakSelf.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"复制微信号"] tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [MobClick event:Event_click_userpage_wx_copy];
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = weakSelf.user.wechat.no;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ZZHUD showSuccessWithStatus:@"已保存至粘贴板"];
                });
            }
        }];
    }];
    
    [self.wxCopyView show:YES];
}

- (void)showSheet {
    [_sheetView removeFromSuperview];
    _sheetView = nil;
    [self endEditing];
    [self.view.window addSubview:self.sheetView];
    [self updateDatailType];
    [_sheetView showSheetWithOrder:self.order type:_statusView.detailType];
}

- (void)updateDatailType {
    if ([self.order.status isEqualToString:@"pending"]) {//等待接受
        _statusView.detailType = OrderDetailTypePending;
    }
    if ([self.order.status isEqualToString:@"cancel"]) {//取消
        _statusView.detailType = OrderDetailTypeCancel;
    }
    if ([self.order.status isEqualToString:@"refused"]) {//拒绝
        _statusView.detailType = OrderDetailTypeRefused;
    }
    if ([self.order.status isEqualToString:@"paying"]) {//待付款
        _statusView.detailType = OrderDetailTypePaying;
    }
    if ([self.order.status isEqualToString:@"meeting"]) {//见面中
        _statusView.detailType = OrderDetailTypeMeeting;
    }
    if ([self.order.status isEqualToString:@"commenting"]) {//待评论
        _statusView.detailType = OrderDetailTypeCommenting;
    }
    if ([self.order.status isEqualToString:@"commented"]) {//已评价
        _statusView.detailType = OrderDetailTypeCommented;
    }
    if ([self.order.status isEqualToString:@"appealing"]) {//申诉中
        _statusView.detailType = OrderDetailTypeAppealing;
    }
    if ([self.order.status isEqualToString:@"refunding"]) {//申请退款
        _statusView.detailType = OrderDetailTypeRefunding;
    }
    if ([self.order.status isEqualToString:@"refundHanding"]) {//退款处理中
        _statusView.detailType = OrderDetailTypeRefundHanding;
    }
    if ([self.order.status isEqualToString:@"refusedRefund"]) {//拒绝退款
        _statusView.detailType = OrderDetailTypeRefusedRefund;
    }
    if ([self.order.status isEqualToString:@"refunded"]) {//已经退款
        _statusView.detailType = OrderDetailTypeRefunded;
    }
}

- (void)showDealView {
    if ([ZZUtils isBan]) {
        return;
    }
    [self.view.window addSubview:self.dealView];
    [self.dealView showView];
}

- (void)createStatusView {
    if (_topTaskView) {
        return;
    }
    
    if (_topView) {
        [_topView removeFromSuperview];
        _topView = nil;
    }
    
    _isFrom = [self.order.from.uid isEqualToString:[ZZUserHelper shareInstance].loginerId];
    
    if (!_statusView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self.statusView];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_statusView setData:self.order];
        });
    }
    [self managerPluginBoardView];
    
    if (!self.portraitUrl) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.portraitUrl = _isFrom?self.order.to.avatar:self.order.from.avatar;
            [self updateUserPortraitUrl];
        });
    }
    [self createPushView];
}

- (void)createTaskView:(NSDictionary *)task {
    if (!task) {
        return;
    }
    
    if (_statusView) {
        [_statusView removeFromSuperview];
        _statusView = nil;
    }
    if (_topTaskView) {
        [_topTaskView removeFromSuperview];
        _topTaskView = nil;
    }
    
    if (_topView) {
        [_topView removeFromSuperview];
        _topView = nil;
    }
    _topTaskView = [[ZZChatTaskView alloc] initWithTaskDic:task];
    _topTaskView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 50.0);
    
    if ([task[@"pd_owner"] isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickAction:)];
        [_topTaskView addGestureRecognizer:tapGesture];
    }
    
    [self.view addSubview:_topTaskView];
    
    self.orderStatusHeight = [_topTaskView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    _topTaskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.orderStatusHeight);
    
    self.tableView.height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - self.orderStatusHeight - SafeAreaBottomHeight;
    self.tableView.top = self.orderStatusHeight;
    [self scrollToBottom:NO finish:nil];
}

- (void)createPushView {
    if (!_pushView) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone) {
            self.pushView.hidden = NO;
        }
    }
}

/**
 是否是线下抢单列表过来的 是就移除移除线下抢单列表
 */
- (void)managerViewControllers {
    if (_fromSnatchList) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        for (UIViewController *ctl in array) {
            if ([ctl isKindOfClass:[ZZTaskSnatchListViewController class]]) {
                [array removeObject:ctl];
                break;
            }
        }
        self.navigationController.viewControllers = array;
    }
}

#pragma mark - InviteVideoChatViewDelegate
- (void)chatWithView:(InviteVideoChatView *)view {
    if (![self canInviteVideoChat:self.dataArray]) {
        [ZZHUD showInfoWithStatus:@"双方聊天后才能邀请视频哦"];
        return;
    }

    [self sendMySelfNotification:@"已发送邀请，请等待回复"];
    [self sendInviteVideoChatMessage];    
}

- (BOOL)canInviteVideoChat:(NSArray *)messages {
    if (![ZZUserHelper shareInstance].configModel.invite_switch) {
        return NO;
    }
    
    __block BOOL canInvite = NO;
    [messages enumerateObjectsUsingBlock:^(__kindof ZZChatBaseModel *baseModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([baseModel.message.content isKindOfClass:[RCTextMessage class]]) {
            if (baseModel.message.messageDirection == MessageDirection_RECEIVE) {
                canInvite = YES;
                *stop = YES;
            }
        }
    }];
    return canInvite;
}

#pragma mark - Navigation
/**
 客服
 */
- (void)gotoChatServerView {
    [ZZServerHelper showServer];
//    //配置UI
//    ZCKitInfo *uiInfo = [ZCKitInfo new];
//    uiInfo.topViewBgColor = kGoldenRod;
//    [ZCSobotApi openZCChat:uiInfo with:self target:nil pageBlock:^(id  _Nonnull object, ZCPageBlockType type) {
//    } messageLinkClick:^BOOL(NSString * _Nonnull link) {
//        return YES;
//    }];
}

- (void)addWeChat {
    [MobClick event:Event_click_usercenter_wx];
    ZZWXViewController *controller = [[ZZWXViewController alloc] init];
    controller.wxUpdate = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ZZTabBarViewController *tabBarController = (ZZTabBarViewController *)self.tabBarController;
            [tabBarController setSelectIndex:3];
            NSMutableArray *controllers = self.navigationController.viewControllers.mutableCopy;
            if ([controllers.lastObject isKindOfClass: [ZZWXViewController class]]) {
                NSArray *newControllers = [controllers subarrayWithRange:NSMakeRange(0, controllers.count - 2)];
                [self.navigationController setViewControllers:newControllers.copy animated:NO];
            }
        });
    };
    controller.user = [ZZUserHelper shareInstance].loginer;;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)checkWeChat {
    
}

- (void)rightBtnClick {
    [self endEditing];
    [UIActionSheet showInView:self.view
                    withTitle:nil
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"查看个人主页",@"举报", _isBan?@"取消拉黑":@"拉黑"]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                        
                         switch (buttonIndex) {
                             case 0:
                             {
                                 [self gotoUserPage:NO];
                             }
                                 break;
                             case 1:
                             {
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     ZZReportViewController *controller = [[ZZReportViewController alloc] init];
                                     ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
                                     controller.uid = self.uid;
                                     [self.navigationController presentViewController:navCtl animated:YES completion:NULL];
                                 });
                             }
                                 break;
                             case 2:
                             {
                                 if (_isBan) {
                                     [ZZUser removeBlackWithUid:self.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                         if (error) {
                                             [ZZHUD showErrorWithStatus:error.message];
                                         }
                                         else if (data) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                                                 hud.labelText = @"取消拉黑成功";
                                                 hud.mode = MBProgressHUDModeText;
                                                 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                                                 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                     [hud hide:YES];
                                                 });
                                             });
                                             
                                             _isBan = NO;
                                             
                                             NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                             
                                             NSMutableArray<NSString *> *muArray = [[userDefault objectForKey:@"BannedVideoPeople"] mutableCopy];
                                             if (!muArray) {
                                                 muArray = @[].mutableCopy;
                                             }
                                             
                                             if ([muArray containsObject:self.uid]) {
                                                 [muArray removeObject:self.uid];
                                             }
                                             
                                             [userDefault setObject:muArray.copy forKey:@"BannedVideoPeople"];
                                             [userDefault synchronize];
                                         }
                                     }];
                                 } else {
                                     [self addToBlack];
                                 }
                             }
                                 break;
                             default:
                                 break;
                         }
                     }];
}

- (void)addToBlack {
    [ZZUser addBlackWithUid:self.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.labelText = @"已把TA加入黑名单";
                hud.mode = MBProgressHUDModeText;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [hud hide:YES];
                });
            });
            _isBan = YES;
        }
    }];
}

#pragma mark - LoadData
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
                         [_topTaskView removeFromSuperview];
                         _topTaskView = nil;
                         [self getOrder];
                     }
                     else {
                         [ZZHUD showErrorWithStatus:error.message];
                     }
                 }];
}

- (void)fetchTask {
    if (isNullString(UserHelper.loginer.uid)) {
        return;
    }
    
    NSString *toUserID = !isNullString(self.uid) ? self.uid : self.user.uid;
    
    if (isNullString(toUserID)) {
        return;
    }
    [ZZRequest method:@"GET"
                 path:@"/api/pd/getPdRelationPoint"
               params:@{
                        @"type": @1,
                        @"from": UserHelper.loginer.uid,
                        @"to": toUserID,
                        }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                     if (!error && data && ![data isKindOfClass:[NSNull class]] && [data isKindOfClass:[NSDictionary class]]) {
                         [self createTaskView:data[@"pdGet"]];
                     }
                     else {
                         //if (self.order && _haveLoadViews && !self.notUpdateOrder) {
                             [self getOrder];
                         //}
                     }
                 }];
}

/**
 有订单获取订单Id  没有就获取最后一次的订单
 */
- (void)getOrder {
    if (_orderId) {
        [self fecchOrder:_orderId];
    } else {
        [self fetchLastOrder];
    }
}

/**
 获取最后一次的订单
 */
- (void)fetchLastOrder {
    NSString *userId = self.uid;
    if (!userId) {
        userId = self.user.uid;
    }
    [ZZOrder latestWithUser:userId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            //获取订单
            self.order = [[ZZOrder alloc] initWithDictionary:data error:nil];
            
            if (self.order.id) {
                [self createStatusView];
            }
        }
        [self getUserInfo];
    }];
}

- (void)fecchOrder:(NSString *)orderId {
    [ZZOrder loadInfo:orderId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            self.order = [[ZZOrder alloc] initWithDictionary:data error:nil];
            [self createStatusView];
        }
        [self getUserInfo];
    }];
}

- (void)getUserInfo {
    if (_haveGetUserInfo) {
        return;
    }
    [ZZUser loadUser:self.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            
            _haveGetUserInfo = YES;
            self.user = [ZZUser yy_modelWithJSON:data];;
            self.navigationItem.title = self.user.nickname;
            self.nickName = self.user.nickname;
            [self managerPluginBoardView];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.portraitUrl = [self.user displayAvatar]; //self.user.avatar;
                [self updateUserPortraitUrl];
            });
            
            if (!self.order.id) {
                if (self.user.rent.status == 2 && self.user.rent.show) {
                    self.topView.user = self.user;
                }
            }
            self.showPushName = self.user.push_config.push_hide_name;
            [self checkIfisBoyToGirl];
            
            if (_shouldShowWeChat) {
                [self showWechatView];
            }
            
            [self createGiftHelper];
            
            if (_shouldShowGift) {
                _shouldShowGift = NO;
                [self showGiftView];
            }
            
            if ([self.giftHelper shouldShowGiftIconAnimation:self.user.uid]) {
                [self showGiftIconAnimations];;
            }
            else {
                [self calCurrentMessageCounts];;
            }
            
            
            // 清除礼物的
            [self.giftHelper showGiftsAnimationIn:self.view];
        }
    }];
}

/*
 生成礼物的helper
 */
- (void)createGiftHelper {

    self.giftHelper = [[ZZGiftHelper alloc] initWithUser:self.user];
    self.giftHelper.entry = self.giftEntry;

    if ([self.giftHelper shouldShowChatGiftTipsView]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.boxView showGiftTipView];
        });
    }
    else {
        [ZZGiftHelper clearUserMessageDataWith:self.user.uid];
    }
}

// 判断是不是男方发给女方，并且没有查看过微信
- (void)checkIfisBoyToGirl {
    ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
    if (loginer.gender == 1 && self.user.gender == 2 && !self.user.can_see_wechat_no) {
        // 如果是，则去判断是否回复了消息
        [self checkIfMessageReplied:NO
                    sendWarning:NO
           didSendMessageBefore:NO
                  oldestMessage:nil];
    }
}

// 判断女方是否已经回复了
- (void)checkIfMessageReplied:(BOOL)didGirlSend
                  sendWarning:(BOOL)sendWarning
         didSendMessageBefore:(BOOL)didSendMessage
                oldestMessage:(RCMessage *)message {
    NSArray<RCMessage *> *conversations = [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_PRIVATE targetId:self.uid oldestMessageId:message.messageId count:20];
    __block BOOL didGirlSendMessage = didGirlSend;
    __block BOOL didSendWarning = sendWarning;
    __block BOOL didSendMessageBefore = didSendMessage;
    
    [conversations enumerateObjectsUsingBlock:^(RCMessage * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        if (([message.content isKindOfClass:[RCTextMessage class]] || [message.content isKindOfClass:[ZZGifMessageModel class]]) && message.conversationType == ConversationType_PRIVATE ) {
            didSendMessageBefore = YES;
            if ([message.senderUserId isEqualToString:self.user.uid]) {
                didGirlSendMessage = YES;
                *stop = YES;
            }
        }
        if ([message.content isKindOfClass:[ZZChatReportModel class]]) {
            ZZChatReportModel *model = (ZZChatReportModel *)message.content;
            if ([model.message isEqualToString:@"消息未回复？试试查看Ta的微信号"]) {
                didSendWarning = YES;
            }
        }
    }];
    
    if (_firstTimeCheck) {
        _firstTimeCheck = NO;
        _latestMessage = conversations.firstObject;
    }
    
    if (!didGirlSendMessage && !didSendWarning && didSendMessageBefore) {
        if (conversations.count == 0) {
            [self sendCheckWeChatMessage:_latestMessage];
        }
        else {
            [self checkIfMessageReplied:didGirlSendMessage
                            sendWarning:didSendWarning
                   didSendMessageBefore:didSendMessageBefore
                          oldestMessage:conversations.lastObject];
        }
    }
}

- (void)sendCheckWeChatMessage:(RCMessage *)message {
    if (!message) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.user.have_wechat_no) {
            ZZChatReportModel *finishModel = [ZZChatReportModel messageWithContent:@"消息未回复？试试查看Ta的微信号"];
            finishModel.title = @"查看Ta的微信号";
            RCMessage *newMessage = [[RCIMClient sharedRCIMClient] insertIncomingMessage:ConversationType_PRIVATE targetId:message.targetId senderUserId:message.targetId receivedStatus:ReceivedStatus_READ content:finishModel sentTime:message.sentTime+100];
            NSDictionary *aDict = @{@"message":newMessage,};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ReceiveMessage object:nil userInfo:aDict];
        }
    });
}

/**
 获取聊天的状态
 注* 这个要判断对方是否开启了私聊付费  这个不得不请求啊  因为是否能开启阅后即焚  的在这个里面
 */
- (void)getChatStatus {
    [ZZChatStatusModel getChatStatus:self.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            self.statusModel = [[ZZChatStatusModel alloc] initWithDictionary:data error:nil];
            self.boxView.statusModel = self.statusModel;
            self.boxView.topView.statusModel = self.statusModel;
            if (self.payChatModel.isStrangerFirst) {
                self.statusModel.chat_status =1;
                self.isMessageBox = NO;
                self.boxView.topView.isMessageBox = NO;
                return ;
            }
            if (self.statusModel.chat_status == 0) {
                self.isMessageBox = NO;
            }
            else {
                self.isMessageBox = NO;
            }
            self.boxView.isMessageBox = NO;// self.isMessageBox && !self.isMessageBoxTo ? YES : NO;
            self.boxView.topView.isMessageBox = NO;// self.isMessageBox && !self.isMessageBoxTo ? YES : NO;
        }
    }];
}

- (void)loadMessages {
    [ZZHUD showWithStatus:@"数据请求中..."];
    [ZZMessage pullOrder:self.order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            NSMutableArray *array = [ZZMessage arrayOfModelsFromDictionaries:data error:nil];
            if (array.count) {
                if (self.messageArray) {
                    [self.messageArray removeAllObjects];
                } else {
                    self.messageArray = [NSMutableArray array];
                }
                [self.messageArray addObjectsFromArray:array];
                
                [self showTimeLine];
            }
        }
    }];
}

//查看时间轴
- (void)showTimeLine {
    if (!_timeLineView) {
        _timeLineView = [[ZZOrderTimeLineView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) order:self.order];
        [self.view.window addSubview:_timeLineView];
    }
    _timeLineView.messageArray = _messageArray;
}

- (void)updateUserPortraitUrl {
    NSArray *cells = self.tableView.visibleCells;
    for (UITableViewCell *cell in cells) {
        if ([cell isKindOfClass:[ZZChatBaseCell class]]) {
            ZZChatBaseCell *aCell = (ZZChatBaseCell *)cell;
            if (!aCell.otherHeadImgView.hidden) {
                [aCell setUrl:self.portraitUrl];
            }
        }
    }
}

#pragma mark - 管理是否能视频或语音
- (void)managerPluginBoardView {
    BOOL canPlayAudio = YES;
    if (self.order.id) {
        if (!self.order.can_do_audio) {
            self.boxView.canMakeVoiceCall = NO;
        }
        if (!self.order.can_do_video) {
            self.boxView.canMakeVideoCall = NO;
        }
        
        if (_isFrom) {
            if (![ZZUtils canPlayAudioWithVersion:self.order.to.version]) {
                canPlayAudio = NO;
            }
            self.navigationItem.title = self.order.to.nickname;
            self.nickName = self.order.to.nickname;
        }
        else {
            if (![ZZUtils canPlayAudioWithVersion:self.order.from.version]) {
                canPlayAudio = NO;
            }
            self.navigationItem.title = self.order.from.nickname;
            self.nickName = self.order.from.nickname;
        }
    }
    else {
        if (![ZZUtils canPlayAudioWithVersion:self.user.version]) {
            canPlayAudio = NO;
        }
    }
    
    if (!canPlayAudio) {
        self.boxView.canMakeVoiceCall = NO;
        self.boxView.canMakeVideoCall = NO;
    }
}

#pragma mark - 跳转
- (void)pickAction:(UITapGestureRecognizer *)recognizer {
    ZZChatTaskView *view = (ZZChatTaskView *)recognizer.view;
    NSString *version = view.task[@"pd"][@"pd_version"];
    BOOL isNew = NO;
    if (!isNullString(version)) {
        if ([ZZUtils compareVersionFrom:@"3.7.7" to:version] == NSOrderedDescending) {
            isNew = NO;
        }
        else {
            isNew = YES;
        }
    }
    if (isNew) {
        ZZUser *user = [ZZUser new];
        user.uid = self.uid;
        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:chatDidPickUser:)]) {
            [self.delegate controller:self chatDidPickUser:user];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            ZZTaskDetailViewController *detailsVC = [[ZZTaskDetailViewController alloc] initWithTaskID:view.task[@"pd"][@"_id"]];
            [self.navigationController pushViewController:detailsVC animated:YES];
        }
    }
    else {
        [ZZInfoToastView showWithType:ToastTaskConfirmChoose keyStr:self.user.nickname action:^(NSInteger actionIndex, ToastType type) {
            if (actionIndex == 1) {
                [self pick:view.task];
            }
        }];
    }
}

- (void)managerNextCtl {
    [self endEditing];
    switch (_statusView.detailType) {
        case OrderDetailTypePending: {
            if (_isFrom) {
                [self edit];
            } else {
                [self showDealView];
            }
            break;
        }
        case OrderDetailTypeMeeting: {
            [self met];
            break;
        }
        case OrderDetailTypeCommenting: {
            if (_isFrom) {
                [self comment];
            } else if(self.order.met && self.order.met.to && self.order.met.from) {
                [self comment];
            }
            break;
        }
        case OrderDetailTypeRefunding: {
            [self gotoOrderDetail:self.order.id];
            break;
        }
        default:
            break;
    }
}

// 取消
- (void)cancel {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_cancel_order];
    if (_isFrom && _statusView.detailType == OrderDetailTypePaying) {
        ZZNewOrderRefundOptionsViewController *controller = [[ZZNewOrderRefundOptionsViewController alloc]init];
        controller.order = self.order;
        controller.isFromChat = YES;
        [self.navigationController pushViewController:controller animated:YES];
        WS(weakSelf);
        controller.callBack = ^(NSString *status) {
            weakSelf.order.status = status;
            [weakSelf callBack];
            [weakSelf reduceOngoingCount];
        };

    } else {
        ZZOrderTalentShowViewController *vc = [[ZZOrderTalentShowViewController alloc] init];
        vc.order = self.order;
        vc.uid = self.uid;
        vc.isFrom = _isFrom;
        WS(weakSelf);
        vc.callBack = ^(NSString *status) {
            weakSelf.order.status = status;
            [weakSelf callBack];
            [weakSelf reduceOngoingCount];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 拒绝
- (void)refuse {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_refuse_order];
    ZZOrderTalentShowViewController *vc = [[ZZOrderTalentShowViewController alloc] init];
    if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:self.order.from.uid]) {
        vc.uid = self.order.to.uid;
    } else {
        vc.uid = self.order.from.uid;
    }
    vc.order = self.order;
    vc.isRefusedInvitation = YES;
    vc.isFrom = NO;
    WS(weakSelf);
    vc.callBack = ^(NSString *status) {
        weakSelf.order.status = status;
        [weakSelf callBack];
        [weakSelf reduceOngoingCount];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// 编辑约会
- (void)edit {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_modify_order];
    ZZRentChooseSkillViewController *controller = [[ZZRentChooseSkillViewController alloc] init];
    controller.isEdit = YES;
    controller.order = self.order;
    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)notifyOther {
    if ([ZZUtils isBan]) {
        return;
    }
    [ZZHUD showWithStatus:nil];
    WS(weakSelf);
    [self.order remindWithOrderId:self.order.id status:self.order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [weakSelf callBack];
        }
    }];
}

- (void)accept {
    [MobClick event:Event_accept_order];
    [ZZHUD showWithStatus:nil];
    WS(weakSelf);
    [self.order accept:self.order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            [weakSelf callBack];
        }
    }];
}

- (void)pay {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_pay_order];
    ZZPayViewController *vc = [[ZZPayViewController alloc] init];
    vc.order = self.order;
    WS(weakSelf);
    vc.didPay = ^(){
        [weakSelf callBack];
    };
    vc.type = PayTypeOrder;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)met {
    if ([ZZUtils isBan]) {
        return;
    }
    if (_isFrom) {
        [MobClick event:Event_from_click_met_order];
        [self showOKCancelAlertWithTitle:@"提示"
                                 message:@"邀约是否已顺利完成，确定后款项将会支付给对方"
                             cancelTitle:@"取消"
                             cancelBlock:nil
                                 okTitle:@"确认"
                                 okBlock:^{
            [self metRequest];
        }];
    } else {
        [MobClick event:Event_to_click_met_order];
        [self showOKCancelAlertWithTitle:@"提示"
                                 message:@"确认已到达见面地点？"
                             cancelTitle:@"取消"
                             cancelBlock:nil
                                 okTitle:@"确认"
                                 okBlock:^{
            [self metRequest];
        }];
    }
}

- (void)metRequest {
    [ZZHUD showWithStatus:@"确认中..."];
    WS(weakSelf);
    [self.order met:[ZZUserHelper shareInstance].location status:self.order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD showSuccessWithStatus:@"完成见面!"];
            
            if (_isFrom) {
                [weakSelf reduceOngoingCount];
            }
            [weakSelf callBack];
        }
    }];
}

- (void)comment {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_comment_order];
    ZZOrderCommentViewController *controller = [[ZZOrderCommentViewController alloc] init];
    controller.order = self.order;
    WS(weakSelf);
    controller.successCallBack = ^{
        [weakSelf callBack];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

//申请退款
- (void)wantToRefund {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_refund_order];

    ZZNewOrderRefundOptionsViewController *vc = [[ZZNewOrderRefundOptionsViewController alloc]init];
    vc.order = self.order;
    vc.isFromChat = YES;
    WS(weakSelf);
    vc.callBack = ^(NSString *status) {
        weakSelf.order.status = status;
        [weakSelf callBack];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)revokeRefund {
    if ([ZZUtils isBan]) {
        return;
    }
    NSString *string = @"您撤销退意向金申请后，邀约将会继续进行，资金仍由平台监管。您只有一次撤销申请的机会，确定撤销本次退意向金申请吗？";
    if (self.order.paid_at) {
        string = @"您撤销退款申请后，邀约将会继续进行，资金仍由平台监管。您只有一次撤销申请的机会，确定撤销本次退款申请吗？";
    }
    [UIAlertView showWithTitle:@"提示" message:string cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            WS(weakSelf);
            [ZZOrder revokeRefundOrder:self.order.id status:self.order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                } else {
                    [weakSelf getOrder];
                }
            }];
        }
    }];
}

- (void)editRefund {
    if ([ZZUtils isBan]) {
        return;
    }
    ZZNewOrderRefundOptionsViewController *controller = [[ZZNewOrderRefundOptionsViewController alloc]init];
    controller.order = self.order;
    controller.isFromChat = YES;
    controller.isModify = YES;
    WS(weakSelf);
    controller.callBack = ^(NSString *status) {
        weakSelf.order.status = status;
        [weakSelf callBack];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoMemedaView {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_user_detail_add_mmd];
    WeakSelf;
    ZZRentMemedaViewController *controller = [[ZZRentMemedaViewController alloc] init];
    controller.uid = self.uid;
    controller.hidesBottomBarWhenPushed = YES;
    controller.fromChat = YES;
    controller.isPrivate = YES;
    controller.popIndex = 3;
    controller.askCallBack = ^(NSString *content,NSString *mid,BOOL inYellow) {
        weakSelf.isInYellow = inYellow;
        [weakSelf sendPacket:content mid:mid];
        weakSelf.isMessageBoxTo = NO;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)rentBtnClick {
    if ([ZZUtils isBan]) {
        return;
    }
    
    [self endEditing];
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
        ZZRentChooseSkillViewController *controller = [[ZZRentChooseSkillViewController alloc] init];
        if (self.order.id) {
            controller.uid = _isFrom ? self.order.to.uid:self.order.from.uid;
        } else {
            controller.user = self.user;
        }
        controller.fromChat = YES;
        controller.hidesBottomBarWhenPushed = YES;
        WS(weakSelf);
        controller.callBack = ^{
            [weakSelf fetchLastOrder];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }
}

/**
 更新订单
 */
- (void)reloadOrder {
    [self getOrder];
    [self callBack];
}

- (void)callBack {
    [_statusView setData:self.order];
    if (_statusChange) {
        _statusChange();
    }
}

- (void)reduceOngoingCount {
    if ([ZZUserHelper shareInstance].unreadModel.order_ongoing_count > 0) {
        [ZZUserHelper shareInstance].unreadModel.order_ongoing_count--;
    }
    [[ZZTabBarViewController sharedInstance] managerAppBadge];
}

#pragma mark - 收发消息处理
- (void)didReceiveMessage:(RCMessage *)message {
    if ([message.content isKindOfClass:[ZZChatOrderInfoModel class]]) {
        if (!self.viewDisappear) {
            [ZZHUD showWithStatus:@"更新中..."];
            [self getOrder];
        }
    }
    if ([message.content isKindOfClass:[ZZChatPacketModel class]]) {
        self.statusModel.private_hb_status = 1;
    }
    self.statusModel.chat_status = 1;
}

- (void)didSendMessage:(ZZChatBaseModel *)model {
    if (self.statusModel.private_hb_status == 1 && !_packetAlertView) {
        NSInteger type = 4;
        NSString *contentStr = nil;
        if ([model.message.content isKindOfClass:[RCTextMessage class]]) {
            type = 2;
            RCTextMessage *textMessage = (RCTextMessage *)model.message.content;
            contentStr = textMessage.content;
        } else if ([model.message.content isKindOfClass:[RCVoiceMessage class]]) {
            type = 3;
        }
        if (!_loadAnswer && !self.viewDisappear) {
            _loadAnswer = YES;
            [self answerMemeda:contentStr type:type];
        }
    }
}

//领红包
- (void)answerMemeda:(NSString *)content type:(NSInteger)type {
    NSMutableDictionary *param = [@{@"type":[NSNumber numberWithInteger:type]} mutableCopy];
    if (content) {
        [param setObject:content forKey:@"content"];
    }
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/answer_bychat",self.uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            _loadAnswer = NO;
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _loadAnswer = NO;
            self.statusModel.private_hb_status = 0;
            CGFloat price = [data[@"price"] doubleValue];
            double yj_price = [data[@"yj_price"] doubleValue];
            if (price != 0) {
                _packetAlertView = [[ZZChatPacketAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                if (self.order.id) {
                    if (_isFrom) {
                        [_packetAlertView setData:self.order.to];
                    } else {
                        [_packetAlertView setData:self.order.from];
                    }
                } else {
                    [_packetAlertView setData:self.user];
                }
                _packetAlertView.yj_price = yj_price;
                _packetAlertView.price = price;
                [self endEditing];
                [self.view.window addSubview:_packetAlertView];
                
                WeakSelf;
                _packetAlertView.cancelCallBack = ^{
                    weakSelf.packetAlertView = nil;
                };
            }
        }
    }];
}

#pragma mark - lazyload
- (ZZChatOrderStatusView *)statusView {
    if (!_statusView) {
        _statusView = [[ZZChatOrderStatusView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        WeakSelf;
        _statusView.touchStatusView = ^{
            [weakSelf gotoOrderDetail:weakSelf.order.id];
        };
        _statusView.touchMoreBtn = ^{
            [weakSelf showSheet];
        };
        _statusView.touchStatusBtn = ^{
            [weakSelf managerNextCtl];
        };
        _statusView.countDownView.timeOut = ^{
            [weakSelf getOrder];
        };
        _statusView.countDownView.touchPay = ^{
            [weakSelf pay];
        };
        [_statusView setData:self.order];
        
        self.orderStatusHeight = [_statusView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        _statusView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.orderStatusHeight);
        [self resetStatusHeight];
    }
    return _statusView;
}

- (ZZChatTopView *)topView {
    WeakSelf;
    if (_statusView || _topTaskView) {
        if (_topView) {
            [_topView removeFromSuperview];
        }
        return nil;
    }
    
    if (!_topView) {
        _topView = [[ZZChatTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        [self.view addSubview:_topView];
        _topView.touchRent = ^{
            [weakSelf rentBtnClick];
        };
        
        self.orderStatusHeight = _topView.height;
        [self resetStatusHeight];
    }
    return _topView;
}

- (ZZChatCheckPushView *)pushView {
    WeakSelf;
    if (!_pushView) {
        _pushView = [[ZZChatCheckPushView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        [self.view addSubview:_pushView];
        _pushView.tapSelf = ^{
            weakSelf.statusView.top = 0;
            weakSelf.orderStatusHeight = weakSelf.orderStatusHeight - 32;
            [weakSelf resetStatusHeight];
        };
        
        self.statusView.top = 32;
        self.orderStatusHeight = self.orderStatusHeight + 32;
        
        if (!(_topTaskView)) {
            [self resetStatusHeight];
        }
    }
    return _pushView;
}

- (void)resetStatusHeight {
    self.tableView.height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - self.orderStatusHeight -SafeAreaBottomHeight;
    self.tableView.top = self.orderStatusHeight;
    [self scrollToBottom:NO finish:nil];
}

- (ZZChatOrderDealView *)dealView {
    WeakSelf;
    if (!_dealView) {
        _dealView = [[ZZChatOrderDealView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _dealView.touchAccept = ^{
            [weakSelf accept];
        };
        _dealView.touchRefuse = ^{
            [weakSelf refuse];
        };
    }
    return _dealView;
}

- (ZZChatStatusSheetView *)sheetView {
    WeakSelf;
    if (!_sheetView) {
        _sheetView = [[ZZChatStatusSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _sheetView.touchCancel = ^{
            [weakSelf cancel];
        };
        _sheetView.touchEdit = ^{
            [weakSelf edit];
        };
        _sheetView.touchRefund = ^{
            [weakSelf wantToRefund];
        };
        _sheetView.touchReject = ^{
            [weakSelf refuse];
        };
        _sheetView.touchRent = ^{
            [weakSelf rentBtnClick];
        };
        _sheetView.touchAsk = ^{
            [weakSelf gotoMemedaView];
        };
        _sheetView.touchDetail = ^{
            [weakSelf loadMessages];
        };
        _sheetView.touchRevokeRefund = ^{
            [weakSelf revokeRefund];
        };
        _sheetView.touchEditRefund = ^{
            [weakSelf editRefund];
        };
    }
    return _sheetView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timeLineView removeFromSuperview];
    _timeLineView = nil;
}


@end
