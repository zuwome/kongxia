//
//  ZZPhoneInputView.m
//  zuwome
//
//  Created by angBiu on 2016/11/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPhoneInputView.h"

@interface ZZPhoneInputView ()

@property(nonatomic, assign)bool showBingdinView;

@end

@implementation ZZPhoneInputView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame showBingdinView:NO];
}

- (instancetype)initWithFrame:(CGRect)frame showBingdinView:(BOOL)showBingdinView {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _showBingdinView = showBingdinView;
        self.userInteractionEnabled = !showBingdinView;
        
        if (!_showBingdinView) {
            if ([ZZUserHelper shareInstance].countryCode) {
                self.text = [ZZUserHelper shareInstance].countryCode;
            }
            else {
                self.text = @"+86";
            }
        }
        else {
            self.text = @"已绑定";
        }
        self.textField.text = @"";
        [self setUp];
        _codeLabel.textColor =  !_showBingdinView ? UIColor.blackColor : UIColor.grayColor;
    }
    
    return self;
}

- (void)setUp {
    [self addSubview:self.codeLabel];
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(20);
    }];
    
    if (!_showBingdinView) {
        UIImageView *triangleImgView = [[UIImageView alloc] init];
        triangleImgView.image = [UIImage imageNamed:@"icon_login_triangle"];
        [self addSubview:triangleImgView];
        
        [triangleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_codeLabel.mas_right).offset(3);
            make.centerY.mas_equalTo(_codeLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(9, 3.5));
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_codeLabel.mas_left);
            make.top.mas_equalTo(_codeLabel.mas_top);
            make.bottom.mas_equalTo(_codeLabel.mas_bottom);
            make.right.mas_equalTo(triangleImgView.mas_right);
        }];
    }
    
    [self addSubview:self.textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(85);
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)setText:(NSString *)text
{
    self.codeLabel.text = text;
    
    CGFloat width = [ZZUtils widthForCellWithText:text fontSize:15];
    
    [_codeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return NO;
}

- (void)btnClick
{
    [MobClick event:Event_click_choose_countrycode];
    if (_touchCode) {
        _touchCode();
    }
}

#pragma mark - lazyload

- (UILabel *)codeLabel
{
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.textColor = kBlackTextColor;
        _codeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _codeLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"请输入手机号码";
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
    }
    return _textField;
}

@end
