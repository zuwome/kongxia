//
//  ZZExChangeAlertView.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/22.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZExChangeAlertView.h"
@interface ZZExChangeAlertView()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *detailLab;
@property (nonatomic,strong) UIButton *exChangeButton;
@property (nonatomic,strong) UIView *inputView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel *equalLab;
@property (nonatomic,strong) UILabel *meBiLab;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *lineVerticalView;
@property (nonatomic,strong) ZZIntegralExChangeModel *model;
@end
@implementation ZZExChangeAlertView

- (void)showAlerViewwithModel:(ZZIntegralExChangeModel *)model {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self setUpUI];
    [self showView:nil];
    self.model = model;
    self.detailLab.text = [NSString stringWithFormat:@"账户: %ld积分",model.integral];
    if ([self.model.selectIntegral integerValue]>0) {
        self.textField.text = [NSString stringWithFormat:@"%@积分", self.model.selectIntegral];
        self.meBiLab.text = [NSString stringWithFormat:@"%ld么币",[self.model.selectIntegral integerValue]/self.model.scale];
    }
}

- (void)setUpUI {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.imageView];
    [self.bgView addSubview:self.detailLab];
    [self.bgView addSubview:self.inputView];
    [self.bgView addSubview:self.textField];
    [self.bgView addSubview:self.equalLab];

    [self.bgView addSubview:self.closeButton];
    [self.bgView addSubview:self.meBiLab];
      [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.exChangeButton];
    [self.bgView addSubview:self.lineVerticalView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(AdaptedWidth(302.5)));
        make.height.equalTo(self.bgView.mas_width).multipliedBy(232.0f/302.5f);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AdaptedWidth(105));
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.bgView.mas_centerY).multipliedBy(0.29);
    }];
    
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY).multipliedBy(0.591);
        make.height.equalTo(@21);
        make.centerX.equalTo(self.bgView.mas_centerX);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imageView.mas_centerY);
        make.left.equalTo(self.imageView.mas_right).offset(3.5);
    }];
    
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(21);
        make.right.offset(-21);
        make.centerY.equalTo(self.bgView.mas_centerY).multipliedBy(1.112);
        make.height.equalTo(@50);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputView.mas_left).offset(23.5);
        make.width.equalTo(@120);
        make.height.equalTo(@21);
        make.centerY.equalTo(self.inputView.mas_centerY);
    }];
    [self.equalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.mas_right).offset(2);
        make.width.equalTo(@10);
        make.centerY.equalTo(self.inputView.mas_centerY);
        
    }];
    
    [self.meBiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.equalLab.mas_right).offset(2);
        make.right.equalTo(self.inputView.mas_right).offset(-20);
        make.centerY.equalTo(self.inputView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.closeButton.mas_top);
    }];
    
    [self.lineVerticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.width.equalTo(@0.5);
        make.height.equalTo(@49);
        make.bottom.offset(0);
    }];
    
    [self.exChangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.offset(0);
        make.left.equalTo(self.lineVerticalView.mas_right);
        make.height.equalTo(@49);
    
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.right.equalTo(self.lineVerticalView.mas_left);
        make.height.equalTo(@49);
        make.width.equalTo(self.exChangeButton.mas_width);
    }];
}

- (UILabel *)titleLab {
    if (!_titleLab ) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"兑换么币";
        _titleLab.textColor = RGBCOLOR(244, 203, 7);
        _titleLab.font = ADaptedFontSCBoldSize(17);
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"icMebiJfdh"];
    }
    return _imageView;
}

- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc]init];
        _detailLab.textAlignment = NSTextAlignmentCenter;
        _detailLab.textColor = RGBCOLOR(140, 140, 140);
        _detailLab.font = CustomFont(15);
    }
    return _detailLab;
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc]init];
        _inputView.layer.cornerRadius = 25;
        _inputView.backgroundColor = RGBCOLOR(255, 253, 246);
        _inputView.layer.borderWidth = 1;
        _inputView.layer.borderColor = [RGBCOLOR(244, 203, 7) CGColor];
    }
    return _inputView;
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.placeholder = @"请输入兑换积分";
        _textField.font = CustomFont(15);
        [_textField setValue:RGBCOLOR(171, 171, 171) forKeyPath:@"placeholderLabel.textColor"];
        [_textField setValue:CustomFont(15) forKeyPath:@"placeholderLabel.font"];
        _textField.textColor = kBlackColor;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        [_textField addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _textField;
}
- (void)textValueChange:(UITextField *)textField
{
    self.meBiLab.text = [NSString stringWithFormat:@"%ld么币",[textField.text integerValue]/self.model.scale];
}
- (UILabel *)equalLab {
    if (!_equalLab) {
        _equalLab = [[UILabel alloc]init];
        _equalLab.textAlignment = NSTextAlignmentCenter;
        _equalLab.textColor = kBlackColor;
        _equalLab.text = @"=";
        _equalLab.font = ADaptedFontMediumSize(15);
        
    }
    return _equalLab;
}

- (UILabel *)meBiLab {
    if (!_meBiLab) {
        _meBiLab = [[UILabel alloc]init];
        _meBiLab.textAlignment = NSTextAlignmentLeft;
        _meBiLab.textColor = RGBCOLOR(244, 203, 7);
        _meBiLab.font = ADaptedFontMediumSize(15);
        _meBiLab.text = @"0么币";
    }
    return _meBiLab;
}
- (UIView *)lineView {
    if (!_lineView ) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(216, 216, 216);
    }
    return _lineView;
}

- (UIView *)lineVerticalView {
    if (!_lineVerticalView ) {
        _lineVerticalView = [[UIView alloc]init];
        _lineVerticalView.backgroundColor = RGBCOLOR(216, 216, 216);
    }
    return _lineVerticalView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"取消" forState:UIControlStateNormal];
        [_closeButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _closeButton.titleLabel.font = CustomFont(15);
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)closeButtonClick {
    [self dissMiss];
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8.5;
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}


- (UIButton *)exChangeButton {
    if (!_exChangeButton) {
        _exChangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exChangeButton addTarget:self action:@selector(exChangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_exChangeButton setTitle:@"兑换" forState:UIControlStateNormal];
        [_exChangeButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _exChangeButton.titleLabel.font = CustomFont(15);
    }
    return _exChangeButton;
}

- (void)exChangeButtonClick:(UIButton *)sender {
    if ([self.textField.text integerValue]%10 != 0) {
        [ZZHUD showTaskInfoWithStatus:@"请输入10的倍数"];
        return;
    }
    if ([self.textField.text integerValue]<10) {
        [ZZHUD showTaskInfoWithStatus:@"兑换么币至少需要10积分"];
        return;
    }
    
 
    
    if (self.exChangeBlock) {
        self.exChangeBlock([self.textField.text intValue],sender);
    }
}
@end
