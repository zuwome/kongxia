//
//  ZZPasswordInputView.m
//  zuwome
//
//  Created by angBiu on 2016/11/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPasswordInputView.h"

@implementation ZZPasswordInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.hideBtn.selected = YES;
        self.textField.placeholder = @"6 - 16位字母和数字组合";
        self.infoLabel.text = @"密码";
    }
    
    return self;
}

#pragma mark - UIButtonMethod

- (void)hideBtnClick
{
    if (_hideBtn.selected) {
        _hideBtn.selected = NO;
        _textField.secureTextEntry = NO;
        
    } else {
        _hideBtn.selected = YES;
        _textField.secureTextEntry = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_touchReturn) {
        _touchReturn();
    }
    [self endEditing:YES];
    return NO;
}

#pragma mark - 

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = kBlackTextColor;
        _infoLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_infoLabel];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(20);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    
    return _infoLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = kBlackTextColor;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.secureTextEntry = YES;
        _textField.delegate = self;
        [self addSubview:_textField];
        //字母和数字的组合方式
        _textField.keyboardType = UIKeyboardTypeASCIICapable;

        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(85);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.hideBtn.mas_left).offset(-2);
        }];
    }
    
    return _textField;
}

- (UIButton *)hideBtn
{
    if (!_hideBtn) {
        _hideBtn = [[UIButton alloc] init];
      
        [_hideBtn addTarget:self action:@selector(hideBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_hideBtn setImage:[UIImage imageNamed:@"icMimaBukejian"] forState:UIControlStateSelected];
        
        [_hideBtn setImage:[UIImage imageNamed:@"icMimaKejian"] forState:UIControlStateNormal];
        [self addSubview:_hideBtn];
        [_hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 40));
        }];
    }
    
    return _hideBtn;
}

@end
