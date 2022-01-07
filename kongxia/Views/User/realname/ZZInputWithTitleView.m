//
//  ZZInputWithTitleView.m
//  zuwome
//
//  Created by 潘杨 on 2018/7/6.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZInputWithTitleView.h"
@interface ZZInputWithTitleView()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *promptTitle;


@property (nonatomic,strong) UIView *lineView;

@end

@implementation ZZInputWithTitleView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title placeholderTitle:(NSString *)placeholderTitle {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.promptTextField];
        [self addSubview:self.lineView];
        [self addSubview:self.promptTitle];

        self.promptTextField.placeholder = placeholderTitle;
        self.backgroundColor = [UIColor whiteColor];
        self.promptTitle.text = title;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.promptTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.offset(15);
        make.width.equalTo(@50);
    }];
    
    [self.promptTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.lessThanOrEqualTo(self.promptTitle.mas_right).offset(10);
        make.height.equalTo(@44);
        make.right.offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = kBGColor;
    }
    return _lineView;
}

- (UILabel *)promptTitle  {
    if (!_promptTitle) {
        _promptTitle = [[UILabel alloc]init];
        _promptTitle.textColor = RGBCOLOR(0, 0, 0);
        _promptTitle.textAlignment = NSTextAlignmentLeft;
        _promptTitle.font = CustomFont(15);
    }
    return _promptTitle;
}


- (UITextField *)promptTextField {
    if (!_promptTextField) {
        _promptTextField = [[UITextField alloc]init];
        _promptTextField.placeholder = @"请输入银行卡卡号";
        [_promptTextField setValue:RGBCOLOR(204, 204, 204) forKeyPath:@"placeholderLabel.textColor"];
        _promptTextField.font = CustomFont(15);
        _promptTextField.textColor = kBlackColor;
        _promptTextField.textAlignment = NSTextAlignmentLeft;
        _promptTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _promptTextField.delegate = self;
        _promptTextField.returnKeyType = UIReturnKeyDone;
    }
    return _promptTextField;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}
@end
