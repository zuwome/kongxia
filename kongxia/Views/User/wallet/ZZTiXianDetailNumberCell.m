//
//  ZZTiXianDetailNumberCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/12.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZTiXianDetailNumberCell.h"
@interface ZZTiXianDetailNumberCell()
@property (nonatomic,strong)UILabel *titleLab;

/**
 钱的标识
 */
@property (nonatomic,strong)UILabel *logoLab;


/**
 提现的详情描述
 */
@property (nonatomic,strong)UILabel *tiXianDetailLab;
/**
 全部提现
 */
@property (nonatomic,strong)UIButton *allTiXianButton;

@end
@implementation ZZTiXianDetailNumberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.logoLab];
    [self.bgView addSubview:self.tiXianTextField];
    [self.bgView addSubview:self.tiXianDetailLab];
    [self.bgView addSubview:self.allTiXianButton];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(10);
        make.height.equalTo(@21);
        make.right.offset(-15);
    }];
    
    [self.logoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        make.width.equalTo(@26);
        make.bottom.equalTo(self.lineView.mas_top).offset(-3);
    }];
    
    [self.tiXianTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoLab.mas_right);
        make.centerY.equalTo(self.logoLab.mas_centerY);
        make.right.offset(-15);
        make.height.equalTo(@50);
    }];
    
    [self.tiXianDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-150);
        make.top.equalTo(self.lineView.mas_bottom).offset(3);
        make.bottom.offset(0);
    }];
    
    [self.allTiXianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
        make.centerY.equalTo(self.tiXianDetailLab.mas_centerY);
    }];

}

- (void)setMaxMoneyNumber:(NSString *)maxMoneyNumber {
    
    if (_maxMoneyNumber != maxMoneyNumber) {
        _maxMoneyNumber = maxMoneyNumber;
        self.tiXianDetailLab.text = [NSString stringWithFormat:@"可提现余额%@元",maxMoneyNumber];
    }
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"提现金额";
        _titleLab.font = ADaptedFontMediumSize(15);
        _titleLab.textColor = kBlackColor;
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UITextField *)tiXianTextField {
    if (!_tiXianTextField) {
        _tiXianTextField = [[UITextField alloc]init];
        _tiXianTextField.placeholder = @"50元 — 2000元";
        [_tiXianTextField setValue:RGBCOLOR(204, 204, 204) forKeyPath:@"placeholderLabel.textColor"];
        _tiXianTextField.font = ADaptedFontMediumSize(15);
        _tiXianTextField.textColor = kBlackColor;
        _tiXianTextField.textAlignment = NSTextAlignmentLeft;
        _tiXianTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tiXianTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _tiXianTextField.returnKeyType = UIReturnKeyDone;
    }
    return _tiXianTextField;
}

-(UILabel *)tiXianDetailLab {
    if (!_tiXianDetailLab) {
        _tiXianDetailLab = [[UILabel alloc]init];
        _tiXianDetailLab.textAlignment = NSTextAlignmentLeft;
        _tiXianDetailLab.textColor = kBlackColor;
        _tiXianDetailLab.font = CustomFont(15);
    }
    return _tiXianDetailLab;
}
- (UILabel *)logoLab {
    if (!_logoLab) {
        _logoLab = [[UILabel alloc]init];
        _logoLab.text = @"￥";
        _logoLab.font = ADaptedFontBoldSize(24);
        _logoLab.textColor = kBlackColor;
        _logoLab.textAlignment = NSTextAlignmentLeft;
    }
    return _logoLab;
}
- (UIButton *)allTiXianButton {
    if (!_allTiXianButton) {
        _allTiXianButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allTiXianButton addTarget:self action:@selector(tixianClick) forControlEvents:UIControlEventTouchUpInside];
        [_allTiXianButton setTitle:@"全部提现" forState:UIControlStateNormal];
        [_allTiXianButton setTitleColor:RGBCOLOR(244, 203, 7) forState:UIControlStateNormal];
        _allTiXianButton.titleLabel.font = CustomFont(15);
    }
    return _allTiXianButton;
}
- (void)tixianClick {
    if ([self.maxMoneyNumber intValue] > (long)[ZZUserHelper shareInstance].configModel.max_bankcard_transfer) {
        self.tiXianTextField.text = [NSString stringWithFormat:@"%ld",(long)[ZZUserHelper shareInstance].configModel.max_bankcard_transfer];
    }
    else {
        self.tiXianTextField.text = self.maxMoneyNumber;
    }
    
    if (self.allTiXianBlock) {
        self.allTiXianBlock();
    }
}


-(void)layoutSubviews {
    [super layoutSubviews];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-39);
        make.height.equalTo(@0.5);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7.5);
        make.right.offset(-7.5);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
}

@end
