//
//  ZZUser.m
//  zuwome
//
//  Created by wlsy on 16/1/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUser.h"
#import <Underscore.h>
#import <RongIMLib/RongIMLib.h>
#import "ZZDateHelper.h"
#import "ZZCommossionManager.h"

@implementation ZZStatisDataModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZPrivacyConfig

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZPushConfig

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZMark

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZZmxy

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZWechat

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end

@implementation ZZAppleIDSignIn

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end

@implementation ZZWeibo

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end
@implementation ZZQQ

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end
@implementation ZZAddress

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end
@implementation ZZUserUnread

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZBaseVideo

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZIDPhoto

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@interface ZZUser ()
@property (nonatomic,assign) BOOL isShowQ_Chat_WoMan;
@property (nonatomic,assign) BOOL isHaveCalculate;//是否计算过了,是YES NO没有
@end
@implementation ZZUser

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"mcoin_total":@"mcoin",
        @"new_query_at" : @"returner",
    }];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
                @"mcoin" : @"mcoin_total",
              @"returner" : @"new_query_at",
             };
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _bio_status = -1;
    }
    return self;
}

- (NSArray *)faces {
  // 当安卓没有人脸验证的时候会上传个null的类.faces 这个里面有个值为null 导致苹果客户端崩溃
    NSMutableArray *facesArray = [_faces mutableCopy];
    for (id object in _faces) {
        if (isNull(object)) {
            [facesArray removeObject:object];
        }
    }
    return [facesArray copy];
}
- (NSString *)generation {
    NSInteger year = [self.birthday year];
    int x = year % 10;
    int y = year % 100 /10;
    
    return [NSString stringWithFormat:@"%d%d后",y, x>=5?5:0];
}
- (void)setMcoin:(NSNumber *)mcoin {
    if (_mcoin != mcoin) {
        _mcoin = mcoin;
        if ([mcoin integerValue]>0) {
            NSString *urlKey = [NSString stringWithFormat:@"%@",self.uid];
            NSString *urlValue =  [ZZKeyValueStore  getValueWithKey:urlKey];
            if (isNullString(urlValue)) {
                [ZZKeyValueStore saveValue:urlKey key:urlKey];
            }
        }
    }
}

- (void)setBio_status:(NSInteger)bio_status {
    _bio_status = bio_status;
}

- (void)login:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/user/sign/in" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)resetPassword:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/user/password/reset" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)getIMToken:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/api/user/rong/token" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)logout:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/api/user/logout" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)loginByCode:(NSDictionary *)param next:(requestCallback)next {
   
   NSString * uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSMutableDictionary *newParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [newParam setValue:uuid forKey:@"uuid"];
    
    [ZZRequest method:@"POST" path:@"/user/sign/code" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)updateWithParam:(NSDictionary *)param next:(requestCallback)next {
    NSMutableDictionary *mutableParam = param.mutableCopy;
    if (mutableParam[@"nickname_status"]) {
        [mutableParam removeObjectForKey:@"nickname_status"];
    }
    if (mutableParam[@"bio_status"]) {
        [mutableParam removeObjectForKey:@"bio_status"];
    }
    [ZZRequest method:@"POST" path:@"/api/user2" params:mutableParam.copy next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)updateUserFacesAndManualStatus:(NSDictionary *)param next:(requestCallback)next {
    NSMutableDictionary *mutableParam = param.mutableCopy;
    [ZZRequest method:@"POST" path:@"/api/user3" params:mutableParam.copy next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)updatePhone:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/api/user/phone" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
       if (next) {
            next(error, data, task);
        }
    }];
}

- (void)updateAvatar:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/api/user/avatar/add" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)signUp:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/user/sign/up" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)loginWithWechat:(NSString *)openid token:(NSString *)token next:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary new];
    [d setObject:token forKey:@"access_token"];
    [d setObject:openid forKey:@"openid"];
    
    [ZZRequest method:@"POST" path:@"/user/sign/wechat" params:d next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)loginWithWeibo:(NSString *)uid token:(NSString *)token nick:(NSString *)nick avatar:(NSString *)avatar profileURL:(NSString *)profileURL next:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary new];
    [d setObject:token forKey:@"access_token"];
    [d setObject:uid forKey:@"uid"];
    [d setObject:nick forKey:@"userName"];
    [d setObject:avatar forKey:@"iconURL"];
    [d setObject:profileURL forKey:@"profileURL"];
    
    [ZZRequest method:@"POST" path:@"/user/sign/weibo" params:d next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)loginWithQQ:(NSString *)openid token:(NSString *)token next:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary new];
    [d setObject:token forKey:@"access_token"];
    [d setObject:openid forKey:@"openid"];
    
    [ZZRequest method:@"POST" path:@"/user/sign/qq" params:d next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

+ (void)loadUser:(NSString *)uid param:(NSDictionary *)param next:(requestCallback)next {
    NSString *path = ({
        NSString *s = @"";
        if (uid) {
            s = [NSString stringWithFormat:@"/api/user/%@", uid];
        } else {
            s = [NSString stringWithFormat:@"/api/user"];
        }
        s;
    });
    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
            if (data) {
                // 封禁信息
                [ZZBanedHelper showBan:data];
                
                // 提醒信息
                [[ZZCommossionManager manager] fetchRemindStatusAction:^(NSInteger action) {
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
            }
        }
    }];
}

+ (void)getUserUnread:(requestCallback)next {
    NSString *latestTime = [ZZUserDefaultsHelper objectForDestKey:@"TastLatestRead"];
    if (isNullString(latestTime)) {
        latestTime = @"2000-01-01T00:00:00.000Z";
    }
    NSDictionary *params = @{
                             @"pdLastTime": latestTime,
                             };
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/unread2?aa=%@",[ZZUserHelper shareInstance].oAuthToken] params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)changePassword:(NSString *)password next:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary new];
    [d setObject:self.password forKey:@"op"];
    [d setObject:password forKey:@"np"];
    
    [ZZRequest method:@"POST" path:@"/api/user/password" params:d next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
    
}

+ (void)checkPhoneAndCode:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:@"/user/phone/code/check" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)getGenderAutoWithParam:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/photo/info" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)getRentPayPriceListNext:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/rent_pay_price" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

+ (void)addBlackWithUid:(NSString *)uid next:(requestCallback)next
{
    [MobClick event:Event_click_add_to_blacklist];
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/black/add",uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            if (next) {
                next(error, data, task);
            }
        } else {
            [[RCIMClient sharedRCIMClient] addToBlacklist:uid success:^{
                [ZZHUD showSuccessWithStatus:@"已把TA加入黑名单"];
                if (next) {
                    next(error, data, task);
                }
                NSDictionary *aDict = @{@"uid":uid};
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_AddUserBlack object:nil userInfo:aDict];
            } error:^(RCErrorCode status) {
                [ZZHUD showErrorWithStatus:@"操作失败"];
            }];
        }
    }];
}

+ (void)removeBlackWithUid:(NSString *)uid next:(requestCallback)next
{
    [MobClick event:Event_click_add_to_blacklist];
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/black/remove",uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            if (next) {
                next(error, data, task);
            }
        } else {
            [[RCIMClient sharedRCIMClient] removeFromBlacklist:uid success:^{
                [ZZHUD showSuccessWithStatus:@"已把TA移除黑名单"];
                if (next) {
                    next(error, data, task);
                }
            } error:^(RCErrorCode status) {
                [ZZHUD showErrorWithStatus:@"操作失败"];
            }];
        }
    }];
}

- (void)checkPhotoIsSamePerson:(NSString *)url faces:(NSArray *)faces next:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary new];
    [d setObject:url forKey:@"photoUrl"];
    [d setObject:faces forKey:@"faces"];
    
    [ZZRequest method:@"POST" path:@"/user/check/photo" params:d next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
    
}

- (void)checkPhotoIsSamePersonNeedLogin:(NSString *)photoId
                               photoUrl:(NSString *)url
                                  faces:(NSArray *)faces
                                   next:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary new];
    if (photoId) {
        [d setObject:photoId forKey:@"photoId"];
    }
    if (url) {
        [d setObject:url forKey:@"photoUrl"];
    }
    if (faces) {
        [d setObject:faces forKey:@"faces"];
    }
    
    [ZZRequest method:@"POST" path:@"/api/user/check/photo" params:d next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

+ (void)rent:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:@"/api/rent" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)getComments:(requestCallback)next {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/user/%@/comments", self.uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)getBalance:(requestCallback)next {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/balance"] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (next) {
            next(error, data, task);
        }
    }];
}

- (void)phoneCheck:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/user/phone/check" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)thirdBindWithParam:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/api/user/platform/bind" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)thirdUnbindWithParam:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/api/user/platform/unbind" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)followWithUid:(NSString *)uid next:(requestCallback)next {
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/follow",uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
        if (data) {
            [ZZUserHelper shareInstance].updateAttentList = YES;
        }
    }];
}

- (void)unfollowWithUid:(NSString *)uid next:(requestCallback)next {
    [UIAlertController showOkCancelAlertIn:[UIViewController currentDisplayViewController]
                                     title:@"提示"
                                   message:@"取消关注之后，将无法及时获取TA的动态消息，确定取消关注TA吗？"
                              confirmTitle:@"确定"
                            confirmHandler:^(UIAlertAction * _Nonnull action) {
        [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/unfollow",uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            next(error, data, task);
        }];
    } cancelTitle:@"取消" cancelHandler:nil];
}

+ (void)getUnloginUserDetailWithUid:(NSString *)uid dic:(NSDictionary *)dic next:(requestCallback)next {
    NSMutableDictionary *param = [dic mutableCopy];
    if (param == nil) {
        param = [NSMutableDictionary new];
    }
    if ([ZZUserHelper shareInstance].location) {
        CLLocation *location = [ZZUserHelper shareInstance].location;
        // 外部接口扩展，这里需要以增加的方式
        [param setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
        [param setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lng"];
    }
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/user/%@/detail",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (BOOL)showCallQ_Chat {
    if (!self.isHaveCalculate) {
        if (self.push_config.qchat_push&&self.gender==2) {
            //如果用户在闪聊广场,同时为女性用户且时间处于闪聊开放时间段就显示
            NSDateFormatter *dateFormat = [ZZDateHelper shareInstance].formatter;
            [dateFormat setDateFormat:@"HH:mm"];
            NSDate *start = [dateFormat dateFromString:self.push_config.qchat_push_begin_at];
            NSDate *expire = [dateFormat dateFromString:self.push_config.qchat_push_end_at];
            NSDate *today = [NSDate date];
            NSString *todayStr = [dateFormat stringFromDate:today];//将日期转换成字符串
            NSDate *chageToDay = [dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
            if ([expire compare:start] == NSOrderedDescending) {
                //当天
                if (([expire compare:chageToDay]==NSOrderedDescending)&&([start compare:chageToDay]==NSOrderedAscending)) {
                    self.isShowQ_Chat_WoMan = YES;
                    self.isHaveCalculate = YES;
                    return YES;
                }
                self.isShowQ_Chat_WoMan = NO;
                self.isHaveCalculate = YES;
                return NO;
            }else if ([expire compare:start] == NSOrderedAscending) {
                //设置跨天的
                if (([expire compare:chageToDay]==NSOrderedAscending)&&([start compare:chageToDay]==NSOrderedAscending)) {
                    self.isShowQ_Chat_WoMan = YES;
                    self.isHaveCalculate = YES;
                    return YES;
                }
                self.isShowQ_Chat_WoMan = NO;
                self.isHaveCalculate = YES;
                return NO;
                NSLog(@"PY_当前用户的设置时间段为跨天");
                
            }else{
                //表示24小时不间断
                self.isShowQ_Chat_WoMan = YES;
                self.isHaveCalculate = YES;
                return YES;
                NSLog(@"PY_当前用户的设置时间段为全天");
            }
        }
        self.isShowQ_Chat_WoMan = NO;
        self.isHaveCalculate = YES;
        return NO;
    }
    else{
        //已经计算过了
        return self.isShowQ_Chat_WoMan;
    }
}

+ (NSInteger)ageWithBirthday:(NSDate *)birthday  {
    if (!birthday) {
        return 0;
    }
    //日历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags = NSCalendarUnitYear;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:birthday toDate:[NSDate date] options:0];
    
    return [components year];
    
}

+ (void)getManualReviewCount:(void (^)(NSInteger))count {
    [ZZHUD show];
    [ZZRequest method:@"GET" path:@"/api/user/photo/avatar_upload" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error)
            [ZZHUD showTastInfoErrorWithString:error.message];
        else {
            count([data[@"count"] integerValue]);
        }
    }];
}

- (void)didUsersFacePassDetected:(void (^)(BOOL))block {
    ZZPhoto *photo = self.photos_origin.firstObject;
    if (block) {
        block(!(photo == nil || photo.face_detect_status != 3));
    }
}

- (BOOL)isUsersAvatarReal {
    ZZPhoto *photo = self.photos_origin.firstObject;
    return !(photo == nil || photo.face_detect_status != 3);
}

- (BOOL)didIDPhotoPassDetected {
    return (self.have_id_photo && self.id_photo.status == 2);
}

- (void)costMcoin:(NSInteger)mcoin isAdd:(BOOL)isAdd {
    self.mcoin = @(mcoin);
}

#pragma mark - 真实头像
/**
 *  MARK: 是否拥有真实头像
 */
- (BOOL)didHaveRealAvatar {
    ZZPhoto *photo = self.photos_origin.firstObject;
    if (photo && photo.face_detect_status == 3) {
        return YES;
    }
    return NO;
}

#pragma mark - 人工审核头像的
/*
 *  可以显示的头像
 *  如果用户正在审核,并且有可用的旧头像, 就显示旧的头像. 如果没有就显示avatar.(这边东西多逻辑奇怪)
 */
- (NSString *)displayAvatar {
    NSString *pattern = @"\\?imageMogr2/blur/20x20";
    if ([self isAvatarManualReviewing] && [self didHaveOldAvatar]) {
        return self.old_avatar;
    }
    else {
        if ([self.avatar isEqualToString:@"http://img.movtrip.com/user/avatar.png"] || [self.avatar isEqualToString:@"http://img.zuwome.com/?imageMogr2/blur/20x20"] ) {
            if (self.photos.count > 0) {
                ZZPhoto *photo = self.photos[0];
                return photo.url;
            }
            else {
                return @"";
            }
        }
        else {
            return [AvatarHelper RemoveDuplicateWithStr:self.avatar pattern:@"\\?imageMogr2/blur/20x20"];
        }
    }
}

/*
 *  可以显示的头像集合
 */
- (NSArray<ZZPhoto *> *)displayAlbum {
    
    // 旧的需求
    if ([self isAvatarManualReviewing] && [self didHaveOldAvatar]) {
        ZZPhoto *photo = [[ZZPhoto alloc] init];
        photo.url = self.old_avatar;
        return @[photo];
    }
    else if (self.avatar_manual_status == 2) {
        return self.photos;
    }
    else {
        if ([self didHaveOldAvatar]) {
            return self.photos;
        }
        else {
            if (self.photos.count) {
                return @[self.photos.firstObject];
            }
            else {
                ZZPhoto *photo = [[ZZPhoto alloc] init];
                photo.url = self.avatar;
                return @[photo];
            }
        }
    }
}

/*
 *  头像是否在审核中
 */
- (BOOL)isAvatarManualReviewing {
    return self.avatar_manual_status == 1;
}

/*
 *  是否有可用的旧头像
 */
- (BOOL)didHaveOldAvatar {
    return !isNullString(self.old_avatar);
}

/*
 *  是否通过身份认证
 */
- (BOOL)isIdentifierCertified {
    if (self.realname.status == 2) {
        return YES;
    }
    if (self.realname_abroad.status == 2) {
        return YES;
    }
    return NO;
}

/*
 *  是否可以发布活动/通告等等
 */
- (BOOL)canPublish:(TaskType)taskType block:(void (^)(BOOL, ToastType, NSInteger))block {

    if (taskType == TaskNormal) {
        if (block) {
            block(YES, -1, -1);
        }
        return YES;
    }
    else if (taskType == TaskFree) {
        if ([self didHaveRealAvatar] || ([self didHaveOldAvatar] && [self isAvatarManualReviewing])) {
            // 只有上架中的才能发布
            if (self.rent.status == 2 && self.rent.show) {
                if (block) {
                    block(YES, -1, -1);
                }
                return YES;
            }
            else {
                if (!self.rent.show) {
                    // 隐身
                    [ZZInfoToastView showWithType:ToastActivityPublishFailDueToNotShow action:^(NSInteger actionIndex, ToastType type) {
                        if (block) {
                            block(NO, type, actionIndex);
                        }
                    }];
                    return NO;
                }
                else if (self.rent.status == 0) {
                    // 未出租
                    [ZZInfoToastView showWithType:ToastActivityPublishFailDueToNotRent action:^(NSInteger actionIndex, ToastType type) {
                        if (block) {
                            block(NO, type, actionIndex);
                        }
                    }];
                    return NO;
                }
                else if (self.rent.status == 1) {
                    // 待审核
                    [ZZInfoToastView showWithType:ToastActivityPublishFailDueToInReview action:^(NSInteger actionIndex, ToastType type) {
                        if (block) {
                            block(NO, type, actionIndex);
                        }
                    }];
                    return NO;
                }
                else {
                    [ZZHUD showErrorWithStatus:@"你已被系统下架暂不可发布,请联系客服"];
                }
                return NO;
            }
        }
        else {
            if ([UserHelper.loginer isAvatarManualReviewing]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"发布活动需要上传本人正脸五官清晰照您的头像正在人工审核中，请等待审核结果" preferredStyle:UIAlertControllerStyleAlert];
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
                                                           message:@"您未上传本人正脸五官清晰照，暂不可发布活动"
                                                         doneTitle:@"去上传"
                                                       cancelTitle:@"取消"
                                                     completeBlock:^(BOOL isCancelled) {
                                                         if (!isCancelled) {
                                                             if (block) {
                                                                 block(NO, ToastRealAvatarNotFound, 1);
                                                             }
                                                         }
                                                     }];
            }
            return NO;
        }
    }
    else {
        if (block) {
            block(YES, -1, -1);
        }
        return YES;
    }
}

/*
 * 个人资料是不是在审核中
 */
- (BOOL)isInfoReviewing {
    return NO;
}

- (BOOL)isFaceVerified {
    return self.faces.count != 0;
}

/*
 * 真实头像 是否显示
 */
- (BOOL)isRealIconEnable {
    return [self isFaceVerified] && [self didHaveRealAvatar];
}

- (BOOL)isFemailAndPhotoReview {
    if (self.gender == 1) {
        return NO;
    }
    
    if (self.faces.count == 0 && ![ZZUserHelper shareInstance].configModel.can_skip_face_detect) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
