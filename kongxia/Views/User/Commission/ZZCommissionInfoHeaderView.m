//
//  ZZCommisstionInfoCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionInfoHeaderView.h"
#import "ZZCommissionListModel.h"

@interface ZZCommissionInfoHeaderView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) UIImageView *verifyImageView;

@property (nonatomic, strong) ZZLevelImgView *levelImageView;

@property (nonatomic, strong) UILabel *meIDlabel;

@property (nonatomic, strong) UILabel *earnedLabel;

@property (nonatomic, strong) UIImageView *downIconImageView;

@end

@implementation ZZCommissionInfoHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[_userCommissionModel.to displayAvatar]] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIImage *roundImage = [image imageAddCornerWithRadius:50 / 2 andSize:CGSizeMake(50, 50)];
        _iconImageView.image = roundImage;
    }];
        
    _nameLabel.text = _userCommissionModel.to.nickname;
    
    _meIDlabel.text = [NSString stringWithFormat:@"么么号: %@", _userCommissionModel.to.ZWMId];
    
    _earnedLabel.text = [NSString stringWithFormat:@"已创收¥%.2f", _userCommissionModel.total_money];
    
    // gender
    if (_userCommissionModel.to.gender == 2) {
        _genderImageView.image = [UIImage imageNamed:@"girl"];
    }
    else if (_userCommissionModel.to.gender == 1) {
        _genderImageView.image = [UIImage imageNamed:@"boy"];
    }
    else {
        _genderImageView.image = [UIImage imageNamed:@""];
    }
    
    // verify
    if ([_userCommissionModel.to isIdentifierCertified]) {
        [_verifyImageView setHidden: NO];
    }
    else {
        [_verifyImageView setHidden: YES];
    }
    
    // level
    [_levelImageView setLevel:_userCommissionModel.to.level];
    
    [self createFrame];
}

#pragma mark - response method
- (void)showUserInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:showUserInfo:)]) {
        [self.delegate view:self showUserInfo:_userCommissionModel.to];
    }
}

- (void)showDetails {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewShouldShowDetails:)]) {
        [self.delegate viewShouldShowDetails:self];
    }
}

#pragma mark - Layout
- (void)layout {
    self.contentView.backgroundColor = RGBCOLOR(247, 247, 247);
    
    [self.contentView addSubview:self.bgView];
    [_bgView addSubview:self.iconImageView];
    [_bgView addSubview:self.nameLabel];
    [_bgView addSubview:self.genderImageView];
    [_bgView addSubview:self.verifyImageView];
    [_bgView addSubview:self.levelImageView];
    [_bgView addSubview:self.meIDlabel];
    [_bgView addSubview:self.earnedLabel];
    [_bgView addSubview:self.downIconImageView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    [_meIDlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(2.0);
        make.left.equalTo(_nameLabel);
    }];
    
    [_downIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.right.equalTo(_bgView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(10, 6));
    }];
    
    [_earnedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(_bgView);
        make.right.equalTo(_downIconImageView.mas_left).offset(-5);
    }];
}

- (void)createFrame {
    _iconImageView.frame = CGRectMake(15.0, 20.0, 50.0, 50.0);
    CGFloat width = [NSString findWidthForText:_userCommissionModel.to.nickname havingWidth:150 andFont:_nameLabel.font];
    _nameLabel.frame = CGRectMake(_iconImageView.right + 8, 23.0, width, _nameLabel.font.lineHeight);
    
    // 性别
    if (_userCommissionModel.to.gender == 2 || _userCommissionModel.to.gender == 1) {
        _genderImageView.frame = CGRectMake(_nameLabel.right + 5.0,
                                            _nameLabel.height * 0.5 - 6 + _nameLabel.top,
                                            12,
                                            12);
    }
    else {
        _genderImageView.frame = CGRectMake(_nameLabel.right,
                                            _nameLabel.height * 0.5 - 6 + _nameLabel.top,
                                            0.0,
                                            0.0);
    }
    
    // 认证
    if ([_userCommissionModel.to isIdentifierCertified]) {
        [_verifyImageView setHidden: NO];
        _verifyImageView.frame = CGRectMake(_genderImageView.right + 5,
                                            _nameLabel.height * 0.5 - 7 + _nameLabel.top,
                                            19,
                                            14);
    }
    else {
        [_verifyImageView setHidden: YES];
        _verifyImageView.frame = CGRectMake(_genderImageView.right,
                                            _nameLabel.height * 0.5 - 7 + _nameLabel.top,
                                            0.0,
                                            0.0);
    }
    
    // 等级
    _levelImageView.hidden = NO;
    _levelImageView.frame = CGRectMake(_verifyImageView.right + 5.0,
                                       _nameLabel.height * 0.5 - 7 + _nameLabel.top,
                                       28.0,
                                       14.0);
}

#pragma mark - getters and setters
- (void)setUserCommissionModel:(ZZCommissionUserModel *)userCommissionModel {
    _userCommissionModel = userCommissionModel;
    [self configureData];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetails)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        
        _iconImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
        [_iconImageView addGestureRecognizer:tap];
    }
    return _iconImageView;
}

- (UIImageView *)genderImageView {
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc] init];
    }
    return _genderImageView;
}

- (UIImageView *)verifyImageView {
    if (!_verifyImageView) {
        _verifyImageView = [[UIImageView alloc] init];
        _verifyImageView.image = [UIImage imageNamed:@"icon_identifier"];
    }
    return _verifyImageView;
}

- (ZZLevelImgView *)levelImageView {
    if (!_levelImageView) {
        _levelImageView = [[ZZLevelImgView alloc] init];
    }
    return _levelImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = RGBCOLOR(63, 58, 58);
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    }
    return _nameLabel;
}

- (UILabel *)meIDlabel {
    if (!_meIDlabel) {
        _meIDlabel = [[UILabel alloc] init];
        _meIDlabel.textColor = RGBCOLOR(190, 190, 190);
        _meIDlabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    }
    return _meIDlabel;
}

- (UILabel *)earnedLabel {
    if (!_earnedLabel) {
        _earnedLabel = [[UILabel alloc] init];
        _earnedLabel.textColor = RGBCOLOR(153, 153, 153);
        _earnedLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    return _earnedLabel;
}

- (UIImageView *)downIconImageView {
    if (!_downIconImageView) {
        _downIconImageView = [[UIImageView alloc] init];
        _downIconImageView.image = [UIImage imageNamed:@"icDown_comm"];
    }
    return _downIconImageView;
}

@end
