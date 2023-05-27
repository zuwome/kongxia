//
//  ZZUser.h
//  zuwome
//
//  Created by wlsy on 16/1/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPhoto.h"
#import "ZZUserLabel.h"
#import "ZZRealname.h"
#import "ZZRent.h"
#import "ZZRequest.h"
#import <JSONModel/JSONModel.h>
#import "ZZMessageBoxConfigModel.h"
#import "ZZEmergencyContactModel.h"
#import "ZZBanModel.h"
#import "ZZTaskConfig.h"
#import "ZZInfoToastView.h"
#import "ZZMyLocationModel.h"

@class ZZRentDropdownModel;

@class ZZSKModel;

//过去30天的统计
@interface ZZStatisDataModel : JSONModel

@property (assign, nonatomic) NSInteger bebrowsed_count;//浏览数
@property (assign, nonatomic) NSInteger beordered_count;//预约数
@property (assign, nonatomic) NSInteger order_respond_rate;//响应率

@end

@interface ZZPrivacyConfig : JSONModel

@property (nonatomic, assign) BOOL open_chat;//已打开 false未打开

@end

//推送配置
@interface ZZPushConfig : JSONModel

@property (nonatomic, assign) BOOL chat;
@property (nonatomic, assign) BOOL following;
@property (nonatomic, assign) BOOL reply;
@property (nonatomic, assign) BOOL like;
@property (nonatomic, assign) BOOL tip;
@property (nonatomic, assign) BOOL mmd_following;
@property (nonatomic, assign) BOOL need_sound;
@property (nonatomic, assign) BOOL need_shake;
@property (nonatomic, assign) BOOL red_packet_msg;//红包推送
@property (nonatomic, assign) BOOL red_packet_following;//红包推送
@property (nonatomic, assign) BOOL sk_following;//红包推送
@property (nonatomic, assign) BOOL system_msg;//系统通知
@property (nonatomic, assign) BOOL no_push;//免打扰
@property (nonatomic, assign) BOOL say_hi;//打开打招呼推送
@property (nonatomic, assign) BOOL push_hide_name;//隐藏昵称
@property (nonatomic, strong) NSString *no_push_begin_at;
@property (nonatomic, strong) NSString *no_push_end_at;
@property (nonatomic, assign) BOOL pd_push;//开启抢任务通知
@property (nonatomic, strong) NSString *pd_push_begin_at;
@property (nonatomic, strong) NSString *pd_push_end_at;
@property (nonatomic, assign) BOOL sms_push;//短信通知
@property (nonatomic, assign) BOOL pd_can_push;// 是否需要本地推送(服务端已经做了开关 及 当前时间是否在有效时间段内判断)

@property (nonatomic, assign) BOOL qchat_push;//闪聊广场的打开和关闭的控制
@property (nonatomic, copy) NSString *qchat_push_begin_at;//起始时间
@property (nonatomic, copy) NSString *qchat_push_end_at;//结束时间
@end

//个人状态（飞机 新人）
@interface ZZMark : JSONModel

@property (nonatomic, assign) BOOL is_flighted_user;
@property (nonatomic, assign) BOOL is_new_rent;
@property (nonatomic, assign) BOOL is_short_distance_user;

@end

@interface ZZZmxy : JSONModel

@property (nonatomic, strong) NSString *openid;

@end

@interface ZZWechat: JSONModel
@property (strong, nonatomic) NSString *wx;
@property (strong, nonatomic) NSString *unionid;
@property (strong, nonatomic) NSString *no;//微信号
@property (assign, nonatomic) NSInteger good_comment_count;//好评数
@property (assign, nonatomic) NSInteger bad_comment_count;//好评数
@end

@interface ZZWeibo: JSONModel
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *userName;//用户名
@property (strong, nonatomic) NSString *iconURL;//头像
@property (strong, nonatomic) NSString *profileURL;//主页
@property (assign, nonatomic) BOOL verified;
@property (strong, nonatomic) NSString *verified_reason;//v头衔
@property (copy, nonatomic) NSString *accessToken;
@end

@interface ZZAppleIDSignIn: JSONModel

@property (nonatomic, copy) NSString *identityToken;

@property (nonatomic, copy) NSString *user;

@property (nonatomic, copy) NSString *authorizationCode;

@end

@interface ZZQQ: JSONModel
@property (strong, nonatomic) NSString *openid;
@end

@interface ZZAddress : JSONModel
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@end

@interface ZZUserUnread : JSONModel

@property (assign, nonatomic) BOOL open_log;
@property (assign, nonatomic) BOOL ongoing;//订单进行中 false不需要小红点 true需要
@property (assign, nonatomic) BOOL dynamic_following;//动态－我关注的
@property (assign, nonatomic) BOOL my_ask_mmd;//我的么么答－我问
@property (assign, nonatomic) BOOL my_answer_mmd;//我的么么答－我答
@property (assign, nonatomic) BOOL my_mmd;//我的么么答
@property (assign, nonatomic) BOOL dynamic;//动态
@property (assign, nonatomic) BOOL notice_tab;//消息tab栏
@property (assign, nonatomic) BOOL me_tab;//我的tab栏

@property (assign, nonatomic) NSInteger order_ongoing_count;//进行中订单数目
@property (assign, nonatomic) BOOL order_commenting;//待评论订单
@property (assign, nonatomic) BOOL order_done;//已完成订单
@property (assign, nonatomic) NSInteger my_answer_mmd_count;//我的么么答-我答数目
@property (assign, nonatomic) BOOL have_system_red_packet;//true有系统扫脸红包  false没有;
@property (assign, nonatomic) NSInteger red_packet_msg_count;//红包留言未读数
@property (strong, nonatomic) ZZMessageBoxConfigModel *say_hi;
@property (strong, nonatomic) NSDictionary *pd;
@property (assign, nonatomic) NSInteger pd_receive;//抢任务数目
@property (copy, nonatomic) NSString *pd_receive_last_time;//最后收到派单任务时间
@property (assign, nonatomic) NSNumber *system_msg;//系统消息
@property (strong, nonatomic) NSNumber *hd;//互动消息
@property (assign, nonatomic) NSNumber *reply;//评论消息

@end

@interface ZZBaseVideo : JSONModel

@property (nonatomic, strong) ZZSKModel *sk;    //达人介绍视频
@property (nonatomic, assign) NSInteger status;//0还未录制 1通过 2不通过 -1审核中
@property (nonatomic, copy) NSString *status_text;//不通过情况下读取 原因

@end

#pragma mark - 身份证件照

typedef NS_ENUM(NSInteger, IDPhotoCellStatus) {
    // 头像非本人，无上传证件照
    IDPhotoCellStatusNone,
    
    // 头像本人，还未上传证件照
    IDPhotoCellStatusMyPhoto,
    
    // 编辑上传证件照
    IDPhotoCellStatusEdit,
    
    // 证件照审核中
    IDPhotoCellStatusReviewing,
    
    // 上传证件照成功
    IDPhotoCellStatusUpload,
    
    // 证件照审核失败
    IDPhotoCellStatusFailed,
};

@interface ZZIDPhoto : JSONModel

// 图片
@property (nonatomic,   copy) NSString *pic;

// 原因
@property (nonatomic,   copy) NSString *reason;

// 状态 0.无证件照 1.待审核 2.已审核 3.不通过
@property (nonatomic, assign) NSInteger status;

// 更新日期
@property (nonatomic,   copy) NSString *updated_at;

// 认证日期
@property (nonatomic,   copy) NSString *verified_at;

// 认证人
@property (nonatomic,   copy) NSString *verifier;

/**
 *  上传说明文本
 */
@property (nonatomic, strong) NSString *tips;

@end

#pragma mark - 用户
@protocol ZZUser
@end
@interface ZZUser : JSONModel
@property (nonatomic, assign) int integral;//积分

@property (assign,nonatomic)  BOOL today_issign;//用户是否已经签到领取了积分
@property (assign,nonatomic)  BOOL open_charge;//该用户是否开启了私聊付费的
@property (strong,nonatomic)  NSString *open_charge_channel;//当前用户是否拥有私聊付费开通渠道
@property (assign,nonatomic)  BOOL can_see_open_charge;//该用户有资格开启私聊付费
@property (strong, nonatomic) ZZWechat *wechat;
@property (nonatomic, strong) ZZAppleIDSignIn *appleIDSignIn;
@property (strong, nonatomic) ZZWeibo *weibo;
@property (strong, nonatomic) ZZQQ *qq;
@property (strong, nonatomic) ZZZmxy *zmxy;//芝麻信用
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *uuid;
@property (nonatomic, copy) NSString *_id; // == uid

@property (strong, nonatomic) NSString *phone;

@property (strong, nonatomic) NSString *nickname;

@property (assign, nonatomic) NSInteger nickname_status;//昵称审核状态 1:审核
// 头像
@property (strong, nonatomic) NSString *avatar;

// 旧的模糊头像 (用于当前照片在审核中)
@property (nonatomic, strong) NSString *old_avatar;

// 旧的清晰头像 (用于当前照片在审核中)
@property (nonatomic,   copy) NSString *old_avatar_origin;

@property (assign, nonatomic) int avatarStatus;//
@property (nonatomic,strong) NSArray *faces;//人脸检测
@property (strong, nonatomic) NSString *password;

// 头像是否在人工审核中 1待审核，2通过，3失败
@property (nonatomic, assign) NSInteger avatar_manual_status;

@property (strong, nonatomic) NSMutableArray<ZZPhoto> *photos;//用户头像(模糊处理)

// 头像(不模糊处理), 第一张用来作为判断是否有真实头像的依据。
@property (strong, nonatomic) NSMutableArray<ZZPhoto> *photos_origin;
@property (assign, nonatomic) int gender;//性别1男 2女
@property (strong, nonatomic) ZZAddress *address;//地址
@property (strong, nonatomic) NSDate *birthday;//生日
@property (strong, nonatomic) NSDate *photo_updated_at;
@property (strong , nonatomic) NSString<Ignore>*generation;
@property (assign, nonatomic)  NSInteger age;
@property (strong , nonatomic) NSString *constellation;//星座
@property (assign, nonatomic) int height;
@property (strong, nonatomic) NSString *heightIn;
@property (assign, nonatomic) int weight;
@property (strong, nonatomic) NSString *weightIn;
@property (strong, nonatomic) NSString *work;
@property (strong, nonatomic) NSString *bio;//自我介绍
@property (assign, nonatomic) NSInteger bio_status;//自我介绍审核状态 0:审核 1:通过 2:不通过
@property (strong, nonatomic) NSString *interest;
@property (strong, nonatomic) ZZRealname *realname;//实名认证信息
@property (strong, nonatomic) ZZRealname *realname_abroad;//国外和港澳台认证
@property (strong, nonatomic) ZZRent *rent;//出租信息
@property (strong, nonatomic) NSNumber *minPrice;//最低价格
@property (strong, nonatomic) NSNumber *balance;//余额
@property (strong, nonatomic) NSNumber *mcoin;//么币
@property (strong, nonatomic) NSString * forzen;//冻结资金带有文字了
@property (assign, nonatomic) BOOL banFriends;//是否拉黑对方
@property (strong,nonatomic)  ZZBanModel *ban;
@property (strong, nonatomic) NSString *distance;//距离
@property (assign, nonatomic) BOOL banStatus;//封禁状态
@property (assign, nonatomic) BOOL isShowOpenQchat;////根据颜值 是否显示开启闪聊
@property (strong, nonatomic) NSMutableArray<ZZUserLabel> *interests_new;//兴趣
@property (strong, nonatomic) NSMutableArray<ZZUserLabel> *works_new;//职业
@property (strong, nonatomic) NSMutableArray<ZZUserLabel> *tags_new;//个人标签
@property (strong, nonatomic) NSString *ZWMId;//么么号
@property (strong, nonatomic) NSString *version;//版本号
@property (assign, nonatomic) NSInteger follow_status;//是否关注
@property (assign, nonatomic) NSInteger follower_count;//粉丝数
@property (assign, nonatomic) NSInteger following_count;//关注数
@property (assign, nonatomic) NSInteger answer_count;//回答数目
@property (assign, nonatomic) NSInteger video_count;//视频数目
@property (assign, nonatomic) NSInteger get_hb_count;//获取红包数
@property (assign, nonatomic) CGFloat get_hb_price;//获取红包总金额
@property (assign, nonatomic) NSInteger mmd_seen_count;//么么答被多少人看
@property (assign, nonatomic) NSInteger answer_count_myask;//我问的 被回答数
@property (assign, nonatomic) CGFloat give_hb_price_myask;//我问的 发送红包总金额
@property (assign, nonatomic) CGFloat get_hb_price_myask;//我问的 获取红包总金额
@property (strong, nonatomic) ZZMark *mark;//个人状态（飞机 新人）
@property (strong, nonatomic) ZZPushConfig *push_config;//推送配置
@property (strong, nonatomic) ZZPrivacyConfig *privacy_config;//隐私配置
@property (assign, nonatomic) CGFloat price_for_chat;//不能聊天时弹窗的最低价格
@property (assign, nonatomic) NSInteger level;//等级
@property (assign, nonatomic) BOOL have_red_packet;//true有扫脸红包 false没有
@property (assign, nonatomic) double take_red_packet_balance;//获取红包的总价钱
@property (assign, nonatomic) NSInteger take_red_packet_count;//获取红包的总个数
@property (assign, nonatomic) double take_red_packet_price;//针对某人获取的红包数目
@property (assign, nonatomic) BOOL can_take_red_packet;//是否能领红包
@property (assign, nonatomic) double red_packet_price;//用户当前总红包
@property (assign, nonatomic) NSInteger get_like_count;//获得多少赞
@property (assign, nonatomic) NSInteger trust_score;//信任值
@property (strong, nonatomic) NSString *trust_score_level;//信任值高
@property (strong, nonatomic) ZZStatisDataModel *last_days;//过去30天的统计
@property (assign, nonatomic) BOOL have_wechat_no;//true有微信号
@property (assign, nonatomic) BOOL can_see_wechat_no;//true可以看此微信号
@property (assign, nonatomic) BOOL have_commented_wechat_no;//true已经评论 false未评论
@property (strong,nonatomic)  NSString  *current_city_name;//用户当前的城市
@property (assign, nonatomic) NSInteger wechat_comment_score;//1差评 5好评
@property (strong,nonatomic)  NSArray  *wechat_comment_content;//评价的内容
@property (assign, nonatomic) BOOL can_bad_comment;//false 不可以差评 true可以差评

@property (strong, nonatomic) NSNumber *money_get_by_wechat_no;//微信号收益
@property (assign, nonatomic) BOOL have_close_account;//是否已经注销了
@property (strong, nonatomic) NSString *avatar_unpass;//未通过的照片
@property (strong, nonatomic) NSString *avatar_unpass_reason;//照片未通过原因
@property (strong, nonatomic) NSString *nickname_unpass;//未通过的昵称
@property (strong, nonatomic) NSString *nickname_unpass_reason;//昵称未通过原因
@property (strong, nonatomic) ZZSKModel *base_sk;//新人介绍视频
@property (strong, nonatomic) NSMutableArray<ZZEmergencyContactModel> *emergency_contacts;//紧急联系人
@property (assign, nonatomic) double wechat_price;//查看此人的微信号需要付款的金额
@property (assign, nonatomic) double wechat_price_mcoin;//查看此人的微信号需要付款的么币（iOS要走内购流程，改用这个字段）
@property (assign, nonatomic) double wechat_price_get;//微信被查看后女方得到的价格
@property (strong, nonatomic) ZZBaseVideo *base_video;//达人视频Model
@property (nonatomic, copy) NSString *rank;//用户人气值
@property (nonatomic, copy) NSString *rank_new;
@property (nonatomic, assign) NSUInteger gender_status;//1 性别ok  2 性别有错且未实名认证
@property (nonatomic, assign) BOOL rent_need_pay;//此人出租需要付费  false：不需要付费（字段的值会根据用户是否是男性，大陆，是否已付费，老用户等条件）
@property (nonatomic, assign) BOOL open_qchat;//是否已经开通闪聊

@property (nonatomic, copy) NSString *link_mic_good_comments_count;//好评数
@property (nonatomic, copy) NSString *lastLoginAtText;//在线时长
@property (nonatomic,assign,readonly) BOOL showCallQ_Chat;//是女性而且处于闪聊开放时间段

// 是否拥有证件照
@property (nonatomic, assign) BOOL have_id_photo;

// 证件照  1:审核中  2: 审核通过
@property (nonatomic, strong) ZZIDPhoto *id_photo;

// 是否已经付费可以查看证件照
@property (nonatomic,   assign) BOOL can_see_real_id_photo;

// 最后一次登陆时间
@property (nonatomic, copy) NSString *last_login_day_update;

// 地理位置发生变化的距离
@property (nonatomic, assign) double loc_num;

// 地理位置发生变化的时间
@property (nonatomic, copy) NSString *loc_num_update_at;

// 用户的常去地点
@property (nonatomic, copy) NSArray<ZZMyLocationModel> *userGooToAddress;

// 通告短信开关
@property (nonatomic, assign) BOOL open_pd_sms;

// 活动短信开关
@property (nonatomic, assign) BOOL open_pdg_sms;

@property (nonatomic, copy) NSArray *loc;

@property (nonatomic, assign) double totalCommissionIncome;

// 人气值(新人和人气的)
@property (nonatomic, assign) double total_score;

// 人气值上升下降(新人和人气的)
@property (nonatomic, assign) NSInteger is_top;

// 人气值/新人排行榜用户ID
@property (strong, nonatomic) NSString *user;

// 距离上次登录时间超过30天的达人回归，隐身
@property (nonatomic, strong) NSString *returner;

+ (void)loadUser:(NSString *)uid param:(NSDictionary *)param next:(requestCallback)next;

+ (void)getUserUnread:(requestCallback)next ;

- (void)login:(NSDictionary *)param next:(requestCallback)next;
- (void)signUp:(NSDictionary *)param next:(requestCallback)next;
- (void)loginByCode:(NSDictionary *)param next:(requestCallback)next;
- (void)logout:(requestCallback)next;
+ (void)getIMToken:(requestCallback)next;
- (void)resetPassword:(NSDictionary *)param next:(requestCallback)next;
//- (void)update:(requestCallback)next;
- (void)updateWithParam:(NSDictionary *)param next:(requestCallback)next;
- (void)updateUserFacesAndManualStatus:(NSDictionary *)param next:(requestCallback)next;

- (void)updatePhone:(NSDictionary *)param next:(requestCallback)next;
- (void)updateAvatar:(NSDictionary *)param next:(requestCallback)next;// 单独更新头像接口

- (void)checkPhotoIsSamePerson:(NSString *)url faces:(NSArray *)faces next:(requestCallback)next;

- (void)checkPhotoIsSamePersonNeedLogin:(NSString *)photoId
                               photoUrl:(NSString *)url
                                  faces:(NSArray *)faces next:(requestCallback)next;

- (void)phoneCheck:(NSDictionary *)param next:(requestCallback)next;
- (void)loginWithWechat:(NSString *)openid token:(NSString *)token next:(requestCallback)next;
- (void)loginWithWeibo:(NSString *)uid token:(NSString *)token nick:(NSString *)nick avatar:(NSString *)avatar profileURL:(NSString *)profileURL next:(requestCallback)next;
- (void)loginWithQQ:(NSString *)openid token:(NSString *)token next:(requestCallback)next;
- (void)changePassword:(NSString *)password next:(requestCallback)next;

+ (void)checkPhoneAndCode:(NSDictionary *)param next:(requestCallback)next;

- (void)getGenderAutoWithParam:(NSDictionary *)param next:(requestCallback)next;

- (void)getRentPayPriceListNext:(requestCallback)next;

/**
 *  拉黑用户
 */
+ (void)addBlackWithUid:(NSString *)uid next:(requestCallback)next;
/**
 *  取消拉黑
 */
+ (void)removeBlackWithUid:(NSString *)uid next:(requestCallback)next;

+ (void)rent:(NSDictionary *)param next:(requestCallback)next;
/**
 *  获取评论
 */
- (void)getComments:(requestCallback)next;
/**
 *  获取余额
 */
- (void)getBalance:(requestCallback)next;
/**
 *  第三方绑定
 */
- (void)thirdBindWithParam:(NSDictionary *)param next:(requestCallback)next;
/**
 *  第三方解绑
 */
- (void)thirdUnbindWithParam:(NSDictionary *)param next:(requestCallback)next;
/**
 *  关注
 */
- (void)followWithUid:(NSString *)uid next:(requestCallback)next;
/**
 *  取消关注
 */
- (void)unfollowWithUid:(NSString *)uid next:(requestCallback)next;
/**
 未登录用户查看个人详情页
 */
+ (void)getUnloginUserDetailWithUid:(NSString *)uid dic:(NSDictionary *)dic next:(requestCallback)next;

/**
 根据出生日期来改变年龄

 @param birthday 出生日期
 @return 年龄
 */
+ (NSInteger)ageWithBirthday:(NSDate *)birthday;

/**
 *  获取用户已上传人工审核头像数
 */
+ (void)getManualReviewCount:(void(^)(NSInteger count))count;

/**
 *  是否上传了真实头像
 */
- (void)didUsersFacePassDetected:(void(^)(BOOL didPass))block;

/**
 *  证件照是否审核通过
 */
- (BOOL)didIDPhotoPassDetected;

- (BOOL)isUsersAvatarReal;

- (void)costMcoin:(NSInteger)mcoin isAdd:(BOOL)isAdd;

#pragma mark -
/**
 *  MARK: 是否拥有真实头像
 */
- (BOOL)didHaveRealAvatar;

/*
 *  可以显示的头像
 */
- (NSString *)displayAvatar;

/*
 *  可以显示的头像集合
 */
- (NSArray<ZZPhoto *> *)displayAlbum;

/*
 *  头像是否在审核中
 */
- (BOOL)isAvatarManualReviewing;

/*
 *  是否有可用的旧头像
 */
- (BOOL)didHaveOldAvatar;

/*
 *  是否通过身份认证
 */
- (BOOL)isIdentifierCertified;

/*
 *  是否可以发布活动/通告等等
 */
- (BOOL)canPublish:(TaskType)taskType block:(void(^)(BOOL canPublish, ToastType failType, NSInteger actionIndex))block;

/*
 * 个人资料是不是在审核中
 */
- (BOOL)isInfoReviewing;

- (BOOL)isFaceVerified;

/*
 * 真实头像 是否显示
 */
- (BOOL)isRealIconEnable;

- (BOOL)isFemailAndPhotoReview;

@end
