//
//  ZZOrderCheckWeChatCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZOrderCheckWeChatCell.h"

@interface ZZOrderCheckWeChatCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton *checkButton;

@property (nonatomic, strong) UIImageView *infoImageView;

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation ZZOrderCheckWeChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)checkWechat:(BOOL)check price:(double)price {
    _subTitleLabel.text = [NSString stringWithFormat:@"%.0f",price];
    _checkButton.selected = check;
}

- (void)selectService {
    if (_delegate && [_delegate respondsToSelector:@selector(selectService:)]) {
        [_delegate selectService:self];
    }
}

#pragma mark - UI
- (void)layout {
    [self addSubview:self.titleLabel];
    [self addSubview:self.checkButton];
    [self addSubview:self.infoImageView];
    [self addSubview:self.iconImageView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(16.0, 16.0));
    }];
    
    [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.bottom.equalTo(self);
        make.width.equalTo(@45.0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(_iconImageView.mas_trailing).offset(13.5);
    }];
    
    [_infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(_titleLabel.mas_trailing).offset(8.0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
}

#pragma mark - Setter&Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"优享邀约服务";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
    }
    return _subTitleLabel;
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [[UIButton alloc] init];
        [_checkButton setImage:[UIImage imageNamed:@"btn_report_n"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"btn_report_p"] forState:UIControlStateSelected];
        [_checkButton addTarget:self action:@selector(selectService) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}

- (UIImageView *)infoImageView {
    if (!_infoImageView) {
        _infoImageView = [[UIImageView alloc] init];
        _infoImageView.image = [UIImage imageNamed:@"icHelpYyCopy"];
        _infoImageView.userInteractionEnabled = YES;
        _infoImageView.contentMode = UIViewContentModeScaleAspectFit;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailInfo)];
//        [_infoImageView addGestureRecognizer:tap];
    }
    return _infoImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icYxyyfwYyCopy"];
        
    }
    return _iconImageView;
}

@end
