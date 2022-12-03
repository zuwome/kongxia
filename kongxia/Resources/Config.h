//
//  Config.h
//  zuwome
//
//  Created by angBiu on 16/5/24.
//  Copyright © 2016年 zz. All rights reserved.
//
#ifndef Config_h
#define Config_h

typedef NS_ENUM(NSInteger,NavigationType) {
    NavigationTypeGotoCenter = 0,    // 点击头像人脸检测完成要进入-我
    NavigationTypeRealname,          // 点击实名认证完成要进入 人脸检测
    NavigationTypeRent,              // 点击我要出租 认证完成要进入我的出租
    NavigationTypeUserLogin,         // 公众号账号登录和注册过来
    NavigationTypeUserCenter,        // 我那边修改图片 提示语要不同
    NavigationTypeNoPhotos,          // 首页过来没有人脸检测并且没有头像
    NavigationTypeHavePhotos,        // 首页过来没有人脸检测但有头像
    NavigationTypeAccountCancel,     // 账号注销
    NavigationTypeChangePhone,       // 修改手机号
    NavigationTypeRestartPhone,      // 重新启用手机号
    NavigationTypeChangePwd,         // 修改密码
    
    NavigationTypeUserInfo,          // 保存用户信息
//    NavigationTypeUserInfo,          // 保存用户信息
    NavigationTypeChat,              // 他人详情页点击聊天需要完善人脸/头像
    NavigationTypeFastChat,
    NavigationTypeOrder,             // 他人详情页点击马上预约需要完善人脸/头像
    NavigationTypeApplyTalent,       // 我的-申请达人需要完善人脸/头像
    NavigationTypeWeChat,            // 我的-我的微信需要完善人脸/头像
    NavigationTypeIDPhoto,           // 我的-我的证件照需要完善人脸/头像
    NavigationTypeRealName,          // 我的-实名认证需要完善人脸/头像
    NavigationTypeRealNameIndentify,
    NavigationTypeCashWithdrawal,    // 我的钱包-提现 需要完善人脸/头像
    NavigationTypeSnatchOrder,       // 闪租抢单 需要完善人脸/头像
    NavigationTypeSelfIntroduce,     // 编辑资料-达人视频 需要完善人脸/头像
    NavigationTypeOpenFastChat ,     // 闪聊-申请开通 需要完善人脸/头像
    NavigationTypeTiXian  ,          // 提现- 银行卡
    NavigationTypeDevicesLoginFirst,  // 设备首次登录
    NavigationTypePublishTask,
    NavigationTypeSignUpForTask,     // 报名
    NavigationTypeApplicantForTalent, // 我的-申请达人需要完善人脸/头像
    NavigationTypeRentInfoRealFace,
    NavigationTypeUnknow = -1,       // unknow
};

typedef NS_ENUM(NSInteger, ChangeMobileStep) {
    ChangeMobileStepVerifyOri = 0,
    ChangeMobileStepSetNewNumber,
};

//
// http://d4hi8h.natappfree.cc
#ifdef DEBUG
#define kBase_URL            @"https://www.movtrip.com" // 测试线
#else
#define kBase_URL            @"https://v2.zuwome.com" // 正式线
#endif

#ifdef DEBUG
#define kBase_URLWithouts            @"http://www.movtrip.com" // 测试线
#else
#define kBase_URLWithouts            @"http://v2.zuwome.com" // 正式线
#endif

#define PeopleTOP_URLStr(string)    [NSString stringWithFormat:@"%@/user/%@/priority/page?v=%@",kBase_URL, string, [UIApplication version]] //人气值
#ifdef DEBUG
#define kQNPrefix_url        @"http://img.movtrip.com/"
#else
#define kQNPrefix_url        @"http://img.zuwome.com/"

#endif

#ifdef DEBUG
#define kQNPrefix_url_h5        @"http://www.movtrip.com/"
#else
#define kQNPrefix_url_h5        @"http://www.zuwome.com/"

#endif

//#define kQNPrefix_url        @"http://7xqekd.com1.z0.glb.clouddn.com/"

#define kArPacketRaidersUrl     @"http://static.zuwome.com/red_packet/guide.html"
#define kArPacketRuleUrl        @"http://static.zuwome.com/red_packet/rule.html"

//通知
#define KMsg_CreateOrderNotification    @"KMsg_CreateOrderNotification" // 创建订单的通知
#define KMsg_TabbarRefreshNotification  @"KMsg_TabbarRefreshNotification" //双击tabbar刷新通知
#define kMsg_PushNotification           @"kMsg_PushNotification" //去调用 getunread
#define kMsg_NoticeToWindows            @"kMsg_NoticeToWindows"//通知需要弹窗告知帐号没挤下线
#define kMsg_OrderStatusChante          @"kUpdateOrderStatus"//订单状态更新
#define kMsg_UpdateOrder                @"OrderDidUpdateNotification"//更新订单
#define kMsg_UserLogin                  @"UserDidLoginNotification"//登录
#define kMsg_UserDidLogout              @"UserDidLogoutNotification"//退出登录
#define kMsg_ReceiveMessage             @"ReceiveMessage"//聊天收到消息
#define kMsg_ReceiveGiftChatMessage             @"kMsg_ReceiveGiftChatMessage"//聊天收到消息
#define kMsg_SendMessage                @"SendMessage"//聊天发送消息
#define kMsg_PushSystemPacket           @"PushSystemPacket"//系统扫脸红包 --- 扫脸红包已经没开启了
#define kMsg_AuthorityConfirm           @"AuthorityConfirm"//第一次安装APP的授权弹窗推送授权通知
#define kMsg_LocationConfirm           @"LocationConfirm"//第一次安装APP的授权弹窗推送授权通知
#define kMsg_RecordFinish               @"RecordFinish"//上传视频成功
#define kMsg_UploadUpdateVideo          @"UploadUpdateVideo"//视频重新录制
#define kMsg_VideoDataShouldUpdate      @"VideoDataShouldUpdate"//视频删除、上传、重录等需要几个页面刷新视频数据
#define kMsg_changeSanChatContent       @"changeSanChatContent"
#define kMsg_VideoUploadProgress        @"VideoUploadProgress"//重新上传视频进行中（时刻和么么答共用---主要为了失败重新上传进度）
#define kMsg_SuccessUploadVide          @"SuccessUploadVide"//成功重新上传视频（时刻和么么答共用---主要为了失败重新上传进度）
#define kMsg_FailureUploadVide          @"FailureUploadVide"//重新上传视频失败（时刻和么么答共用---主要为了失败重新上传进度）
#define kMsg_DeleteFailureVide          @"DeleteFailureVide"//删除上传失败的视频
#define kMsg_UserDidRegister            @"UserDidRegister"//用户注册成功
#define kMsg_UserErrorInfo              @"UserErrorInfo"//用户名或者头像錯误
#define kMsg_UpdateMessageBox           @"UpdateMessageBox"//消息盒子
#define kMsg_ReceiveMessageBox          @"ReceiveMessageBox "//收到消息盒子
#define kMsg_BurnAfterReadCount         @"BurnAfterReadCount"//阅后即焚倒计时
#define kMsg_AddUserBlack               @"AddUserBlack "//加入黑名单
#define kMsg_PublishedQuestion          @"PublishedQuestion"//发布问题成功
#define kMsg_ReceivePublishOrder        @"ReceivePublishOrder"//收到派单
#define kMsg_UpdateSnatchedPublishOrder @"UpdateSnatchedPublishOrder"//更新派单（已被抢）
#define kMsg_SnatchPublishOrder         @"PublishedQuestion"//派单被女方抢了
#define kMsg_AcceptSnatchOrder          @"AcceptSnatchOrder"//女方抢单男方接受了
#define kMsg_ConnectRoomData            @"ConnectRoomData"//接单接受连麦房间信息
#define kMsg_CancelConnect              @"CancelConnect"//男方发起连麦后取消
#define kMsg_RefuseConnect              @"RefuseConnect"//女方拒绝了连麦申请
#define kMsg_BusyConnect                @"BusyConnect"//女方忙
#define kMsg_NoFaceTimeout              @"NoFaceTimeout"//接单方一定时间没有露脸
#define kMsg_ConnectPushNotification    @"ConnectPushNotification"//连麦推送
#define kMsg_NewPublishOrder            @"NewPublishOrder"//收到新的派单
#define kMsg_UpdatePublishOrderIfNeed   @"UpdatePublishOrderIfNeed"//需要更新抢任务列表
#define kMsg_UpdatePublishingList       @"UpdatePublishingList"//发单方列表女方被抢更新
#define kMsg_UpdateTaskSnatchCount      @"UpdateTaskSnatchCount"//更新抢任务数目
#define KMsg_UpdateSnatchUnreadCount    @"KMsg_UpdateSnatchUnreadCount"//更新闪租未读数（只给闪租小红点使用）
#define kMsg_VideoBrokeRules            @"VideoBrokeRules"//视频违规挂断通知(涉黄等)
#define kMsg_SK_Zan_Status              @"kMsg_SK_Zan_Status"//时刻、录制视频赞状态发生变化
#define kMsg_MMD_Zan_Status             @"kMsg_MMD_Zan_Status"//么么哒视频赞发生变化
#define kMsg_UploadCompleted            @"kMsg_UploadCompleted"//达人视频上传，并保存用户信息完成
#define kMsg_UploadAuditFail            @"kMsg_UploadAuditFail"//达人视频审核失败通知返回
#define kMsg_FastChatFail               @"kMsg_FastChatFail"//闪聊视频审核失败
#define kMsg_ConnectVideoStar           @"kMsg_ConnectVideoStar"//对方点了接通视频，我方可以开始连接视频
#define kMsg_OpenFastChat               @"kMsg_OpenFastChat"//开通闪聊成功
#define kMsg_UpdatedAvatar              @"kMsg_UpdatedAvatar"//更新头像，用户判断是否更新成假头像
#define kMsg_UpdatedRentStatus          @"kMsg_UpdatedRentStatus"//出租状态，用户判断是否隐身了
#define kMsg_UpdatedGenderStatus        @"kMsg_UpdatedGenderStatus"//性别异常，重新更新身份证完成提醒
#define kMsg_PublicRecharge             @"kMsg_PublicRecharge"//收到公众号充值成功的回调，客户端需要更新么币余额
#define kMsg_PublishedTaskNotification  @"kMsg_PublishedTaskNotification" // 发布了任务
#define kMsg_UserRentInfoDidChanged     @"kMsg_UserRentInfoDidChanged" // 用户出租信息发生变化

#define kMsg_TaskStatusDidChanged       @"kMsg_TaskStatusDidChanged" // 任务状态发生变化
#define kMsg_TaskPickedNontification    @"kMsg_TaskPickedNontification" // 任务选人了,需要刷新列表
#define kMsg_TaskUnreadCountDidChanged  @"kMsg_TaskUnreadCountDidChanged" // 新的订单数量通知
#define kMsg_PublishBtnShowNotification @"kMsg_PublishBtnShowNotification" // 发布按钮隐藏显示

#define kMsg_OpenShanChatMessage        @"开启视频咨询，获取更多收益 》"

#define kMsg_Mebi_NO    @"您当前账户么币不足，请充值"

//首页列表滚动通知
#define SubTableCanNotScrollNotify  @"SubTableCanNotScrollNotify"

//当前订单的支付数据（用于验证支付结果）
#define kPaymentData    @"kPaymentData"



//体重保密
#define kSecretWeight               -1

//左键间距
#define kLeftEdgeInset              -11

//订单尽快
#define kOrderQuickTimeString       @"尽快"

#define kMmemejunUid                @"56ca13fd6ae1450848c75945"//么么君的id（暂未生成这个账号）
#define kCustomerServiceId          @"KEFU146288374711644"//客服的uid
#define kEnableVideoKey             @"kEnableVideoKey"//连麦记录是否开启了镜头
#define DEVICE_ONLY_KEY             (@"DEVICE_ONLY_KEY")//设备唯一标识key

#define CHINESE_SYSTEM(x) [UIFont systemFontOfSize:x]
//自适应宽度
#define AdaptedWidth(x)  ceilf((x)/375.0f * SCREEN_WIDTH)
//自适应高度
#define AdaptedHeight(x) ceilf((x)/667.0f * SCREEN_HEIGHT)
//自适应字体
#define AdaptedFontSize(R)     CHINESE_SYSTEM(AdaptedWidth(R))
#define ADaptedFontSCBoldSize(R)  [UIFont fontWithName:@"PingFang-SC-Bold" size:R]?[UIFont fontWithName:@"PingFang-SC-Bold" size:R]:[UIFont fontWithName:@"Helvetica-Bold" size:R]
#define ADaptedFontMediumSize(R)  [UIFont fontWithName:@"PingFangSC-Medium" size:R]?[UIFont fontWithName:@"PingFangSC-Medium" size:R]:[UIFont fontWithName:@"Helvetica-Bold" size:R]



#define ADaptedFuturaBoldSize(R)  [UIFont fontWithName:@"Futura-Bold" size:R]?[UIFont fontWithName:@"Futura-Bold" size:R]:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:R]

#define ADaptedFontBoldSize(R)  [UIFont fontWithName:@"PingFangSC-Semibold" size:R]?[UIFont fontWithName:@"PingFangSC-Semibold" size:R]:[UIFont fontWithName:@"Helvetica-Bold" size:R]
#define CustomFont(R)   [UIFont systemFontOfSize:R]
//获取当前屏幕高
//#define  SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//获取当前屏幕宽
//#define  SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

// 所有视频列表页面，视频的最大高度
#define  VIDEO_MAX_HEIGHT   ((SCREEN_WIDTH - 15) / 2.0 * 13 / 11.5)

//导航栏+状态栏高度navigationBar
#define NAVIGATIONBAR_HEIGHT        (SCREEN_HEIGHT >= 812.0 ? 88 : 64)
//底部圆角宏
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)
//状态栏高度 iPhoneX状态栏44
#define STATUSBAR_HEIGHT            (SCREEN_HEIGHT == 812.0 ? 44 : 20)
//状态栏的bar返回按钮移动高度
#define STATUSBARBar_HEIGHT            (SCREEN_HEIGHT == 812.0 ? 12 : 0)
//顶部状态栏新增加高度
#define STATUSBARBar_ADD_HEIGHT            (SCREEN_HEIGHT == 812.0 ? 48 : 32)
//顶部距离导航中心的距离偏移
#define STATUSBARBar_Center           (SCREEN_HEIGHT == 812.0 ? 22 : 10)

/**
 *  设别类型
 */
#define IPHONE_DEVICE (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
#define IPAD_DEVICE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IPHONE_DEVICE_UUID ([UIDevice currentDevice].identifierForVendor.UUIDString)

/**
 *  系统缩放系数
 */
#define SCALE_SIZE (IPAD_DEVICE ? (SCREEN_WIDTH / (SCREEN_HEIGHT > SCREEN_WIDTH ? 768.0 : 1024.0)) :(SCREEN_WIDTH / (SCREEN_HEIGHT > SCREEN_WIDTH ? 375.0 : 667.0)))

#define ZXDefaltMargin SCALE_SET(15)

/**
 *  系统缩放调整
 */

#define SCALE_SET(VALUES) (SCALE_SIZE * (VALUES))


#define iPhoneXShowCallVideo  (SCREEN_HEIGHT == 812.0 ? 70 : 0)
#define  IOS_11_NO_Show   if (@available(iOS 11.0, *)) {\
[UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
[UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
[UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
}
#define  IOS_11_Show   if (@available(iOS 11.0, *)) {\
[UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;\
[UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;\
[UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;\
}
//状态栏的bar的高度
#define  STATUSBARBar_Y_HEIGHT NAVIGATIONBAR_HEIGHT-44-STATUSBARBar_HEIGHT
//Tabbar 高度
#define TABBAR_HEIGHT               (SCREEN_HEIGHT == 812.0 ? 83 : 49)

#define isFullScreenDevice           (SCREEN_HEIGHT >= 812.0)

#define isIPhoneX                   (SCREEN_HEIGHT == 812.0)

#define isIPhoneXsMax                   (SCREEN_HEIGHT == 896.0)

//weakself
#define WeakSelf __weak typeof(self)weakSelf = self;

#define WEAK_OBJECT(obj, weakObj)       __weak typeof(obj) weakObj = obj;
#define WEAK_SELF()                     WEAK_OBJECT(self, weakSelf);

/**
 * 生成 commonInit 方法
 */
#define commonInitSafe(className)                   [self className ## _commonInit]
#define commonInitImplementationSafe(className)     -(void) className##_commonInit

/**
 *  安全地调用 block
 */
#define BLOCK_SAFE_CALLS(block, ...) block ? block(__VA_ARGS__) : nil

#define BLOCK_SAFE_CALLS_In_Main_Queue(block, ...) block ? dispatch_async(dispatch_get_main_queue(), ^{ block(__VA_ARGS__); }) : nil

/**
 * 通知相关
 */
#define BIND_MSG_WITH_OBSERVER(OBSERVER, STRID, SELECTOR, OBJ)   [[NSNotificationCenter defaultCenter] addObserver:OBSERVER  \
selector:SELECTOR      \
name:STRID         \
object:OBJ];

#define BIND_MSG_WITH_OBJ(STRID, SELECTOR, OBJ)     BIND_MSG_WITH_OBSERVER(self, STRID, SELECTOR, OBJ);

#define BIND_MSG(STRID, SELECTOR)                   BIND_MSG_WITH_OBJ(STRID, SELECTOR, nil);

#define POST_MSG_WITH_OBJ_DICT(aName, anObject, aUserInfo)     [[NSNotificationCenter defaultCenter] \
postNotificationName:aName \
object:anObject \
userInfo:aUserInfo]
#define POST_MSG_WITH_OBJ(aName, anObject)      POST_MSG_WITH_OBJ_DICT(aName, anObject, nil)
#define POST_MSG(aName)                         POST_MSG_WITH_OBJ(aName, nil)

#define REMOVE_MSG(STRID)       [[NSNotificationCenter defaultCenter] removeObserver:self name:STRID object:nil];
#define REMOVE_ALL_MSG()        [[NSNotificationCenter defaultCenter] removeObserver:self]

//判断是否空字符串
#define isNullString(s)     ((!s) || [s isEqual:[NSNull null]] || [s isEqualToString:@""])

//判断系统版本做高度偏移
#define  OFFSET_SYSTEMVERSION (([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0 )?0:-20)

//RGB颜色设置
//#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

//RGBA颜色设置
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 十六进制颜色设置
//#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 十六进制颜色设置
#define HEXACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

// 判断iOS7 或者7 之后
#define IOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//判断是否是iOS8及以上
#define IOS8_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//判断是否是iOS9及以上
#define IOS9_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

//判断是否是iOS10及以上
#define IOS10_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

//判断是否是iOS11及以上
#define IOS11_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)


#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 9.0)
#define IOS8_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

// 判断iPhone4
#define ISiPhone4       CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(640, 960))

// 判断iPhone5
#define ISiPhone5       CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(640, 1136))

// 判断iPhone6
#define ISiPhone6       CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(750, 1334))

//判断iPhone6p
#define ISiPhone6P      CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(1242, 2208))

// 背景色
#define kBGColor                HEXCOLOR(0xF5F5F5)

// 黑色文字
#define kBlackTextColor         HEXCOLOR(0x000000)

/// 黑色文字  63 58 58
#define kBlackColor             HEXCOLOR(0x3f3a3a)

// 灰色文字
#define kGrayTextColor          HEXCOLOR(0xababab)

//深灰色文字
#define kGrayContentColor       HEXCOLOR(0x808080)

//评论灰色字(7A7A7B)
#define kGrayCommentColor       HEXCOLOR(0x7A7A7B)

//灰色的线
#define kGrayLineColor          HEXCOLOR(0xD8D8D8)

//灰色线颜色
#define kLineViewColor          HEXCOLOR(0xededed)

//黄色
#define kYellowColor            HEXCOLOR(0xF4CB07)

//红色
#define kRedColor               HEXCOLOR(0xF42407)
#define kUploadRedColor         HEXCOLOR(0xec0005)

//红色字体
#define kRedTextColor           HEXCOLOR(0xFD5F66)

//红点颜色
//#define kRedPointColor          HEXCOLOR(0xF32426)
#define kRedPointColor          HEXCOLOR(0xFA595A)

//蓝色颜色
#define kBlueColor              HEXCOLOR(0xF32426)

//棕灰色   rgb:102, 102, 102
#define kBrownishGreyColor      HEXCOLOR(0x666666)

//日光黄   rgb:255, 223, 54
#define kSunYellow              HEXCOLOR(0xFFDF36)

//金菊色
#define kGoldenRod              HEXCOLOR(0xF0C20D)

//rgb:252, 47, 82
#define kReddishPink            HEXCOLOR(0xFC2F52)

//Warm Gray rgb:153, 153, 153
#define kWarmGray               HEXCOLOR(0x999999)

//石板灰   rgb:230, 230, 230
#define kStoneGray              HEXCOLOR(0xE6E6E6)

/* 默认图片 */

// 选择达人
#define defaultBackgroundImage_SelectTalent ([UIImage imageFromColor:RGBCOLOR(242, 242, 242)])

#define INT_TO_STRING(i)        [NSString stringWithFormat:@"%zd",i]
#define DOUBLE_TO_STRING(i)        [NSString stringWithFormat:@"%f",i]

#define ZWM_YELLOW @"#F4CB07"

#ifdef DEBUG
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

//弱引用申明
#define WS(weakSelf) __weak typeof(self)weakSelf = self



//=====================单例==================
// @interface
#define singleton_interface(className) \
+ (className *)shared;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
static dispatch_once_t singleton_onceToken; \
static dispatch_once_t singleton_share_onceToken; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
dispatch_once(&singleton_onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared \
{ \
dispatch_once(&singleton_share_onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
typedef NS_ENUM(NSInteger, ShowHUDType) {
    ShowHUDType_OpenSanChat =100,//开通闪聊的提示
    ShowHUDType_OpenRentSuccess,//开通闪租的提示
};
#endif /* Config_h */
