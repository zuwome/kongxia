//
//  ZZCommissionInviteCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/2.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionInviteCell.h"
#import "ZZCommissionListModel.h"
#import "ZZCommissionInviteUserModel.h"

@interface ZZCommissionInviteCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) UIImageView *verifyImageView;

@property (nonatomic, strong) ZZLevelImgView *levelImageView;

@property (nonatomic, strong) UILabel *incomeLabel;

@property (nonatomic, strong) UIButton *actionbtn;

@end

@implementation ZZCommissionInviteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - private method
- (void)configureData {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[_userModel.to displayAvatar]] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIImage *roundImage = [image imageAddCornerWithRadius:50 / 2 andSize:CGSizeMake(50, 50)];
        _iconImageView.image = roundImage;
    }];
        
    _nameLabel.text = _userModel.to.nickname;
    
    // gender
    if (_userModel.to.gender == 2) {
        _genderImageView.image = [UIImage imageNamed:@"girl"];
    }
    else if (_userModel.to.gender == 1) {
        _genderImageView.image = [UIImage imageNamed:@"boy"];
    }
    else {
        _genderImageView.image = [UIImage imageNamed:@""];
    }
    
    // verify
    if ([_userModel.to isIdentifierCertified]) {
        [_verifyImageView setHidden: NO];
    }
    else {
        [_verifyImageView setHidden: YES];
    }
    
    // level
    [_levelImageView setLevel:_userModel.to.level];
    
    // status
    NSString *status = nil;
    BOOL shouldShowBtn = NO;
    NSInteger actionTag = 9999;
    if (_userModel.to.gender == 1) {
        status = @"已注册成功";
    }
    else {
        if (_userModel.to.rent.status == 0) {
            status = @"未申请达人";
            shouldShowBtn = YES;
            actionTag = 0;
        }
        else {
            if (_userModel.to.have_wechat_no) {
                status = @"已申请达人";
            }
            else {
                status = @"未填写微信号";
                shouldShowBtn = YES;
                actionTag = 1;
            }
        }
    }
    
    _incomeLabel.text = status;
    
    _actionbtn.hidden = !shouldShowBtn;
    if (shouldShowBtn) {
        if ([[ZZUserHelper shareInstance].remindedUID containsObject:_userModel.to.uuid]) {
            _actionbtn.enabled = NO;
            _actionbtn.normalTitle = @"已提醒";
        }
        else {
            _actionbtn.enabled = YES;
            _actionbtn.tag = actionTag;
        }
    }
    
    [self createFrame];
}

#pragma mark - response method
- (void)showUserInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inviteCell:showUserInfo:)]) {
        [self.delegate inviteCell:self showUserInfo:_userModel];
    }
}

- (void)showAction:(UIButton *)btn {
    if (btn.tag == 9999) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(inviteCell:reminder:action:)]) {
        [self.delegate inviteCell:self reminder:_userModel action:btn.tag];
    }
}

#pragma mark - Layout
- (void)layout {
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.genderImageView];
    [self.contentView addSubview:self.verifyImageView];
    [self.contentView addSubview:self.levelImageView];
    [self.contentView addSubview:self.incomeLabel];
    [self.contentView addSubview:self.actionbtn];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10.0);
        make.bottom.equalTo(_iconImageView).offset(-7);
    }];
    
    
    UIView *seperateLine = [[UIView alloc] init];
    seperateLine.backgroundColor = RGBCOLOR(237, 237, 237);
    [self.contentView addSubview:seperateLine];
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15.0);
        make.right.equalTo(self.contentView).offset(-15.0);
        make.height.equalTo(@0.5);
    }];
    
    [_actionbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(82, 32));
    }];
}

- (void)createFrame {

    CGFloat width = [NSString findWidthForText:_userModel.to.nickname havingWidth:150 andFont:_nameLabel.font];
    _nameLabel.frame = CGRectMake(65 + 8, 23.0, width, _nameLabel.font.lineHeight);

    // 性别
    if (_userModel.to.gender == 2 || _userModel.to.gender == 1) {
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
    if ([_userModel.to isIdentifierCertified]) {
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
- (void)setUserModel:(ZZCommissionInviteUserInfoModel *)userModel {
    _userModel = userModel;
    [self configureData];
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

- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.textColor = RGBCOLOR(153, 153, 153);
        _incomeLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    }
    return _incomeLabel;
}

- (UIButton *)actionbtn {
    if (!_actionbtn) {
        _actionbtn = [[UIButton alloc] init];
        _actionbtn.normalTitleColor = RGBCOLOR(151, 151, 151);
        _actionbtn.normalTitle = @"提醒Ta";
        _actionbtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [_actionbtn addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _actionbtn.layer.borderWidth = 1.0;
        _actionbtn.layer.borderColor = RGBCOLOR(151, 151, 151).CGColor;
        _actionbtn.layer.cornerRadius = 16;
        
        _actionbtn.hidden = YES;
        _actionbtn.tag = 9999;
    }
    return _actionbtn;
}

@end
