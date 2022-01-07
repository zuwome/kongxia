//
//  ZZTimeSelector.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/1.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTimeSelector.h"
#import "ZZTimeSelectorModel.h"
#import "ZZDateHelper.h"

#import "ZZDatePicker.h"

#define EARLY           (@"尽快")
#define TODAY           (@"今天")
#define TOMORROW        (@"明天")
#define AFTER_TOMORROW  (@"后天")

@interface ZZTimeSelector () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView       *bgView;

@property (nonatomic, strong) UIButton     *bgBtn;

@property (nonatomic, strong) ZZTimeSelectorTopView *topView;

@property (nonatomic, strong) UILabel *timeTitleLabel;

@property (nonatomic, strong) UIPickerView *timePicker;

@property (nonatomic, strong) UILabel *deadTimeLabel;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *durationTitleLabel;

@property (nonatomic, strong) UIPickerView *hourPicker;

@property (nonatomic, assign) NSInteger minimunGap; // 时间开始

@property (nonatomic, assign) NSInteger gapBetweenNow; // 默认选择距离现在多少时间

@property (nonatomic, copy) NSArray<ZZTimeSelectorModel *> *datesArray;

// 通告时间段
@property (nonatomic, copy) NSArray<NSNumber *> *durations;

// 活动时间段
@property (nonatomic, copy) NSArray<NSString *> *durationsDesArr;

@property (nonatomic, strong) ZZTimeSelectorModel *currentSelectModel;

@property (nonatomic, assign) NSInteger currentSelectDuration;

// 选择的活动时间段
@property (nonatomic, copy) NSString *currentSelectDurationDes;

@end

@implementation ZZTimeSelector

//- (instancetype)initWithFrame:(CGRect)frame taskType:(TaskType)taskType {
//    self = [super initWithFrame:frame];
//    if (self) {
//        _taskType = taskType;
//        [self initDatas];
//        [self layout];
//        [self defaultSetting];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame taskType:(TaskType)taskType timeType:(PostTaskItemType)timeType {
    self = [super initWithFrame:frame];
    if (self) {
        _timeType = timeType;
        _taskType = taskType;
        [self initDatas];
        [self layout];
        [self defaultSetting];
    }
    return self;
}

#pragma mark - public Method
- (void)showDate:(NSString *)date dateDesc:(NSString *)dateDesc duration:(NSInteger)duration {
    [self setDate:date dateDesc:dateDesc duration:duration];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.top = SCREEN_HEIGHT - self.bgView.height;
    }];
}

- (void)showDate:(NSString *)date dateDesc:(NSString *)dateDesc duratioDes:(NSString *)duratioDes {
    [self setDate:date dateDesc:dateDesc durationDes:duratioDes];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.top = SCREEN_HEIGHT - self.bgView.height;
    }];
}

- (void)showDurations:(NSInteger)duration {
    [self setDuration:duration];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.top = SCREEN_HEIGHT - self.bgView.height;
    }];
}

#pragma mark - private method
- (void)initDatas {
    if (_taskType == TaskNormal) {
        if (_timeType == postTime) {
            // 距离当前时间1个小时
            _minimunGap = 1;
            _gapBetweenNow = 4;
            
            // 默认选择三个小时之后的
            ZZTimeSelectorModel *selectorTime = self.datesArray[0];
            if (selectorTime.hours.count >= _gapBetweenNow) {
                _currentSelectModel = selectorTime;
                _currentSelectModel.selectedHour = selectorTime.hours[_gapBetweenNow - 1];
                
                NSDate *date = [NSDate date];
                NSInteger currentMinute = date.minute;
                if (currentMinute % 10 != 0) {
                    if (currentMinute + (10 - currentMinute % 10) >= 60) {
                        currentMinute = 0;
                    }
                    else {
                        currentMinute += (10 - currentMinute % 10);
                    }
                }
                _currentSelectModel.selectedMinute = [NSString stringWithFormat:@"%02ld", currentMinute];
            }
            else {
                NSInteger gap =  [selectorTime.hours.firstObject integerValue] + _gapBetweenNow - 24;
                selectorTime = self.datesArray[1];
                _currentSelectModel = selectorTime;
                _currentSelectModel.selectedHour = selectorTime.hours[gap - 1];
                
                NSDate *date = [NSDate date];
                NSInteger currentMinute = date.minute;
                if (currentMinute % 10 != 0) {
                    if (currentMinute + (10 - currentMinute % 10) >= 60) {
                        currentMinute = 0;
                    }
                    else {
                        currentMinute += (10 - currentMinute % 10);
                    }
                }
                _currentSelectModel.selectedMinute = [NSString stringWithFormat:@"%02ld", currentMinute];
            }
            
            __block NSInteger hourIndex = -1;
            [_currentSelectModel.hours enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:_currentSelectModel.selectedHour]) {
                    hourIndex = idx;
                    *stop = YES;
                }
            }];
            
            if (hourIndex != -1) {
                [self.timePicker selectRow:hourIndex inComponent:1 animated:YES];
            }
            
            __block NSInteger minIndex = -1;
            [_currentSelectModel.minutes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:_currentSelectModel.selectedMinute]) {
                    minIndex = idx;
                    *stop = YES;
                }
            }];
            
            if (minIndex != -1) {
                [self.timePicker selectRow:minIndex inComponent:2 animated:YES];
            }
            else {
                _currentSelectModel.selectedMinute = @"00";
                [self.timePicker selectRow:0 inComponent:2 animated:YES];
            }
            
        }
        else {
            _currentSelectDuration = [self.durations[0] integerValue];
        }
    }
    else {
        _currentSelectModel = self.datesArray[0];
        _currentSelectDurationDes = self.durationsDesArr.firstObject;
    }
}

- (void)defaultSetting {
    NSUInteger index = [_datesArray indexOfObject:_currentSelectModel];
    [_timePicker selectRow:index inComponent:0 animated:NO];
    
    if (_taskType == TaskNormal) {
        if (_timeType == postDuration) {
            NSUInteger hourIndex = [_currentSelectModel.hours indexOfObject:_currentSelectModel.selectedHour];
            [_timePicker selectRow:hourIndex inComponent:1 animated:NO];
            [_timePicker reloadComponent:2];
        }
        
        [self showDeadLine];
    }
}

- (void)setDate:(NSString *)dateStr dateDesc:(nonnull NSString *)dateDesc durationDes:(NSString *)durationDes {
    __block ZZTimeSelectorModel *selectedModel;
    __block NSInteger index = -1;
    
    _timeTitleLabel.text = @"活动开始时间";
    _durationTitleLabel.text = @"活动时间";
    
    [_datesArray enumerateObjectsUsingBlock:^(ZZTimeSelectorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.dayDesc isEqualToString:dateDesc]) {
            *stop = YES;
            selectedModel = obj;
            index = idx;
        }
    }];
    
    if (!selectedModel) {
        return;
    }
    
    _currentSelectDurationDes = durationDes;
    _currentSelectModel = selectedModel;
    
    NSInteger durationIndex = [_durationsDesArr indexOfObject:_currentSelectDurationDes];
    if (durationIndex >= 0 && durationIndex < _durationsDesArr.count) {
        [_hourPicker selectRow:durationIndex inComponent:0 animated:NO];
    }
    
    if (index >= 0 && index < _datesArray.count) {
        [_timePicker selectRow:index inComponent:0 animated:NO];
    }
}

- (void)setDate:(NSString *)dateStr dateDesc:(nonnull NSString *)dateDesc duration:(NSInteger)duration {
    __block ZZTimeSelectorModel *selectedModel;
    __block NSInteger index = -1;
    
    if (_taskType == TaskFree) {
        _timeTitleLabel.text = @"活动开始时间";
        _durationTitleLabel.text = @"活动时间";
    }
    else {
        _timeTitleLabel.text = @"通告开始时间";
        _durationTitleLabel.text = @"选择通告进行时长";
    }
    
    [_datesArray enumerateObjectsUsingBlock:^(ZZTimeSelectorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.dayDesc isEqualToString:dateDesc]) {
            *stop = YES;
            selectedModel = obj;
            index = idx;
        }
    }];
    
    if (!selectedModel) {
        return;
    }
    
    _currentSelectModel = selectedModel;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:dateStr];
    
    selectedModel.selectedHour = [NSString stringWithFormat:@"%02ld", (long)date.hour];
    selectedModel.selectedMinute = [NSString stringWithFormat:@"%02ld", (long)date.minute];
    
    [_timePicker reloadAllComponents];
    
    [_timePicker selectRow:index inComponent:0 animated:NO];
    
    if (selectedModel.dateType == DateSoon) {
        [_timePicker selectRow:0 inComponent:1 animated:NO];
        [_timePicker selectRow:0 inComponent:2 animated:NO];
    }
    else {
        NSInteger hourIndex = [_datesArray[index].hours indexOfObject:_datesArray[index].selectedHour];
        if (hourIndex >= 0 && hourIndex < _datesArray[index].hours.count) {
            [_timePicker selectRow:hourIndex inComponent:1 animated:NO];
        }
        else {
            [_timePicker selectRow:0 inComponent:1 animated:NO];
        }
        
        NSInteger minuteIndex = [_datesArray[index].minutes indexOfObject:_datesArray[index].selectedMinute];
        if (minuteIndex >= 0 && minuteIndex < _datesArray[index].minutes.count) {
            [_timePicker selectRow:minuteIndex inComponent:2 animated:NO];
        }
        else {
            [_timePicker selectRow:0 inComponent:2 animated:NO];
        }
    }
}

- (void)setDuration:(NSInteger)duration {
    if (duration > 0) {
        _currentSelectDuration = duration;
    }
    else if (duration == 0) {
        _currentSelectDuration = 2;
    }
    
    
    NSInteger durationIndex = [_durations indexOfObject:@(_currentSelectDuration)];
    if (durationIndex >= 0 && durationIndex < _durations.count) {
        [_hourPicker selectRow:durationIndex inComponent:0 animated:NO];
    }
    else {
        [_hourPicker selectRow:1 inComponent:0 animated:NO];
    }
}

- (BOOL)isTodayEnoughForPick {
    NSDate *now = [NSDate date];
    NSUInteger hour = now.hour;
    if (hour == 23) {
        return NO;
    }
    if (now.minute >= 50) {
        hour += 1;
    }
    return !(hour + _minimunGap >= 24) ;
}

- (void)showDeadLine {
    
    if (_taskType == TaskFree) {
//        _deadTimeLabel.text = [NSString stringWithFormat:@"%@ 自动结束发布", deadLineDes];
    }
    else {
        NSString *deadLineDes = [[ZZDateHelper shareInstance] deadLineDescriptByDateStr:_currentSelectModel.timeDesc];
        if (_timeType == postTime) {
            _deadTimeLabel.text = [NSString stringWithFormat:@"%@ 自动结束报名", deadLineDes];
        }
        else if (_timeType == postDuration) {
            _deadTimeLabel.text = @"时长越久，达人报名越积极，您的选择越多";
        }
    }
    
    if (_taskType == TaskNormal && UserHelper.loginer.gender == 1 && _timeType == postTime) {
        BOOL isLateNight = [[ZZDateHelper shareInstance] isLateNight:_currentSelectModel.timeDesc];
        _topView.titleLabel.text = isLateNight ? @"该时段报名人数可能会较少" : @"留给达人报名时间越久，报名人数越多";
    }
    else if (_taskType == TaskNormal && _timeType == postDuration) {
        _topView.titleLabel.text = @"选择时长";
    }
}

#pragma mark - response method
- (void)cancelBtnClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureBtnClick {
    [self cancelBtnClick];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_taskType == TaskFree) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(timeView:time:durationDes:)]) {
                [self.delegate timeView:self time:_currentSelectModel durationDes:_currentSelectDurationDes];
            }
        }
        else {
            if (_timeType == postTime) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(timeView:time:duration:)]) {
                    [self.delegate timeView:self time:_currentSelectModel duration:0];
                }
            }
            else if (_timeType == postDuration) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(timeView:chooseDuration:)]) {
                    [self.delegate timeView:self chooseDuration:_currentSelectDuration];
                }
            }
        }
    });
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == _timePicker) {
        if (_taskType == TaskFree) {
            return 1;
        }
        else {
            return 3;
        }
    }
    else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _timePicker) {
        if (_taskType == TaskNormal) {
            switch (component) {
                case 0: {
                    return self.datesArray.count;
                    break;
                }
                case 1: {
                    return _currentSelectModel.hours.count;
                    break;
                }
                case 2: {
                    return _currentSelectModel.minutes.count;
                    break;
                }
                default: {
                    return 1;
                    break;
                }
            }
        }
        else {
            return self.datesArray.count;
        }
    }
    else {
        if (_taskType == TaskNormal) {
            return self.durations.count;
        }
        else {
           return self.durationsDesArr.count;
        }
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        pickerLabel.textColor = [UIColor blackColor];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSUInteger index = [_datesArray indexOfObject:_currentSelectModel];
    if (pickerView == _timePicker) {
        switch (component) {
            case 0: {
                return _datesArray[row].dayDesc;
                break;
            }
            case 1: {
                if (_datesArray[index].dateType == DateSoon) {
                    return _currentSelectModel.hours[row];
                }
                else {
                    return [NSString stringWithFormat:@"%@%@时",[[ZZDateHelper shareInstance] hourDescript:[_currentSelectModel.hours[row] integerValue]], _currentSelectModel.hours[row]];
                }
                break;
            }
            case 2: {
                NSArray *minutes = _currentSelectModel.minutes;
                if (row > minutes.count - 1) {
                    row = 0;
                }
                if (_datesArray[index].dateType == DateSoon) {
                    return _currentSelectModel.minutes[row];
                }
                else {
                    return [NSString stringWithFormat:@"%@分", _currentSelectModel.minutes[row]];
                }
                break;
            }
            default: {
                return @"1";
                break;
            }
        }
    }
    else {
        if (_taskType == TaskFree) {
            return self.durationsDesArr[row];
        }
        else {
            return [NSString stringWithFormat:@"%@小时", self.durations[row]];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSUInteger index = [_datesArray indexOfObject:_currentSelectModel];
    ZZTimeSelectorModel *oldModel = _currentSelectModel;
    if (pickerView == _timePicker) {
        if (_taskType == TaskFree) {
            _currentSelectModel = _datesArray[row];
            [_hourPicker reloadAllComponents];
            
            NSInteger index = -1;
            index = [_durationsDesArr indexOfObject:_currentSelectDurationDes];
            if (index >= 0 && index < _durationsDesArr.count) {
                [_hourPicker selectRow:index inComponent:0 animated:NO];
            }
            else {
                _currentSelectDurationDes = _durationsDesArr.firstObject;
            }
        }
        else {
            switch (component) {
                case 0: {
                    _currentSelectModel = _datesArray[row];
                    if (_currentSelectModel.dateType != DateSoon) {
                        NSInteger hourIndex = 0;
                        if ([_currentSelectModel.hours containsObject:oldModel.selectedHour] ) {
                            _currentSelectModel.selectedHour = oldModel.selectedHour;
                            hourIndex = [_currentSelectModel.hours indexOfObject:_currentSelectModel.selectedHour];
                        }
                        else {
                            _currentSelectModel.selectedHour = _currentSelectModel.hours.firstObject;
                        }
                        
                        NSInteger minuteIndex = 0;
                        if ([_currentSelectModel.minutes containsObject:oldModel.selectedMinute] ) {
                            _currentSelectModel.selectedMinute = oldModel.selectedMinute;
                            minuteIndex = [_currentSelectModel.minutes indexOfObject:_currentSelectModel.selectedMinute];
                        }
                        else {
                            _currentSelectModel.selectedMinute = _currentSelectModel.minutes.firstObject;
                        }
                        [pickerView reloadComponent:1];
                        [pickerView reloadComponent:2];
                        [_timePicker selectRow:hourIndex inComponent:1 animated:NO];
                        [_timePicker selectRow:minuteIndex inComponent:2 animated:NO];
                        [self showDeadLine];
                    }
                    break;
                }
                case 1: {
                    _currentSelectModel.selectedHour = _datesArray[index].hours[row];
                    [_timePicker reloadComponent:2];
                    NSInteger minuteIndex = 0;
                    if ([_currentSelectModel.minutes containsObject:oldModel.selectedMinute] ) {
                        _currentSelectModel.selectedMinute = oldModel.selectedMinute;
                        minuteIndex = [_currentSelectModel.minutes indexOfObject:_currentSelectModel.selectedMinute];
                    }
                    else {
                        _currentSelectModel.selectedMinute = _currentSelectModel.minutes.firstObject;
                    }
                    [_timePicker selectRow:minuteIndex inComponent:2 animated:NO];
                    [self showDeadLine];
                    break;
                }
                case 2: {
                    _currentSelectModel.selectedMinute = _datesArray[index].minutes[row];
                    [self showDeadLine];
                    break;
                }
                default:
                    break;
            }
        }
    }
    else {
        if (_taskType == TaskFree) {
            _currentSelectDurationDes = self.durationsDesArr[row];
        }
        else {
            _currentSelectDuration = [self.durations[row] integerValue];
        }
    }
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgBtn];
    [self addSubview:self.bgView];
    [_bgView addSubview:self.topView];
    
    if (_taskType == TaskFree) {
        [_bgView addSubview:self.timeTitleLabel];
        [_bgView addSubview:self.timePicker];
        [_bgView addSubview:self.deadTimeLabel];
        [_bgView addSubview:self.line];
        [_bgView addSubview:self.durationTitleLabel];
        [_bgView addSubview:self.hourPicker];
        
        _timeTitleLabel.frame     = CGRectMake(0.0, _topView.bottom + 10, self.width, _timeTitleLabel.font.lineHeight);
        _timePicker.frame         = CGRectMake(0.0, _timeTitleLabel.bottom + 20, self.width, 120.0);
        _deadTimeLabel.frame      = CGRectMake(0.0, _timePicker.bottom + 20, self.width, _deadTimeLabel.font.lineHeight);
        _line.frame               = CGRectMake(0.0, _deadTimeLabel.bottom + 5, self.width, 0.5);
        _durationTitleLabel.frame = CGRectMake(0.0, _line.bottom + 10.0, self.width, _durationTitleLabel.font.lineHeight);
        _hourPicker.frame         = CGRectMake(0.0, _durationTitleLabel.bottom + 5, self.width, 120);
    }
    else {
        if (_timeType == postTime) {
            [_bgView addSubview:self.timeTitleLabel];
            [_bgView addSubview:self.timePicker];
            [_bgView addSubview:self.deadTimeLabel];
            
            _timeTitleLabel.frame     = CGRectMake(0.0, _topView.bottom + 10, self.width, _timeTitleLabel.font.lineHeight);
            _timePicker.frame         = CGRectMake(0.0, _timeTitleLabel.bottom + 20, self.width, 250.0);
            _deadTimeLabel.frame      = CGRectMake(0.0, _timePicker.bottom + 20, self.width, _deadTimeLabel.font.lineHeight);
        }
        else if (_timeType == postDuration) {
            [_bgView addSubview:self.durationTitleLabel];
            [_bgView addSubview:self.hourPicker];
            [_bgView addSubview:self.deadTimeLabel];
            
            _durationTitleLabel.frame = CGRectMake(0.0, _topView.bottom + 10, self.width, _durationTitleLabel.font.lineHeight);
            _hourPicker.frame         = CGRectMake(0.0, _durationTitleLabel.bottom + 20, self.width, 250.0);
            _deadTimeLabel.frame      = CGRectMake(0.0, _hourPicker.bottom + 20, self.width, _deadTimeLabel.font.lineHeight);
        }
    }
}

#pragma mark - Getter&Setter
- (UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgBtn.backgroundColor = HEXACOLOR(0x000000, 0.3);
        [_bgBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 445)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (ZZTimeSelectorTopView *)topView {
    if (!_topView) {
        _topView = [[ZZTimeSelectorTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 51)];
        [_topView.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView.confirmBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        if (_taskType == TaskFree) {
            _topView.titleLabel.text = nil;
        }
        else {
            _topView.titleLabel.text = @"留给达人报名时间越久，报名人数越多";
        }
    }
    return _topView;
}

- (UILabel *)timeTitleLabel {
    if (!_timeTitleLabel) {
        _timeTitleLabel = [[UILabel alloc] init];
        _timeTitleLabel.textColor = kYellowColor;
        _timeTitleLabel.textAlignment = NSTextAlignmentCenter;
        _timeTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _timeTitleLabel.text = @"通告开始时间";
    }
    return _timeTitleLabel;
}

- (UIPickerView *)timePicker {
    if (!_timePicker) {
        _timePicker = [[UIPickerView alloc] init];
        _timePicker.delegate = self;
        _timePicker.dataSource = self;
    }
    return _timePicker;
}

- (UILabel *)deadTimeLabel {
    if (!_deadTimeLabel) {
        _deadTimeLabel = [[UILabel alloc] init];
        _deadTimeLabel.textColor = RGBCOLOR(63, 58, 58);
        _deadTimeLabel.textAlignment = NSTextAlignmentCenter;
        _deadTimeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        if (_taskType == TaskFree) {
            _deadTimeLabel.text = @"活动时间过期后自动结束发布";
        }
        else {
            _deadTimeLabel.text = @"通告开始时间";
        }
        
    }
    return _deadTimeLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEXCOLOR(0xededed);
    }
    return _line;
}

- (UILabel *)durationTitleLabel {
    if (!_durationTitleLabel) {
        _durationTitleLabel = [[UILabel alloc] init];
        _durationTitleLabel.textColor = kYellowColor;
        _durationTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _durationTitleLabel.textAlignment = NSTextAlignmentCenter;
        if (_taskType == TaskFree) {
            _durationTitleLabel.text = @"通告时间";
        }
        else {
            _durationTitleLabel.text = @"通告进行时长";
        }
    }
    return _durationTitleLabel;
}

- (UIPickerView *)hourPicker {
    if (!_hourPicker) {
        _hourPicker = [[UIPickerView alloc] init];
        _hourPicker.delegate = self;
        _hourPicker.dataSource = self;
    }
    return _hourPicker;
}

- (NSArray<ZZTimeSelectorModel *> *)datesArray {
    if (!_datesArray) {
        NSMutableArray *datesArray = @[].mutableCopy;
        
        NSInteger maxDuration = 8;
        if (_taskType == TaskFree) {
            maxDuration = 14;
        }
        for (int i = 0; i < maxDuration; i++) {
            ZZDateModel *dateModel = [[ZZDateHelper shareInstance] getDateModelWithDays:i];
            ZZTimeSelectorModel *model = [[ZZTimeSelectorModel alloc] initWithMinimunGap:_minimunGap];
            model.day = dateModel.timeString;
            model.dayDesc = dateModel.showString;
            if (i == 0) {
                model.dateType = DateToday;
            }
            else if (i == 1) {
                model.dateType = DateTomorrow;
            }
            else {
                model.dateType = DateNormal;
            }
            [datesArray addObject:model];
        }
        
        if (_taskType != TaskFree) {
            if (![self isTodayEnoughForPick]) {
                [datesArray removeObjectAtIndex:0];
            }
        }
        
        if (_taskType == TaskFree && datesArray.count > 0) {
            [datesArray removeObjectAtIndex:0];
        }
        
        // 尽快
//        ZZTimeSelectorModel *model = [[ZZTimeSelectorModel alloc] init];
//        model.dateType = DateSoon;
//        [datesArray insertObject:model atIndex:0];
        
        _datesArray = datesArray.copy;
    }
    return _datesArray;
}

- (NSArray<NSNumber *> *)durations {
    if (!_durations) {
        _durations = @[@1, @2, @3, @4, @5, @6];
    }
    return _durations;
}

- (NSArray<NSString *> *)durationsDesArr {
    if ([_currentSelectModel.dayDesc isEqualToString:@"今天"]) {
        NSDate *date = [NSDate date];
        NSInteger currentHour = date.hour;
        NSInteger currentMinute = date.minute;
        
        if (currentHour >= 0 && currentHour < 5) {
            // 深夜
            if (currentHour == 4 && currentMinute >= 30) {
                _durationsDesArr = @[@"上午", @"中午", @"下午", @"傍晚", @"晚上", @"整天"];
            }
            else {
                _durationsDesArr = @[@"上午", @"中午", @"下午", @"傍晚", @"晚上", @"深夜", @"整天"];
            }
        }
        else if (currentHour >= 5 && currentHour < 11) {
            // 上午
            if (currentHour == 10 && currentMinute >= 30) {
                _durationsDesArr = @[@"中午", @"下午", @"傍晚", @"晚上", @"整天"];
            }
            else {
                _durationsDesArr = @[@"上午", @"中午", @"下午", @"傍晚", @"晚上", @"整天"];
            }
        }
        else if (currentHour >= 11 && currentHour < 13) {
            // 中午
            if (currentHour == 12 && currentMinute >= 30) {
                _durationsDesArr = @[@"下午", @"傍晚", @"晚上", @"整天"];
            }
            else {
                _durationsDesArr = @[@"中午", @"下午", @"傍晚", @"晚上", @"整天"];
            }
            
        }
        else if (currentHour >= 13 && currentHour < 17) {
            // 下午
            if (currentHour == 16 && currentMinute >= 30) {
                _durationsDesArr = @[@"傍晚", @"晚上", @"整天"];
            }
            else {
                _durationsDesArr = @[@"下午", @"傍晚", @"晚上", @"整天"];
            }
        }
        else if (currentHour >= 17 && currentHour < 19) {
            // 傍晚
            if (currentHour == 18 && currentMinute >= 30) {
                _durationsDesArr = @[@"晚上", @"整天"];
            }
            else {
                _durationsDesArr = @[@"傍晚", @"晚上", @"整天"];
            }
        }
        else if (currentHour >= 19 && currentHour < 24) {
            // 晚上
            if (currentHour == 23 && currentMinute >= 30) {
                _durationsDesArr = @[@"整天"];
            }
            else {
                _durationsDesArr = @[@"晚上", @"整天"];
            }
        }
    }
    else {
        _durationsDesArr = @[@"上午", @"中午", @"下午", @"傍晚", @"晚上", @"深夜", @"整天"];
    }
    return _durationsDesArr;
}

@end

@interface ZZTimeSelectorTopView ()

@end

@implementation ZZTimeSelectorTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)layout {
    [self addSubview:self.cancelBtn];
    [self addSubview:self.confirmBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.line];
}

#pragma mark - getters and setters
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
        [_cancelBtn setTitleFont: [UIFont systemFontOfSize:15]];
        _cancelBtn.normalTitle = @"取消";
        _cancelBtn.normalTitleColor = kBlackColor;
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, 45)];
        [_confirmBtn setTitleFont: [UIFont systemFontOfSize:15]];
        _confirmBtn.normalTitle = @"确定";
        _confirmBtn.normalTitleColor = HEXCOLOR(0x2186fb);
    }
    return _confirmBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cancelBtn.right + 10, 0.0, self.confirmBtn.left - 10 - self.cancelBtn.right - 10, 45.0)];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        _titleLabel.textColor = RGBCOLOR(153, 153, 153);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(12, 44, SCREEN_WIDTH - 24, 1)];
        _line.backgroundColor = HEXCOLOR(0xededed);
    }
    return _line;
}

@end
