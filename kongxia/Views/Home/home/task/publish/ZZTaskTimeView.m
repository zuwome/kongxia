//
//  ZZTaskTimeView.m
//  zuwome
//
//  Created by angBiu on 2017/8/5.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTaskTimeView.h"
#import "ZZDateHelper.h"

#import "ZZDatePicker.h"

#define EARLY           (@"尽快")
#define TODAY           (@"今天")
#define TOMORROW        (@"明天")
#define AFTER_TOMORROW  (@"后天")

@interface ZZTaskTimeView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIPickerView *timePicker;
@property (nonatomic, strong) UIView *hourView;
@property (nonatomic, strong) UIPickerView *hourPicker;

@property (nonatomic, strong) NSArray *hours;
@property (nonatomic, strong) NSMutableArray *dayArray;
@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;
@property (nonatomic, strong) NSArray *allMinuteArray;
@property (nonatomic, strong) NSMutableArray *allHourArray;
@property (nonatomic, strong) NSMutableArray *firstHourArray;
@property (nonatomic, strong) NSMutableArray *firstMinuteArray;

@property (nonatomic, strong) NSString *dayString;
@property (nonatomic, strong) NSString *hourString;
@property (nonatomic, strong) NSString *minuteString;
@property (nonatomic, strong) NSString *selectString;
@property (nonatomic, strong) NSDate *nextTwoDate;
@property (nonatomic, assign) NSInteger lastDayRow;
@property (nonatomic, assign) NSInteger lastHourRow;

@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, copy) NSString *selectedDate;     //

@end

@implementation ZZTaskTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.bgBtn];
        [self addSubview:self.bgView];
        
        _hour = 1;
    }
    
    return self;
}

- (void)showDatePickerWithDate:(NSDate *)date hour:(NSInteger)hourCount {
    [self managerDateList];
    _nextTwoDate = [[ZZDateHelper shareInstance] getNextHours:0.5];
    BOOL haveDate = YES;
    if (!date || [date compare:_nextTwoDate] == NSOrderedAscending) {
        date = _nextTwoDate;
        haveDate = NO;
    }
    
    [self manageFirstData];
    [self managerQuickTime];
    
    if (date && _showDate) {
        [self getAllData];
        _dayString = [[ZZDateHelper shareInstance] getDayStringWithDate:date];
        NSString *dayString = [[ZZDateHelper shareInstance] getShowDateStringWithDateString:_dayString];
        
        __block NSInteger first = 0;
        [_dayArray enumerateObjectsUsingBlock:^(ZZDateModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.showString isEqualToString:dayString]) {
                first = idx;
            }
        }];
        
        _hourString = [[[ZZDateHelper shareInstance] getDetailDateStringWithDate:date] substringToIndex:2];
        
        _minuteString = [[[ZZDateHelper shareInstance] getDetailDateStringWithDate:date] substringWithRange:NSMakeRange(3, 2)];
        NSInteger third = [_minuteString integerValue]/10;
        NSInteger minute = [_minuteString integerValue];
        NSInteger hour = [_hourString integerValue];
        
        if (haveDate) {
            if (minute > 50) {
                _minuteString = @"00";
                if (hour == 23) {
                    _hourString = @"00";
                } else {
                    hour++;
                    if (hour >= 10) {
                        _hourString = [NSString stringWithFormat:@"%ld",hour];
                    } else {
                        _hourString = [NSString stringWithFormat:@"0%ld",hour];
                    }
                }
            } else {
                _minuteString = [NSString stringWithFormat:@"%ld0",third];
            }
        }
        else {
            if (minute >= 50) {
                _minuteString = @"00";
                if (hour == 23) {
                    _hourString = @"00";
                } else {
                    hour++;
                    if (hour >= 10) {
                        _hourString = [NSString stringWithFormat:@"%ld",hour];
                    } else {
                        _hourString = [NSString stringWithFormat:@"0%ld",hour];
                    }
                }
            } else {
                _minuteString = [NSString stringWithFormat:@"%ld0",third+1];
            }
        }
        
        _lastDayRow = first;
        if (first == 1) {
            [_hourArray removeAllObjects];
            [_minuteArray removeAllObjects];
            [_hourArray addObjectsFromArray:_firstHourArray];
            
            if ([_hourArray indexOfObject:_hourString] == 0) {
                [_minuteArray addObjectsFromArray:_firstMinuteArray];
            } else {
                [_minuteArray addObjectsFromArray:_allMinuteArray];
            }
        }
        
        ZZDateModel *dayModel = _dayArray[first];
        _dayString = dayModel.timeString;
        
        NSInteger second = [_hourArray indexOfObject:_hourString];
        third = [_minuteArray indexOfObject:_minuteString];
        [_timePicker reloadAllComponents];
        [_timePicker selectRow:first inComponent:0 animated:YES];
        [_timePicker selectRow:second inComponent:1 animated:YES];
        
        if ([_minuteArray indexOfObject:_minuteString] != 0) {
            [_timePicker selectRow:third inComponent:2 animated:YES];
        }
        else {
            [_timePicker selectRow:0 inComponent:2 animated:YES];
        }
        
        _lastHourRow = second;
        
        _selectString = [NSString stringWithFormat:@"%@ %@:%@",_dayString,_hourString,_minuteString];
    } else {
        [self getFirstData];
        [_timePicker selectRow:1 inComponent:0 animated:YES];
        [self pickerView:_timePicker didSelectRow:1 inComponent:0];
    }
    
    [_hourPicker selectRow:hourCount - 1 inComponent:0 animated:YES];
    
    // 每次打开记录上一次时间
    ZZDateModel *model = _dayArray[[_timePicker selectedRowInComponent:0]];
    _selectedDate = model.showString;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.top = SCREEN_HEIGHT - self.bgView.height;
    }];
}

#pragma mark - UIButtonMethod

- (void)cancelBtnClick
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureBtnClick
{
    [self cancelBtnClick];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_delegate && [_delegate respondsToSelector:@selector(timeView:didSelectedString:hour:selectDate:)]) {
//            [_delegate timeView:self didSelectedString:_selectString hour:_hour];
            [_delegate timeView:self didSelectedString:_selectString hour:_hour selectDate:_selectedDate];
        }
    });
}

#pragma mark - UIPickerViewMethod

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return pickerView == _timePicker ? 3:1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _timePicker) {
        switch (component) {
            case 0:
            {
                return _dayArray.count;
            }
                break;
            case 1:
            {
                return _hourArray.count;
            }
                break;
            default:
            {
                return _minuteArray.count;
            }
                break;
        }
    } else {
        return self.hours.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _timePicker) {
        switch (component) {
            case 0:
            {
                ZZDateModel *model = _dayArray[row];
                return model.showString;
            }
                break;
            case 1:
            {
                if (row < _hourArray.count) {
                    return [NSString stringWithFormat:@"%@时",_hourArray[row]];
                } else {
                    return @"";
                }
            }
                break;
            default:
            {
                if (row < _minuteArray.count) {
                    return [NSString stringWithFormat:@"%@分",_minuteArray[row]];
                } else {
                    return @"";
                }
            }
                break;
        }
    } else {
        return self.hours[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _timePicker) {
        switch (component) {
            case 0:
            {
                ZZDateModel *model = _dayArray[row];
                _selectedDate = model.showString;                
                if (row == 0) {
                    _lastHourRow = 0;
                    [_hourArray removeAllObjects];
                    [_minuteArray removeAllObjects];
                    
                    NSDate *currentDate = [NSDate date];
                    NSDate *earyTime = [currentDate dateByAddingHours:4];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSString *timeString = [dateFormatter stringFromDate:earyTime];

                    [_minuteArray addObject: [NSString stringWithFormat:@"%@前",timeString]];
                    
                    [_timePicker reloadAllComponents];
                    _showDate = NO;
                } else if (row == 1) {
                    _lastHourRow = 0;
                    [self getFirstData];
                    NSInteger index = 0;
                    if ([_hourArray containsObject:@"12"]) {
                        index = [_hourArray indexOfObject:@"12"];
                    }
                    if (index != 0) {
                        [_minuteArray removeAllObjects];
                        [_minuteArray addObjectsFromArray:_allMinuteArray];
                    }
                    [_timePicker reloadAllComponents];
                    [_timePicker selectRow:index inComponent:1 animated:YES];
                    [_timePicker selectRow:0 inComponent:2 animated:YES];
                    ZZDateModel *model = _dayArray[row];
                    _dayString = model.timeString;
                    _hourString = _hourArray[index];
                    _minuteString = _minuteArray.count > 0 ? _minuteArray[0] : @"00";
                    _showDate = YES;
                } else if (_lastDayRow == 0 || _lastDayRow == 1) {
                    [self getAllData];
                    _hourString = _hourArray[0];
                    _minuteString = _minuteArray[0];
                    [_timePicker reloadAllComponents];
                    [_timePicker selectRow:12 inComponent:1 animated:YES];
                    [_timePicker selectRow:0 inComponent:2 animated:YES];
                    ZZDateModel *model = _dayArray[row];
                    _dayString = model.timeString;
                    _lastHourRow = 12;
                    _hourString = _hourArray[12];
                    _showDate = YES;
                } else {
                    [_timePicker selectRow:12 inComponent:1 animated:YES];
                    [_timePicker selectRow:0 inComponent:2 animated:YES];
                    ZZDateModel *model = _dayArray[row];
                    _dayString = model.timeString;
                    _lastHourRow = 12;
                    _hourString = _hourArray[12];
                    _minuteString = _minuteArray[0];
                }
                
                _lastDayRow = row;
            }
                break;
            case 1:
            {
                if (row < _hourArray.count) {
                    _hourString = _hourArray[row];
                    if (row == 0 && _lastHourRow != 0) {
                        [_minuteArray removeAllObjects];
                        [_minuteArray addObjectsFromArray:_firstMinuteArray];
                        _minuteString = _minuteArray[0];
                        [_timePicker reloadAllComponents];
                        [_timePicker selectRow:0 inComponent:2 animated:YES];
                    } else if (_lastHourRow == 0) {
                        [_minuteArray removeAllObjects];
                        [_minuteArray addObjectsFromArray:_allMinuteArray];
                        _minuteString = _minuteArray[0];
                        [_timePicker reloadAllComponents];
                        [_timePicker selectRow:0 inComponent:2 animated:YES];
                    }
                    _lastHourRow = row;
                }
            }
                break;
            default:
            {
                if (row < _minuteArray.count) {
                    _minuteString = _minuteArray[row];
                }
            }
                break;
        }
        
        if (_lastDayRow != 0) {
            _selectString = [NSString stringWithFormat:@"%@ %@:%@",_dayString,_hourString,_minuteString];
        } else {
            [self managerQuickTime];
        }
    } else {
        _hour = row+1;
    }
}

#pragma mark - data

- (void)managerDateList
{
    _dayArray = [NSMutableArray array];
    for (int i=0; i<8; i++) {
        [_dayArray addObject:[[ZZDateHelper shareInstance] getDateModelWithDays:i]];
    }
    ZZDateModel *model = [[ZZDateModel alloc] init];
    model.showString = kOrderQuickTimeString;
    [_dayArray insertObject:model atIndex:0];
    
    _allHourArray = [NSMutableArray array];
    for (int i=0; i<24; i++) {
        if (i<10) {
            [_allHourArray addObject:[NSString stringWithFormat:@"0%d",i]];
        } else {
            [_allHourArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    _allMinuteArray = @[@"00",@"10",@"20",@"30",@"40",@"50"];
    
    _hourArray = [NSMutableArray array];
    _minuteArray = [NSMutableArray array];
    
    [_timePicker reloadAllComponents];
}

- (void)managerQuickTime
{
    if (_dayArray.count>0) {
        ZZDateModel *model = _dayArray[1];
        _dayString = model.timeString;
    }
    if (_firstHourArray.count>0) {
     _hourString = _firstHourArray[0];
    }
    if (_firstMinuteArray.count>0) {
         _minuteString = _firstMinuteArray[0];
    }
    
    NSInteger currentHour = [_hourString integerValue];
    if (24 - currentHour > 4) {
        currentHour += 4;
    }
    else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *currentDate = [dateFormatter dateFromString:_dayString];
        NSDate *time = [currentDate dateByAddingDays:1];
        
        _dayString = [dateFormatter stringFromDate:time];

        if (24 - currentHour == 4) {
            currentHour = 0;
        }
        else {
            currentHour = (currentHour + 4 - 24);
        }
    }
    
    _hourString = [NSString stringWithFormat:@"%ld",currentHour];
    _selectString = [NSString stringWithFormat:@"%@ %@:%@",_dayString,_hourString,_minuteString];
}

- (void)manageFirstData
{
    NSString *hourStr = [[[ZZDateHelper shareInstance] getDetailDateStringWithDate:_nextTwoDate] substringToIndex:2];
    NSString *minuteStr = [[[ZZDateHelper shareInstance] getDetailDateStringWithDate:_nextTwoDate] substringWithRange:NSMakeRange(3, 2)];
    NSInteger currentHour = [[[[ZZDateHelper shareInstance] getDetailDateStringWithDate:[NSDate date]] substringToIndex:2] integerValue];
    NSInteger hour = [hourStr integerValue];
    _firstHourArray = [NSMutableArray array];
    _firstMinuteArray = [NSMutableArray array];
    
    if (currentHour >= 22) {
        [_dayArray removeObjectAtIndex:1];
        
        if ([minuteStr integerValue] >= 50) {
            [_firstMinuteArray addObjectsFromArray:_allMinuteArray];
            [_allHourArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx > hour) {
                    [_firstHourArray addObject:string];
                }
            }];
        } else {
            [_allMinuteArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx > [minuteStr integerValue]/10) {
                    [_firstMinuteArray addObject:string];
                }
            }];
            
            [_allHourArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx >= hour) {
                    [_firstHourArray addObject:string];
                }
            }];
        }
        
    } else if ([minuteStr integerValue] >= 50) {
        [_firstMinuteArray addObjectsFromArray:_allMinuteArray];
        if (hour == 23) {
            [_dayArray removeObjectAtIndex:1];
            [_firstHourArray addObjectsFromArray:_allHourArray];
        } else {
            [_allHourArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx > hour) {
                    [_firstHourArray addObject:string];
                }
            }];
        }
    } else {
        
        [_allMinuteArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > [minuteStr integerValue]/10) {
                [_firstMinuteArray addObject:string];
            }
        }];
        
        [_allHourArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= hour) {
                [_firstHourArray addObject:string];
            }
        }];
    }
}

- (void)getFirstData
{
    [_hourArray removeAllObjects];
    [_minuteArray removeAllObjects];
    [_hourArray addObjectsFromArray:_firstHourArray];
    [_minuteArray addObjectsFromArray:_firstMinuteArray];
}

- (void)getAllData
{
    [_hourArray removeAllObjects];
    [_minuteArray removeAllObjects];
    [_hourArray addObjectsFromArray:_allHourArray];
    [_minuteArray addObjectsFromArray:_allMinuteArray];
}

#pragma mark -

- (UIButton *)bgBtn
{
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgBtn.backgroundColor = HEXACOLOR(0x000000, 0.3);
        [_bgBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 360)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        [_bgView addSubview:self.topView];
        [_bgView addSubview:self.timeView];
        [_bgView addSubview:self.hourView];
    }
    return _bgView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:cancelBtn];
        
        UILabel *cancelLabel = [[UILabel alloc] init];
        cancelLabel.textColor = kBlackColor;
        cancelLabel.font = [UIFont systemFontOfSize:15];
        cancelLabel.text = @"取消";
        cancelLabel.userInteractionEnabled = NO;
        [cancelBtn addSubview:cancelLabel];
        
        [cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cancelBtn.mas_left).offset(12);
            make.centerY.mas_equalTo(cancelBtn.mas_centerY);
        }];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, 45)];
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:sureBtn];
        
        UILabel *sureLabel = [[UILabel alloc] init];
        sureLabel.textColor = HEXCOLOR(0x2186fb);
        sureLabel.font = [UIFont systemFontOfSize:15];
        sureLabel.text = @"确定";
        sureLabel.userInteractionEnabled = NO;
        [sureBtn addSubview:sureLabel];
        
        [sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(sureBtn.mas_right).offset(-12);
            make.centerY.mas_equalTo(sureBtn.mas_centerY);
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 44, SCREEN_WIDTH - 24, 1)];
        lineView.backgroundColor = HEXCOLOR(0xededed);
        [_topView addSubview:lineView];
    }
    return _topView;
}

- (UIView *)timeView
{
    if (!_timeView) {
        _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.height, SCREEN_WIDTH, 158)];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kYellowColor;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = @"开始时间";
        [_timeView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_timeView.mas_centerX);
            make.top.mas_equalTo(_timeView.mas_top).offset(10);
            make.height.mas_equalTo(@25);
        }];
        
        _timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 158-35)];
        _timePicker.delegate = self;
        _timePicker.dataSource = self;
        [_timeView addSubview:_timePicker];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 157, SCREEN_WIDTH - 24, 1)];
        lineView.backgroundColor = HEXCOLOR(0xededed);
        [_timeView addSubview:lineView];
    }
    return _timeView;
}

- (UIView *)hourView
{
    if (!_hourView) {
        _hourView = [[UIView alloc] initWithFrame:CGRectMake(0, 198, SCREEN_WIDTH, 360-198)];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kYellowColor;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = @"任务时长";
        [_hourView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_hourView.mas_centerX);
            make.top.mas_equalTo(_hourView.mas_top).offset(10);
            make.height.mas_equalTo(@25);
        }];
        
        _hourPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, _hourView.height - 35)];
        _hourPicker.delegate = self;
        _hourPicker.dataSource = self;
        [_hourView addSubview:_hourPicker];
    }
    return _hourView;
}

- (NSArray *)hours
{
    return @[@"1小时",@"2小时",@"3小时",@"4小时",@"5小时",@"6小时"];
}

@end
