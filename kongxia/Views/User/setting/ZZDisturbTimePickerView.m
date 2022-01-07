//
//  ZZDisturbTimePickerView.m
//  zuwome
//
//  Created by angBiu on 2017/5/16.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZDisturbTimePickerView.h"

@interface ZZDisturbTimePickerView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) BOOL isViewUp;

@property (nonatomic, assign) NSInteger leftIndex;
@property (nonatomic, assign) NSInteger rightIndex;

@end

@implementation ZZDisturbTimePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.bgBtn];
        [self addSubview:self.bgView];
    }
    
    return self;
}

- (void)show:(NSString *)timeString
{
    if (_isViewUp) {
        return;
    }
    NSArray *array = [timeString componentsSeparatedByString:@"至"];
    if ([self.dataArray containsObject:array[0]]) {
        _leftIndex = [self.dataArray indexOfObject:array[0]];
    }
    if ([self.dataArray containsObject:array[1]]) {
        _rightIndex = [self.dataArray indexOfObject:array[1]];
    }
    [self.pickerView selectRow:_leftIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:_rightIndex inComponent:2 animated:YES];
    
    self.hidden = NO;
    self.bgBtn.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.top = SCREEN_HEIGHT - self.bgView.height;
    } completion:^(BOOL finished) {
        _isViewUp = YES;
    }];
}

- (void)viewDown
{
    if (!_isViewUp) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        _isViewUp = NO;
        self.hidden = YES;
    }];
}

#pragma mark - UIPickerViewMethod

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component == 1 ? 1:999999;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 1) {
        return @"至";
    } else {
        NSInteger index = row%24;
        return self.dataArray[index];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _leftIndex = row%24;
    } else if (component == 2) {
        _rightIndex = row%24;
    }
}

#pragma mark - UIButtonMethod

- (void)cancelBtnClick
{
    [self viewDown];
}

- (void)ensureBtnClick
{
    [self viewDown];
    NSString *string = [NSString stringWithFormat:@"%@至%@",self.dataArray[_leftIndex],self.dataArray[_rightIndex]];
    if (_chooseTime) {
        _chooseTime(string);
    }
}

#pragma mark - 

- (UIButton *)bgBtn
{
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_bgBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _bgBtn.backgroundColor = kBlackTextColor;
        _bgBtn.alpha = 0.5;
    }
    return _bgBtn;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        [_bgView addSubview:self.topView];
        [_bgView addSubview:self.pickerView];
    }
    return _bgView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _topView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.height - 0.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = kLineViewColor;
        [_topView addSubview:lineView];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:cancelBtn];
        
        UILabel *cancelLabel = [[UILabel alloc] init];
        cancelLabel.textColor = kBlackTextColor;
        cancelLabel.font = [UIFont systemFontOfSize:15];
        cancelLabel.userInteractionEnabled = NO;
        cancelLabel.text = @"取消";
        [cancelBtn addSubview:cancelLabel];
        
        [cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cancelBtn.mas_left).offset(15);
            make.centerY.mas_equalTo(cancelBtn.mas_centerY);
        }];
        
        UIButton *ensureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, _topView.height)];
        [ensureBtn addTarget:self action:@selector(ensureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:ensureBtn];
        
        UILabel *ensureLabel = [[UILabel alloc] init];
        ensureLabel.textColor = kBlackTextColor;
        ensureLabel.font = [UIFont systemFontOfSize:15];
        ensureLabel.userInteractionEnabled = NO;
        ensureLabel.text = @"确定";
        [ensureBtn addSubview:ensureLabel];
        
        [ensureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ensureBtn.mas_right).offset(-15);
            make.centerY.mas_equalTo(ensureBtn.mas_centerY);
        }];
    }
    return _topView;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _topView.height, SCREEN_WIDTH, _bgView.height - _topView.height)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00"];
    }
    return _dataArray;
}

@end
