//
//  ZZUserHelper.m
//  zuwome
//
//  Created by wlsy on 16/1/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUser.h"
#import "ZZUserHelper.h"
#import "ZZUserDefaultsHelper.h"
#import <CoreLocation/CoreLocation.h>
#import "MiPushSDK.h"
#import "JZLocationConverter.h"
#import "ZZActivityUrlNetManager.h"//活动的H5
 
@interface ZZUserHelper()
@end

@implementation ZZUserHelper
+ (ZZUserHelper *)shareInstance {
    dispatch_once(&ZZUserhelperOnce, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    _chatUid = nil;
    _banStatusReasons = nil;
}

/**
 * MARK: 加载过sayHi数据
 * targetId  :当前的对话人的id
 */
- (NSString *)loadSayHiMessageDataWithtargetId:(NSString *)targetId {
    NSString *name = [NSString stringWithFormat:@"%@With%@sayHi",self.loginer.uid,targetId];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

/**
 * MARK: 保存加载过的sayHi数据
 */
- (void)saveSayHiMessageListDataWithtargetId:(NSString *)targetId {
    NSString *key = [NSString stringWithFormat:@"%@With%@sayHi",self.loginer.uid,targetId];
    [ZZUserDefaultsHelper setObject:key forDestKey:key];
}

/**
 *  MARK: 是否是达人
 *  已经上架并且没有隐身
 */
- (BOOL)isStar {
    if ([ZZUserHelper shareInstance].loginer.rent.status == 2 && [ZZUserHelper shareInstance].loginer.rent.show) {
        return YES;
    }
    return NO;
}

/**
 *  MARK: 是否正在出租
 *  进行中的单，并且(已上架 没有隐身状态)
 */
- (BOOL)isOnRenting {
    if ([ZZUserHelper shareInstance].unreadModel.order_ongoing_count != 0 || ([ZZUserHelper shareInstance].loginer.rent.status == 2 && [ZZUserHelper shareInstance].loginer.rent.show)) {
        return YES;
    }
    return NO;
}

- (BOOL)isOnRenting:(NavigationType)type
             action:(void (^)(BOOL success, NavigationType type, BOOL isCancel))action {
    NSString *message = nil;
    
    if ([self isOnRenting]) {
        if (type == NavigationTypeUserInfo) {
            message = @"您已发布出租信息头像位置必须是本人正脸五官清晰照片";
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更换失败" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"重新上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:doneAction];
        
        UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        if ([rootVC presentedViewController] != nil) {
            rootVC = [UIAlertController findAppreciatedRootVC];
        }
        [rootVC presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

/**
 *  MARK: 是否可以出租
 */
- (BOOL)canRent {
    BOOL canRent = YES;
    canRent = [self canProceedFollowingAction:NavigationTypeRent block:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
        
    }];
    
    if (!canRent) {
        return canRent;
    }
    
    if (self.configModel.open_rent_need_pay_module) {
        
        if (self.loginer.gender == 2) {
            
        }
        else if (_loginer.rent_need_pay) {
            
        }
        
        return NO;
    }
    
    
    
    return YES;
}

/**
 * MARK: 是否可以申请达人
 * 检查循序:
 *  一、是否有活体。
 *  二、是否有真实头像
 *      1.系统配置。
 *      2.是否拥有真实头像。
 *      3.头像审核中，是否有旧的可用头像。
 */
- (BOOL)canApplyTalentWithBlock:(void (^)(BOOL success, NSInteger infoIncompleteType, BOOL isCancel))block {
    if (![self didHaveRealFace]) {
        [self cantProceedAction:0
                          title:@"目前账户安全级别较低，将进行身份识别，否则无法发布出租信息"
                        message:nil
                           done:@"前往"
                    cancelTitle:@"取消"
                          block:block];
        return NO;
    }
    else {
        if ([self didHaveRealAvatar]) {
            if (block) {
                block(YES, 1, NO);
            }
            return YES;
        }
        else {
            if (![self.configModel canProceedWithoutRealAvatar:NavigationTypeApplyTalent]) {
                
                // 人工审核失败
                if (self.loginer.avatar_manual_status == 3) {
                    [self cantProceedAction:1
                                      title:@"您需要使用本人正脸五官清晰照，才能获取达人资格，请前往上传真实头像"
                                    message:nil
                                       done:@"前往"
                                cancelTitle:@"取消"
                                      block:block];
                    return NO;
                }
                else if (![self didHaveRealAvatar] && ![self isAvatarManualReviewing]) {
                    [self cantProceedAction:1
                                      title:@"您未上传本人正脸五官清晰照，无法发布出租信息，请前往上传真实头像"
                                    message:nil
                                       done:@"前往"
                                cancelTitle:@"取消"
                                      block:block];
                    return NO;
                }
            }
            
            if (block) {
                block(YES, 1, NO);
            }
            return YES;
        }
    }
}

/**
 * MARK: 是否可以实名认证
 */
- (BOOL)canVerifyRealNameWithBlock:(void (^)(BOOL success, NSInteger infoIncompleteType, BOOL isCancel))block {
    // 是否有活体
    if (![self didHaveRealFace]) {
        [self cantProceedAction:0
                          title:@"目前账户安全级别较低，将进行身份识别，否则无法发布出租信息"
                        message:nil
                           done:@"前往"
                    cancelTitle:@"取消"
                          block:block];
        return NO;
    }
    else {
        if (![self.configModel canProceedWithoutRealAvatar:NavigationTypeRealName]) {
            [self cantProceedAction:1
                              title:@"您未上传本人正脸五官清晰照，不能实名认证，请前往上传真实头像"
                            message:nil
                               done:@"前往"
                        cancelTitle:@"取消"
                              block:block];
            return NO;
        }
        else {
            if (block) {
                block(YES, 1, NO);
            }
            return YES;
        }
    }
}

/**
 * MARK: 是否可以开通闪聊
 * 1.非真实头像，并且没有在审核中的头像，不能开通。
 * 2.头像人工审核中，并且已经录制了达人视频或者已经录制了达人视频。
 */
- (BOOL)canOpenQuickChat {
    if (![self didHaveRealAvatar] && ![self isAvatarManualReviewing]) {
        return NO;
    }
    
    if ([self isAvatarManualReviewing]) {
        if (_loginer.base_video.status != 1) {
            return NO;
        }
    }
    return YES;
}

/**
 * MARK: 是否可以开通闪聊
 * 1.非真实头像，并且没有在审核中的头像，不能开通。
 * 2.头像人工审核中，并且已经录制了达人视频或者已经录制了达人视频。
 * 错误4: 没有达人视频
 */
- (BOOL)canOpenQuickChatWithBlock:(void (^)(BOOL, NSInteger, BOOL))block {
    if (![self didHaveRealAvatar] && ![self isAvatarManualReviewing]) {
        [self cantProceedAction:2
                          title:@"温馨提示"
                        message:@"头像未使用本人正脸五官清晰的照片，将会导致头像无法完整展现"
                           done:@"重新上传"
                    cancelTitle:nil
                          block:block];
        return NO;
    }
    
    if ([self isAvatarManualReviewing]) {
        if (self.loginer.base_video.status != 1) {
            [self cantProceedAction:4
                              title:@"温馨提示"
                            message:@"您还为上传达人视频，无法开通闪聊"
                               done:@"去上传"
                        cancelTitle:@"取消"
                              block:block];
            return NO;
        }
    }
    return YES;
}

#pragma mark - User Info
/**
 *  MARK: 保存用户信息
 */
- (BOOL)canSaveWithPhoto:(ZZPhoto *)photo
            navigateType:(NavigationType)type
                   block:(void (^)(BOOL success, NSInteger infoIncompleteType, BOOL isCancel))block {
    
    // 真实头像 1.假如在出租，这必须上传真实头像。 2.如系统配置一定需要真实头像，则必须上传
    if (!(photo && photo.face_detect_status == 3)) {
        
        // 是否正在出租
        BOOL canProceed = [self isOnRenting];
        
        if (canProceed) {
            [ZZInfoToastView showWithType:ToastRealAvatarFail action:^(NSInteger actionIndex, ToastType type) {
                if (block) {
                    block(NO, 3, actionIndex == 1 ? NO : YES);
                }
            }];
            return NO;
        }
        
        // 是否一定要有真实头像
        canProceed = [self.configModel canProceedWithoutRealAvatar:type];
        if (canProceed) {
            [ZZInfoToastView showWithType:ToastRealAvatarNotMatch action:^(NSInteger actionIndex, ToastType type) {
                if (block) {
                    block(NO, 2, actionIndex == 1 ? NO : YES);
                }
            }];
            return NO;
        }
        
        // or
        [self cantProceedAction:1
                          title:@"温馨提示"
                        message:@"头像未使用本人正脸五官清晰的照片，将会导致头像无法完整展现且部分功能受到限制如下:\n* 无法设置微信号码\n* 无法向陌生人发起聊天\n* 无法下单、发布出租信息赚取收益"
                           done:@"重新上传"
                    cancelTitle:nil
                          block:block];
        return NO;
    }
    return YES;
}

/**
 *  MARK: 判断身份信息是否完整，是否可以继续接下去的action
 */
- (BOOL)canProceedFollowingAction:(NavigationType)type
                            block:(void (^)(BOOL, NSInteger, BOOL))block {
    
    // 活体
    if (![self didHaveRealFace:type action:block]) {
        return NO;
    }
    
    // 真实头像
    if (![self didHaveRealAvatar:type action:block]) {
        return NO;
    }
    
    return YES;
}

#pragma mark 活体
/**
 *  MARK: 是否拥有活体
 */
- (BOOL)didHaveRealFace {
    // 活体
    if (self.loginer.faces.count != 0) {
        return YES;
    }
    return NO;
}

/**
 *  MARK: 活体
 */
- (BOOL)didHaveRealFace:(NavigationType)type
                 action:(void (^)(BOOL, NSInteger, BOOL))action {
    NSString *title = nil, *message = nil, *doneTitle = @"前往", *cancelTitle = @"取消";
    // 活体
    if (![self didHaveRealFace] && ![self.configModel canProceedWithoutRealFace:type]) {
        if (type == NavigationTypeUserInfo) {
            title = @"温馨提示";
            message = @"跳过身份识别后账户安全级别较低，将会导致头像无法完全展现且部分功能受到限制如下:\n* 无法设置微信号码\n* 无法向陌生人发起聊天\n* 无法下单、发布出租信息赚取收益";
            doneTitle = @"前往识别";
            cancelTitle = @"继续保存";
        }
        else if (type == NavigationTypeSelfIntroduce) {
            message = @"目前账户安全级别较低，将进行身份识别，否则不能发布达人介绍视频";
        }
        else if (type == NavigationTypeApplyTalent) {
            message = @"目前账户安全级别较低，将进行身份识别，否则无法发布出租信息";
        }
        else if (type == NavigationTypeWeChat) {
            message = @"目前账户安全级别较低，将进行身份识别，否则无法设置微信号";
        }
        else if (type == NavigationTypeRealName) {
            message = @"目前账户安全级别较低，将进行身份识别，否则无法实名认证";
        }
        else if (type == NavigationTypeFastChat) {
            message = @"目前账户安全级别较低，将进行身份识别，否则不能申请开通";
        }
        else if (type == NavigationTypeIDPhoto) {
            message = @"您未上传本人正脸五官清晰照，无法上传证件照，请先设置真实头像";
        }
        [self cantProceedAction:0
                          title:title
                        message:message
                           done:doneTitle
                    cancelTitle:cancelTitle
                          block:action];
        return NO;
    }
    return YES;
}

#pragma mark 真实头像
/**
 *  MARK: 是否拥有真实头像
 */
- (BOOL)didHaveRealAvatar {
    ZZPhoto *photo = self.loginer.photos_origin.firstObject;
    if (photo && photo.face_detect_status == 3) {
        return YES;
    }
    return NO;
}

- (bool)isMale {
    return self.loginer.gender == 1;
}

- (bool)shouldCheckFaceWhenSignin {
    return ![self isMale];
}

/**
 *  MARK: 不需要真实头像的操作
 */
- (BOOL)canProceedWithoutRealAvatar:(NavigationType)type {
    // 申请达人、 证件照、 微信不需要
    if (type == NavigationTypeIDPhoto || type == NavigationTypeWeChat) {
        return YES;
    }
    
    // 申请达人 1.已有真实头像: YES 2.
    if (type == NavigationTypeApplyTalent) {
        
        if ([self isAvatarManualReviewing]) {
            
        }
    }
    return NO;
}

/**
 *  MARK: 真实头像: 是否有真实头像
 */
- (BOOL)didHaveRealAvatar:(NavigationType)type
                   action:(void (^)(BOOL, NSInteger, BOOL))action {
    NSString *title = nil, *message = nil, *doneTitle = @"前往", *cancelTitle = @"取消";
    // 真实头像
    if ([self.configModel canProceedWithoutRealAvatar:type]) {
        return YES;
    }
    else {
        if (![self didHaveRealAvatar] && ![self canProceedWithoutRealAvatar:type]) {
            if (type == NavigationTypeSelfIntroduce) {
                message = @"您未上传本人正脸五官清晰照，不能上传达人视频，请前往进行上传真实头像";
            }
            else if (type == NavigationTypeApplyTalent) {
                message = @"您未上传本人正脸五官清晰照，无法发布出租信息，请前往上传真实头像";
            }
            else if (type == NavigationTypeWeChat) {
                message = @"您未上传本人正脸五官清晰照，无法设置微信号，请前往上传真实头像";
            }
            else if (type == NavigationTypeRealName) {
                message = @"您未上传本人正脸五官清晰照，不能实名认证，请前往上传真实头像";
            }
            else if (type == NavigationTypeFastChat) {
                message = @"你未上传本人正脸五官清晰照，不能申请开通，请前往进行上传真实头像";
            }
            else if (type == NavigationTypeSignUpForTask) {
                message = @"您未上传本人正脸五官清晰照，暂不可报名";
            }
            [self cantProceedAction:1
                              title:title
                            message:message
                               done:doneTitle
                        cancelTitle:cancelTitle
                              block:action];
            return NO;
        }
    }
    return YES;
}

/**
 *  MARK: 旧的可用头像: 是否有旧的可用头像
 */
- (BOOL)didHaveOldAvatar {
    return self.loginer.old_avatar.length > 0;
}

/**
 *  MARK: 头像是否在审核中
 */
- (BOOL)isAvatarManualReviewing {
    return self.loginer.avatar_manual_status == 1;
}

/**
 *  MARK: 用户头像是否在审核中
 */
- (BOOL)isUsersAvatarManuallReviewing:(ZZUser *)user {
    return user.avatar_manual_status == 1;
}

/**
 *  MARK: 头像审核中，是否可以显示旧头像。
 */
- (BOOL)canShowOldAvatarWhileIsManualReviewing {
    if ([self isAvatarManualReviewing] && _loginer.old_avatar.length > 0) {
        return YES;
    }
    return NO;
}

/**
 *  MARK: 用户头像审核中，是否可以显示旧头像
 */
- (BOOL)canShowUserOldAvatarWhileIsManualReviewingg:(ZZUser *)user {
    if ([self isUsersAvatarManuallReviewing:user] && user.old_avatar.length > 0) {
        return YES;
    }
    return NO;
}

/**
 *  MARK: 身份信息不完整不能继续的action
 */
- (void)cantProceedAction:(NSInteger)incompleteType
                    title:(NSString *)title
                  message:(NSString *)message
                     done:(NSString *)doneTitle
              cancelTitle:(NSString *)cancelTitle
                    block:(void (^)(BOOL success, NavigationType type, BOOL isCancel))block {
    [UIAlertController presentAlertControllerWithTitle:title
                                               message:message
                                             doneTitle:doneTitle
                                           cancelTitle:cancelTitle
                                         completeBlock:^(BOOL isCancelled) {
        if (block) {
            block(NO, incompleteType, isCancelled);
        }
    }];
}

#pragma mark - Login / Logout / change
/**
 *  MARK: 保存登录用户
 */
- (void)saveLoginer:(ZZUser *)user postNotif:(BOOL)post {
//    NSDictionary *userDic1 = [user yy_modelToJSONObject];
    NSDictionary *userDic = [user toDictionary];
    [UIApplication setObject:userDic forKey:@"loginer"];
    if (post) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginerDidSaveNotification" object:self];
    }
    if (user) {
        [MiPushSDK setAlias:[ZZUserHelper shareInstance].loginer.uid];
    }
}

/**
 * MARK: 当更改账户的时候释放
 */
+ (void)releaseCurrentWhenChangeAccount {
    //用户自己的单利模式
    ZZUserhelperOnce = 0;
    _sharedObject = nil;
    //h5活动的单利模式
    ActivityUrlNetManagerOnce = 0 ;
    ActivityUrlNetManagerShareInstace = nil;
}

/**
 *  MARK: 清除当前登录用户, 用在退出登录
 */
- (void)clearLoginer {
    NSString *name = [NSString stringWithFormat:@"OAuth"];
    [ZZUserDefaultsHelper setObject:nil forDestKey:name];
    [ZZUserDefaultsHelper setObject:nil forDestKey:@"IMToken"];
    [ZZUserDefaultsHelper setObject:nil forDestKey:@"UserVideoNotIntersted"];
    [ZZUserDefaultsHelper setObject:nil forDestKey:@"BannedVideoPeople"];
//    [ZZUserDefaultsHelper setObject:nil forDestKey:@"loginer"];
    [ZZUserDefaultsHelper setObject:nil forDestKey:@"myTasksInfo"];
    
    // 女性显示是否隐藏提醒去解除隐身的
    [ZZUserDefaultsHelper setObject:nil forDestKey:@"LastShowNotHideViewDay"];
    
    [ZZKeyValueStore saveValue:@{} key:[ZZStoreKey sharedInstance].publicTask];
}

#pragma mark - Request
/**
 *  MARK: 获取用户信息
 */
+ (void)fetchUserInfoWithNext:(void (^)(ZZError *, id))next {
    [ZZUser loadUser:[ZZUserHelper shareInstance].loginerId param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (next) {
                next(error, nil);
            }
            return ;
        }
        ZZUser *user = [ZZUser yy_modelWithJSON:data];
        [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
        if (next) {
            next(error, user);
        }
    }];
}

/**
 *  MARK: 获取用户较少的数据
 */
+ (void)getUserMiniInfo:(NSString *)uid next:(requestCallback)next {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/mini", uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

/**
 *  MARK: 获取用户较少的数据？？？？？？？
 */
+ (void)getMiniUserInfo:(NSString *)uid next:(requestCallback)next {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/mini2?aa=%@", uid,[ZZUserHelper shareInstance].oAuthToken] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

/**
 *  MARK: 获取用户首都？？？？？？？？？？？？
 */
+ (void)loadUserCapital:(requestCallback)next {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/capital"] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

/**
 *  MARK: 更新用户微博信息
 */
- (void)updateUserWeiboWithParam:(NSDictionary *)param next:(requestCallback)next {
    NSMutableDictionary *mutableParam = param.mutableCopy;
    if (mutableParam[@"nickname_status"]) {
        [mutableParam removeObjectForKey:@"nickname_status"];
    }
    if (mutableParam[@"bio_status"]) {
        [mutableParam removeObjectForKey:@"bio_status"];
    }
    [ZZRequest method:@"POST" path:@"/api/user2" params:mutableParam next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

/**
 *  MARK: 更新Token
 */
- (void)updateDevice:(NSString *)token callback:(requestCallback)callback {
    NSString *uid = self.loginerId;
    NSString *deviceToken =  [UIApplication objectForKey:[NSString stringWithFormat:@"%@_DeviceToken", uid]];
    
    if ((!deviceToken && token) || (token && ![deviceToken isEqualToString:token])) {
        [ZZRequest method:@"POST" path:@"/api/user" params:@{@"deviceToken": token}  next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (!error && data) {
                NSLog(@"保存 device token 到本地")
                [UIApplication setObject:token forKey:[NSString stringWithFormat:@"%@_DeviceToken", uid]];
            }
        }];
    } else {
        NSLog(@"无需保存 device token")
    }
}

/**
 *  MARK: 余额记录（分页）
 */
+ (void)getUserBalanceRecordWithParam:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/capital2"] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

/**
 *  MARK: 提现记录 (分页)
 */
+ (void)getUserCashRecordWithParam:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/transfer"] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

/**
 *  MARK: 充值记录 (分页)
 */
+ (void)getUserRechargeRecordWithParam:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/recharge"] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

/*
 * MARK: 更新用户经纬度
 */
- (void)updateUserLocationWithLocation:(CLLocation *)location {
    if (location) {
        CLLocationCoordinate2D coordinate = [JZLocationConverter wgs84ToGcj02:location.coordinate];
        
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"lat"] = @(coordinate.latitude);
        params[@"lng"] = @(coordinate.longitude);
        params[@"uuid"] = [ZZUUIDManager getUUID];
        
        // 保存一下旧的城市
        self.oldCityName = self.loginer.current_city_name;
        [ZZRequest method:@"POST" path:@"/api/user2" params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (!error && data) {
                ZZUser *user = [ZZUser yy_modelWithJSON:data];
                [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
            }
        }];
    }
}

/**
 * MARK: 检测文本是否违规
 * type: 1个人签名 2昵称 3公开么么答 4私信么么答 5技能介绍
 */
+ (void)checkTextWithText:(NSString *)text
                     type:(NSInteger)type
                     next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/system/text_detect" params:@{@"content":text,@"type":[NSNumber numberWithInteger:type]} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

/**
 * MARK: 上传错误log
 */
+ (void)uploadLogWithParam:(NSDictionary *)param
                      next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/system/app_log" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

/**
 * MARK: 更新余额 不含么币 ,只是钱包
 */
+ (void)updateTheBalanceNext:(requestCallback)next {
    [[ZZUserHelper shareInstance].loginer getBalance:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZHUD dismiss];
        if (next) {
            next(error, data, task);
        }
        if (error == NULL) {
            //更新余额
            ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
            if (data[@"balance"] != NULL && [data[@"balance"] isKindOfClass:[NSNumber class]]) {
                loginer.balance = data[@"balance"];
            }
            [[ZZUserHelper shareInstance] saveLoginer:loginer postNotif:NO];
        }
        else {
            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
}

/**
 * MARK: 请求么币和余额,并且更新
 */
+ (void)requestMeBiAndMoneynext:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/api/user/mcoin" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showTastInfoErrorWithString:error.message];
        } else {
            [ZZHUD dismiss];
            ZZUser *user = [ZZUserHelper shareInstance].loginer;
            NSLog(@"之前有的么币: %d", [user.mcoin intValue]);
            
            NSNumber *balance = [NSNumber numberWithDouble:[data[@"balance"] doubleValue]];
            NSNumber *mcoin = [NSNumber numberWithInteger:[data[@"mcoin_total"] integerValue]];
            user.balance = balance;
            user.mcoin = mcoin;
            NSLog(@"之后的么币: %d", [user.mcoin intValue]);
            
            [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
        }
        if (next) {
            next(error,data,task);
        }
    }];
}

#pragma mark - Setter&Getter
- (BOOL)isLogin {
    return self.oAuthToken ? YES : NO;
}

- (ZZUser *)loginer {
    NSDictionary *user =  [UIApplication objectForKey:@"loginer"];
    ZZUser *uu = [ZZUser yy_modelWithJSON:user];
    return uu;
}

- (NSString *)loginerId {
    return self.loginer.uid;
}

- (NSString *)oAuthToken {
    NSString *name = [NSString stringWithFormat:@"OAuth"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setOAuthToken:(NSString *)oAuthToken {
    NSLog(@"saveoAuthToken ====   %@",oAuthToken);
    NSString *name = [NSString stringWithFormat:@"OAuth"];
    [ZZUserDefaultsHelper setObject:oAuthToken forDestKey:name];
}

- (NSString *)uploadToken {
    NSString *name = [NSString stringWithFormat:@"UploadToken"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setUploadToken:(NSString *)uploadToken {
    NSString *name = [NSString stringWithFormat:@"UploadToken"];
    [ZZUserDefaultsHelper setObject:uploadToken forDestKey:name];
}

- (void)setIMToken:(NSString *)IMToken {
    NSString *name = [NSString stringWithFormat:@"IMTokenUpdate"];
    [ZZUserDefaultsHelper setObject:IMToken forDestKey:name];
}

- (NSString *)IMToken {
    NSString *name = [NSString stringWithFormat:@"IMTokenUpdate"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setLocationArray:(NSArray *)locationArray {
    NSString *locationArrPath = [NSString stringWithFormat:@"locationuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:locationArray];
    [ZZUserDefaultsHelper setObject:objectData forDestKey:locationArrPath];
}

- (NSArray *)locationArray {
    NSString *locationArrPath = [NSString stringWithFormat:@"locationuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    
    NSData *objectData = [ZZUserDefaultsHelper objectForDestKey:locationArrPath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
}

- (void)setRemarkArray:(NSArray *)remarkArray {
    NSString *locationArrPath = [NSString stringWithFormat:@"remarkuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:remarkArray];
    [ZZUserDefaultsHelper setObject:objectData forDestKey:locationArrPath];
}

- (NSArray *)remarkArray {
    NSString *locationArrPath = [NSString stringWithFormat:@"remarkuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    
    NSData *objectData = [ZZUserDefaultsHelper objectForDestKey:locationArrPath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
}

- (void)setIsFirstRent:(NSString *)isFirstRent {
    NSString *name = [NSString stringWithFormat:@"isFirstRentuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    [ZZUserDefaultsHelper setObject:isFirstRent forDestKey:name];
}

- (NSString *)isFirstRent {
    NSString *name = [NSString stringWithFormat:@"isFirstRentuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setCacheOrder:(ZZCacheOrder *)cacheOrder {
    NSString *name = [NSString stringWithFormat:@"usercacheOrder"];
    NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:cacheOrder];
    [ZZUserDefaultsHelper setObject:objectData forDestKey:name];
}

- (ZZCacheOrder *)cacheOrder {
    NSString *name = [NSString stringWithFormat:@"usercacheOrder"];
    NSData *objectData = [ZZUserDefaultsHelper objectForDestKey:name];
    return [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
}

- (void)setCacheSingingTask:(ZZKTVModel *)cacheSingingTask {
    NSString *name = [NSString stringWithFormat:@"cacheSingingTask"];
    NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:cacheSingingTask];
    [ZZUserDefaultsHelper setObject:objectData forDestKey:name];
}

- (ZZKTVModel *)cacheSingingTask {
    NSString *name = [NSString stringWithFormat:@"cacheSingingTask"];
    NSData *objectData = [ZZUserDefaultsHelper objectForDestKey:name];
    return [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
}

- (void)setRecordConfigModel:(ZZRecordConfigModel *)recordConfigModel {
    NSString *name = [NSString stringWithFormat:@"recordConfigModel"];
    NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:recordConfigModel];
    [ZZUserDefaultsHelper setObject:objectData forDestKey:name];
}

- (ZZRecordConfigModel *)recordConfigModel {
    NSString *name = [NSString stringWithFormat:@"recordConfigModel"];
    NSData *objectData = [ZZUserDefaultsHelper objectForDestKey:name];
    return [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
}

- (void)setCityName:(NSString *)cityName {
    NSString *name = [NSString stringWithFormat:@"cityname"];
    [ZZUserDefaultsHelper setObject:cityName forDestKey:name];
}

- (NSString *)cityName {
    NSString *name = [NSString stringWithFormat:@"cityname"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setUserFirstRent:(NSString *)userFirstRent {
    NSString *name = [NSString stringWithFormat:@"userFirstRentuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    [ZZUserDefaultsHelper setObject:userFirstRent forDestKey:name];
}

- (NSString *)userFirstRent {
    NSString *name = [NSString stringWithFormat:@"userFirstRentuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setUserFirstPersonalLabel:(NSString *)userFirstPersonalLabel {
    NSString *name = [NSString stringWithFormat:@"userFirstPersonalLabeluid=%@",[ZZUserHelper shareInstance].loginer.uid];
    [ZZUserDefaultsHelper setObject:userFirstPersonalLabel forDestKey:name];
}

- (NSString *)userFirstPersonalLabel {
    NSString *name = [NSString stringWithFormat:@"userFirstPersonalLabeluid=%@",[ZZUserHelper shareInstance].loginer.uid];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setUserFirstInterest:(NSString *)userFirstInterest {
    NSString *name = [NSString stringWithFormat:@"userFirstInterestuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    [ZZUserDefaultsHelper setObject:userFirstInterest forDestKey:name];
}

- (NSString *)userFirstInterest {
    NSString *name = [NSString stringWithFormat:@"userFirstInterestuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setUserFirstJob:(NSString *)userFirstJob {
    NSString *name = [NSString stringWithFormat:@"userFirstJobuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    [ZZUserDefaultsHelper setObject:userFirstJob forDestKey:name];
}

- (NSString *)userFirstJob {
    NSString *name = [NSString stringWithFormat:@"userFirstJobuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setUserFirstWB:(NSString *)userFirstWB {
    NSString *name = [NSString stringWithFormat:@"userFirstWBuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    [ZZUserDefaultsHelper setObject:userFirstWB forDestKey:name];
}

- (NSString *)userFirstWB {
    NSString *name = [NSString stringWithFormat:@"userFirstWBuid=%@",[ZZUserHelper shareInstance].loginer.uid];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setAllow3GPlay:(NSString *)allow3GPlay {
    NSString *name = [NSString stringWithFormat:@"allow3GPlay"];
    [ZZUserDefaultsHelper setObject:allow3GPlay forDestKey:name];
}

- (NSString *)allow3GPlay {
    NSString *name = [NSString stringWithFormat:@"allow3GPlay"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setAllow3GUpload:(NSString *)allow3GUpload {
    NSString *name = [NSString stringWithFormat:@"allow3GUpload"];
    [ZZUserDefaultsHelper setObject:allow3GUpload forDestKey:name];
}

- (NSString *)allow3GUpload {
    NSString *name = [NSString stringWithFormat:@"allow3GUpload"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setFirstRentPage:(NSString *)firstRentPage {
    NSString *name = [NSString stringWithFormat:@"firstRentPage"];
    [ZZUserDefaultsHelper setObject:firstRentPage forDestKey:name];
}

- (NSString *)firstRentPage {
    NSString *name = [NSString stringWithFormat:@"firstRentPage"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setFirstOrderDetailPage:(NSString *)firstOrderDetailPage {
    NSString *name = [NSString stringWithFormat:@"firstOrderDetailPage"];
    [ZZUserDefaultsHelper setObject:firstOrderDetailPage forDestKey:name];
}

- (NSString *)firstOrderDetailPage {
    NSString *name = [NSString stringWithFormat:@"firstOrderDetailPage"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setLastPacketMoney:(NSString *)lastPacketMoney {
    NSString *name = [NSString stringWithFormat:@"lastPacketMoney"];
    [ZZUserDefaultsHelper setObject:lastPacketMoney forDestKey:name];
}

- (NSString *)lastPacketMoney {
    NSString *name = [NSString stringWithFormat:@"lastPacketMoney"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setLastPayMethod:(NSString *)lastPayMethod {
    NSString *name = [NSString stringWithFormat:@"lastPayMethod"];
    [ZZUserDefaultsHelper setObject:lastPayMethod forDestKey:name];
}

- (NSString *)lastPayMethod {
    NSString *name = [NSString stringWithFormat:@"lastPayMethod"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setLastAskMoney:(NSString *)lastAskMoney {
    NSString *name = [NSString stringWithFormat:@"lastAskMoney"];
    [ZZUserDefaultsHelper setObject:lastAskMoney forDestKey:name];
}

- (NSString *)lastAskMoney {
    NSString *name = [NSString stringWithFormat:@"lastAskMoney"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setLastAskType:(NSString *)lastAskType {
    NSString *name = [NSString stringWithFormat:@"lastAskType"];
    [ZZUserDefaultsHelper setObject:lastAskType forDestKey:name];
}

- (NSString *)lastAskType {
    NSString *name = [NSString stringWithFormat:@"lastAskType"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

/**
 *  MARK: 是否第一次发布私聊付费的消息
 */
+ (NSString *)firstSendPrivChatMessage{
    NSString *name = [NSString stringWithFormat:@"firstSendPrivChatMessage"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

/**
 *  MARK: 设置第一次发布私聊付费的消息
 */
+ (void)setFirstSendPrivChatMessage {
    NSString *name = [NSString stringWithFormat:@"firstSendPrivChatMessage"];
    [ZZUserDefaultsHelper setObject:name forDestKey:name];
}

- (void)setFirstAnonymousAskInfo:(NSString *)firstAnonymousAskInfo {
    NSString *name = [NSString stringWithFormat:@"firstAnonymousAskInfo"];
    [ZZUserDefaultsHelper setObject:firstAnonymousAskInfo forDestKey:name];
}

- (NSString *)firstAnonymousAskInfo {
    NSString *name = [NSString stringWithFormat:@"firstAnonymousAskInfo"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setFirstAskMemeda:(NSString *)firstAskMemeda {
    NSString *name = [NSString stringWithFormat:@"firstAskMemeda"];
    [ZZUserDefaultsHelper setObject:firstAskMemeda forDestKey:name];
}

- (NSString *)firstAskMemeda {
    NSString *name = [NSString stringWithFormat:@"firstAskMemeda"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setFirstHomeGuide:(NSString *)firstHomeGuide {
    NSString *name = [NSString stringWithFormat:@"firstHomeGuide"];
    [ZZUserDefaultsHelper setObject:firstHomeGuide forDestKey:name];
}

- (NSString *)firstHomeGuide {
    NSString *name = [NSString stringWithFormat:@"firstHomeGuide"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setFirstInstallAPP:(NSString *)firstInstallAPP {
    NSString *name = [NSString stringWithFormat:@"firstInstallAPP"];
    [ZZUserDefaultsHelper setObject:firstInstallAPP forDestKey:name];
}

- (NSString *)firstInstallAPP {
    NSString *name = [NSString stringWithFormat:@"firstInstallAPP"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setFirstRecordVideo:(NSString *)firstRecordVideo {
    NSString *name = [NSString stringWithFormat:@"firstRecordVideo"];
    [ZZUserDefaultsHelper setObject:firstRecordVideo forDestKey:name];
}

- (NSString *)firstRecordVideo {
    NSString *name = [NSString stringWithFormat:@"firstRecordVideo"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setLastFilterSexValue:(NSString *)lastFilterSexValue {
    NSString *name = [NSString stringWithFormat:@"lastFilterSexValue"];
    [ZZUserDefaultsHelper setObject:lastFilterSexValue forDestKey:name];
}

- (NSString *)lastFilterSexValue {
    NSString *name = [NSString stringWithFormat:@"lastFilterSexValue"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setUserFansCount:(NSString *)userFansCount {
    NSString *name = [NSString stringWithFormat:@"userFansCount===%@",[ZZUserHelper shareInstance].loginer.uid];
    [ZZUserDefaultsHelper setObject:userFansCount forDestKey:name];
}

- (NSString *)userFansCount {
    NSString *name = [NSString stringWithFormat:@"userFansCount===%@",[ZZUserHelper shareInstance].loginer.uid];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setCountryCode:(NSString *)countryCode {
    NSString *name = [NSString stringWithFormat:@"countryCode"];
    [ZZUserDefaultsHelper setObject:countryCode forDestKey:name];
}

- (NSString *)countryCode {
    NSString *name = [NSString stringWithFormat:@"countryCode"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setLastStickersVersion:(NSString *)lastStickersVersion {
    NSString *name = [NSString stringWithFormat:@"lastStickersVersion"];
    [ZZUserDefaultsHelper setObject:lastStickersVersion forDestKey:name];
}

- (NSString *)lastStickersVersion {
    NSString *name = [NSString stringWithFormat:@"lastStickersVersion"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setLastSKTopicVersion:(NSString *)lastSKTopicVersion {
    NSString *name = [NSString stringWithFormat:@"lastSKTopicVersion"];
    [ZZUserDefaultsHelper setObject:lastSKTopicVersion forDestKey:name];
}

- (NSString *)lastSKTopicVersion {
    NSString *name = [NSString stringWithFormat:@"lastSKTopicVersion"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (void)setHavePlayerDownUpGuide:(NSString *)havePlayerDownUpGuide {
    NSString *name = [NSString stringWithFormat:@"havePlayerDownUpGuide"];
    [ZZUserDefaultsHelper setObject:havePlayerDownUpGuide forDestKey:name];
}

- (NSString *)havePlayerDownUpGuide {
    NSString *name = [NSString stringWithFormat:@"havePlayerDownUpGuide"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (NSMutableArray *)uploadVideoArray {
    if (!_uploadVideoArray) {
        _uploadVideoArray = [NSMutableArray array];
    }
    return _uploadVideoArray;
}
@end
