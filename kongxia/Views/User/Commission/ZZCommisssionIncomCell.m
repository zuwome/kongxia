//
//  ZZCommisssionIncomCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/2.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommisssionIncomCell.h"
#import "ZZCommissionIncomModel.h"

@interface ZZCommisssionIncomCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) UIImageView *verifyImageView;

@property (nonatomic, strong) ZZLevelImgView *levelImageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *incomeIconImageView;

@property (nonatomic, strong) UILabel *incomeLabel;

@end

@implementation ZZCommisssionIncomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[_incomeModel.to displayAvatar]] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIImage *roundImage = [image imageAddCornerWithRadius:50 / 2 andSize:CGSizeMake(50, 50)];
        _iconImageView.image = roundImage;
    }];
        
    _nameLabel.text = _incomeModel.to.nickname;
    
    // gender
    if (_incomeModel.to.gender == 2) {
        _genderImageView.image = [UIImage imageNamed:@"girl"];
    }
    else if (_incomeModel.to.gender == 1) {
        _genderImageView.image = [UIImage imageNamed:@"boy"];
    }
    else {
        _genderImageView.image = [UIImage imageNamed:@""];
    }
    
    // verify
    if ([_incomeModel.to isIdentifierCertified]) {
        [_verifyImageView setHidden: NO];
    }
    else {
        [_verifyImageView setHidden: YES];
    }
    
    // level
    [_levelImageView setLevel:_incomeModel.to.level];
    
    // income
    _incomeLabel.text = [NSString stringWithFormat:@"您获得平台分红%.2f元分红", _incomeModel.agency_price];
    
    // time
    if (isNullString(_incomeModel.created_at_desc)) {
        _incomeModel.created_at_desc = [[ZZDateHelper shareInstance] getCommissionTimeDesc:_incomeModel.created_at];
    }
    _timeLabel.text = _incomeModel.created_at_desc;
    
    [self createFrame];
}

#pragma mark - response method
- (void)showUserInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(incomeCell:showUserInfo:)]) {
        [self.delegate incomeCell:self showUserInfo:_incomeModel.to];
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
    [_bgView addSubview:self.timeLabel];
    [_bgView addSubview:self.incomeLabel];
    [_bgView addSubview:self.incomeIconImageView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.left.equalTo(_bgView).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [_incomeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10.0);
        make.bottom.equalTo(_iconImageView).offset(-7);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_incomeIconImageView);
        make.left.equalTo(_incomeIconImageView.mas_right).offset(4);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.right.equalTo(_bgView).offset(-15);
    }];
    
    UIView *seperateLine = [[UIView alloc] init];
    seperateLine.backgroundColor = RGBCOLOR(237, 237, 237);
    [_bgView addSubview:seperateLine];
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bgView);
        make.left.equalTo(_bgView).offset(15.0);
        make.right.equalTo(_bgView).offset(-15.0);
        make.height.equalTo(@0.5);
    }];
}

- (void)createFrame {

    CGFloat width = [NSString findWidthForText:_incomeModel.to.nickname havingWidth:150 andFont:_nameLabel.font];
    _nameLabel.frame = CGRectMake(65 + 8, 23.0, width, _nameLabel.font.lineHeight);

    // 性别
    if (_incomeModel.to.gender == 2 || _incomeModel.to.gender == 1) {
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
    if ([_incomeModel.to isIdentifierCertified]) {
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
- (void)setIncomeModel:(ZZCommissionIncomModel *)incomeModel {
    _incomeModel = incomeModel;
    [self configureData];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
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

- (UIImageView *)incomeIconImageView {
    if (!_incomeIconImageView) {
        _incomeIconImageView = [[UIImageView alloc] init];
        _incomeIconImageView.image = [UIImage imageNamed:@"icHhrfh"];
    }
    return _incomeIconImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = RGBCOLOR(190, 190, 190);
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    }
    return _timeLabel;
}

- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.textColor = RGBCOLOR(153, 153, 153);
        _incomeLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    }
    return _incomeLabel;
}

@end
