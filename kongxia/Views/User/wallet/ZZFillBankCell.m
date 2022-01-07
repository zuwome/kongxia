//
//  ZZFillBankCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZFillBankCell.h"
@interface ZZFillBankCell()
@property (nonatomic,strong) UILabel *titleLab;//提示
@property (nonatomic,strong) UILabel *cardholderLab;//持卡人
@property (nonatomic,strong) UILabel *cardholderNameLab;//持卡人的名字
@property (nonatomic,strong) UILabel *cardNumberLab;//卡号
@property (nonatomic,strong) UIButton *detailButton;//持卡的详情

@end
@implementation ZZFillBankCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.bgView addSubview:self.lineView];
    [self.contentView addSubview:self.titleLab];
    [self.bgView addSubview:self.cardholderLab];
    [self.bgView addSubview:self.cardholderNameLab];
    [self.bgView addSubview:self.cardNumberLab];
    [self.bgView addSubview:self.detailButton];
    [self.bgView addSubview:self.carNumberTextField];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.offset(0);
        make.bottom.equalTo(self.bgView.mas_top);
    }];
    [self.cardholderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView.mas_top);
        make.top.offset(0);
        make.left.offset(15);
        make.width.equalTo(@50);
        make.right.equalTo(self.cardholderNameLab.mas_left).offset(-18);
    }];
    
    [self.cardholderNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(150);
        make.bottom.equalTo(self.lineView.mas_top);
        make.top.offset(0);
    }];
    
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(self.cardholderLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    [self.cardNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.offset(0);
    }];
    [self.carNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardholderLab.mas_right).offset(18);
        make.right.offset(-15);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.offset(0);
    }];
}
- (void)setUserName:(NSString *)userName {
    if (_userName != userName) {
        _userName = userName;
        self.cardholderNameLab.text = userName;
    }
}
- (UILabel *)cardholderLab {
    if (!_cardholderLab) {
        _cardholderLab = [[UILabel alloc]init];
        _cardholderLab.textColor = kBlackColor;
        _cardholderLab.text = @"持卡人";
        _cardholderLab.font = CustomFont(15);
        _cardholderLab.textAlignment = NSTextAlignmentLeft;
        
    }
    return _cardholderLab;
}
- (UILabel *)cardNumberLab {
    if (!_cardNumberLab) {
        _cardNumberLab = [[UILabel alloc]init];
        _cardNumberLab.textColor = kBlackColor;
        _cardNumberLab.text = @"卡号";
        _cardNumberLab.font = CustomFont(15);
        _cardNumberLab.textAlignment = NSTextAlignmentLeft;
    }
    return _cardNumberLab;
}
- (UILabel *)cardholderNameLab {
    if (!_cardholderNameLab) {
        _cardholderNameLab = [[UILabel alloc]init];
        _cardholderNameLab.textColor = [UIColor blackColor];
        _cardholderNameLab.font = CustomFont(15);
        _cardholderNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _cardholderNameLab;
}

-(UITextField *)carNumberTextField {
    if (!_carNumberTextField) {
        _carNumberTextField = [[UITextField alloc]init];
        _carNumberTextField.placeholder = @"请输入银行卡卡号";
        [_carNumberTextField setValue:RGBCOLOR(204, 204, 204) forKeyPath:@"placeholderLabel.textColor"];
        _carNumberTextField.font = CustomFont(15);
        _carNumberTextField.textColor = kBlackColor;
        _carNumberTextField.textAlignment = NSTextAlignmentLeft;
        _carNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _carNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _carNumberTextField.returnKeyType = UIReturnKeyDone;

    }
    return _carNumberTextField;
}

- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailButton setImage:[UIImage imageNamed:@"icDetails"] forState:UIControlStateNormal];
        [_detailButton addTarget:self action:@selector(clickDetailInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}

-(UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"请填写持卡人本人的银行卡";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = RGBCOLOR(161, 161, 161);
        _titleLab.font = CustomFont(12);
    }
    return _titleLab;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.equalTo(@0.5);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7.5);
        make.right.offset(-7.5);
        make.top.offset(28);
        make.bottom.offset(-12);
    }];
}

/**
 点击查看详情,弹出提示为了保证提现成功,只能填写和实名认证一致的银行卡
 */
- (void)clickDetailInfoButton:(UIButton *)sender {
    
    if (self.detailClickBlock) {
        self.detailClickBlock(sender);
    }
}
@end
