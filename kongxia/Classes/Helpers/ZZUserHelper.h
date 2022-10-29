//
//  ZZUserHelper.h
//  zuwome
//
//  Created by wlsy on 16/1/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUser.h"
#import <Foundation/Foundation.h>
#import "ZZRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "ZZCacheOrder.h"
#import "ZZSystemConfigModel.h"
#import "ZZRecordConfigModel.h"
#import "ZZActivityUrlModel.h"
#import "ZZKTVModel.h"

#define loginedUser [ZZUserHelper shareInstance].loginer
#define UserHelper [ZZUserHelper shareInstance]
static dispatch_once_t ZZUserhelperOnce = 0;
    __strong static id _sharedObject = nil;

@interface ZZUserHelper : NSObject

@property (strong, nonatomic) ZZUser *loginer;
@property (strong, nonatomic) NSString *loginerId;
@property (strong, nonatomic) NSString *oAuthToken;
@property (strong, nonatomic) NSString *publicToken;//公众号传过来的token
@property (strong, nonatomic) NSString *IMToken;
@property (strong, nonatomic) NSString *uploadToken;
@property (strong, nonatomic) NSArray *locationArray;//历史地址
@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) NSArray *remarkArray;//下订单 打招呼
@property (strong, nonatomic) NSString *isFirstRent;
@property (strong, nonatomic) ZZCacheOrder *cacheOrder;//订单信息备份
@property (strong, nonatomic) ZZKTVModel *cacheSingingTask;//唱歌任务备份
@property (strong, nonatomic) NSString *currentChatUid;//正在聊天的对象
@property (strong, nonatomic) ZZSystemConfigModel *configModel;
@property (strong, nonatomic) ZZRecordConfigModel *recordConfigModel;//录制界面保存的参数
@property (nonatomic, strong) ZZActivityUrlModel * h5_activity;

@property (nonatomic,assign) NSInteger consumptionMebi;//私聊付费的消息钱数

@property (nonatomic,assign)  BOOL firstCloseTopView;//是否已经关闭过了

// 用户所在城市（定位时,旧的）
@property (nonatomic, strong) NSString *oldCityName;
// 用户所在城市（定位时）
@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) CLLocation *selectedLocation;
@property (assign, nonatomic) BOOL isAbroad;//是否是国外

@property (nonatomic, strong) NSString *charge_id;//支付的id

@property (strong, nonatomic) NSString *userFirstRent;//出租红点
@property (strong, nonatomic) NSString *userFirstPersonalLabel;//个人标签
@property (strong, nonatomic) NSString *userFirstInterest;//兴趣爱好
@property (strong, nonatomic) NSString *userFirstJob;//职业
@property (strong, nonatomic) NSString *userFirstWB;//微博
//趣拍accesstoken
@property (strong, nonatomic) NSString *qpAccesstoken;//趣拍token
//face++
@property (assign, nonatomic) BOOL license;
//是否允许3G播放
@property (strong, nonatomic) NSString *allow3GPlay;
//是否允许3G上传
@property (strong, nonatomic) NSString *allow3GUpload;
//是否是第一次进个人页
@property (strong, nonatomic) NSString *firstRentPage;
//是否是第一次订单付全款
@property (strong, nonatomic) NSString *firstOrderDetailPage;
//上次打赏的金额
@property (strong, nonatomic) NSString *lastPacketMoney;
//上次支付方式
@property (strong, nonatomic) NSString *lastPayMethod;
//上次提问么么答的金额
@property (strong, nonatomic) NSString *lastAskMoney;
//上次提问是否是么么答私信
@property (strong, nonatomic) NSString *lastAskType;
//是否需要进行匿名提问NEW提示
@property (strong, nonatomic) NSString *firstAnonymousAskInfo;
//第一次跟人问么么答
@property (strong, nonatomic) NSString *firstAskMemeda;
//第一次首页引导
@property (strong, nonatomic) NSString *firstHomeGuide;
//是否安装了APP
@property (strong, nonatomic) NSString *firstInstallAPP;
@property (strong, nonatomic) NSString *firstRecordVideo;//第一次录制时刻

//上次筛选是否选择了男女
@property (strong, nonatomic) NSString *lastFilterSexValue;
//粉丝数
@property (strong, nonatomic) NSString *userFansCount;
@property (strong, nonatomic) NSString *countryCode;//国际区号
@property (strong, nonatomic) ZZUserUnread *unreadModel;
@property (strong, nonatomic) NSString *lastStickersVersion;//录制贴纸红点
@property (strong, nonatomic) NSString *lastSKTopicVersion;//录制时刻话题红点
@property (strong, nonatomic) NSString *havePlayerDownUpGuide;//播放列表是否上下手势引导过了
@property (strong, nonatomic) NSMutableArray *uploadVideoArray;//正在上传的视频
@property (assign, nonatomic) BOOL updateMessageList;
@property (assign, nonatomic) BOOL updateAttentList;
@property (assign, nonatomic) BOOL uploadingQuestionVideo;
@property (assign ,nonatomic) BOOL upDateVideoList;//更新我的视频

@property (assign,nonatomic) BOOL isJumpPublish;//是否跳转过选择达人
@property (assign, nonatomic) BOOL banStatus;//用户自己的封禁状态,新增加的接口告诉用户被封禁了,服务端实时返回封禁状态的接口
@property (strong, nonatomic) NSString *banStatusReasons;//用户自己被封禁的原因
@property (copy, nonatomic) NSString *chatUid;//用户当前聊天的人的uid

@property (nonatomic, copy) NSArray<NSString *> *remindedUID;

+ (ZZUserHelper *)shareInstance;

/**
 *  MARK: 是否第一次发布私聊付费的消息
 */
+ (NSString *)firstSendPrivChatMessage;

/**
 *  MARK: 设置第一次发布私聊付费的消息
 */
+ (void)setFirstSendPrivChatMessage ;

/**
 * MARK: 是否是加载过sayHi数据
 * targetId: 当前的对话人的id
 */
- (NSString *)loadSayHiMessageDataWithtargetId:(NSString *)targetId;

/**
 * MARK: 保存加载过的sayHi数据
 */
- (void)saveSayHiMessageListDataWithtargetId:(NSString *)targetId;

/**
 *  MARK: 是否是达人
 *  已经上架并且没有隐身
 */
- (BOOL)isStar;

/**
 *  MARK: 是否正在出租
 *  进行中的单，并且 (已上架 没有隐身状态)
 */
- (BOOL)isOnRenting;

- (BOOL)isOnRenting:(NavigationType)type
             action:(void (^)(BOOL success, NavigationType type, BOOL isCancel))action;

/**
 *  MARK: 是否可以出租
 */
- (BOOL)canRent;

/**
 * MARK: 是否可以申请达人
 */
- (BOOL)canApplyTalentWithBlock:(void (^)(BOOL success, NSInteger infoIncompleteType, BOOL isCancel))block;

/**
 * MARK: 是否可以实名认证
 */
- (BOOL)canVerifyRealNameWithBlock:(void (^)(BOOL success, NSInteger infoIncompleteType, BOOL isCancel))block;

/**
 * MARK: 是否可以开通闪聊
 */
- (BOOL)canOpenQuickChat;

- (BOOL)canOpenQuickChatWithBlock:(void (^)(BOOL success, NSInteger infoIncompleteType, BOOL isCancel))block;

#pragma mark - User Info
- (bool)isMale;

- (bool)shouldCheckFaceWhenSignin;

/**
 *  MARK: 身份信息不全的提示
 *  @param infoIncompleteType 0:活体 1: 真实头像 2:不需要真实头像 3:订单
 */
- (BOOL)canProceedFollowingAction:(NavigationType)type
                            block:(void(^)(BOOL success, NSInteger infoIncompleteType, BOOL isCancel))block;

#pragma mark - 活体/人脸
/**
 *  MARK: 活体
 */
- (BOOL)didHaveRealFace:(NavigationType)type
                 action:(void (^)(BOOL success, NSInteger infoIncompleteType, BOOL isCancel))action;

- (BOOL)didHaveRealFace;

#pragma mark 真实头像
- (BOOL)didHaveRealAvatar;

/**
 *  MARK: 真实头像: 是否有真实头像
 */
- (BOOL)didHaveRealAvatar:(NavigationType)type
                   action:(void (^)(BOOL success, NSInteger infoIncompleteType, BOOL isCancel))action;

/**
 *  MARK: 真实头像: 当前头像是否可以保存用户信息
 */
- (BOOL)canSaveWithPhoto:(ZZPhoto *)photo
            navigateType:(NavigationType)type
                   block:(void (^)(BOOL success, NSInteger infoIncompleteType, BOOL isCancel))block;

/**
 *  MARK: 旧的可用头像: 是否有旧的可用头像
 */
- (BOOL)didHaveOldAvatar;


/**
 *  MARK: 用户头像是否在审核中
 */
- (BOOL)isUsersAvatarManuallReviewing:(ZZUser *)user;

/**
 *  MARK: 自己的头像是否在审核中
 */
- (BOOL)isAvatarManualReviewing;

/**
 *  MARK: 用户头像审核中，是否可以显示旧头像
 */
- (BOOL)canShowUserOldAvatarWhileIsManualReviewingg:(ZZUser *)user;

/**
 *  MARK: 自己头像审核中，是否可以显示旧头像
 */
- (BOOL)canShowOldAvatarWhileIsManualReviewing;

#pragma mark - Login / Logout / change
/**
 *  MARK: 保存登录用户
 */
- (void)saveLoginer:(ZZUser *)user postNotif:(BOOL)post;

/**
 * MARK: 当更改账户的时候释放
 */
+ (void)releaseCurrentWhenChangeAccount ;

/**
 *  MARK: 清除当前登录用户, 用在退出登录
 */
- (void)clearLoginer;

#pragma mark - Request
/**
 *  MARK: 获取用户信息
 */
+ (void)fetchUserInfoWithNext:(void(^)(ZZError *error, id data))next;

/**
 *  MARK: 获取用户较少的数据
 */
+ (void)getUserMiniInfo:(NSString *)uid
                   next:(requestCallback)next;

/**
 *  MARK: 获取用户较少的数据？？？？？？？
 */
+ (void)getMiniUserInfo:(NSString *)uid
                   next:(requestCallback)next;

/**
 *  MARK: 获取用户首都？？？？？？？？？？？？
 */
+ (void)loadUserCapital:(requestCallback)next;

/**
 *  MARK: 更新用户微博信息
 */
- (void)updateUserWeiboWithParam:(NSDictionary *)param
                            next:(requestCallback)next;

/**
 *  MARK: 更新Token
 */
- (void)updateDevice:(NSString *)token
            callback:(requestCallback)callback;

/**
 *  MARK: 余额记录（分页）
 */
+ (void)getUserBalanceRecordWithParam:(NSDictionary *)param
                                 next:(requestCallback)next;

/**
 *  MARK: 提现记录 (分页)
 */
+ (void)getUserCashRecordWithParam:(NSDictionary *)param
                              next:(requestCallback)next;

/**
 *  MARK: 充值记录 (分页)
 */
+ (void)getUserRechargeRecordWithParam:(NSDictionary *)param
                                  next:(requestCallback)next;

/*
 * MARK: 更新用户经纬度
 */
- (void)updateUserLocationWithLocation:(CLLocation *)location;

/**
 MARK: 检测文本是否违规
 */
+ (void)checkTextWithText:(NSString *)text type:(NSInteger)type
                     next:(requestCallback)next;

/**
 MARK: 上传错误log
 */
+ (void)uploadLogWithParam:(NSDictionary *)param
                      next:(requestCallback)next;

/**
 MARK: 更新余额 不含么币 ,只是钱包
 */
+ (void)updateTheBalanceNext:(requestCallback)next;

/**
 MARK: 请求么币和余额,并且更新
 */
+ (void)requestMeBiAndMoneynext:(requestCallback)next;

@end
