//
//  ZZMessageListViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageListViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "ZZTabBarViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZMessageConnectStatusView.h"
#import "ZZMessageSystemCell.h"
#import "ZZMessageListCell.h"
#import "ZZMessagelistBoxCell.h"
#import "ZZVideoMessage.h"
#import "ZZMessageListViewController+ZZTableView.h"

#import "ZZUserInfoModel.h"
#import "ZZDateHelper.h"
#import "ZZChatOrderInfoModel.h"
#import <RongIMLib/RongIMLib.h>
#import <MJRefresh.h>
#import "ZZShowMessageRed.h"
#import "ZZEarnedCoinView.h"

#import "kongxia-Swift.h"

#define RefreshLimit 15 //默认每次加载15条

@interface ZZMessageListViewController () <RCIMConnectionStatusDelegate, ZZMessageListHeaderViewDelegate> {
    BOOL _connectStatusSuccess;//是否连接成功
    BOOL _viewDisappear;
}

@property (nonatomic, strong) ZZEarnedCoinView *earnedView;

@property (nonatomic, strong) ZZMessageConnectStatusView *connectStatusView;//顶部连接状态view
@property (nonatomic, strong) NSMutableArray *updateArray;//需要更新订单状态的uid array

@property (nonatomic,assign) int refreshStartPosition;//刷新的开始位置
@property (nonatomic,strong) MJRefreshNormalHeader *header;
@property (nonatomic,assign) BOOL updatingEnd;//是否在已经加载过

@property (nonatomic,assign) long long lastTimestamp;//用于记录当前聊天更新的最后一条时间戳(这里以自己接受为主)

@end

@implementation ZZMessageListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"PY_会话%s",__func__);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    // 获取聊天消息列表
    if ([ZZUserHelper shareInstance].updateMessageList) {
        // 新增加, 未读
        [ZZShowMessageRed getUnRedOtherMessage];

        // 获取列表
        [self refreshNewMessage];
    }
    
    // 更新消息列表用户信息
    if (_updateArray.count) {
        [self updateUserInfo];
    }
    
    // 获取账户余额
    [ZZUserHelper updateTheBalanceNext:nil];
    
    // 获取价格配置
    [[ZZUserHelper shareInstance].configModel fetchPriceConfig:NO inViewController:nil block:nil];
    
    // 获取今日总收益
    [self fetchTotalIncome];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"PY_会话%s",__func__);
    [self getUnreadCountWithCount:0];
    _viewDisappear = NO;
    [ZZUserHelper shareInstance].updateMessageList = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ZZTabBarViewController sharedInstance] hideBubbleView];
    [[ZZTabBarViewController sharedInstance] hideRentBubble];
    [_tableView setEditing:NO animated:YES];
    _viewDisappear = YES;
      NSLog(@"PY_会话%s",__func__);
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"PY_会话%s",__func__);

    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PushNotification object:nil userInfo:nil];
    
    self.navigationItem.title = @"消息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBGColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [ZZUserHelper shareInstance].updateMessageList = NO;
    [self initRCIM];
    [self createViews];
    [self addNotifications];
    [self getMessageList];
}

- (void)initRCIM {
    _connectStatusSuccess = YES;
    [RCIM sharedRCIM].connectionStatusDelegate = self;
    RCKitConfigCenter.message.enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE)];
    RCKitConfigCenter.message.enableMessageRecall = YES;
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kMsg_ReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGiftNotification:) name:kMsg_ReceiveGiftChatMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageBox) name:kMsg_UpdateMessageBox object:nil];
    //当有消息盒子主动请求的消息的时候刷新消息盒子小红点
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchUnreadMessageBoxCounts) name:kMsg_UpdateTaskSnatchCount object:nil];
//    refreshNewMessage
    // 双击tab 刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarRefresh) name:KMsg_TabbarRefreshNotification object:nil];
}

#pragma mark - 数据
- (void)getMessageList {
    [self loadNewListMessage];
    _lastTimestamp = 0;
//    [self refreshNewMessage];   2018.7.24 查看代码逻辑，认为不需要再次刷新信息数据 -- lql
}

#pragma mark - 刷新和加载更多
- (void)tabbarRefresh {
    if ([[UIViewController currentDisplayViewController] isKindOfClass: [self class]]) {
        if (![_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header beginRefreshing];
        }
    }
}

/**
 加载更多(每次15条)
 */
- (void)loadMoreMessageListData {
    WS(weakSelf);
    NSArray *newAddArray = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)] count:RefreshLimit startTime:_lastTimestamp];
    if (newAddArray.count<=0) {
        return;
    }
    RCConversation *lastConversation = [newAddArray lastObject];
    weakSelf.lastTimestamp = lastConversation.sentTime ;
    [self loadOtherManagerDataArray:newAddArray];

    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

/**
 当前界面再次显示
 */
- (void)refreshNewMessage {
    int count = _conversationArray.count > 0 ? (int)_conversationArray.count : RefreshLimit;
    self.conversationArray = [NSMutableArray arrayWithArray:[[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)] count:count startTime:0]];
    RCConversation *lastConversation = [_conversationArray lastObject];
    self.lastTimestamp = lastConversation.sentTime ;
    [self firshLoadManagerData];
}

/**
 刷新最新数据
 */
- (void)loadNewListMessage {
    WS(weakSelf);
    _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ZZShowMessageRed getUnRedOtherMessage];
        weakSelf.conversationArray = [NSMutableArray arrayWithArray:[[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)] count:RefreshLimit startTime:0]];
        [weakSelf.tableView.mj_header endRefreshing];
        RCConversation *lastConversation = [_conversationArray lastObject];
        weakSelf.lastTimestamp = lastConversation.sentTime;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf firshLoadManagerData];
        });
    }];
    
    _header.stateLabel.hidden = YES;
    self.tableView.mj_header = self.header;
}

//最开始的15条数据
- (void)firshLoadManagerData {
    NSDate *messageBoxDate = nil;
    if (!isNullString([ZZUserHelper shareInstance].unreadModel.say_hi.latest_at) && [ZZUserHelper shareInstance].unreadModel.say_hi.user_count != 0) {
        messageBoxDate = [[ZZDateHelper shareInstance] getDateWithDateString:[ZZUserHelper shareInstance].unreadModel.say_hi.latest_at];
    }
    NSDate *taskDate = nil;
    if (!isNullString([ZZUserHelper shareInstance].unreadModel.pd_receive_last_time)) {
        taskDate = [[ZZDateHelper shareInstance] getDetailDataWithDateString:[ZZUserHelper shareInstance].unreadModel.pd_receive_last_time];
    }
    
    @autoreleasepool {
        NSArray *oldConversationArray  = [_conversationArray copy];
        for (RCConversation *conversation in oldConversationArray) {
            
            if (![conversation isKindOfClass:[RCConversation class]]) {
                continue;
            }
            
            //移除系统客服
            if ([conversation.targetId isEqualToString: kCustomerServiceId] || [conversation.targetId isEqualToString:kMmemejunUid]) {
                [self.conversationArray removeObject:conversation];
            }
            
            if (![self.userInfoDict objectForKey:conversation.targetId]) {
                [self getUserInfoWithUid:conversation.targetId conversation:conversation];
            }
            
            if (messageBoxDate && ![self.conversationArray containsObject:[ZZUserHelper shareInstance].unreadModel.say_hi]) {
                NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:conversation.sentTime/1000];
                if ([messageBoxDate compare:messageDate] == NSOrderedDescending) {
                    NSInteger lastIndex = [self.conversationArray indexOfObject:conversation];
                    if (lastIndex == NSNotFound) {
                          [self.conversationArray addObject:[ZZUserHelper shareInstance].unreadModel.say_hi];
                    } else {
                        [self.conversationArray insertObject:[ZZUserHelper shareInstance].unreadModel.say_hi atIndex:lastIndex];
                    }
                } else if (conversation == [_conversationArray lastObject]) {
                    [self.conversationArray addObject:[ZZUserHelper shareInstance].unreadModel.say_hi];
                }
            }
            
            //抢任务列表排序
            ZZUser *user = [ZZUserHelper shareInstance].loginer;
            ZZPhoto *photo = user.photos_origin.firstObject;
            if (!user.banStatus &&
                photo != nil && photo.face_detect_status == 3 &&
                user.gender_status != 2 &&
                user.rent.status == 2 && user.rent.show) {
                //抢任务项能出现的情况：1.用户未被ban 2.人脸有比对通过 3.性别无异常且通过实名认证 4.上架达人且未隐身
                if (taskDate && ![self.conversationArray containsObject:[ZZUserHelper shareInstance].unreadModel]) {
                    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:conversation.sentTime/1000];
                    if ([taskDate compare:messageDate] == NSOrderedAscending) {
                        NSInteger lastIndex = [self.conversationArray indexOfObject:conversation];
                        if (lastIndex != NSNotFound) {
                            [self.conversationArray insertObject:[ZZUserHelper shareInstance].unreadModel atIndex:lastIndex];
                        }
                    }
                }
            }
        }
        
        if (oldConversationArray.count == 0 && messageBoxDate) {
            [self.conversationArray addObject:[ZZUserHelper shareInstance].unreadModel.say_hi];
        }
        
        if (![self.conversationArray containsObject:[ZZUserHelper shareInstance].unreadModel]) {
            [self.conversationArray insertObject:[ZZUserHelper shareInstance].unreadModel atIndex:0];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }
}

/**
 加载其他的数据
 */
- (void)loadOtherManagerDataArray:(NSArray *)othermessageArray {
    NSDate *messageBoxDate;
    if (!isNullString([ZZUserHelper shareInstance].unreadModel.say_hi.latest_at) && [ZZUserHelper shareInstance].unreadModel.say_hi.user_count != 0) {
        messageBoxDate = [[ZZDateHelper shareInstance] getDateWithDateString:[ZZUserHelper shareInstance].unreadModel.say_hi.latest_at];
    }
    id message = [self.conversationArray lastObject];
    //如果消息盒子的消息是最后一条数据的话那就需要排序
    if ([message isKindOfClass:[ZZMessageBoxConfigModel class]]) {
        NSMutableArray *tempmessageArray = [NSMutableArray arrayWithArray:othermessageArray];
        [tempmessageArray addObject:message];
        @autoreleasepool {
            RCConversation *customerService;//系统客服
            for (int i=0; i<tempmessageArray.count; i++) {
                NSDate *messageDateNew;
                id  obj1  = tempmessageArray[i] ;
                if ([obj1 isKindOfClass:[ZZMessageBoxConfigModel class]]) {
                    messageDateNew = messageBoxDate;
                } else if ([obj1 isKindOfClass:[RCConversation class]]) {
                    RCConversation *conversation = (RCConversation*)obj1;
                    /**判断系统客服*/
                    if ([conversation.targetId isEqualToString: kCustomerServiceId]||[conversation.targetId isEqualToString:kMmemejunUid]) {
                        customerService = conversation;
                    }
                    /***/
                    messageDateNew = [NSDate dateWithTimeIntervalSince1970:conversation.sentTime/1000];
                    if (![self.userInfoDict objectForKey:conversation.targetId]) {
                        [self getUserInfoWithUid:conversation.targetId conversation:conversation];
                    }
                }
                for (int j=i+1; j<tempmessageArray.count; j++) {
                    NSDate *messageDatelast;
                    id  obj2  = tempmessageArray[j] ;
                    if ([obj2 isKindOfClass:[ZZMessageBoxConfigModel class]]) {
                        messageDatelast = messageBoxDate;
                    } else if ([obj2 isKindOfClass:[RCConversation class]]) {
                        RCConversation*conversation = (RCConversation*)obj2;
                        messageDatelast   = [NSDate dateWithTimeIntervalSince1970:conversation.sentTime/1000];
                    }
                    if ([messageDateNew compare:messageDatelast] == NSOrderedAscending) {
                        [tempmessageArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                    }
                }
            }
            ///移除系统客服
            if (customerService !=nil) {
                [tempmessageArray removeObject:customerService];
            }
        }
        //消息盒子
        [self.conversationArray removeObject:message];
        [self.conversationArray addObjectsFromArray:tempmessageArray];
    } else {
        //不是不需要排序
        [self.conversationArray addObjectsFromArray:othermessageArray];
    }
}

- (void)getUserInfoWithUid:(NSString *)uid conversation:(RCConversation *)conversation {
    [ZZUserHelper getMiniUserInfo:uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithDictionary:[self getUserInfoDict]];
            
            // 保存最后一条的ID
            NSNumber *latestMessageID = nil;
            
            // 是否存在礼物
            NSNumber *didHaveGift = nil;
            
            // 礼物动画列表
            NSArray *animationUsersArr = nil;            
            
            NSMutableDictionary *userInfo = [aDict[uid] mutableCopy];
            if (userInfo) {
                if (userInfo[@"latestMessageID"]) {
                    latestMessageID = userInfo[@"latestMessageID"];
                }
                
                if (userInfo[@"didHaveGift"]) {
                    didHaveGift = userInfo[@"didHaveGift"];
                }
                
                if (userInfo[@"animationUsersArr"]) {
                    animationUsersArr = userInfo[@"animationUsersArr"];
                }
            }
            
            NSMutableDictionary *userData = [data mutableCopy];
            userData[@"latestMessageID"] = latestMessageID;
            userData[@"didHaveGift"] = didHaveGift;
            userData[@"animationUsersArr"] = animationUsersArr;
            
            [aDict setObject:userData.copy forKey:uid];
            [self saveUserInfoDict:aDict];
            [self.userInfoDict setObject:data forKey:uid];
            if ([_updateArray containsObject:uid]) {
                [_updateArray removeObject:uid];
            }
            if (conversation && [self.conversationArray containsObject:conversation]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.conversationArray indexOfObject:conversation] inSection:1];
                ZZMessageListCell *cell = (ZZMessageListCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (cell) {
                    ZZUserInfoModel *userInfo = [self getUserInfoModel:conversation.targetId];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell setData:conversation userInfo:userInfo];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }
        }
    }];
}

- (void)getUnreadCountWithCount:(int)count {
    //在线客服
    _systemUnreadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_CUSTOMERSERVICE)]];
    ZZTabBarViewController *ctl = [ZZTabBarViewController sharedInstance];
    [ctl manageUnreadCountWithCount:count];
    [ctl managerAppBadge];
}

- (void)updateUserInfo {
    if (_updateArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_updateArray enumerateObjectsUsingBlock:^(NSString *uid, NSUInteger idx, BOOL * _Nonnull stop) {
                [self getUserInfoWithUid:uid conversation:nil];
            }];
        });
    }
}

- (void)fetchTotalIncome {
    if (![[ZZUserHelper shareInstance] isLogin]) {
        return;
    }
    
    if (![ZZUserHelper shareInstance].loginer.open_charge) {
        return;
    }
    
    [ZZRequest method:@"GET" path:@"/api/userinfo/getChatCharge" params:@{@"uid": [ZZUserHelper shareInstance].loginer.uid} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error || !data || ![data isKindOfClass:[NSDictionary class]]) {
            [self createRightEarnedView:@"0"];
        }
        else {
            NSDictionary *infoDic = data;
            if (![infoDic isKindOfClass:[NSDictionary class]] || !infoDic[@"amount"]) {
                [self createRightEarnedView:@"0"];
            }
            
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            [numberFormatter setGroupingSeparator:@""];
            NSString *amountStr = [numberFormatter stringFromNumber:infoDic[@"amount"]];
            [self createRightEarnedView:amountStr];
        }
    }];
}

- (void)fetchUnreadMessageBoxCounts {
    if (![[ZZUserHelper shareInstance] isLogin]) {
        return;
    }
    
    [ZZRequest method:@"GET" path:@"/api/getSayHiDrawCount" params:@{@"uid": [ZZUserHelper shareInstance].loginer.uid} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (!error && [data isKindOfClass:[NSNumber class]]) {
            NSInteger unreadCount = [(NSNumber *)data intValue];
            [ZZUserHelper shareInstance].unreadModel.say_hi.user_count = unreadCount;
            [self refreshNewMessage];
        }

    }];
}

/**
 实时刷新关注的界面
 */
- (void)refreshConversectionDataWithMessage:(RCMessage *)message {
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        //未读消息tabbar的列表
        [self getUnreadCountWithCount:0];
        //已经显示的界面的消息
        NSInteger originalIndex = [weakSelf getRefeshIndexWithSendMesssage:message];
        if (originalIndex == -1) {
            // 新的消息
            NSArray *newConversation = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)] count:1 startTime:0];
            RCConversation *conversation = newConversation.lastObject;
            [weakSelf.conversationArray insertObject:conversation atIndex:0];
            if (![weakSelf.userInfoDict objectForKey:conversation.targetId]) {
                [weakSelf getUserInfoWithUid:conversation.targetId conversation:conversation];
            }

            // 会有bug 不知道怎么整，只能先reloadData
            [weakSelf.tableView reloadData];
            return;
        }
        
        //这里是第二个区的
        id object;
        if (originalIndex < weakSelf.conversationArray.count) {
            object = weakSelf.conversationArray[originalIndex];
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:originalIndex inSection:1];
        if ([object isKindOfClass:[RCConversation class]]) {
            //关注的
            ZZMessageListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            if ([cell isKindOfClass:[ZZMessageListCell class]]) {
                RCConversation *model = (RCConversation *)object;
                model.objectName = message.objectName;
                model.senderUserId = message.senderUserId;
                model.unreadMessageCount +=1;
                model.receivedTime = message.receivedTime;
                model.sentTime = message.sentTime;
                ZZUserInfoModel *userInfo = [self getUserInfoModel:message.targetId];
                model.lastestMessage = message.content;
                [cell setData:model userInfo:userInfo];
            }
            else {
                [_tableView reloadData];
                return;
            }
            
        } else {
            //打招呼的
            ZZMessagelistBoxCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            [cell setData];
        }
        [self.conversationArray removeObjectAtIndex:originalIndex];
        if (object) {
            [self.conversationArray insertObject:object atIndex:0];
        }
        
        [weakSelf.tableView reloadData];
    });
}

/**
 返回当前消息的所在数组的位置
 -1 表示当前属于新消息
 */
- (NSInteger)getRefeshIndexWithSendMesssage:(RCMessage *)message {
    __block  NSInteger integer = -1;
    [self.conversationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[RCConversation class]]) {
            RCConversation *conversation =(RCConversation *)obj;
            if ([conversation.targetId isEqualToString:message.targetId]) {
                integer = idx;
                *stop = YES;
            }
        }
    }];
    return integer;
}
- (void)updateData {
    [self refreshNewMessage];
    [self getUnreadCountWithCount:0];
}

- (NSDictionary *)getUserInfoDict {
    return [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].messageListUserInfo];
}

- (ZZUserInfoModel *)getUserInfoModel:(NSString *)targetId {
    NSDictionary *aDit = [[self getUserInfoDict] objectForKey:targetId];
    ZZUserInfoModel *model = [[ZZUserInfoModel alloc] initWithDictionary:aDit error:nil];
    return model;
}

- (void)saveUserInfoDict:(NSDictionary *)aDict {
    [ZZKeyValueStore saveValue:aDict key:[ZZStoreKey sharedInstance].messageListUserInfo];
}

#pragma mark - ZZMessageListHeaderViewDelegate
- (void)showDetails:(ZZMessageListHeaderView *)view {
    if ([ZZUtils isBan]) {
        [ZZHUD showErrorWithStatus:@"您已被封禁"];
        return ;
    }
    
    if ([[ZZUserHelper shareInstance] isAvatarManualReviewing]) {
        [ZZHUD showErrorWithStatus:@"头像人工审核中，暂时无法打招呼"];
        return ;
    }

    NSString *url;
    if (![[ZZSayHiHelper sharedInstance] didTodayShowWithSayHiType:SayHiTypeDailyLogin]) {
        url = H5Url.inviteDaren_zuwome;
    }
    else {
        url = H5Url.inviteDaren;
    }
    
    ZZLinkWebViewController *webview = [[ZZLinkWebViewController alloc] init];
    webview.urlString = url;
    webview.isPush = YES;
    webview.isHideBar = YES;
    webview.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webview animated:YES];
}

- (void)close:(ZZMessageListHeaderView *)view {
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - CreateViews
- (void)createRightEarnedView:(NSString *)income {
    if (!_earnedView) {
        _earnedView = [[ZZEarnedCoinView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150, 32)];
        UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc]initWithCustomView:_earnedView];
        self.navigationItem.rightBarButtonItem = rightBarButon;
    }
    [_earnedView earnedIncom:income];
}

- (void)createListHeaderView {
    BOOL didShowHeaderView = ([[ZZUserHelper shareInstance] isLogin] && [ZZUserHelper shareInstance].loginer.gender == 2);
    if (didShowHeaderView) {
        ZZMessageListHeaderView *headerView = [[ZZMessageListHeaderView alloc] init];
        headerView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 44.0);
        headerView.delegate = self;
        _tableView.tableHeaderView = headerView;
    }
}

- (void)createViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:_tableView];
    [self registerCellForTableView:self.tableView];
    [self createListHeaderView];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.conversationArray.count == indexPath.row+1) {
        _updatingEnd = YES;
    }
    if ((self.conversationArray.count - indexPath.row < RefreshLimit) && (self.conversationArray.count >= RefreshLimit) && _updatingEnd) {
        _updatingEnd = NO;
        [self loadMoreMessageListData];
    }
}

#pragma mark - RCIMDelegate
- (void)receiveGiftNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.tableView reloadData];
    });
   
}

- (void)receiveNotification:(NSNotification *)notification {
    RCMessage *message = [notification.userInfo objectForKey:@"message"];
    if (message.conversationType == ConversationType_PRIVATE) {
        //单聊消息
        int left = [[notification.userInfo objectForKey:@"left"] intValue];
        if (left == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZZUserHelper shareInstance].updateMessageList = YES;
                if ([message.targetId isEqualToString: kCustomerServiceId] || [message.targetId isEqualToString:kMmemejunUid]) {
                    //如果是系统客服的话就不要了,为了防止系统客服带来的bug
                    return ;
                }
                [self refreshConversectionDataWithMessage:message];
            });
            [[ZZTabBarViewController sharedInstance] manageUnreadCountWithCount:0];
        }
        if ([message.content isKindOfClass:[ZZChatOrderInfoModel class]]) {
            if (![self.updateArray containsObject:message.targetId]) {
                [self.updateArray addObject:message.targetId];
                //假如用户在当前页面 直接刷新
                if (!_viewDisappear) {
                    [self updateUserInfo];
                }
            }
        }
    } else if (message.conversationType == ConversationType_CUSTOMERSERVICE) {
        //客服
        if (!_viewDisappear) {
            [self updateData];
        }
        [ZZUserHelper shareInstance].updateMessageList = YES;
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }
}

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    switch (status) {
        case ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT: {
            _tableView.tableHeaderView = self.connectStatusView;
            _connectStatusSuccess = NO;
            _connectStatusView.titleLabel.text = @"当前用户在其他设备上登陆，此设备被踢下线";
        } break;
        case ConnectionStatus_NETWORK_UNAVAILABLE: {
            _tableView.tableHeaderView = self.connectStatusView;
            _connectStatusSuccess = NO;
            _connectStatusView.titleLabel.text = @"当前网络不可用，请检查你的网络设置";
        } break;
        case ConnectionStatus_Connected: {
            _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
            _connectStatusSuccess = YES;
            [self refreshNewMessage];
            [self createListHeaderView];
        } break;
        case ConnectionStatus_Connecting: {
            _tableView.tableHeaderView = self.connectStatusView;
            _connectStatusSuccess = NO;
            _connectStatusView.titleLabel.text = @"连接中...";
        } break;
        case ConnectionStatus_TOKEN_INCORRECT: {
            
        } break;
        case ConnectionStatus_Unconnected:
        case ConnectionStatus_SignOut: {
            _tableView.tableHeaderView = self.connectStatusView;
            _connectStatusSuccess = NO;
            _connectStatusView.titleLabel.text = @"网络不给力，请检查网络设置";
        } break;
        default: {
            _tableView.tableHeaderView = self.connectStatusView;
            _connectStatusSuccess = NO;
            _connectStatusView.titleLabel.text = @"连接失败，重连中...";
        } break;
    }
}

- (void)updateMessageBox {
    [self refreshNewMessage];
}

#pragma mark - LazyLoad
- (NSMutableArray *)conversationArray {
    if (!_conversationArray) {
        _conversationArray = [NSMutableArray array];
    }
    return _conversationArray;
}

- (NSMutableArray *)updateArray {
    if (!_updateArray) {
        _updateArray = [NSMutableArray array];
    }
    return _updateArray;
}

- (ZZMessageConnectStatusView *)connectStatusView {
    if (!_connectStatusView) {
        _connectStatusView = [[ZZMessageConnectStatusView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        _connectStatusView.viewController = self;
    }
    return _connectStatusView;
}

- (NSMutableDictionary *)userInfoDict {
    if (!_userInfoDict) {
        _userInfoDict = [NSMutableDictionary dictionary];
    }
    return _userInfoDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Lazy loading
- (NSDictionary *)messageListUIDic {
    if (!_messageListUIDic) {
        _messageListUIDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                @[@"互动",@"系统",@"评论"],@"title",
                                @[@"icInteraction",@"icSystem",@"icon_messagelist_comment"],@"image",
                                nil];
    }
    return _messageListUIDic;
}

@end


@interface ZZMessageListHeaderView ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation ZZMessageListHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetails)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - response method
- (void)showDetails {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showDetails:)]) {
        [self.delegate showDetails:self];
    }
}

- (void)close {
    if (self.delegate && [self.delegate respondsToSelector:@selector(close:)]) {
        [self.delegate close:self];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(252, 250, 228);
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.closeBtn];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(self).offset(15);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.equalTo(self).offset(-15);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_iconImageView.mas_right).offset(8);
        make.right.equalTo(_closeBtn.mas_left).offset(-8);
    }];
    
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"私信收益太低？点击查看怎样获取更高收益";
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
        _titleLabel.textColor = HEXCOLOR(0x666666);
        
        NSString *str = @"私信收益太低？点击查看怎样获取更高收益";
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:13.0]
                                  range:NSMakeRange(0, str.length)];
        [attributeStr addAttribute:NSForegroundColorAttributeName
                                  value:HEXCOLOR(0x666666)
                                  range:NSMakeRange(0, str.length)];
        
        NSRange priceRange = [str rangeOfString:@"获取更高收益"];
        if (priceRange.location != NSNotFound) {
            [attributeStr addAttribute:NSFontAttributeName
                                      value:[UIFont fontWithName:@"PingFangSC-Medium" size: 13.0f]
                                      range:priceRange];
            [attributeStr addAttribute:NSForegroundColorAttributeName
                                      value:HEXCOLOR(0x1296DB)
                                      range:priceRange];
        }
        _titleLabel.attributedText = attributeStr;
        
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"ic_qianbi"];
    }
    return _iconImageView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        _closeBtn.normalImage = [UIImage imageNamed:@"ic_guanbi"];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
@end
