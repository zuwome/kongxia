//
//  ZZSystemConfigModel.h
//  zuwome
//
//  Created by angBiu on 2016/11/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ZZUpdateModel.h"
#import "ZZSkillModel.h"

@protocol ZZBannersModel

@end

@interface ZZSystemConfigSkModel : JSONModel

@property (nonatomic, strong) NSString *content;

@end

@interface ZZSystemYjConfigModel : JSONModel

@property (nonatomic, assign) double order_from;//订单抽佣
@property (nonatomic, assign) double mmd;//么么答抽佣
@property (nonatomic, assign) double mmd_tip;//么么答打赏抽佣
@property (nonatomic, assign) double mmd_private;//私信抽佣
@property (nonatomic, assign) double sk_tip;//时刻打赏抽佣

@end

@interface ZZSystemMMDConfigModel : JSONModel

@property (nonatomic, strong) NSString *private_min_price;
@property (nonatomic, strong) NSString *public_min_price;
@property (nonatomic, strong) NSString *tip_min_price;

@end

@interface ZZDisableModuleModel : JSONModel

@property (nonatomic, strong) NSArray<NSString *> *no_have_face;//需要有人脸
@property (nonatomic, strong) NSArray<NSString *> *no_have_face_text;//文本
@property (nonatomic, strong) NSArray<NSString *> *no_have_real_avatar;//需要有头像
@property (nonatomic, strong) NSArray<NSString *> *no_have_real_avatar_text;//文本

@end

@interface ZZQchat : JSONModel

@property (nonatomic, copy) NSString *tip;
@property (nonatomic, assign) BOOL need_idcard_verify;//true代表开通闪聊需要身份认证
@property (nonatomic, assign) BOOL show_comment;////是否显示好评，false不显示

@end

@interface ZZCancelReasonModel : JSONModel

@property (nonatomic, strong) NSArray<NSString *> *no_graber;// 没人抢取消理由
@property (nonatomic, strong) NSArray<NSString *> *have_graber;// 有人选取消的理由

@end

@interface ZZBannersModel : JSONModel

@property (nonatomic, assign) int type;//1 表示下载图片形式 2 表示H5形式 3 表示视频展示形式
@property (nonatomic, copy) NSString *cover_url;//封面图
@property (nonatomic, copy) NSString *link_url;//事件地址

@end

@interface ZZPdModel : JSONModel

@property (nonatomic, strong) ZZCancelReasonModel *cancel_reason;
@property (nonatomic, strong) NSArray<ZZBannersModel> *banners;
@property (nonatomic, assign) BOOL hide_banner;// true隐藏闪租顶部banner

@end

@interface ZZTipsModel : JSONModel

@property (nonatomic, copy) NSString *link_mic; //@"对方在线，快和TA视频通话吧"聊天会话里面的连麦提示

@end

@protocol ZZSkillCatalogModel
@end
@interface ZZSkillCatalogModel : JSONModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger classify;
@property (nonatomic, copy) NSString *url;
@end

#pragma mark - 价格模型
@interface ZZPriceConfigModel : JSONModel
/**
 *  连麦价格表 json数据为double型，但是在转换的时候可能会丢失精度，因此全部转换成nsstring保证精度正确。
 */
// 每多少分钟结算一次（每个结算单位 消耗X么币）
@property (nonatomic, copy) NSString *settlement_unit;

// 每个结算单位 消耗X么币
@property (nonatomic, copy) NSString *per_unit_cost_mcoin;

// 每次结算需要消耗多少张咨询卡（每个结算单位 3张卡）
@property (nonatomic, copy) NSString *per_unit_cost_card;

// 汇率: 一张咨询卡 = X么币
@property (nonatomic, copy) NSString *one_card_to_mcoin;

// 每个结算单位 用户获得X元: per_unit_cost_mcoin / 10 * 0.7/
@property (nonatomic, copy) NSString *per_unit_get_money;

// 可申请退款时间
@property (nonatomic, copy) NSString *can_refund_time;

// 连麦价格文本
@property (nonatomic, copy) NSDictionary *text;

/**
 *  私信价格
 */
// 每条私信消耗的X么币
@property (nonatomic, copy) NSString *per_chat_cost_mcoin;

// 发送私信，赠送X张私信卡
@property (nonatomic, copy) NSString *per_chat_give_card;

// 每条私信获得X元: per_chat_cost / 10 / 2
@property (nonatomic, copy) NSString *per_chat_get_money;

// 回复信息，领取X张私信卡
@property (nonatomic, copy) NSString *per_chat_get_card;

// 一张私信卡等于X么币
@property (nonatomic, copy) NSString *chat_one_card_to_mcoin;

// 私聊价格文本
@property (nonatomic,   copy) NSDictionary *text_chat;

@end

#pragma mark - 消息盒子里面回复打招呼的次数和天数
@interface SayhiConfigModel : JSONModel

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger day;

@end

@interface ZZUserInfomationDetailModel : JSONModel

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSArray *icons;

@end

@interface ZZUserInfomationModel : JSONModel

@property (nonatomic, strong) ZZUserInfomationDetailModel *yrz;  //他人点以完真实头像用户
@property (nonatomic, strong) ZZUserInfomationDetailModel *rzcg; //已认证真实头像 已申请达人
@property (nonatomic, strong) ZZUserInfomationDetailModel *shdr; //已认证真实头像。 未申请达人
@property (nonatomic, strong) ZZUserInfomationDetailModel *wrztx;  //未认证真实头像
@property (nonatomic, strong) ZZUserInfomationDetailModel *sh; //未点亮头像正在人工审核
@property (nonatomic, strong) ZZUserInfomationDetailModel *ycjwtx; //已采集活体 无真实头像
@property (nonatomic, strong) ZZUserInfomationDetailModel *wsbwcj; //未识别 未采集

@end



#pragma mark - 系统配置
@interface ZZSystemConfigModel : JSONModel

@property (nonatomic, strong) ZZPriceConfigModel *priceConfig;

@property (nonatomic, strong) ZZSystemMMDConfigModel *mmd;

@property (nonatomic, strong) ZZUpdateModel *version;

@property (nonatomic, strong) ZZSystemYjConfigModel *yj;

@property (nonatomic, strong) ZZSystemConfigSkModel *sk;

@property (nonatomic, strong) ZZQchat *qchat;

// 是否打开闪聊引导的女性开关
@property (nonatomic, assign) BOOL isShowQchat;

// 敏感词
@property (nonatomic, strong) NSArray *chat_forbidden_words;

@property (nonatomic, strong) NSDictionary *comments;

// 录制界面话题红点
@property (nonatomic, strong) NSString *group_version;

//@property (nonatomic, strong) NSString *wechat_price;
//@property (nonatomic, strong) NSString *wechat_price_get;//女方得到的价格

// 服务端是否允许开启客户端私聊付费 Yes  允许 NO 不允许
@property (nonatomic, assign) BOOL globaChatCharge;

@property (nonatomic, strong) NSDictionary *wechat;

@property (nonatomic, strong) NSArray *base_sk_group;

// 问题贴纸版本
@property (nonatomic, strong) NSString *question_sticker_version;

@property (nonatomic, strong) NSString *question_sticker_down_link;

@property (nonatomic, strong) ZZSkillModel *skill;

// true代表隐藏个人详情页的连麦按钮
@property (nonatomic, assign) BOOL hide_link_mic;

// true 表示有跳过人脸识别 按钮
@property (nonatomic, assign) BOOL can_skip_face_detect;

// 禁止使用的列表
@property (nonatomic, strong) ZZDisableModuleModel *disable_module;

// 1v1视频评价按钮选项
@property (nonatomic, strong) NSDictionary *link_mic_comments;

/**
 最小提现金额
 */
@property (nonatomic, assign) NSInteger min_bankcard_transfer ;

/**
最高提现金额
*/
@property (nonatomic, assign) NSInteger max_bankcard_transfer ;

// 派单相关Model
@property (nonatomic, strong) ZZPdModel *pd;

@property (nonatomic, strong) ZZTipsModel *tip;

@property (nonatomic, strong) ZZUserInfomationModel *user_infomation;

// ture隐藏视频页的查看微信按钮、暂时不用
@property (nonatomic, assign) BOOL hide_see_wechat;

// true代表首页隐藏闪租hot标志
@property (nonatomic, assign) BOOL hide_hot_symbol;

// ture代表视频页面隐藏查看微信按钮
@property (nonatomic, assign) BOOL hide_see_wechat_at_video;

// ture代表个人详情页 隐藏查看微信按钮
@property (nonatomic, assign) BOOL hide_see_wechat_at_userdetail;

// true代表隐藏私信红包
@property (nonatomic, assign) BOOL hide_mmd_private_at_userdetail;

// true代表可以有假头像  false代表不可以
@property (nonatomic, assign) BOOL can_have_false_avatar;

// 全局开关，true代表开启出租收费模块
@property (nonatomic, assign) BOOL open_rent_need_pay_module;

// true代表隐藏达人视频录制的相册按钮
@property (nonatomic, assign) BOOL hide_base_sk_album;

// true代表隐藏sk录制(达人视频除外)的相册按钮
@property (nonatomic, assign) BOOL hide_sk_album;

// true代表隐藏MMD录制的相册按钮
@property (nonatomic, assign) BOOL hide_mmd_album;

// true 表示当前扣费方式更改为么币扣费  false 表示当前的扣费方式为钱币  --主要针对 发单和1v1连麦
@property (nonatomic, assign) BOOL isChangeVideoChatPayMeBi;

// 是否能跳过开通闪聊环节
@property (nonatomic, assign) BOOL can_skip_qchat;

// 是否隐藏私信收益开关
@property (nonatomic, assign) BOOL hide_open_charge;

// 查看证件照最低金额
@property (nonatomic, assign) double mcoin_for_id_photo;

// 查看微信的最低金额
@property (nonatomic, assign) double wechat_price_mcoin;

// 技能主题大类信息 2018.8.16 -- 新增字段（主题大类标识等）
@property (nonatomic, strong) NSArray<ZZSkillCatalogModel> *skill_catalog;

// 出租 邀约优享邀约服务查看微信价格 开关
@property (nonatomic, assign) BOOL order_wechat_enable;

// 出租 邀约优享邀约服务查看微信价格
@property (nonatomic, assign) double order_wechat_price;

@property (nonatomic,   copy) NSString *give_up_wechat_service_tip;

// 3.6.0新版本的微信
@property (nonatomic, assign) BOOL wechat_new;

// 邀约报名的服务费
@property (nonatomic, assign) CGFloat pd_agency;

// 新鲜的
@property (nonatomic, assign) BOOL open_new_rent;

// 一键打招呼
@property (nonatomic, assign) BOOL open_sayhi_new;

// 消息盒子里面回复打招呼的次数
@property (nonatomic, strong) SayhiConfigModel *sayhi_config;

// 视频邀请开关
@property (nonatomic, assign) BOOL invite_switch;

// 通过技能标识，获取技能名称
- (NSString *)getNameOfSkillByClassify:(NSInteger)classify;

// 检查价格配置文件是否完整
- (BOOL)isPriceConfigExit;

/**
 *  获取价格配置信息(视频、聊天价格)
 */
- (void)fetchPriceConfig:(BOOL)needRetry
        inViewController:(UIViewController *)viewController
                   block:(void (^)(BOOL isComplete))block;


/**
 *  MARK: 不需要真实头像也可以进行的操作
 */
- (BOOL)canProceedWithoutRealAvatar:(NavigationType)type;

/**
 *  MARK: 不需要人脸识别也可以进行的操作
 */
- (BOOL)canProceedWithoutRealFace:(NavigationType)type;

#pragma mark - Request
+ (void)fetchSysConfigWithCompleteHandler:(void(^)(BOOL isSuccess))completeHandler;

@end
