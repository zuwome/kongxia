//
//  ZZDateHelper.h
//  zuwome
//
//  Created by angBiu on 16/5/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZDateModel;

@interface ZZDateHelper : NSObject

+ (instancetype)shareInstance;

/**
 相册视频的时候转换时间秒
 */
- (NSString *)photoAlbumDateChangeToTimeStrWithDate:(NSDate *)date;
/**
 *  获取完整时间(含秒数)
 *
 *  @param date date
 *
 *  @return 例: 2000-11-11 11:11:11

 */
- (NSString *)chindDateFormate:(NSDate *)update;
/**
 *  获取完整时间
 *
 *  @param date date
 *
 *  @return 例: 2000-11-11 11:11
 */
- (NSString *)getDateStringWithDate:(NSDate *)date;

/**
 *  通过时间字符串获取date
 *
 *  @param dateString <#dateString description#>
 *
 *  @return <#return value description#>
 */
- (NSDate *)getDateWithDateString:(NSString *)dateString;

- (NSDate *)getLocalDateWithString:(NSString *)dateString;

/**
 *  通过时间字符串获取date 时分秒
 *
 *  @param dateString 2016-09-14 11:13:26
 *
 *  @return 2016-09-14 11:13:26
 */
- (NSDate *)getDetailDataWithDateString:(NSString *)dateString;

/**
 *  获取到日
 *
 *  @param date date
 *
 */
- (NSString *)getDayStringWithDate:(NSDate *)date;

- (BOOL)isGreaterThan30:(NSString *)serverTime;

/**
 *  判断是不是同一天(精确到天)
 */
- (BOOL)isTheSameDay:(NSString *)serverTime;

/**
*  判断是不是同一天(精确到小时)
*/
- (BOOL)isTheSamepreciseDay:(NSString *)serverTime;

/**
 *  获取到日
 *
 *  @param date date
 *
 *  @return 例:11
 */
- (NSString *)getCurrentExactDay;




/**
 *  获取日后面具体时间
 *
 *  @param date date
 *
 *  @return 例:11：11
 */
- (NSString *)getDetailDateStringWithDate:(NSDate *)date;

/**
 获取 小时

 @param date date
 @return xiaoshi
 */
- (NSString *)getDateHourStringWithDate:(NSDate *)date;

/**
 获取 分钟
 
 @param date date
 @return 分钟
 */
- (NSString *)getDateMinuteStringWithDate:(NSDate *)date;

/**
 *  聊天downview展示的时间
 *
 *  @param dateString dateString
 *
 *  @return 今天、明天、后天 星期一 下星期一一
 */
- (NSString *)getShowDateStringWithDateString:(NSString *)dateString;

- (NSDate *)getNextDays:(NSInteger)days date:(NSDate *)date;

/**
 获取后面几天的时间

 @param days <#days description#>
 @return <#return value description#>
 */
- (NSDate *)getNextDays:(NSInteger)days;

/**
 *  获取后面几个小时的时间
 *
 *  @param hours <#hours description#>
 *
 *  @return <#return value description#>
 */
- (NSDate *)getNextHours:(NSInteger)hours;

/**
 *  2010年12月10日
 *
 *  @param dateString string
 *
 *  @return 2010年12月10日
 */
- (NSString *)getOrderTimeStringWithDateString:(NSString *)dateString;

/**
 *  返回 下周一 24:00格式
 *
 *  @param dateString string
 *
 *  @return 下周一 24：00
 */
- (NSString *)getOrderDetailTimeStringWithDateString:(NSString *)dateString;

/**
 *  获取时间model
 *
 *  @param intervel 相差几天
 *
 *  @return zzdatemodel
 */
- (ZZDateModel *)getDateModelWithDays:(NSInteger)days;

/**
 *  聊天列表时间显示格式
 *
 *  @param secs <#secs description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)ConvertChatMessageTime:(long long)secs;

/**
 *  获取倒计时string
 *
 *  @param timeInterval 时间戳
 *
 *  @return 时分秒倒计时array
 */
- (NSMutableArray *)getCountDownStringArrayWithInterval:(NSTimeInterval)timeInterval;

/**
 *  判断消息是否可以撤回
 *
 *  @param interval <#interval description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isNearTime:(long long)interval;

/**
 *  获取尽快显示的时间
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)getQuickTimeStringWithDate:(NSDate *)date;

/**
 *  聊天界面里面的时间显示格式
 *
 *  @param secs <#secs description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)getMessageChatMessageTime:(long long)secs;

+ (NSString *)getCountdownTimeString:(NSInteger)during;

- (NSDateFormatter *)formatter;

/**
 获取当前的时间的年月日
 */
+ (NSString *)getCurrentDate;
/**
 获取当前的时间精确到天
 */
+ (NSString *)getCurrentDateDay ;

/**
 把服务器时间转换成本地时间
 */
+ (NSString *)localTime:(NSString *)serverTime;

/**
 把服务器时间转换成本地时间戳
 */
+ (NSString *)localTimeStampe:(NSString *)serverTime;

/**
 把服务器时间转换成本地时间
 */
+ (NSString *)localTime:(NSString *)serverTime dateType:(NSString *)dateType;

/*
    通告:是否超过最后的时间
 */
- (BOOL)taskIsPassLimitedTime:(NSString *)time;

/*
   是否超过7天
*/
- (BOOL)isPassAWeek:(NSString *)time;

/*
   是否超过15天
*/
- (BOOL)isPassFifteenDay:(NSString *)time;

/**
 根据小时获取
 凌晨：0-5
 早上：5-11
 中午：11-13
 下午：13-17
 傍晚：17-19
 晚上：19-24
 */
- (NSString *)hourDescript:(NSInteger)hour;

// 邀约订单根据当前小时;
- (NSInteger)getHourByDateStr:(NSString *)dateStr;

// 邀约订单根据当前小时显示文字
- (NSString *)hourDescriptByDateStr:(NSString *)dateStr;

// 邀约订单过期时间的显示
- (NSString *)deadLineDescriptByDateStr:(NSString *)dateStr;

/**
 *  任务显示时间
 *
 *  @param dateString dateString
 *
 *  @return 今天、明天、后天 星期一 下星期一一
 */
- (NSString *)showDateStringWithDateString:(NSString *)dateString;

/**
 * 22 - 8点
 */
- (BOOL)isLateNight:(NSString *)dateStr;

/**
 * 22 - 6点
 */
- (BOOL)isMidNight:(NSString *)dateStr;

/**
 * 通告的开始时间和现在相比
 */
- (BOOL)taskDatePassToday:(NSString *)dateStr;

/**
 * 分佣的时间显示
*/
- (NSString *)getCommissionTimeDesc:(NSString *)dateStr;

+ (NSString *)fetchCurrentTimeStampe;

- (NSString *)fetchTimeForKTV;

- (NSString *)currentTimeDescriptForKTVForRecord:(NSString *)serverTime;

- (NSString *)currentTimeDescriptForKTV:(NSString *)serverTime;

@end

