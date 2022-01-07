//
//  ZZGiftHelper.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZGiftHelper.h"

#import "ZZChatViewController.h"

#import "ZZGiftModel.h"
#import "ZZDownloadHelper.h"
#import "ZZChatGiftModel.h"
#import "ZZUserInfoModel.h"


@interface ZZGiftHelper()

@property (nonatomic, strong) NSDictionary *userGiftChatInfo;

@property (nonatomic, assign) BOOL didUserExitInTheList;

@property (nonatomic, strong) ZZUserInfoModel *userInfoModel;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *animationsArr;

@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, strong) ZZPrivateChatGiftView *animationView;

@end

@implementation ZZGiftHelper

- (instancetype)initWithUser:(ZZUser *)user {
    self = [super init];
    if (self) {
        _isAnimating = NO;
        _user = user;
        [ZZKeyValueStore createTable:@"PrivateChatGiftList"];
        [self fetchUserInfo];
    }
    return self;
}

/*
 是否需要在聊天页面底部显示一个发送礼物的tipView
*/
- (BOOL)shouldShowChatGiftTipsView {
    // 自己是男的
    if ([ZZUserHelper shareInstance].loginer.gender != 1) {
        return NO;
    }
    
    // 对方是女的
    if (_user.gender != 2) {
        return NO;
    }
    
    // 符合条件的男女用户首次聊天展示一次；已聊过天的，该功能上线后的首次聊天展示一次
    NSArray *chatUsers = [_userGiftChatInfo[@"toUsers"] mutableCopy];
    if (chatUsers && [chatUsers containsObject: _user.uid]) {
        return NO;
    }
    return YES;
}

/*
 在赠送礼物的时候, 是否要显示提示框
*/
- (BOOL)shouldShowSendGiftTips {
    if (_userGiftChatInfo && ![_userGiftChatInfo[@"showGiftSendTip"] boolValue]) {
        return NO;
    }
    return YES;
}

/*
 么币是否充足
 */
- (BOOL)didHaveEnoughMoneyToSendGift:(ZZGiftModel *)model {
    NSInteger currentCostMebi = [ZZUserHelper shareInstance].consumptionMebi;
    NSInteger totalToBeCost = currentCostMebi + model.mcoin;
    if ([[ZZUserHelper shareInstance].loginer.mcoin integerValue] < totalToBeCost) {
        return NO;
    }
    return YES;
}

- (BOOL)shouldShowGiftIconAnimation:(NSString *)uid {
     NSArray<RCMessage *> *array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:uid count:15];
    return array.count >= 15;
}

#pragma mark - Save/Edit Info
- (void)fetchUserInfo {
    _userGiftChatInfo = [ZZKeyValueStore getValueWithKey:[ZZUserHelper shareInstance].loginer.uid
    tableName:@"PrivateChatGiftList"];
    if (!_userGiftChatInfo) {
        _userGiftChatInfo = @{
            @"showGiftSendTip" : @(YES),
            @"toUsers": @{},
        };
        [self saveChatGiftUserInfo];
    }
}

- (ZZUserInfoModel *)fetchCurrentSendedGiftUser {
    NSArray *giftsArr = _userGiftChatInfo[@"SendedGifts"];
    if (!giftsArr || giftsArr.count == 0) {

        return nil;
    }
    
    __block BOOL didhaveUser = NO;
    __block NSDictionary *sendedUserInfo = nil;
    [giftsArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"uid"] isEqualToString:_user.uid]) {
            sendedUserInfo = obj;
            didhaveUser = YES;
            *stop = YES;
        }
    }];
    
    if (!didhaveUser) {
        return nil;
    }
    
    return [[ZZUserInfoModel alloc] initWithDictionary:sendedUserInfo error:nil];
    
}

- (void)addChatUser {
    if (_didUserExitInTheList) {
        return;
    }
        
    NSMutableDictionary *giftChatInfo = _userGiftChatInfo.mutableCopy;
    NSMutableArray *chatUsers = [giftChatInfo[@"toUsers"] mutableCopy];
    
    if ([chatUsers containsObject:_user.uid]) {
        _didUserExitInTheList = YES;
        return;
    }
    
    if (!chatUsers || ![chatUsers isKindOfClass:[NSMutableArray class]]) {
        chatUsers = @[_user.uid].mutableCopy;
    }
    else {
        [chatUsers addObject:_user.uid];
    }
    
    giftChatInfo[@"toUsers"] = chatUsers.copy;
    _userGiftChatInfo = giftChatInfo.copy;
    [self saveChatGiftUserInfo];
}

/*
 付款的时候不再显示发送的提示
*/
- (void)neverShowSendGiftTips {
    NSMutableDictionary *info = _userGiftChatInfo.mutableCopy;
    info[@"showGiftSendTip"] = @(NO);
    _userGiftChatInfo = info.copy;
    [self saveChatGiftUserInfo];
}


- (void)saveChatGiftUserInfo {
    [ZZKeyValueStore saveValue:_userGiftChatInfo key:[ZZUserHelper shareInstance].loginer.uid tableName:@"PrivateChatGiftList"];
}

#pragma mark - 显示动画
/*
 显示动画
 */
- (void)showGiftsAnimationIn:(UIView *)view {
    
    if (!self.userInfoModel.didHaveGift) {
        return;
    }
    
    if (!_animationsArr) {
        _animationsArr = @[].mutableCopy;
    }
    
    for (NSDictionary *info in self.userInfoModel.animationsArr) {
        if (![info isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        if (isNullString(info[@"lottie"]) || isNullString(info[@"icon"])) {
            continue;
        }
        [_animationsArr addObject:info];
    }
    
    if (_animationsArr.count == 0) {
        return;
    }
    
    _isAnimating = YES;
    [self showAnimationIn:view animationArr:_animationsArr.firstObject];
    
    [ZZGiftHelper clearUserMessageDataWith:_user.uid];
}

- (void)showAnimationIn:(UIView *)view animationArr:(NSDictionary *)lottieInfo {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_isAnimating) {
                return ;
            }
            
            _animationView = [[ZZPrivateChatGiftView alloc] initWithContentsOfURL:[NSURL URLWithString:lottieInfo[@"lottie"]]];
            _animationView.contentMode = UIViewContentModeScaleAspectFit;
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:lottieInfo[@"icon"]]];
            [_animationView addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_animationView);
            }];
            
            [view addSubview:_animationView];
            _animationView.frame = view.bounds;
            _animationView.loopAnimation = NO;
            _animationView.cacheEnable = YES;
            _animationView.userInteractionEnabled = YES;
            [_animationView playWithCompletion:^(BOOL animationFinished) {
                [_animationView removeFromSuperview];
                _animationView = nil;
                @synchronized (self) {
                    if (_animationsArr.count > 0) {
                        [_animationsArr removeObjectAtIndex:0];
                    }
                }
                
                if (_animationsArr.count > 0) {
                    [self showAnimationIn:view animationArr:_animationsArr.firstObject];
                }
                else {
                    // 清除礼物的数据
                    [ZZGiftHelper clearUserMessageDataWith:_user.uid];
                    _isAnimating = NO;
                }
            }];
        });
    }
}

- (void)reciveANewGift:(RCMessage *)message showIn:(UIView *)view {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![[UIViewController currentDisplayViewController] isKindOfClass: [ZZChatViewController class]]) {
            return;
        }
        
        if (![message.content isKindOfClass: [ZZChatGiftModel class]]) {
            return;
        }
        
        if (message.messageDirection != MessageDirection_RECEIVE) {
            return;
        }
        
        ZZChatGiftModel *giftMessage = (ZZChatGiftModel *)message.content;
        
        if (isNullString(giftMessage.icon) || isNullString(giftMessage.lottie) ) {
            return;
        }
        
        NSDictionary *info = @{
            @"icon": giftMessage.icon,
            @"lottie": giftMessage.lottie
        };
        
        if (!_animationsArr) {
            _animationsArr = @[].mutableCopy;
        }
    
        @synchronized (self) {
            [_animationsArr addObject:info];
        }
    
        if (_isAnimating) {
            
        }
        else {
            _isAnimating = YES;
            [self showAnimationIn:view animationArr:_animationsArr.firstObject];
        }
//    });
}

- (void)stopAnimations {
    _isAnimating = NO;
    [_animationView stop];
    [_animationView removeFromSuperview];
    _animationView = nil;
    
    // 清除礼物的数据
    [ZZGiftHelper clearUserMessageDataWith:_user.uid];
}


#pragma mark - Request
/*
获取礼物列表
*/
- (void)fetchGiftsListWithCompleteBlock:(void (^)(NSArray<ZZGiftModel *> *))completeBlock {
    [ZZRequest method:@"GET" path:@"/api/getAllGift" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            NSArray *modelArr = [NSArray yy_modelArrayWithClass:[ZZGiftModel class] json:data];
            if (modelArr.count == 0) {
                [ZZHUD showErrorWithStatus:@"请重试"];
            }
            else {
                if (completeBlock) {
                    completeBlock(modelArr);
                }
            }
        }
    }];
}

/*
 发送礼物
*/
- (void)sendGift:(ZZGiftModel *)giftModel finishedBlock:(void (^)(BOOL))finishedBlock {
    
    NSInteger source = 0;
    if (_entry == GiftEntryIDPhoto) {
        source = 1;
        _entry = GiftEntryNone;
    }
    else if (_entry == GiftEntryKTV) {
        source = 4;
        _entry = GiftEntryNone;
    }
    
    NSDictionary *param = @{
        @"gid": giftModel._id,
        @"touid": _user.uid,
        @"source": @(source),
    };
    
    [ZZRequest method:@"POST"
                 path:@"/api/giveGift"
               params:param
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (finishedBlock) {
                finishedBlock(NO);
            }
            return;
        }
        
        // 发送礼物成功之后要相应的在[ZZUserHelper shareInstance].consumptionMebi 加上发送的价格
        [ZZUserHelper shareInstance].consumptionMebi += giftModel.mcoin;
        
        NSDictionary *dic = (NSDictionary *)data;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if (!isNullString(dic[@"from_msg_a"])) {
                giftModel.from_msg_a = dic[@"from_msg_a"];
            }
            
            if (!isNullString(dic[@"from_msg_b"])) {
                giftModel.from_msg_b = dic[@"from_msg_b"];
            }
            
            if (!isNullString(dic[@"to_msg_a"])) {
                giftModel.to_msg_a = dic[@"to_msg_a"];
            }
            
            if (!isNullString(dic[@"to_msg_b"])) {
                giftModel.to_msg_b = dic[@"to_msg_b"];
            }
            
            giftModel.charm_num = dic[@"charm_num"];
            
            
        }
        if (finishedBlock) {
            finishedBlock(YES);
        }
    }];
}


#pragma mark - getters and setters
- (ZZUserInfoModel *)userInfoModel {
    if (!_userInfoModel) {
        // 保存的用户信息
        _userInfoModel = [self fetchCurrentSendedGiftUser];
    }
    return _userInfoModel;
}


#pragma mark - 类方法: 判断当前所有聊天未读的是否有礼物
+ (NSDictionary *)getUserInfoDict {
    return [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].messageListUserInfo];
}

+ (ZZUserInfoModel *)getUserInfoModel:(NSString *)targetId {
    NSDictionary *aDit = [[self getUserInfoDict] objectForKey:targetId];
    ZZUserInfoModel *model = [[ZZUserInfoModel alloc] initWithDictionary:aDit error:nil];
    return model;
}

+ (void)saveUserInfoDict:(NSDictionary *)aDict {
    [ZZKeyValueStore saveValue:aDict key:[ZZStoreKey sharedInstance].messageListUserInfo];
}


+ (NSDictionary *)fetchUserInfo {
    if (![[ZZUserHelper shareInstance] isLogin]) {
        return nil;
    }
    [ZZKeyValueStore createTable:@"PrivateChatGiftList"];
    NSDictionary *userGiftChatInfo = [ZZKeyValueStore getValueWithKey:[ZZUserHelper shareInstance].loginer.uid
                                                          tableName:@"PrivateChatGiftList"];
    
    if (!userGiftChatInfo) {
        userGiftChatInfo = @{
            @"showGiftSendTip" : @(YES),
            @"toUsers": @{},
        };
        
        [self saveChatGiftUserInfo:userGiftChatInfo];
    }
    
    return userGiftChatInfo;
}

+ (ZZUserInfoModel *)fetchCurrentSendedGiftUser:(NSString *)userID {
    NSDictionary *userInfo = [self fetchUserInfo];
    NSArray *giftsArr = userInfo[@"SendedGifts"];
    if (!giftsArr || giftsArr.count == 0) {
        return nil;
    }
    
    __block BOOL didhaveUser = NO;
    __block NSDictionary *sendedUserInfo = nil;
    [giftsArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"uid"] isEqualToString:userID]) {
            sendedUserInfo = obj;
            didhaveUser = YES;
            *stop = YES;
        }
    }];
    
    if (!didhaveUser) {
        return nil;
    }
    
    return [[ZZUserInfoModel alloc] initWithDictionary:sendedUserInfo error:nil];
}

+ (void)fetchCurrentSendedGifyUser:(NSString *)sendedUserID userInfo:(NSDictionary *)userInfo completeHandler:(void(^)(NSMutableDictionary *sendedUserInfo, NSInteger sendedUserIndex))completeHandler {
    NSArray *giftsArr = userInfo[@"SendedGifts"];
    if (!giftsArr || giftsArr.count == 0) {
        // 没有数据情况
        [self fetchUserMiniDataWith:sendedUserID completion:^(NSMutableDictionary *sendedUserInfo) {
            if (completeHandler) {
                completeHandler(sendedUserInfo, -1);
            }
        }];
        
        return;
    }
    
    __block BOOL didhaveUser = NO;
    __block NSDictionary *sendedUserInfo = nil;
    __block NSInteger sendedUserIndex = -1;
    [giftsArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"uid"] isEqualToString:sendedUserID]) {
            sendedUserInfo = obj;
            didhaveUser = YES;
            *stop = YES;
            sendedUserIndex = idx;
        }
    }];
    
    if (!didhaveUser) {
        // 没有数据情况
        [self fetchUserMiniDataWith:sendedUserID completion:^(NSMutableDictionary *sendedUserInfo) {
            if (completeHandler) {
                completeHandler(sendedUserInfo, -1);
            }
        }];
        return ;
    }
    
    if (completeHandler) {
        completeHandler([sendedUserInfo mutableCopy], sendedUserIndex);
    }
    
}

+ (void)saveChatGiftUserInfo:(NSDictionary *)userInfo {
    [ZZKeyValueStore saveValue:userInfo key:[ZZUserHelper shareInstance].loginer.uid tableName:@"PrivateChatGiftList"];
}

/*
启动APP 获取所有未读数据
*/
+ (void)checkIfUnreadMessagesHaveGifts {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSInteger unreadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
        NSArray<RCConversation *> *conversationArray = [NSMutableArray arrayWithArray:[[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)] count:9999 startTime:0]];

        if (unreadCount == 0) {
            return;
        }
        
        for (RCConversation *conversation in conversationArray) {
            if (conversation.unreadMessageCount == 0) {
                continue;
            }
            
            // userID
            NSString *userID = conversation.targetId;
            
            
            NSDictionary *userInfo = [self fetchUserInfo];
            
            // 保存的用户信息
            [self fetchCurrentSendedGifyUser:userID userInfo:userInfo completeHandler:^(NSMutableDictionary *sendedUserInfo, NSInteger sendedUserIndex) {
                if (sendedUserInfo) {
                    [self configureGiftDataUserID:userID
                                         userInfo:userInfo.mutableCopy
                                     sendedUserID:userID
                                   sendedUserInfo:sendedUserInfo
                                  sendedUserIndex:sendedUserIndex
                                      unreadCount:conversation.unreadMessageCount];
                }
            }];
        }
    });
}

+ (void)configureGiftDataUserID:(NSString *)userID
                       userInfo:(NSMutableDictionary *)userInfo
                   sendedUserID:(NSString *)sendedUserID
                 sendedUserInfo:(NSMutableDictionary *)sendeduserInfo
                sendedUserIndex:(NSInteger)sendedUserIndex
                    unreadCount:(int)unreadCount {
    // 最后一条消息(防止重复)
    RCMessage *message = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:userID count:1].firstObject;
    
    // 如果相同就不走下去了
    if (sendeduserInfo[@"latestMessageID"]) {
        long savedLatestMessageID = [sendeduserInfo[@"latestMessageID"] longValue];
        if (message.messageId <= savedLatestMessageID) {
            return;
        }
    }
    
    __block BOOL didHaveGift = NO;
    NSMutableArray *animationsArr = @[].mutableCopy;
    NSArray<RCMessage *> *array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:userID count:unreadCount];
    [array enumerateObjectsUsingBlock:^(RCMessage * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        if (message.messageDirection == MessageDirection_RECEIVE) {
            if ([message.content isKindOfClass: [ZZChatGiftModel class]]) {
                ZZChatGiftModel *giftMessage = (ZZChatGiftModel *)message.content;
                didHaveGift = YES;
                if (!isNullString(giftMessage.lottie) && !isNullString(giftMessage.icon)) {
                    NSDictionary *infoDic = @{
                        @"icon" : giftMessage.icon,
                        @"lottie" : giftMessage.lottie,
                    };
                    [animationsArr addObject:infoDic];
                }
            }
        }
    }];
    
    if (!didHaveGift) {
        return;
    }
    
    // 保存最后一条的ID
    sendeduserInfo[@"latestMessageID"] = @(message.messageId);
    
    // 是否存在礼物
    sendeduserInfo[@"didHaveGift"] = @(didHaveGift);
    
    // 礼物动画列表
    sendeduserInfo[@"animationsArr"] = animationsArr.copy;
    
    NSMutableArray *sendGiftUsersArr = [userInfo[@"SendedGifts"] mutableCopy];
    if (!sendGiftUsersArr || sendGiftUsersArr.count == 0) {
        sendGiftUsersArr = @[sendeduserInfo].mutableCopy;
    }
    else {
        if (sendedUserIndex == -1 || sendGiftUsersArr.count < sendedUserIndex) {
            [sendGiftUsersArr addObject:sendeduserInfo.copy];
        }
        else {
            sendGiftUsersArr[sendedUserIndex] = sendeduserInfo.copy;
        }
    }
    
    userInfo[@"SendedGifts"] = sendGiftUsersArr.copy;
    
    NSMutableDictionary *messageListInfo = [[self getUserInfoDict] mutableCopy];
    NSDictionary *aDit = [messageListInfo objectForKey:sendedUserID];
    ZZUserInfoModel *model = [[ZZUserInfoModel alloc] initWithDictionary:aDit error:nil];
    if (!aDit || !model) {
        model = [[ZZUserInfoModel alloc] initWithDictionary:sendeduserInfo error:nil];
    }
    model.animationsArr = nil;
    
    NSMutableArray *users = model.animationUsersArr.mutableCopy;
    if (!users || users.count == 0) {
        users = @[[ZZUserHelper shareInstance].loginer.uid].mutableCopy;
    }
    else {
        if (![users containsObject:[ZZUserHelper shareInstance].loginer.uid]) {
            [users addObject:[ZZUserHelper shareInstance].loginer.uid];
        }
        
    }
    model.animationUsersArr = users.copy;
    NSDictionary *saveDic = [model toDictionary];
    
    if (!messageListInfo) {
        messageListInfo = @{}.mutableCopy;
    }
    [messageListInfo setObject:saveDic forKey:sendedUserID];
    [self saveUserInfoDict:messageListInfo.copy];
    
//    if (completion) {
//        completion(YES);
//    }
    
    // 保存数据到数据库
    [self saveChatGiftUserInfo:userInfo.copy];

}

/*
 获取到新一条信息, 判断是不是需要保存到数据库
*/
+ (void)recivedNewMessage:(RCMessage *)message completion:(void (^)(BOOL))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIViewController currentDisplayViewController] isKindOfClass: [ZZChatViewController class]]) {
            return;
        }
        
        if (![message.content isKindOfClass: [ZZChatGiftModel class]]) {
            return;
        }
        
        if (message.messageDirection != MessageDirection_RECEIVE) {
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 发礼物用户userID
            NSString *sendedUserID = message.targetId;
            
            NSDictionary *userInfo = [self fetchUserInfo];
            
            // 获取用户
            [self fetchCurrentSendedGifyUser:sendedUserID
                                    userInfo:userInfo
                             completeHandler:^(NSMutableDictionary *sendedUserInfo, NSInteger sendedUserIndex) {
                if (sendedUserInfo) {
                    [self addGiftMessage:message
                            userID:[ZZUserHelper shareInstance].loginer.uid
                          userInfo:userInfo.mutableCopy
                      sendedUserID:sendedUserID
                    sendedUserInfo:sendedUserInfo.mutableCopy
                sendedUserIndex:sendedUserIndex completion:completion];
                }
            }];
        });
    });
}

+ (void)addGiftMessage:(RCMessage *)message
                userID:(NSString *)userID
              userInfo:(NSMutableDictionary *)userInfo
          sendedUserID:(NSString *)sendedUserID
        sendedUserInfo:(NSMutableDictionary *)sendeduserInfo
       sendedUserIndex:(NSInteger)sendedUserIndex completion:(void(^)(BOOL isComplete))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZZChatGiftModel *giftMessage = (ZZChatGiftModel *)message.content;
        
        // 保存最后一条的ID
        sendeduserInfo[@"latestMessageID"] = @(message.messageId);
        
        // 是否存在礼物
        sendeduserInfo[@"didHaveGift"] = @(YES);
        
        // 礼物动画列表
        NSMutableArray *giftsArr = [sendeduserInfo[@"animationsArr"] mutableCopy];
        if (!giftsArr) {
            if (!isNullString(giftMessage.lottie) && !isNullString(giftMessage.icon)) {
                NSDictionary *infoDic = @{
                    @"icon" : giftMessage.icon,
                    @"lottie" : giftMessage.lottie,
                };
                sendeduserInfo[@"animationsArr"] = @[infoDic];
            }
        }
        else {
            if (!isNullString(giftMessage.lottie) && !isNullString(giftMessage.icon)) {
                NSDictionary *infoDic = @{
                    @"icon" : giftMessage.icon,
                    @"lottie" : giftMessage.lottie,
                };
                [giftsArr addObject:infoDic];
                sendeduserInfo[@"animationsArr"] = giftsArr.copy;
            }
        }
        
        NSMutableArray *sendGiftUsersArr = [userInfo[@"SendedGifts"] mutableCopy];
        if (!sendGiftUsersArr || sendGiftUsersArr.count == 0) {
            sendGiftUsersArr = @[sendeduserInfo].mutableCopy;
        }
        else {
            if (sendedUserIndex == -1 || sendGiftUsersArr.count < sendedUserIndex) {
                [sendGiftUsersArr addObject:sendeduserInfo.copy];
            }
            else {
                sendGiftUsersArr[sendedUserIndex] = sendeduserInfo.copy;
            }
        }
        
        userInfo[@"SendedGifts"] = sendGiftUsersArr.copy;
        
        NSMutableDictionary *messageListInfo = [[self getUserInfoDict] mutableCopy];
        NSDictionary *aDit = [messageListInfo objectForKey:sendedUserID];
        ZZUserInfoModel *model = [[ZZUserInfoModel alloc] initWithDictionary:aDit error:nil];
        if (!aDit || !model) {
            model = [[ZZUserInfoModel alloc] initWithDictionary:sendeduserInfo error:nil];
        }
        model.animationsArr = nil;
        
        NSMutableArray *users = model.animationUsersArr.mutableCopy;
        if (!users || users.count == 0) {
            users = @[[ZZUserHelper shareInstance].loginer.uid].mutableCopy;
        }
        else {
            if (![users containsObject:[ZZUserHelper shareInstance].loginer.uid]) {
                [users addObject:[ZZUserHelper shareInstance].loginer.uid];
            }
            
        }
        model.animationUsersArr = users.copy;
        NSDictionary *saveDic = [model toDictionary];
        
        if (!messageListInfo) {
            messageListInfo = @{}.mutableCopy;
        }
        [messageListInfo setObject:saveDic forKey:sendedUserID];
        [self saveUserInfoDict:messageListInfo.copy];
        
        if (completion) {
            completion(YES);
        }
        
        // 保存数据到数据库
        [self saveChatGiftUserInfo:userInfo.copy];
    });
}


/*
 进入聊天删除所有的礼物数据
 */
+ (void)clearUserMessageDataWith:(NSString *)userID {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 保存的用户信息
        NSMutableDictionary *userInfo = [[self fetchUserInfo] mutableCopy];

        NSArray *giftsArr = userInfo[@"SendedGifts"];
        if (!giftsArr || giftsArr.count == 0) {
            return;
        }
        
        __block BOOL didhaveUser = NO;
        __block NSDictionary *sendedUserInfo = nil;
        __block NSInteger sendedUserIndex = -1;
        [giftsArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"uid"] isEqualToString:userID]) {
                sendedUserInfo = obj;
                didhaveUser = YES;
                *stop = YES;
                sendedUserIndex = idx;
            }
        }];
        
        if (!didhaveUser || sendedUserIndex == -1 || sendedUserIndex >= giftsArr.count) {
            return ;
        }
        
        NSMutableArray *sendGiftsUsers = giftsArr.mutableCopy;
        [sendGiftsUsers removeObjectAtIndex:sendedUserIndex];
        
        userInfo[@"SendedGifts"] = sendGiftsUsers.copy;
        
        NSMutableDictionary *messageListInfo = [[self getUserInfoDict] mutableCopy];
        NSDictionary *aDit = [messageListInfo objectForKey:userID];
        ZZUserInfoModel *model = [[ZZUserInfoModel alloc] initWithDictionary:aDit error:nil];
        if (!aDit || !model) {
            return;
        }
        
        NSMutableArray *users = model.animationUsersArr.mutableCopy;
        if (users.count > 0 && [users containsObject:[ZZUserHelper shareInstance].loginer.uid]) {
            [users removeObject:[ZZUserHelper shareInstance].loginer.uid];
            
            model.animationUsersArr = users.copy;
            NSDictionary *saveDic = [model toDictionary];
            
            if (!messageListInfo) {
                messageListInfo = @{}.mutableCopy;
            }
            [messageListInfo setObject:saveDic forKey:userID];
            [self saveUserInfoDict:messageListInfo.copy];
        }
        
        // 保存数据到数据库
        [self saveChatGiftUserInfo:userInfo.copy];
        
    });
}

+ (void)fetchUserMiniDataWith:(NSString *)userID completion:(void(^)(NSMutableDictionary *sendedUserInfo))completion {
    [ZZUserHelper getMiniUserInfo:userID next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data && ([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSMutableDictionary class]])) {
            if (completion) {
                completion([data mutableCopy]);
            }
        }
    }];
}

@end


@implementation ZZPrivateChatGiftView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}

@end
