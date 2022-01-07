//
//  ZZTaskMoneyInputView.m
//  zuwome
//
//  Created by angBiu on 2017/8/5.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTaskMoneyInputView.h"

@interface ZZTaskMoneyInputView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) NSInteger minPrice;

@property (nonatomic, strong) UILabel *moneyDescriptLabel;

@end

@implementation ZZTaskMoneyInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIButton *bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgBtn.backgroundColor = HEXACOLOR(0x000000, 0.3);
        [bgBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.lineView];
        [self.bgView addSubview:self.textField];
        [self.bgView addSubview:self.moneyDescriptLabel];
        
        
        [self setUpTheConstraints];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    return self;
}

- (void)setUpTheConstraints {
    CGFloat textWidth = getTextWidth([UIFont systemFontOfSize:20], @"输入金额(不低于100)", 40.0f).width;
    CGFloat width = getTextWidth([UIFont systemFontOfSize:20], @"元/人", 40.0f).width;
    
    //+30 是因为有个一键清空按钮
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgView.mas_centerX);
        make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-40);
        make.width.mas_equalTo(@(textWidth + width+40));
        make.height.mas_equalTo(@0.5);
    }];
    
  
 
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineView.mas_left);
        make.bottom.equalTo(_lineView.mas_bottom);
        make.width.greaterThanOrEqualTo(@(textWidth+40));
        make.height.equalTo(@40);
    }];
    WS(weakSelf);
    _textField.touchReturn = ^{
        [weakSelf sureBtnClick];
    };
    
    UILabel *perLabel = [[UILabel alloc] init];
    perLabel.textColor = kBlackColor;
    perLabel.font = [UIFont systemFontOfSize:ISiPhone5 ? 16 : 18];
    perLabel.text = @"元/人";
    [_bgView addSubview:perLabel];
    
    [perLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_lineView.mas_right);
        make.centerY.equalTo(_textField.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    
    [_moneyDescriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(15.0);
        make.right.equalTo(_bgView).offset(-15.0);
        make.bottom.equalTo(_bgView).offset(-15.0);
    }];
}


- (void)setHour:(NSInteger)hour
{
    _hour = hour;
    
    if (_hour == 0) {
        _minPrice = 100;
    } else {
        _minPrice = 100 + 50*(_hour - 1);
    }
    NSString *placeholder = [NSString stringWithFormat:@"输入金额(不低于%ld)",_minPrice];
    self.textField.placeholder = placeholder;
    
    CGFloat textWidth = [ZZUtils widthForCellWithText:placeholder fontSize:20];
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textWidth+40);
    }];
}

#pragma mark -

- (void)keyboardWillShow:(NSNotification *)notification
{
//    CGRect rect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat during = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:during animations:^{
        self.bgView.top = SCREEN_HEIGHT - self.bgView.height;
    }];
}

#pragma mark - UIButtonMethod

- (void)cancelBtnClick
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureBtnClick
{
    if (isNullString(_textField.text)) {
        [ZZHUD showErrorWithStatus:@"请输入金额"];
        return;
    }
    if ([ZZUtils compareWithValue1:[NSNumber numberWithInteger:_minPrice] value2:_textField.text] == NSOrderedDescending) {
        [ZZHUD showErrorWithStatus:[NSString stringWithFormat:@"金额不能小于%ld元",_minPrice]];
        return;
    }
    
    NSString *string = [ZZUtils dealAccuracyDouble:[_textField.text doubleValue]];
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:price:)]) {
        [_delegate inputView:self price:string];
    }
    [self cancelBtnClick];
}

#pragma mark - lazyload

- (UILabel *)moneyDescriptLabel
{
    if (!_moneyDescriptLabel) {
        _moneyDescriptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _moneyDescriptLabel.font = [UIFont systemFontOfSize:14];
        _moneyDescriptLabel.text = @"通告发布成功后将收取总金额的30%作为发布服务费，不可退还";
        _moneyDescriptLabel.textColor = RGBCOLOR(171, 171, 171);
        _moneyDescriptLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyDescriptLabel;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 394)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        [_bgView addSubview:self.topView];
        self.lineView.hidden = NO;
    }
    return _bgView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
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
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40)];
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
    }
    return _topView;
}

- (ZZMoneyTextField *)textField {
    if (!_textField) {
        _textField = [[ZZMoneyTextField alloc] initWithFrame:CGRectZero];
        _textField.textColor = kBlackColor;
        _textField.font = [UIFont systemFontOfSize:ISiPhone5 ? 16 : 18];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.noEndEditing = YES;
        _textField.pure = YES;
    }
    return _textField;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xededed);
      
    }
    return _lineView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
