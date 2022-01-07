//
//  ZZTimeModel.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/1.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTimeSelectorModel.h"
#import "ZZDateHelper.h"

@implementation ZZTimeSelectorModel

- (instancetype)initWithMinimunGap:(NSInteger)gap {
    self = [super init];
    if (self) {
        _minimunGap = gap;
    }
    return self;
}

- (void)configureData {
    if (_dateType == DateNormal) {
        NSMutableArray *hourM = @[].mutableCopy;
        for (NSInteger i = 0; i < 24; i++) {
            [hourM addObject: [NSString stringWithFormat:@"%02ld", (long)i]];
        }
        _hours = hourM.copy;
    }
    else {
        NSDate *date = [NSDate date];
        NSInteger currentHour = date.hour;
        NSInteger currentMinute = date.minute;
        
        if (currentMinute > 50) {
            currentHour += 1;
            currentMinute = 0;
        }
        
        if (_dateType == DateSoon) {
            _dayDesc = @"尽快";
            
            date = [date dateByAddingHours:_minimunGap];
            if (currentMinute % 10 != 0) {
                NSInteger offset = 10 - currentMinute % 10;
                date = [date dateByAddingMinutes:offset];
            }
            NSString *dateStr = [[ZZDateHelper shareInstance] getDateStringWithDate:date];

            _day = dateStr;//[NSString stringWithFormat:@"%02ld:%02ld",(long)date.hour,(long)date.minute];
            _hours = @[@""];
        }
        else if (_dateType == DateToday) {
            NSInteger startTime = (currentHour + _minimunGap - 24) > 0 ? (currentHour + _minimunGap - 24) : currentHour + _minimunGap;
            
            NSMutableArray *hourM = @[].mutableCopy;
            for (NSInteger i = 0; i < 24; i++) {
                if (startTime <= i) {
                    [hourM addObject: [NSString stringWithFormat:@"%02ld", (long)i]];
                }
            }
            _hours = hourM.copy;
        }
        else if (_dateType == DateTomorrow) {
            NSInteger startTime = (currentHour + _minimunGap - 24) > 0 ? (currentHour + _minimunGap - 24) : 0;
            
            NSMutableArray *hourM = @[].mutableCopy;
            for (NSInteger i = 0; i < 24; i++) {
                if (startTime <= i) {
                    [hourM addObject: [NSString stringWithFormat:@"%02ld", (long)i]];
                }
            }
            _hours = hourM.copy;
        }
    }
}

- (void)setDateType:(DateType)dateType {
    _dateType = dateType;
    [self configureData];
}

- (NSString *)timeDesc {
    if (self.dateType == DateSoon) {
        return _day;
    }
    return [NSString stringWithFormat:@"%@ %@:%@", _day, _selectedHour ?: _hours.firstObject, _selectedMinute ?: _minutes.firstObject];
}

- (NSArray *)minutes {
    NSMutableArray *minutesM = @[].mutableCopy;
    if (_dateType == DateNormal) {
        for (NSInteger i = 0; i < 60; i+=10) {
            [minutesM addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
        }
    }
    else if (_dateType == DateSoon) {
        NSString *hour = [_day componentsSeparatedByString:@" "].lastObject;
        minutesM = @[[NSString stringWithFormat:@"%@之前",hour]].mutableCopy;
    }
    else {
        NSInteger hourIndex = [_hours indexOfObject:_selectedHour];
        if (hourIndex != 0) {
            for (NSInteger i = 0; i < 60; i+=10) {
                [minutesM addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
            }
        }
        else {
            NSDate *date = [NSDate date];
            NSInteger currentHour = date.hour;
            NSInteger currentMinute = date.minute;
            
            if (currentMinute > 50) {
                currentHour += 1;
                currentMinute = 0;
            }
            
            if (_dateType == DateToday) {
                NSInteger startTime = (currentHour + _minimunGap - 24) > 0 ? (currentHour  + _minimunGap - 24) : currentHour + _minimunGap;
                for (NSInteger i = 0; i < 60; i+=10) {
                    if (startTime >= 0) {
                        if (currentMinute <= i) {
                            [minutesM addObject: [NSString stringWithFormat:@"%02ld", (long)i]];
                        }
                    }
                    else {
                        [minutesM addObject: [NSString stringWithFormat:@"%02ld", (long)i]];
                    }
                }
            }
            else if (_dateType == DateTomorrow) {
                
                NSInteger startTime = [_hours indexOfObject:_selectedHour] == 0 ? currentMinute : 0;
                //(currentHour + _minimunGap - 24) > 0 ? (currentHour + _minimunGap - 24) : 0;
                if ((currentHour + _minimunGap - 24) < 0) {
                    startTime = 0;
                }
                
                for (NSInteger i = 0; i < 60; i+=10) {
                    if (startTime > 0) {
                        if (currentMinute <= i) {
                            [minutesM addObject: [NSString stringWithFormat:@"%02ld", (long)i]];
                        }
                    }
                    else {
                        [minutesM addObject: [NSString stringWithFormat:@"%02ld", (long)i]];
                    }
                }
            }
        }
    }
    return minutesM.copy;
}

@end
