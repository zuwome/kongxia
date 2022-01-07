//
//  ZZDatePicker.m
//  zuwome
//
//  Created by angBiu on 16/5/31.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZDatePicker.h"
#import "ZZDateHelper.h"

#define EARLY           (@"尽快")
#define TODAY           (@"今天")
#define TOMORROW        (@"明天")
#define AFTER_TOMORROW  (@"后天")

@implementation ZZDateModel 

@end



@interface ZZDatePicker ()

@property (nonatomic, copy) NSString *selectDate;

@end

@implementation ZZDatePicker
{
    NSMutableArray          *_dayArray;
    NSMutableArray          *_hourArray;
    NSMutableArray          *_minuteArray;
    NSArray                 *_allMinuteArray;
    NSMutableArray          *_allHourArray;
    NSMutableArray          *_firstHourArray;
    NSMutableArray          *_firstMinuteArray;
    
    NSArray                 *_timeArray;
    
    NSString                *_dayString;
    NSString                *_hourString;
    NSString                *_minuteString;
    
    UIView                  *_pickView;
    UIPickerView            *_subPickView;
    UIButton                *_bgBtn;
    
    NSString                *_selectString;
    NSInteger               _index;
    NSDate                  *_nextTwoDate;
    NSInteger               _lastDayRow;
    NSInteger               _lastHourRow;
    
    UILabel                 *_centerInfoLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    return self;
}

- (void)showDatePickerWithDate:(NSDate *)date
{
    [self creatTopView];
    [self creatPickView];
    [self managerDateList];
    
    _selectDate = TODAY;
    _nextTwoDate = [[ZZDateHelper shareInstance] getNextHours:4];
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
                    //                first++;
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
        } else {
            if (minute >= 50) {
                _minuteString = @"00";
                if (hour == 23) {
                    _hourString = @"00";
                    //                first++;
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
        [_subPickView reloadAllComponents];
        [_subPickView selectRow:first inComponent:0 animated:YES];
        [_subPickView selectRow:second inComponent:1 animated:YES];
        [_subPickView selectRow:third inComponent:2 animated:YES];
        _lastHourRow = second;
        
        [self showInfo];
        
        _selectString = [NSString stringWithFormat:@"%@ %@:%@",_dayString,_hourString,_minuteString];
    } else {
        [self getFirstData];
        [_subPickView selectRow:1 inComponent:0 animated:YES];
        [self pickerView:_subPickView didSelectRow:1 inComponent:0];
    }
    
    ZZDateModel *model = _dayArray[[_subPickView selectedRowInComponent:0]];
    _selectDate = model.showString;
}

- (void)showInfo
{
    if (_lastDayRow == 0) {
        _centerInfoLabel.text = @"";
    } else if (_lastDayRow == 1) {
        _centerInfoLabel.text = @"建议提早一天预约";
    } else if ([_hourString integerValue] < 9 || [_hourString integerValue] > 21) {
        _centerInfoLabel.text = @"该时段可能不便于出行";
    } else {
        _centerInfoLabel.text = @"";
    }
}

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
    
    [_subPickView reloadAllComponents];
}

- (void)managerQuickTime
{
    ZZDateModel *model = _dayArray[1];
    _dayString = model.timeString;
    _hourString = _firstHourArray[0];
    _minuteString = _firstMinuteArray[0];
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

#pragma mark - UIPickerViewMethod

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
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
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
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
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            if (row == 0) {
                _lastHourRow = 0;
                [_hourArray removeAllObjects];
                [_minuteArray removeAllObjects];
                [_subPickView reloadAllComponents];
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
                [_subPickView reloadAllComponents];
                [_subPickView selectRow:index inComponent:1 animated:YES];
                [_subPickView selectRow:0 inComponent:2 animated:YES];
                ZZDateModel *model = _dayArray[row];
                _dayString = model.timeString;
                _hourString = _hourArray[index];
                _minuteString = _minuteArray[0];
                _showDate = YES;
            } else if (_lastDayRow == 0 || _lastDayRow == 1) {
                [self getAllData];
                _hourString = _hourArray[0];
                _minuteString = _minuteArray[0];
                [_subPickView reloadAllComponents];
                [_subPickView selectRow:12 inComponent:1 animated:YES];
                [_subPickView selectRow:0 inComponent:2 animated:YES];
                ZZDateModel *model = _dayArray[row];
                _dayString = model.timeString;
                _lastHourRow = 12;
                _hourString = _hourArray[12];
                _showDate = YES;
            } else {
                [_subPickView selectRow:12 inComponent:1 animated:YES];
                [_subPickView selectRow:0 inComponent:2 animated:YES];
                ZZDateModel *model = _dayArray[row];
                _dayString = model.timeString;
                _lastHourRow = 12;
                _hourString = _hourArray[12];
                _minuteString = _minuteArray[0];
            }
            
            _lastDayRow = row;
            ZZDateModel *model = _dayArray[row];
            _selectDate = model.showString;
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
                    [_subPickView reloadAllComponents];
                    [_subPickView selectRow:0 inComponent:2 animated:YES];
                } else if (_lastHourRow == 0) {
                    [_minuteArray removeAllObjects];
                    [_minuteArray addObjectsFromArray:_allMinuteArray];
                    _minuteString = _minuteArray[0];
                    [_subPickView reloadAllComponents];
                    [_subPickView selectRow:0 inComponent:2 animated:YES];
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
    _index = row;
    
    [self showInfo];
}

#pragma mark - CreatView

- (void)creatTopView
{
    //点击其他地方收起PickView
    _bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgBtn.backgroundColor = [UIColor blackColor];
    _bgBtn.alpha = 0.3;
    [_bgBtn addTarget:self action:@selector(removePickView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bgBtn];
    
    _pickView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260)];
    _pickView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickView];
    
    //创建取消和确定按钮
    UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 44)];
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(removePickView)];
    lefttem.width = 80;
    lefttem.tintColor = [UIColor colorWithHexString:ZWM_YELLOW andAlpha:1];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(getThePickInfo)];
    right.width = 80;
    right.tintColor = [UIColor colorWithHexString:ZWM_YELLOW andAlpha:1];
    toolbar.items=@[lefttem,centerSpace,right];
    
    _centerInfoLabel = [[UILabel alloc] init];
    _centerInfoLabel.textAlignment = NSTextAlignmentCenter;
    _centerInfoLabel.textColor = kBlackTextColor;
    _centerInfoLabel.font = [UIFont systemFontOfSize:15];
    [toolbar addSubview:_centerInfoLabel];
    
    [_centerInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(toolbar.mas_top);
        make.bottom.mas_equalTo(toolbar.mas_bottom);
        make.left.mas_equalTo(toolbar.mas_left).offset(80);
        make.right.mas_equalTo(toolbar.mas_right).offset(-80);
    }];
    
    [_pickView addSubview:toolbar];
}

//自定义选择器
- (void)creatPickView
{
    _subPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 216)];
    _subPickView.delegate = self;
    _subPickView.dataSource = self;
    [_pickView addSubview:_subPickView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _pickView.frame = CGRectMake(0, SCREEN_HEIGHT - 260, SCREEN_WIDTH, 260);
    }];
}

- (void)getThePickInfo
{
    if ([[[ZZDateHelper shareInstance]getDateWithDateString:_selectString] compare:[[ZZDateHelper shareInstance] getNextHours:2]] == NSOrderedAscending) {
        [ZZHUD showErrorWithStatus:@"请至少提前两个小时预约!"];
        return;
    }
    // 事件
//    if (_delegate && [_delegate respondsToSelector:@selector(ZZDatePicker:didSelectedString:index:)]) {
//        [_delegate ZZDatePicker:self didSelectedString:_selectString index:_index];
//    }
//    
    if (_delegate && [_delegate respondsToSelector:@selector(ZZDatePicker:didSelectedString:selectDate:index:)]) {
        [_delegate ZZDatePicker:self didSelectedString:_selectString selectDate:_selectDate index:_index];
    }
    
    [self removePickView];
}

- (void)removePickView
{
    [UIView animateWithDuration:0.3 animations:^{
        _pickView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 260);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
