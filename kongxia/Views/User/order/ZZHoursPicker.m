//
//  ZZHoursPicker.m
//  zuwome
//
//  Created by angBiu on 2017/2/27.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZHoursPicker.h"

@interface ZZHoursPicker () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *hourArray;
@property (nonatomic, strong) NSString *selectString;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ZZHoursPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIButton *bgBtn = [[UIButton alloc] initWithFrame:frame];
        bgBtn.backgroundColor = kBlackTextColor;
        bgBtn.alpha = 0.3;
        [bgBtn addTarget:self action:@selector(removePickView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        [self addSubview:self.bgView];
    }
    
    return self;
}

- (void)showViews:(NSInteger)index
{
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.frame = CGRectMake(0, SCREEN_HEIGHT - 260, SCREEN_WIDTH, 260);
    }];
    NSInteger row = 0;
    if (index) {
        row = index - 1;
    }
    [_pickerView selectRow:row inComponent:0 animated:YES];
    _selectString = self.hourArray[row];
    _index = row;
}

#pragma mark - UIPickerViewMethod

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.hourArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.hourArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectString = self.hourArray[row];
    _index = row;
}

#pragma mark -

- (void)getThePickInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(ZZHoursPicker:didSelectedString:index:)]) {
        [_delegate ZZHoursPicker:self didSelectedString:_selectString index:_index];
    }
    
    [self removePickView];
}

- (void)removePickView
{
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
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
        
        [_bgView addSubview:toolbar];
        [_bgView addSubview:self.pickerView];
    }
    return _bgView;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 216)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (NSArray *)hourArray
{
    if (!_hourArray) {
        _hourArray = @[@"1小时",@"2小时",@"3小时",@"4小时",@"5小时",@"6小时"];
    }
    return _hourArray;
}

@end
