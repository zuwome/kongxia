//
//  ZZDateHelper.m
//  zuwome
//
//  Created by angBiu on 16/5/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZDateHelper.h"
#import "ZZDatePicker.h"

@interface ZZDateHelper ()

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) NSDateFormatter *localFormatter;

@end

@implementation ZZDateHelper

+ (instancetype)shareInstance {
    __strong static id sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

/**
 相册视频的时候转换时间秒
 */
- (NSString *)photoAlbumDateChangeToTimeStrWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [ZZDateHelper shareInstance].formatter;
    formatter.dateFormat = @"mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

/**
 返回含有秒数的时间
 */
- (NSString *)chindDateFormate:(NSDate *)update {
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [self.formatter stringFromDate:update];
    return destDateString;
}

- (NSString *)getDateStringWithDate:(NSDate *)date {
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [self.formatter stringFromDate:date];
    return dateString;
}

- (NSDate *)getDateWithDateString:(NSString *)dateString {
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [self.formatter dateFromString:dateString];
    return date;
}

- (NSDate *)getLocalDateWithString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

- (NSDate *)getDetailDataWithDateString:(NSString *)dateString {
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [self.formatter dateFromString:dateString];
    return date;
}

- (NSString *)getDayStringWithDate:(NSDate *)date {
    [self.formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [self.formatter stringFromDate:date];
    return dateString;
}

- (BOOL)isGreaterThan30:(NSString *)serverTime {
    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
    serverFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    
    serverFormatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *serverDate = [serverFormatter dateFromString:serverTime];
    
    // 当前的时间
    NSDate *nowDate = [NSDate date];
    if (nowDate && serverDate) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitDay;
        
        NSDateComponents *delta = [calendar components:unit fromDate:serverDate toDate:nowDate options:0];
        
        if (delta.day >= 30) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}

- (BOOL)isTheSameDay:(NSString *)serverTime {

    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
    serverFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    
    serverFormatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *serverDate = [serverFormatter dateFromString:serverTime];
    
    // 当前的时间
    NSDate *nowDate = [NSDate date];
    if (nowDate && serverDate) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
        
        NSDateComponents *serverComponent = [calendar components:unit fromDate:serverDate];
        NSDateComponents *nowComponent = [calendar components:unit fromDate:nowDate];
        
        return serverComponent.day == nowComponent.day && serverComponent.month == nowComponent.month && serverComponent.year == nowComponent.year;
    }
    else {
        return NO;
    }
}

/**
*  判断是不是同一天(精确到小时)
*/
- (BOOL)isTheSamepreciseDay:(NSString *)serverTime {
    // 服务器返回的最后一次登录时间
    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
    serverFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    
    serverFormatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *serverDate = [serverFormatter dateFromString:serverTime];
    
    
    // 当前的时间
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *serverComponent = [calendar components:unit fromDate:serverDate];
    NSDateComponents *nowComponent = [calendar components:unit fromDate:nowDate];
    
    return serverComponent.day == nowComponent.day && serverComponent.month == nowComponent.month && serverComponent.year == nowComponent.year;
}

- (NSString *)getCurrentExactDay {
    NSDate *date = [NSDate date];
    [self.formatter setDateFormat:@"dd"];
    NSString *dateString = [self.formatter stringFromDate:date];
    return dateString;
}

- (NSString *)getDetailDateStringWithDate:(NSDate *)date {
    [self.formatter setDateFormat:@"HH:mm"];
    NSString *dateString = [self.formatter stringFromDate:date];
    return dateString;
}

- (NSString *)getDateHourStringWithDate:(NSDate *)date {
    [self.formatter setDateFormat:@"HH"];
    NSString *dateString = [self.formatter stringFromDate:date];
    return dateString;
}

- (NSString *)getDateMinuteStringWithDate:(NSDate *)date{
    [self.formatter setDateFormat:@"mm"];
    NSString *dateString = [self.formatter stringFromDate:date];
    return dateString;
}

- (NSString *)getShowDateStringWithDateString:(NSString *)dateString {
    //根据字符串获取date
    [self.formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [self.formatter dateFromString:dateString];
    NSDate *todayDate = [NSDate date];
    
    //获取date所在星期几
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger index = [comps weekday];
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger todayIndex = [comps weekday];
    NSString *showString;
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&todayDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [calendar components:NSDayCalendarUnit fromDate:todayDate toDate:date options:0];
    
    if (dayComponents.day < 1) {
        showString = [NSString stringWithFormat:@"今天"];
    } else if (dayComponents.day < 2) {
        showString = [NSString stringWithFormat:@"明天"];
    } else if (dayComponents.day < 3) {
        showString = [NSString stringWithFormat:@"后天"];
    } else if (dayComponents.day + todayIndex < 9) {
        showString = [NSString stringWithFormat:@"%@",weekdays[index]];
    } else if (dayComponents.day + todayIndex < 16) {
        showString = [NSString stringWithFormat:@"下%@",weekdays[index]];
    } else {
        showString = [NSString stringWithFormat:@"下下%@",weekdays[index]];
    }
    
    return showString;
}

- (NSString *)getOrderTimeStringWithDateString:(NSString *)dateString
{
    NSString *detailString = [dateString substringToIndex:10];
    detailString = [detailString stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    detailString = [detailString stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    detailString = [detailString stringByAppendingString:@"日"];
    
    return detailString;
}

- (NSString *)getOrderDetailTimeStringWithDateString:(NSString *)dateString
{
    //根据字符串获取date
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [self.formatter dateFromString:dateString];
    NSDate *todayDate = [NSDate date];
    NSString *timeString = [self getDetailDateStringWithDate:date];
    
    if ([date compare:todayDate] == NSOrderedAscending) {
        return timeString;
    }
    
    //获取date所在星期几
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger index = [comps weekday];
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger todayIndex = [comps weekday];
    NSString *showString;
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&todayDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [calendar components:NSDayCalendarUnit fromDate:todayDate toDate:date options:0];
    
    if (dayComponents.day < 1) {
        showString = [NSString stringWithFormat:@"今天 %@",timeString];
    } else if (dayComponents.day < 2) {
        showString = [NSString stringWithFormat:@"明天 %@",timeString];
    } else if (dayComponents.day < 3) {
        showString = [NSString stringWithFormat:@"后天 %@",timeString];
    } else if (dayComponents.day + todayIndex < 9) {
        showString = [NSString stringWithFormat:@"%@ %@",weekdays[index],timeString];
    } else if (dayComponents.day + todayIndex < 16) {
        showString = [NSString stringWithFormat:@"下%@ %@",weekdays[index],timeString];
    } else {
        showString = [NSString stringWithFormat:@"下下%@ %@",weekdays[index],timeString];
    }
    return showString;
}

- (NSDate *)getNextDays:(NSInteger)days date:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setDay:+days];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    return newdate;
}

- (NSDate *)getNextDays:(NSInteger)days
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setDay:+days];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    return newdate;
}

- (NSDate *)getNextHours:(NSInteger)hours
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    [adcomps setWeekday:0];
    
    [adcomps setDay:0];
    
    [adcomps setHour:+hours];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    return newdate;
}

- (ZZDateModel *)getDateModelWithDays:(NSInteger)days
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setDay:+days];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    ZZDateModel *model = [[ZZDateModel alloc] init];
    NSString *dateString = [self getDayStringWithDate:newdate];
    model.timeString = dateString;
    model.showString = [self getShowDateStringWithDateString:dateString];
    
    return model;
}

- (NSString*)ConvertChatMessageTime:(long long)secs
{
    NSString *timeText=nil;
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs/1000];
    
    [self.formatter setDateFormat:@"MM:dd"];
    
    NSString *strMsgDay = [self.formatter stringFromDate:messageDate];
    
    NSDate *now = [NSDate date];
    
    NSString* strToday = [self.formatter stringFromDate:now];
    
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24*60*60)];
    
    NSString *strYesterday = [self.formatter stringFromDate:yesterday];
    
    if ([strMsgDay isEqualToString:strToday]) {
        [self.formatter setDateFormat:@"HH':'mm"];
    }else if([strMsgDay isEqualToString:strYesterday]) {
        [self.formatter setDateFormat:@"昨天"];
    }
    else {
        [self.formatter setDateFormat:@"MM-dd"];
    }
    
    timeText = [self.formatter stringFromDate:messageDate];
    
    return timeText;
}

- (NSMutableArray *)getCountDownStringArrayWithInterval:(NSTimeInterval)timeInterval
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *hourString = @"00";
    NSString *minuteString = @"00";
    NSString *secondString = @"00";
    
    int hours = (int)(timeInterval/3600);
    int minute = (int)(timeInterval-hours*3600)/60;
    int second = timeInterval-hours*3600-minute*60;
    
    if (hours < 10) {
        hourString = [NSString stringWithFormat:@"0%d",hours];
    } else {
        hourString = [NSString stringWithFormat:@"%d",hours];
    }
    if (minute < 10) {
        minuteString = [NSString stringWithFormat:@"0%d",minute];
    } else {
        minuteString = [NSString stringWithFormat:@"%d",minute];
    }
    if (second < 10) {
        secondString = [NSString stringWithFormat:@"0%d",second];
    } else {
        secondString = [NSString stringWithFormat:@"%d",second];
    }
    
    [array addObject:hourString];
    [array addObject:minuteString];
    [array addObject:secondString];
    return array;
}

+ (BOOL)isNearTime:(long long)interval
{
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:messageDate];
    
    if (timeInterval > 2*60) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)getQuickTimeStringWithDate:(NSDate *)date
{
    NSString *string = [self getDetailDateStringWithDate:date];
    
    [self.formatter setDateFormat:@"MM-dd"];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [today dateByAddingTimeInterval:secondsPerDay];
    
    NSString * todayString = [self.formatter stringFromDate:today];
    NSString * tomorrowString = [self.formatter stringFromDate:tomorrow];
    
    NSString * dateString = [self.formatter stringFromDate:date];
    
    if ([dateString isEqualToString:todayString]) {
        string = [NSString stringWithFormat:@"（今天%@前）",string];
    } else if ([dateString isEqualToString:tomorrowString]) {
        string = [NSString stringWithFormat:@"（明天%@前）",string];
    } else {
        string = nil;
    }
    
    return string;
}

- (NSString*)getMessageChatMessageTime:(long long)secs
{
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs/1000];
    [self.formatter setLocale:[NSLocale systemLocale]];
    [self.formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [self.formatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:messageDate];
    NSDate *msgDate = [cal dateFromComponents:components];
    
    NSString *weekday = [self getWeekdayWithNumber:components.weekday];
    
    components = [cal components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    NSInteger hour = [[self getDateHourStringWithDate:messageDate] integerValue];
    NSInteger count = hour/3;
    NSString *moringString = @"上午";
    switch (count) {
        case 0:
        {
            moringString = @"拂晓";
        }
            break;
        case 1:
        {
            moringString = @"黎明";
        }
            break;
        case 2:
        {
            moringString = @"清晨";
        }
            break;
        case 3:
        {
            moringString = @"上午";
        }
            break;
        case 4:
        {
            moringString = @"中午";
        }
            break;
        case 5:
        {
            moringString = @"下午";
        }
            break;
        case 6:
        {
            moringString = @"傍晚";
        }
            break;
        case 7:
        {
            moringString = @"深夜";
        }
            break;
        default:
            break;
    }
    if (hour > 12) {
        hour = hour - 12;
    }
    
    if([today isEqualToDate:msgDate]){
        [self.formatter setDateFormat:[NSString stringWithFormat:@"%@ %ld:mm",moringString,hour]];
        return [self.formatter stringFromDate:messageDate];
    }
    
    components.day -= 1;
    NSDate *yestoday = [cal dateFromComponents:components];
    if([yestoday isEqualToDate:msgDate]){
        [self.formatter setDateFormat:[NSString stringWithFormat:@"昨天 %@ %ld:mm",moringString,hour]];
        return [self.formatter stringFromDate:messageDate];
    }
    
    for (int i = 1; i <= 6; i++) {
        components.day -= 1;
        NSDate *nowdate = [cal dateFromComponents:components];
        if([nowdate isEqualToDate:msgDate]){
            [self.formatter setDateFormat:[NSString stringWithFormat:@"%@ %@ %ld:mm",weekday,moringString,hour]];
            return [self.formatter stringFromDate:messageDate];
        }
    }
    
    while (1) {
        components.day -= 1;
        NSDate *nowdate = [cal dateFromComponents:components];
        if ([nowdate isEqualToDate:msgDate]) {
            [self.formatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
            return [self.formatter stringFromDate:messageDate];
            break;
        }
    }
}

//1代表星期日、如此类推
- (NSString *)getWeekdayWithNumber:(NSInteger)number
{
    switch (number) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
}

+ (NSString *)getCountdownTimeString:(NSInteger)during
{
    NSInteger minute = during/60;
    NSInteger second = during%60;
    NSString *timeString = @"";
    if (minute < 10) {
        timeString = [NSString stringWithFormat:@"0%ld",minute];
    } else {
        timeString = [NSString stringWithFormat:@"%ld",minute];
    }
    if (second < 10) {
        timeString = [NSString stringWithFormat:@"%@:0%ld",timeString,second];
    } else {
        timeString = [NSString stringWithFormat:@"%@:%ld",timeString,second];
    }
    return timeString;
}


/**
 获取当前的时间的年月日
 */
+ (NSString *)getCurrentDate {
    NSDate *todayDate = [NSDate date];
    [[ZZDateHelper shareInstance].formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString = [[ZZDateHelper shareInstance].formatter stringFromDate:todayDate];
    return timeString;
}
/**
 获取当前的时间精确到天
 */
+ (NSString *)getCurrentDateDay {
    NSDate *todayDate = [NSDate date];
    [[ZZDateHelper shareInstance].formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeString = [[ZZDateHelper shareInstance].formatter stringFromDate:todayDate];
    return timeString;
}

- (NSString *)showDateStringWithDateString:(NSString *)dateString {
    if (isNullString(dateString)) {
        return dateString;
    }
    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
    serverFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    serverFormatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *localdate = [serverFormatter dateFromString:dateString];
    
    serverFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *localTimeStr = [serverFormatter stringFromDate:localdate];
    NSDate *date = [serverFormatter dateFromString:localTimeStr];
 
    NSDate *todayDate = [NSDate date];
    
    if ([date compare:todayDate] == NSOrderedAscending) {
        return localTimeStr;
    }
    
    //获取date所在星期几
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear
                        | NSCalendarUnitMonth
                        | NSCalendarUnitDay
                        | NSCalendarUnitWeekday
                        | NSCalendarUnitHour
                        | NSCalendarUnitMinute
                        | NSCalendarUnitSecond;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger index = [comps weekday];
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger todayIndex = [comps weekday];
    
    
    [calendar rangeOfUnit:NSCalendarUnitDay
                startDate:&todayDate
                 interval:NULL
                  forDate:[NSDate date]];
    
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitDay
                                                  fromDate:todayDate
                                                    toDate:date
                                                   options:0];
    
    NSString *showString = @"";
    if (dayComponents.day < 1) {
        showString = [NSString stringWithFormat:@"今天 %@",localTimeStr];
    }
    else if (dayComponents.day < 2) {
        showString = [NSString stringWithFormat:@"明天 %@",localTimeStr];
    }
    else if (dayComponents.day < 3) {
        showString = [NSString stringWithFormat:@"后天 %@",localTimeStr];
    }
    else if (dayComponents.day + todayIndex < 9) {
        showString = [NSString stringWithFormat:@"%@ %@",weekdays[index],localTimeStr];
    }
    else if (dayComponents.day + todayIndex < 16) {
        showString = [NSString stringWithFormat:@"下%@ %@",weekdays[index],localTimeStr];
    }
    else {
        showString = [NSString stringWithFormat:@"下下%@ %@",weekdays[index],localTimeStr];
    }
    
    return showString;
}

#pragma mark - new shit
/**
 把服务器时间转换成本地时间
 */
+ (NSString *)localTime:(NSString *)serverTime {
    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
    serverFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    
    serverFormatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [serverFormatter dateFromString:serverTime];
    
    serverFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *localTimeStr = [serverFormatter stringFromDate:date];
    return localTimeStr;
}

/**
 把服务器时间转换成本地时间戳
 */
+ (NSString *)localTimeStampe:(NSString *)serverTime {
    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
    serverFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    
    serverFormatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [serverFormatter dateFromString:serverTime];
    
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f", time];
    return timeStamp;
}

/**
 把服务器时间转换成本地时间
 */
+ (NSString *)localTime:(NSString *)serverTime dateType:(NSString *)dateType {
    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
    serverFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    
    serverFormatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [serverFormatter dateFromString:serverTime];
    
    serverFormatter.dateFormat = dateType;
    NSString *localTimeStr = [serverFormatter stringFromDate:date];
    return localTimeStr;
}

/*
    通告:是否超过最后的时间
 */
- (BOOL)taskIsPassLimitedTime:(NSString *)time {
    
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.formatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [self.formatter dateFromString:time];
    NSTimeInterval dateStampe = [date timeIntervalSince1970];
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentTime = [currentDate timeIntervalSince1970];
    
    return ((dateStampe - currentTime) <= 60 * 60);
}

/*
   是否超过7天
*/
- (BOOL)isPassAWeek:(NSString *)time {
    if (isNullString(time)) {
        return YES;
    }
    
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.formatter.timeZone = [NSTimeZone localTimeZone];
    
    NSDate *date = [self.formatter dateFromString:time];
    NSTimeInterval dateStampe = [date timeIntervalSince1970];
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentTime = [currentDate timeIntervalSince1970];
    
    return ((currentTime - dateStampe) >= 60 * 60 * 24 * 7);
}

/*
   是否超过15天
*/
- (BOOL)isPassFifteenDay:(NSString *)time {
    if (isNullString(time)) {
        return YES;
    }
    
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.formatter.timeZone = [NSTimeZone localTimeZone];
    
    NSDate *date = [self.formatter dateFromString:time];
    NSTimeInterval dateStampe = [date timeIntervalSince1970];
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentTime = [currentDate timeIntervalSince1970];
    
    return ((currentTime - dateStampe) >= 60 * 60 * 24 * ([ZZUserHelper shareInstance].configModel.sayhi_config ? [ZZUserHelper shareInstance].configModel.sayhi_config.day : 15));
}

/**
 根据小时获取
 凌晨：0-5
 早上：5-11
 中午：11-13
 下午：13-17
 傍晚：17-19
 晚上：19-24
 */
- (NSString *)hourDescript:(NSInteger)hour {
    if (hour >= 0 && hour < 5) {
        return @"凌晨";
    }
    else if (hour >= 5 && hour < 11) {
        return @"早上";
    }
    else if (hour >= 11 && hour < 13) {
        return @"中午";
    }
    else if (hour >= 13 && hour < 17) {
        return @"下午";
    }
    else if (hour >= 17 && hour < 19) {
        return @"傍晚";
    }
    else {
        return @"晚上";
    }
}

// 邀约订单根据当前小时;
- (NSInteger)getHourByDateStr:(NSString *)dateStr {
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.formatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [self.formatter dateFromString:dateStr];
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return newDate.hour;
}

// 邀约订单根据当前小时显示文字
- (NSString *)hourDescriptByDateStr:(NSString *)dateStr {
    return [self hourDescript:[self getHourByDateStr:dateStr]];
}

// 邀约订单过期时间的显示
- (NSString *)deadLineDescriptByDateStr:(NSString *)dateStr {
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.formatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [self.formatter dateFromString:dateStr];
    date = [date dateByMinusMinutes:30];
    
    if (!date) {
        return nil;
    }
    
    NSString *hourDes = [self hourDescript:date.hour];
    NSString *weekDay = [self fetchDateDescriptComparesToNow:date];
    
    [self.formatter setDateFormat:@"HH:mm"];
    NSString *dateString = [self.formatter stringFromDate:date];
    NSDate *newDate = [self.formatter dateFromString:dateString];
    
    return [NSString stringWithFormat:@"%@ %@ %@分",weekDay, hourDes, [self.formatter stringFromDate:newDate]];
}

- (NSString *)fetchDateDescriptComparesToNow:(NSDate *)date {
    NSArray *weekdays = @[[NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    NSCalendarUnit unit = NSCalendarUnitWeekday
                        | NSCalendarUnitWeekdayOrdinal
                        | NSCalendarUnitDay
                        | NSCalendarUnitMonth
                        | NSCalendarUnitYear
                        | NSCalendarUnitHour
                        | NSCalendarUnitMinute
                        | NSCalendarUnitSecond;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:now];
    NSDateComponents *deadLineCmps = [calendar components:unit fromDate:date];
    
    NSString *dateDescript = nil;
    
    NSInteger dayGaps = deadLineCmps.day - nowCmps.day;
    if (dayGaps == 0) {
        dateDescript = @"今天";
    }
    else if (dayGaps == 1) {
        dateDescript = @"明天";
    }
    else if (dayGaps == 2) {
        dateDescript = @"后天";
    }
    else {
        if (dayGaps > weekdays.count - nowCmps.weekday) {
            dateDescript = [NSString stringWithFormat:@"下%@",weekdays[deadLineCmps.weekday]];
        }
        else {
            dateDescript = weekdays[deadLineCmps.weekday];
        }
    }
    return dateDescript;
}

- (BOOL)isLateNight:(NSString *)dateStr {
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.formatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [self.formatter dateFromString:dateStr];
    NSInteger hour = date.hour;
    return (hour >= 22 || (hour >= 0 && hour < 8));
}

- (BOOL)isMidNight:(NSString *)dateStr {
    if (isNullString(dateStr)) {
        return NO;
    }
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.formatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [self.formatter dateFromString:dateStr];
    NSInteger hour = date.hour;
    return (hour >= 22 || (hour >= 0 && hour < 6));
}

/**
 * 通告的开始时间和现在相比
 */
- (BOOL)taskDatePassToday:(NSString *)dateStr {
    if (isNullString(dateStr)) {
        return NO;
    }

    NSString *taskDatetimeStr = [ZZDateHelper localTimeStampe:dateStr];
    NSTimeInterval createTimeStamp = taskDatetimeStr.doubleValue;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    return timeStamp > createTimeStamp;
}

- (NSString *)getCommissionTimeDesc:(NSString *)dateStr {
    // 服务器返回的最后一次登录时间
    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
    serverFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    serverFormatter.timeZone = [NSTimeZone localTimeZone];
    NSDate *serverDate = [serverFormatter dateFromString:dateStr];
    
    // 当前的时间
    NSDate *nowDate = [NSDate date];
    
    NSTimeInterval nowDateStampe = [nowDate timeIntervalSince1970];
    NSTimeInterval serverDateStampe = [serverDate timeIntervalSince1970];
    
    NSString *preStr = nil;
    if (nowDateStampe - serverDateStampe < 60 * 60 * 24 * 3) {
        // 三天内
        [self.formatter setDateFormat:@"HH:mm:ss"];
        if (nowDateStampe - serverDateStampe < 60 * 60 * 24 * 2 && nowDateStampe - serverDateStampe >= 60 * 60 * 24) {
            preStr = @"昨天";
        }
        else if (nowDateStampe - serverDateStampe >= 60 * 60 * 24 * 2) {
            preStr = @"前天";
        }
    }
    else {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
        
        NSDateComponents *serverComponent = [calendar components:unit fromDate:serverDate];
        NSDateComponents *nowComponent = [calendar components:unit fromDate:nowDate];
        
        NSDateComponents *components = [calendar components:unit fromDateComponents:nowComponent toDateComponents:serverComponent options:0];
        
        if (components.year >= 1 ) {
            // 超过一年显示年月日时间
            [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            
        }
        else {
            // 超过三个月显示月日时间
            [self.formatter setDateFormat:@"MM-dd HH:mm"];
        }
    }
    
    
    NSString *dateString = [self.formatter stringFromDate:serverDate];
    if (!isNullString(preStr)) {
        dateString = [NSString stringWithFormat:@"%@ %@", preStr, dateString];
    }
    return dateString;
}

+ (NSString *)fetchCurrentTimeStampe {
    NSDate *date         = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time  = [date timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f", time];
    return timeStamp;
}

- (NSString *)fetchTimeForKTV {
    [self.formatter setDateFormat:@"yyyyMMddHHmmss"];
    self.formatter.timeZone = [NSTimeZone localTimeZone];
    
    NSDate *todayDate = [NSDate date];
    return [self.formatter stringFromDate:todayDate];
}

- (NSString *)currentTimeDescriptForKTVForRecord:(NSString *)serverTime {
    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
    serverFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *serverDate = [serverFormatter dateFromString:serverTime];
    
    // 创建NSCalendar对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear;
    
    NSDateComponents *serverCmps = [calendar components:type fromDate:serverDate];
    NSDateComponents *currentCmps = [calendar components:type fromDate:[NSDate date]];
    
    NSString *formatter = @"MM月dd日 HH:mm:ss";
    if (serverCmps.year != currentCmps.year) {
        formatter = @"yyyy年MM月dd日 HH:mm:ss";
    }
    
    [self.formatter setDateFormat:formatter];
    self.formatter.timeZone = [NSTimeZone localTimeZone];
    return [_formatter stringFromDate:serverDate];
}

- (NSString *)currentTimeDescriptForKTV:(NSString *)serverTime {
    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
    serverFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    
    NSDate *serverDate = [serverFormatter dateFromString:serverTime];
    
    // 创建NSCalendar对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear;
    
    NSDateComponents *serverCmps = [calendar components:type fromDate:serverDate];
    NSDateComponents *currentCmps = [calendar components:type fromDate:[NSDate date]];
    
    NSString *formatter = @"MM月dd日 HH:mm:ss";
    if (serverCmps.year != currentCmps.year) {
        formatter = @"yyyy年MM月dd日 HH:mm:ss";
    }
    
    [self.formatter setDateFormat:formatter];
    self.formatter.timeZone = [NSTimeZone localTimeZone];
    return [_formatter stringFromDate:serverDate];
}

#pragma mark - Lazyload
- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
    }
    return _formatter;
}

@end
