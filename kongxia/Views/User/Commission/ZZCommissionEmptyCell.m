//
//  ZZCommissionEmptyCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionEmptyCell.h"

@interface ZZCommissionEmptyCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *goInviteBtn;

@end

@implementation ZZCommissionEmptyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - private method
- (void)configureData {
    NSString *icon = @"picKztWdfh";
    if (_type == CommissionDetails) {
        _titleLabel.text = @"暂无好友消费、或创造收入";
        _goInviteBtn.hidden = YES;
        icon = @"picKztWdfh";
    }
    else if (_type == CommissionIncome) {
        _titleLabel.text = @"邀请好友来空虾\n他消费、赚钱你都有现金分红";
        _goInviteBtn.hidden = NO;
        _goInviteBtn.normalTitle = @"可以获得多少现金分红?";
        icon = @"picYaoqinghaoyou";
    }
    else {
        _titleLabel.text = @"暂无注册成功的好友";
        _goInviteBtn.hidden = YES;
        icon = @"picWuzhucehaoyou";
    }
    _iconImageView.image = [UIImage imageNamed:icon];
}

#pragma mark - response method
- (void)action {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:btnAction:)]) {
        [self.delegate cell:self btnAction:_type];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.goInviteBtn];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(48.0);
        make.size.mas_equalTo(CGSizeMake(136, 84));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_iconImageView.mas_bottom).offset(12.0);
    }];
    
    [_goInviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_titleLabel.mas_bottom).offset(20.0);
        make.size.mas_equalTo(CGSizeMake(210.0, 44.0));
    }];
}

#pragma mark - getters and setters
- (void)setType:(CommissionDetailsType)type {
    _type = type;
    [self configureData];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"picKztWdfh"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(153, 153, 153);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _titleLabel.text = @"您还未邀请好友，暂时不能参与分红哦";
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)goInviteBtn {
    if (!_goInviteBtn) {
        _goInviteBtn = [[UIButton alloc] init];
        _goInviteBtn.normalTitle = @"去邀请";
        _goInviteBtn.normalTitleColor = RGBCOLOR(74, 144, 226);
        _goInviteBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        
        [_goInviteBtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goInviteBtn;
}

@end
