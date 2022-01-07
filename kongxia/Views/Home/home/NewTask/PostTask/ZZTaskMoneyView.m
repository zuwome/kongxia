//
//  ZZTaskMoneyInputView.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskMoneyView.h"
#import "ZZDateHelper.h"

@interface ZZTaskMoneyView() <UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UITextField *moneyTextfield;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *line1View;

@property (nonatomic, strong) UILabel *moneyDescriptLabel;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, assign) BOOL isMidNight;

@property (nonatomic, assign) PriceLimiteType limiteType;

@property (nonatomic, assign) double minimunPrice;

@property (nonatomic, assign) double maximunPrice;

@property (nonatomic, assign) double addPricePerHour;


@end

@implementation ZZTaskMoneyView

+ (instancetype)createWithPrice:(NSString *)price
                   taskDuration:(NSInteger)duration
                           date:(NSString *)date
                       taskType:(TaskType)taskType {
    ZZTaskMoneyView *view = [[ZZTaskMoneyView alloc] initWithPrice:price
                                                      taskDuration:duration
                                                          taskType:taskType date:date];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [view show];
    return view;
}

- (instancetype)initWithPrice:(NSString *)price
                 taskDuration:(NSInteger)duration
                     taskType:(TaskType)taskType
                         date:(NSString *)date {
    self = [super init];
    if (self) {
        
        _taskType = taskType;
        _price = price;
        _duration = duration != 0 ? duration : 1;
        _date = date;
    
        if (_taskType == TaskFree) {
            _limiteType = LimiteMaximun;
        }
        else {
            _limiteType = LimiteMinimun;
        }
        
        if (_limiteType == LimiteMaximun) {
            _addPricePerHour = 100;
            
            _minimunPrice = 1;
            if (_taskType == TaskFree) {
                _maximunPrice = 300.0;
            }
            else {
                _maximunPrice = 300.0;
            }
            
            if (_duration > 1) {
                _maximunPrice += _addPricePerHour * (_duration - 1);
            }
            
            if ([_price doubleValue] > _maximunPrice) {
                _price = nil;
            }
        }
        else {
            _isMidNight = [[ZZDateHelper shareInstance] isMidNight:_date];
            _addPricePerHour = 50;
            
            if (_isMidNight) {
                _minimunPrice = 400;
            }
            else {
                _minimunPrice = 200.0;
            }
            _maximunPrice = 10000;
            
            if (_duration > 1) {
                _minimunPrice += _addPricePerHour * (_duration - 1);
            }
            if ([_price doubleValue] > _maximunPrice || [_price doubleValue] < _minimunPrice) {
                _price = nil;
            }
        }
        [self layout];
        [self configureText];
        [self addNotifications];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.5;
        _contentView.frame = CGRectMake(0.0, SCREEN_HEIGHT - 394, SCREEN_WIDTH, 394);
    }];
}

- (void)dismiss {
    [self endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.0;
        _contentView.frame = CGRectMake(0.0, SCREEN_HEIGHT, SCREEN_WIDTH, 394 );
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)configureText {

    NSString *placeHolderStr = nil;
    if (_taskType == TaskFree) {
        _titleLabel.text = @"技能价格";
        placeHolderStr = [NSString stringWithFormat:@"输入金额(不高于%.0f)",_maximunPrice];
        _moneyTextfield.placeholder = placeHolderStr;
        _subTitleLabel.text = @"价格越低，能越快的收到邀请，活动的成功率越高";
        _moneyDescriptLabel.text = nil;
        _moneyDescriptLabel.hidden = YES;
    }
    else {
        _titleLabel.text = @"通告金额";
        if (_taskType == TaskFree) {
            placeHolderStr = [NSString stringWithFormat:@"输入金额(不高于%.0f)",_maximunPrice];
            _subTitleLabel.text = @"价格越低，收到的邀约越多，您将有更多的选择";
        }
        else {
            if (_isMidNight) {
                placeHolderStr = [NSString stringWithFormat:@"输入金额(深夜时段不低于%.0f)", _minimunPrice];
            }
            else {
                placeHolderStr = [NSString stringWithFormat:@"输入金额(不低于%.0f)", _minimunPrice];
            }
            _subTitleLabel.text = @"金额越高，报名的达人会更积极，您的选择就越多";
        }
        _moneyTextfield.placeholder = placeHolderStr;
        _moneyDescriptLabel.text = @"发布通告需支付发布服务费，发布服务费为通告金额*30%，发布成功30分钟后且无人报名的情况下，您取消发布或通告自动过期后，发布服务费将全额退回";
        _moneyDescriptLabel.hidden = NO;
        
    }
}

#pragma mark - event response
- (void)sureBtnClick {
    if (isNullString(_moneyTextfield.text)) {
        [ZZHUD showErrorWithStatus:@"请输入金额"];
        return;
    }
    
    if (![_moneyTextfield.text isPureNumber]) {
        [ZZHUD showErrorWithStatus:@"请输入正确的金额"];
        return;
    }
    
    if (_limiteType == LimiteMinimun) {
        if ([ZZUtils compareWithValue1:[NSNumber numberWithInteger:_minimunPrice] value2:_moneyTextfield.text] == NSOrderedDescending) {
            [ZZHUD showErrorWithStatus:[NSString stringWithFormat:@"金额不能小于%.0f元",_minimunPrice]];
            return;
        }
        
        if ([_moneyTextfield.text doubleValue] > _maximunPrice) {
            [ZZHUD showErrorWithStatus:[NSString stringWithFormat:@"金额不能大于%.0f", _maximunPrice]];
            return;
        }
    }
    else {
        if ([ZZUtils compareWithValue1:[NSNumber numberWithInteger:_maximunPrice] value2:_moneyTextfield.text] == NSOrderedAscending) {
            [ZZHUD showErrorWithStatus:[NSString stringWithFormat:@"金额不能大于%.0f元",_maximunPrice]];
            return;
        }
    }
    
    NSString *string = [ZZUtils dealAccuracyDouble:[_moneyTextfield.text doubleValue]];
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:price:)]) {
        [_delegate inputView:self price:string];
    }
    [self dismiss];
}

#pragma mark - Notifications
- (void)addNotifications {
    if (isIPhoneX || isIPhoneXsMax) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillChangeFrame:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
}

#pragma mark -键盘的监听方法
/**
 *  键盘弹出事件
 */
- (void)keyboardWillShow:(NSNotification *)nontification {

    NSDictionary *info          = [nontification userInfo];
    CGFloat  curkeyBoardHeight  = [[info objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect newFrame = [keyWindow convertRect:_subTitleLabel.frame fromView:_subTitleLabel.superview];
    CGFloat keyBoardTop = SCREEN_HEIGHT - curkeyBoardHeight;
    if (curkeyBoardHeight > newFrame.size.height + newFrame.origin.y) {
        return;
    }
    /*! 第三方键盘回调三次问题，监听仅执行最后一次 */
#pragma warning iOS 11 Will Some Problems
//    if(begin.size.height > 0 && (begin.origin.y - end.origin.y > 0)) {
        [UIView animateWithDuration:0.25 animations:^{
            self.top -= (newFrame.size.height + newFrame.origin.y) - keyBoardTop;
        } completion:^(BOOL finished) {
            
        }];
//    }
}

/**
 *  键盘回收时间
 */
- (void)keyboardWillHide:(NSNotification *)nontification {
    [UIView animateWithDuration:0.25 animations:^{
        self.top = SCREEN_HEIGHT - self.height;
    }completion:^(BOOL finished) {
        
    }];
}

/**
 *  键盘改变高度
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    CGFloat keyBoardHeight = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect newFrame = [keyWindow convertRect:_subTitleLabel.frame fromView:_subTitleLabel.superview];
    CGFloat keyBoardTop = SCREEN_HEIGHT - keyBoardHeight;
    if (keyBoardHeight > newFrame.size.height + newFrame.origin.y) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.top -= (newFrame.size.height + newFrame.origin.y) - keyBoardTop;
    } completion:nil];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [_contentView addSubview:self.cancelBtn];
    [_contentView addSubview:self.confirmBtn];
    [_contentView addSubview:self.titleLabel];
    [_contentView addSubview:self.lineView];
    [_contentView addSubview:self.line1View];
    [_contentView addSubview:self.moneyTextfield];
    [_contentView addSubview:self.subTitleLabel];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 394);
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView);
        make.right.equalTo(_contentView);
        make.top.equalTo(_contentView).offset(48.5);
        make.height.equalTo(@0.5);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView);
        make.top.equalTo(_contentView);
        make.bottom.equalTo(_lineView.mas_top);
        make.width.equalTo(@72.0);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentView);
        make.top.equalTo(_contentView);
        make.bottom.equalTo(_lineView.mas_top);
        make.width.equalTo(@72.0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView);
        make.centerY.equalTo(_confirmBtn);
    }];
    
    [_moneyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView);
        make.top.equalTo(_lineView.mas_bottom).offset(60.0);
//        make.width.equalTo(@(320));
    }];
    
    [_line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(30);
        make.right.equalTo(_contentView).offset(-30);
        make.top.equalTo(_moneyTextfield.mas_bottom).offset(8);
        make.height.equalTo(@0.5);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(15.0);
        make.right.equalTo(_contentView).offset(-15.0);
        make.top.equalTo(_line1View.mas_bottom).offset(4);
    }];
    
    [_contentView addSubview:self.moneyDescriptLabel];
    
    [_moneyDescriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView);
        make.bottom.equalTo(_contentView).offset( - 15);
        make.left.equalTo(_contentView).offset(15);
        make.right.equalTo(_contentView).offset(-15);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(20,20)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
    });
}

#pragma mark - Getter&Setter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGBCOLOR(52, 52, 52) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        [_cancelBtn addTarget:self
                       action:@selector(dismiss)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:RGBCOLOR(74, 144, 226) forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        [_confirmBtn addTarget:self
                       action:@selector(sureBtnClick)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBCOLOR(240, 238, 239);
    }
    return _lineView;
}

- (UIView *)line1View {
    if (!_line1View) {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = RGBCOLOR(240, 238, 239);
    }
    return _line1View;
}

- (UITextField *)moneyTextfield {
    if (!_moneyTextfield) {
        _moneyTextfield = [[UITextField alloc] initWithFrame:CGRectZero];
        _moneyTextfield.textColor = kBlackColor;
        _moneyTextfield.textAlignment = NSTextAlignmentCenter;
        _moneyTextfield.keyboardType = UIKeyboardTypeNumberPad;
        _moneyTextfield.delegate = self;
        if (_price) {
            _moneyTextfield.text = _price;
        }
        NSString *placeholder = nil;
        CGFloat textFont = 18;
        if (_taskType == TaskFree) {
            placeholder = [NSString stringWithFormat:@"输入金额(不高于%.0f)",_maximunPrice];
        }
        else {
            placeholder = [NSString stringWithFormat:@"输入金额(%@%.0f)", _isMidNight ? @"深夜时段不低于" : @"不低于", _minimunPrice];;
        }
       
        _moneyTextfield.placeholder = placeholder;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%ld小时共", _duration];
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBCOLOR(63, 58, 58);
        CGFloat width = [NSString findWidthForText:label.text havingWidth:SCREEN_WIDTH andFont:label.font];
        label.frame = CGRectMake(0.0, 0.0, width, 25);
        _moneyTextfield.font = [UIFont systemFontOfSize:textFont];
        _moneyTextfield.leftView = label;
        _moneyTextfield.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return _moneyTextfield;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"通告总金额";
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        
        NSString *subTitle = nil;
        if (_taskType == TaskFree) {
            subTitle = @"价格越低，能越快的收到邀请，活动的成功率越高";
        }
        else {
            subTitle = @"金额越高，报名的达人会更积极，您的选择就越多";
        }
        _subTitleLabel.text = subTitle;
        _subTitleLabel.textColor = RGBCOLOR(244, 203, 7);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.font = CustomFont(12);
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

- (UILabel *)moneyDescriptLabel {
    if (!_moneyDescriptLabel) {
        _moneyDescriptLabel = [[UILabel alloc] init];
        _moneyDescriptLabel.text = [NSString stringWithFormat:@"通告总金额，包含%.0f%%的通告服务费和%.0f%%租金，发布成功后，服务费不可退还；若未选人，租金将原路退还给您",UserHelper.configModel.pd_agency * 100, (1 - UserHelper.configModel.pd_agency) * 100];
        //@"邀约总金额，包含30%的发布服务费和70%租金，发布成功后，服务费不可退还；若未选人，租金将原路退还给您";
        _moneyDescriptLabel.textColor = HEXCOLOR(0x3F3A3A);
        _moneyDescriptLabel.textAlignment = NSTextAlignmentCenter;
        _moneyDescriptLabel.font = CustomFont(13);
        _moneyDescriptLabel.numberOfLines = 0;
    }
    return _moneyDescriptLabel;
}

@end
