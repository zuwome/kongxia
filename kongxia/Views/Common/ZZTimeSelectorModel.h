//
//  ZZTimeModel.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/1.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DateType) {
    DateSoon,
    DateToday,
    DateTomorrow,
    DateNormal,
};

@interface ZZTimeSelectorModel : NSObject

@property (nonatomic, assign) NSInteger minimunGap; // 距离现在多少时间

@property (nonatomic, assign) DateType dateType;

// 通告时间描述
@property (nonatomic, copy) NSString *timeDesc;

@property (nonatomic, copy) NSString *day;

@property (nonatomic, copy) NSString *dayDesc;

@property (nonatomic, copy) NSArray *hours;

@property (nonatomic, copy) NSArray *firstMinutes;

@property (nonatomic, copy) NSArray *minutes;

@property (nonatomic, copy) NSString *selectedHour;

@property (nonatomic, copy) NSString *selectedMinute;

- (instancetype)initWithMinimunGap:(NSInteger)gap;

@end
