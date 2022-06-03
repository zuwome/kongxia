//
//  ZZUtils.h
//  zuwome
//
//  Created by angBiu on 16/5/31.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZUser.h"
#import "ZZVideoHelper.h"

@interface ZZUtils : NSObject
/**
 *  计算字符字节长度
 *
 *  @param string string
 *
 *  @return 返回字符字节长度
 */
+ (NSUInteger)lenghtWithString:(NSString *)string;

+ (BOOL)isAllowPhotoLibrary;
/**
 *  是否允许相机访问
 */
+ (BOOL)isAllowCamera;
/**
 *  是否允许麦克风访问
 */
+ (BOOL)isAllowAudio;
/**
 *  是否允许定位
 */
+ (BOOL)isAllowLocation;
/**
 *  是否允许通知
 */
+ (BOOL)isAllowNotification;
/**
 *  是否允许访问通讯录
 */
+ (void)checkContactAuthorization:(void(^)(bool isAuthorized))block;

// 计算 text 对应的高度
+ (CGFloat)heightForCellWithText:(NSString *)contentText fontSize:(CGFloat)labelFont labelWidth:(CGFloat)labelWidth;

//计算 text 对应的宽度
+ (CGFloat)widthForCellWithText:(NSString *)contentText fontSize:(CGFloat)labelFont;


/**
 根据json返回dictionary

 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 字典转json
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

//是否是手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;


/**
 密码是否复杂
 注*必须是字母和数字混排
 @param passwordString 密码
 @return yes 是
 */
+ (BOOL)isThePasswordNotTooSimpleWithPasswordString:(NSString *)passwordString;

//手机号加密处理
+ (NSString *)encryptPhone:(NSString *)phoen;

//设置textField在不是整数情况下只能输入一个小数点 并且小数点后只有两位
+ (BOOL)limitTextFieldWithTextField:(UITextField *)textField range:(NSRange)range replacementString:(NSString *)string pure:(BOOL)pure;

/**
 设置首字母不能为0 或小数点
 且最多只能有1个小数点
 */
+ (BOOL)limitTextFieldWithTextField:(UITextField *)textField range:(NSRange)range replacementString:(NSString *)string;
//是否整形
+ (BOOL)isPureInt:(NSString *)string;

//图片压缩
+ (NSData *)imageRepresentationDataWithImage:(UIImage *)image;

//个人页压缩图片
+ (NSData *)userImageRepresentationDataWithImage:(UIImage *)image;

+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

//版本判断
+ (BOOL)canPlayAudioWithVersion:(NSString *)version;

//获取版本号
+ (NSString *)getVersionString;

//获取标签高度（个人页）
+ (CGFloat)getLabelHeight:(NSArray *)labelArray;

//获取常出没地点高度（个人页）
+ (CGFloat)getMyLocationLabelHeight:(NSArray *)labelArray;

//获取标签高度 (么么答)
+ (CGFloat)getTagViewHeight:(NSArray *)tagArray fontSize:(CGFloat)fontSize padding:(UIEdgeInsets)padding lineSpacing:(CGFloat)lineSpacing interitemSpacing:(CGFloat)interitemSpacing maxWidth:(CGFloat)maxWidth;

+ (void)networkReachability:(void (^)(void))block;

//是否被封禁了
+ (BOOL)isBan;

//是否是全部空格字符串
+ (BOOL)isEmpty:(NSString *)str;

+ (void)clearMemoryCache;

+ (void)managerUnread;

+ (UIImage *)imageWithName:(NSString *)name;

+ (NSString *)deleteEmptyStrWithString:(NSString *)string;

//生成二维码图片
+ (UIImage *)createQRCodeImgWithString:(NSString *)string imgHeight:(CGFloat)imgHeight;

//给图片上色
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

//两张图片合成一张图片
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;

//把图片2合成到图片1中心位置
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 size:(CGSize)size;
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 rect:(CGRect)rect;

//修改图片尺寸
+ (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;

//scrollview截图
+ (UIImage *)getScrollViewimage:(UIScrollView *)scrollView;

//view截图
+ (UIImage *)getViewImage:(UIView *)view;

// 这个方法是拿到当前正在显示的控制器，不管是push进去的，还是present进去的都能拿到
+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc;

+ (NSString*)deviceVersion;

+ (NSMutableAttributedString *)setLineSpace:(NSString *)string space:(CGFloat)space fontSize:(CGFloat)fontSize color:(UIColor *)color;

+ (NSMutableAttributedString *)setWordSpace:(NSString *)string space:(CGFloat)space fontSize:(CGFloat)fontSize color:(UIColor *)color;

//设置计数显示形式 (k、w)
+ (NSString *)getCountStringWithCount:(NSInteger)count;

/**
 小数点精度返回
 */
+ (NSString *)dealAccuracyNumber:(NSNumber *)number;
+ (NSString *)dealAccuracyDouble:(double)value;

/**
 是否已身份认证
 */
+ (BOOL)isIdentifierAuthority:(ZZUser *)user;
/**
 图片慢慢显示出来的动画
 */
+ (void)imageLoadAnimation:(UIImageView *)imageView imageUrl:(NSURL *)imageUrl;
/**
 获取视频的封面
 */
+ (UIImage *)getThumbImageWithVideoUrl:(NSURL *)videoUrl;

/**
 返回用户的昵称（添加了备注）
 */
+ (NSString *)getUserShowName:(ZZUser *)user;
/**
 *  检测对象是否存在该属性
 */
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName;

/**
 检测用户是否登录未登录直接去登录
 */
+ (BOOL)isUserLogin;

/**
 获取消息时长
 */
+ (NSUInteger)getVideoTimeDuring:(NSURL *)videoPth;

/**
 名字*号处理
 */
+ (NSString *)dealUserNameWithStar:(NSString *)name;

/**
 浮点型对比
 */
+ (NSComparisonResult)compareWithValue1:(id)value1 value2:(id)value2;

/**
 连麦过程中是否余额不足了
 */
+ (BOOL)liveStreamIsLowBalance:(CGFloat)money;

/**
 连麦时发送一些状态的命令消息
 */
+ (void)sendCommand:(NSString *)name uid:(NSString *)uid param:(NSDictionary *)param;
/**
 *  是否正在连麦
 */
+ (BOOL)isConnecting;
/**
 *  是否允许进行录制视频
 */
+ (BOOL)isAllowRecord;

+ (void)checkRecodeAuth:(Authorized)auth;


/**
 去掉首尾的空格

 */
+ (NSString *)removeSpaceAndNewline:(NSString *)str;

/**
 绘制渐变色颜色的方法

 @param view 要绘制的view
 @param fromHexColor 开始的颜色
 @param toHexColor 结束的颜色
 @param endPoint 结束的位置
 @param locationsArray 渐变的分割点
 @param type CAGradientLayer 的唯一标示
 */
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColor toColor:(UIColor *)toHexColor endPoint:(CGPoint )endPoint locations:(NSArray *)locationsArray type:(NSString *)type;

+ (CAGradientLayer *)setGradientColor:(NSArray<UIColor *> *)colorsArr locations:(NSArray<NSNumber *> *)locationsArr start:(CGPoint)startPoint end:(CGPoint)endPoint inView:(UIView *)view;

/**
 模糊图片

 @param image 要模糊的图片
 @param blur <#blur description#>
 @return 模糊后的图片
 */
+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

/**
 比较两个版本号
 */
+ (NSComparisonResult)compareVersionFrom:(NSString *)from to:(NSString *)to;

/**
 *  计算两个人的距离
 */
+ (CGFloat)calculateLocation:(CLLocation *)location toMy:(CLLocation *)myLocation;
@end
