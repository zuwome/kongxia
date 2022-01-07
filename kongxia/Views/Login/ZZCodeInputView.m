//
//  ZZCodeInputView.m
//  zuwome
//
//  Created by angBiu on 2016/11/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZCodeInputView.h"

@implementation ZZCodeInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.infoLabel.text = @"验证码";
        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        self.textField.placeholder = @"请输入验证码";
    }
    
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(85);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.right.mas_equalTo(_sendBtn.mas_left).offset(-15);
        }];
    }
    
    return _textField;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#cccccc" andAlpha:1] cornerRadius:0] forState:UIControlStateDisabled];
        [_sendBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:ZWM_YELLOW andAlpha:1] cornerRadius:0] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        [_sendBtn setTitleColor:kBlackTextColor forState:UIControlStateDisabled];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sendBtn.layer.cornerRadius = 3;
        _sendBtn.clipsToBounds = YES;
        [self addSubview:_sendBtn];
        
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-20);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 37));
        }];
    }
    
    return _sendBtn;
}

@end
