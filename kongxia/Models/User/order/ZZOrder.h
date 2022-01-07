//
//  ZZOrder.h
//  zuwome
//
//  Created by wlsy on 16/1/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZUser.h"
#import "ZZSkill.h"
#import "ZZCity.h"
#import <CoreLocation/CoreLocation.h>

@interface JSONValueTransformer(CLLocation)
//CLLocation
-(CLLocation *)CLLocationFromNSDictionary:(NSDictionary*)dic;
-(NSDictionary *)JSONObjectFromCLLocation:(CLLocation*)location;

@end


@interface ZZOrderReport : JSONModel

@property (nonatomic, copy) NSString *reason;       // 申诉理由
@property (nonatomic, copy) NSString *check_reason; // 申诉结果

@end
@interface ZZOrderRefundDepositModel : JSONModel

@property (strong, nonatomic) NSString *responsibility;
@property (strong, nonatomic) NSString *explain_detail ;//责任详细说明
@property (strong, nonatomic) NSString  *explain_title;//责任说明
@property (strong, nonatomic) ZZOrderRefundDepositModel  *refund_from_text;//给用户用的
@property (strong, nonatomic) ZZOrderRefundDepositModel  *refund_to_text;//给达人用的
@end

@interface ZZOrderRefund : JSONModel
@property (assign, nonatomic) BOOL dispute;//是否是 其他 原因（即自定义原因）

/**
 用户上传的理由
 */
@property (strong, nonatomic) NSString *remarks;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *amount;
@property (assign, nonatomic) BOOL is_deposit;

/**
 用户上传证据的理由
 */
@property (strong, nonatomic) NSArray *photos;
/**
 达人上传证据的理由
 */
@property(nonatomic,strong) NSString *refuse_reason;
/**
 达人拒绝的上传图片证据
 */
@property(nonatomic,strong) NSArray  *refuse_photos;
@property (strong, nonatomic) ZZOrderRefundDepositModel* refund_text;

@property (nonatomic, copy) NSString *appeal_result;//拒绝退款后，管理后台判别的原因
@end


@interface ZZOrderAppeal : JSONModel
@property (assign, nonatomic) BOOL dispute;
@property (strong, nonatomic) NSString *remarks;
@property (strong, nonatomic) NSNumber *amount;
@end


@interface ZZOrderMet : JSONModel
@property (assign, nonatomic) BOOL to;
@property (assign, nonatomic) BOOL from;
@end

@interface ZZOrderLocation : JSONModel
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@end

typedef NS_ENUM(NSInteger,OrderDetailType) {
    OrderDetailTypePending,               //待接受
    OrderDetailTypeCancel,                //取消
    OrderDetailTypeRefused,               //拒绝
    OrderDetailTypePaying,                //待付款
    OrderDetailTypeMeeting,               //见面中
    OrderDetailTypeCommenting,            //待评论
    OrderDetailTypeCommented,             //已评论
    OrderDetailTypeAppealing,             //申诉中
    OrderDetailTypeRefunding,             //申请退款（发起方申请，待商家接受或拒绝）
    OrderDetailTypeRefundHanding,         //退款处理中（已接受退款且为第三方支付退款）
    OrderDetailTypeRefusedRefund,         //拒绝退款
    OrderDetailTypeRefunded               //已退款
};

@interface ZZOrder : JSONModel
// 是否是优享
@property (nonatomic, assign) BOOL isBestDetail;

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) ZZUser *from;
@property (strong, nonatomic) ZZUser *to;
@property (assign,nonatomic) BOOL isFromCancel;//是否是达人取消的
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *accepted_at;
@property (strong, nonatomic) NSString *paid_at;//付全款时间
@property (strong, nonatomic) NSDate *dated_at;
@property (strong, nonatomic) NSString<Ignore> *dated_at_string;
// 只是用来从线下把时间传给通告
@property (nonatomic, copy) NSString *date_Des;
@property (assign, nonatomic) int hours;

// 单价
@property (strong, nonatomic) NSNumber *price;

// 预付款 (单价 * 时间 + 下单费) * 0.05
@property (strong, nonatomic) NSNumber *advancePrice;

// 总价 (单价 * 时间 + 下单费 + 优享)
@property (strong, nonatomic) NSNumber *totalPrice;

// 下单费用
@property (nonatomic, strong) NSNumber *xdf_price;

@property (strong, nonatomic) NSString *remarks;//用户上传退款的理由
@property (strong, nonatomic) ZZSkill *skill;
@property (strong, nonatomic) ZZCity *city;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *status;//paying  代表代付款
@property (strong, nonatomic) NSString *statusText;
@property (strong, nonatomic) NSString *cancel_type;//2是 接受预约后超时取消
@property (strong, nonatomic) ZZOrderLocation *loc;
@property (strong, nonatomic) ZZOrderRefund *refund;
@property (strong, nonatomic) ZZOrderAppeal *appeal;
@property (strong, nonatomic) ZZOrderMet *met;
@property (assign, nonatomic) BOOL need_deposit;//是否是意向金
@property (assign, nonatomic) double deposit;//意向金价格
@property (strong, nonatomic) NSString *distance;//距离

@property (strong, nonatomic) NSString *reason;//意向金申述
//@property (strong, nonatomic) NSString *totalPriceShow;//显示的总价格（意向金情况）
@property (assign, nonatomic) BOOL exceed_dated_at;//判断是否显示24小时超时字段
@property (strong, nonatomic) NSString *exceed_dated_at_show;//24小时超时文案
@property (assign, nonatomic) BOOL can_do_video;//是否能视频通话
@property (assign, nonatomic) BOOL can_do_audio;//是否能语音通话
@property (assign, nonatomic) BOOL can_notify_accept_order;//是否可以提醒（没有判断男女，前端自己判断）
@property (assign, nonatomic) NSInteger notify_count_down;//倒计时起点 数值类型 单位：秒 （可以提醒时 返回的是0）
@property (assign, nonatomic) NSInteger dated_at_type;//1尽快  0具体时间 2=上午  3=中午 4=下午 5=晚上 6=深夜 7=整天
@property (nonatomic, copy) NSString *selectDate;   // 选择的日期，入 今天、明天、周一...周五
@property (strong, nonatomic) NSString *notify_btn_text;//提醒文案
@property (assign, nonatomic) BOOL need_yj;//true代表这单有抽用
@property (strong, nonatomic) NSNumber *yj_price;//佣金
@property (strong,nonatomic)  NSNumber *reason_type;//1用户的责任  2达人的责任
@property (nonatomic, copy)  NSString *status_desc;//"平台正在监管资金"
@property (nonatomic, assign) NSInteger cancel_refund_times;//1代表已经取消过一次，0代表未取消过退款
@property (nonatomic, strong) NSDate *dated_begin_at;
@property (nonatomic, strong) NSDate *dated_end_at;
@property (nonatomic, strong) NSString *dated_at_text;//聊天界面时间显示
@property (nonatomic, strong) NSString *dated_at_text2;//订单详情时间显示
@property (nonatomic, strong) NSString *hours_text;
@property (nonatomic, assign) NSInteger type;//1、正常订单 2、派单线上视频 3、派单线下 4、闪聊
@property (nonatomic, strong) ZZOrderReport *report;   // 申诉相关
@property (nonatomic, copy) NSString *room;//房间id (roomId)

// 是否查看微信（默认为YES）
@property (nonatomic, assign) BOOL wechat_service;

@property (nonatomic, assign) BOOL isWechatServiceFromCached;

// 微信价格
@property (nonatomic, assign) double wechat_price;

// 判断该订单的版本是不是
@property (nonatomic, copy) NSString *pd_version;

// 查看微信价格
//@property (nonatomic, assign) double checkWeChatPrice;

+ (void)loadInfo:(NSString *)orderId next:(requestCallback)next;
//旧的下单
- (void)add:(requestCallback)next;
//新的意向金下单
- (void)addDeposit:(requestCallback)next;
- (void)update:(requestCallback)next;

- (void)cancel:(NSString *)reason status:(NSString *)status next:(requestCallback)next;
- (void)refuse:(NSString *)reason status:(NSString *)status  next:(requestCallback)next;
//- (void)appeal:(NSString *)status next:(requestCallback)next;

- (void)refund:(NSString *)status next:(requestCallback)next;
- (void)refundDeposit:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next;

- (void)refundYes:(NSString *)status next:(requestCallback)next;
- (void)refundNo:(NSString *)status param:(NSDictionary *)param next:(requestCallback)next;
- (void)accept:(NSString *)status next:(requestCallback)next;
- (void)pay:(NSString *)channel status:(NSString *)status next:(requestCallback)next;
- (void)advancePay:(NSString *)channel status:(NSString *)status next:(requestCallback)next;
- (void)met:(CLLocation *)location status:(NSString *)status next:(requestCallback)next;
- (void)comments:(requestCallback)next;
- (void)getPhone:(requestCallback)next;
/**
 *  订单提醒对方
 */
- (void)remindWithOrderId:(NSString *)orderId status:(NSString *)status next:(requestCallback)next;

/**
 取消订单
 */
+ (void)cancelOrder:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next;

/**
 拒绝订单
 */
+ (void)refuseOrder:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next;

/**
 拒绝订单
 */
+ (void)refundOrder:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next;
/**
 获取订单列表
 */
+ (void)pullAllWithStatus:(NSString *)status lt:(NSString *)lt next:(requestCallback)next;
/**
 获取最近的订单
 */
+ (void)latestWithUser:(NSString *)uid next:(requestCallback)next;
/**
 删除订单
 */
+ (void)deleteOrderWithOrderId:(NSString *)orderId next:(requestCallback)next;
/**
 撤销退款申请
 */
+ (void)revokeRefundOrder:(NSString *)orderId status:(NSString *)status next:(requestCallback)next;
/**
 编辑退款申请
 */
+ (void)editRefundOrder:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next;
/**
 订单评论
 */
+ (void)commentOrder:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next;

// 不计额外费用(优享、下单费)
- (double)pureTotalPrice;

// 是不是最新的邀约订单 v
- (BOOL)isNewTask;

@end
