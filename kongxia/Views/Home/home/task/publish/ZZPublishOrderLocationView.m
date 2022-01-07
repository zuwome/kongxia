//
//  ZZPublishOrderLocationView.m
//  zuwome
//
//  Created by angBiu on 2017/7/20.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZPublishOrderLocationView.h"
#import "ZZPublishLocationModel.h"

@interface ZZPublishOrderLocationView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) BOOL isViewUp;
@property (nonatomic, copy) NSString *location;

@end

@implementation ZZPublishOrderLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.bgBtn];
        [self addSubview:self.bgView];
    }
    
    return self;
}

- (void)setLocationsArray:(NSMutableArray *)locationsArray
{
    _locationsArray = locationsArray;
    [self.pickerView reloadAllComponents];
}

- (void)show:(NSString *)location
{
    if (_isViewUp) {
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.bgBtn.hidden = NO;
    NSInteger row = 0;
    if ([location isEqualToString:self.nearStr]) {
        row = 1;
    } else if ([location isEqualToString:self.noLimitStr]) {
        row = 0;
    } else {
        for (ZZPublishLocationModel *model in _locationsArray) {
            if ([model.province isEqualToString:location]) {
                row = [_locationsArray indexOfObject:model];
                
                row += 2;
                break;
            }
        }
    }
    [self.pickerView selectRow:row inComponent:0 animated:YES];
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
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewMethod

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.locationsArray.count + 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return self.noLimitStr;
    } else if (row == 1) {
        return self.nearStr;
    } else {
        ZZPublishLocationModel *model = self.locationsArray[row-2];
        return model.province;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        _location = self.noLimitStr;
    } else if (row == 1) {
        _location = self.nearStr;
    } else {
        ZZPublishLocationModel *model = self.locationsArray[row-2];
        _location = model.province;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

#pragma mark - UIButtonMethod

- (void)cancelBtnClick
{
    [self viewDown];
}

- (void)ensureBtnClick
{
    [self viewDown];
    if (_chooseTime) {
        if (isNullString(_location)) {
            _location = self.noLimitStr;
        }
        _chooseTime(_location);
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
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"选择对方所在的位置";
        [_topView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_topView);
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

- (NSString *)noLimitStr
{
    return @"不限地区";
}

- (NSString *)nearStr
{
    return @"附近";
}

@end
