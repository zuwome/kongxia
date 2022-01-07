//
//  ZZKTVTaskCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVTaskCell.h"

#import "ZZLevelImgView.h"

@interface ZZKTVTaskCell ()

@property (nonatomic, strong) UIView *contentBgView;

@property (nonatomic, strong) UIImageView *userIconImageView;

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) ZZLevelImgView *levelImageView;

@property (nonatomic, strong) UIImageView *giftIconImageView;

@property (nonatomic, strong) UIImageView *giftCountsImageView;

@property (nonatomic, strong) UILabel *giftsLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *singBtn;

@property (nonatomic, strong) UIImageView *singBtnImageView;

@property (nonatomic, strong) UILabel *lyricsLabel;

@property (nonatomic, strong) UIView *seperateLine;

@property (nonatomic, strong) UILabel *songTitleLabel;

@property (nonatomic, strong) UIButton *showMoreBtn;

@property (nonatomic, strong) UIButton *audioBtn;

@end

@implementation ZZKTVTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}


- (void)configure {
    if (_model.is_anonymous == 2) {
        // user Icon
        [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:_model.anonymous_avatar] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *roundImage = [image imageAddCornerWithRadius:30 andSize:CGSizeMake(60, 60)];
            _userIconImageView.image = roundImage;
        }];
        
        // 名字
        if (isNullString(_model.anonymous_nickName)) {
            _userNameLabel.text = @"匿名用户";
        }
        else {
            _userNameLabel.text = _model.anonymous_nickName;
        }
        
    }
    else {
        // user Icon
        [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:[_model.from displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *roundImage = [image imageAddCornerWithRadius:30 andSize:CGSizeMake(60, 60)];
            _userIconImageView.image = roundImage;
        }];
        
        // 名字
        _userNameLabel.text = _model.from.nickname;
    }
    
    
    // 性别
    if (_model.from.gender == 2) {
        _genderImageView.image = [UIImage imageNamed:@"girl"];
    }
    else if (_model.from.gender == 1) {
        _genderImageView.image = [UIImage imageNamed:@"boy"];
    }
    else {
        _genderImageView.image = [UIImage imageNamed:@""];
    }
    
    // 等级
    [_levelImageView setLevel:_model.from.level];
    
    // 时间
    _timeLabel.text = [[ZZDateHelper shareInstance] currentTimeDescriptForKTV:_model.created_at];
    
    //
    _giftsLabel.text = [NSString stringWithFormat:@"%ld", _model.gift_count];
    
    [_giftIconImageView sd_setImageWithURL:[NSURL URLWithString:_model.gift.icon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    // 歌名
    _songTitleLabel.text = [NSString stringWithFormat:@"《%@ --- %@》",_model.song_list.firstObject.name, _model.song_list.firstObject.auth];

    // 歌词
    _lyricsLabel.text = _model.song_list.firstObject.content;
    
    _showMoreBtn.hidden = !(_model.song_list.count > 1);
    
    [self layoutIfNeeded];
    if (_model.gift_last_count == 0) {
        _singBtnImageView.hidden = YES;

        _singBtn.backgroundColor = RGBCOLOR(247, 247, 247);
        _singBtn.normalTitle = @"已领完";
        _singBtn.normalTitleColor = RGBCOLOR(176, 176, 176);
        _singBtn.titleLabel.font = ADaptedFontMediumSize(12);
        
        [_singBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(56, 32));
        }];
        
        _singBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else {
        _singBtnImageView.hidden = NO;

        _singBtn.normalTitle = @"唱歌领礼物";
        _singBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _singBtn.titleLabel.font = ADaptedFontMediumSize(12);
        _singBtn.backgroundColor = RGBCOLOR(254, 234, 238);
        
        [_singBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(95, 32));
        }];
        _singBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
}


#pragma mark - response method
- (void)singAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showDetails:)]) {
        [self.delegate cell:self showDetails:_model];
    }
}

- (void)showMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showDetails:)]) {
        [self.delegate cell:self showDetails:_model];
    }
}

- (void)showUserInfo {
    if (_model.is_anonymous == 2) {
        [ZZHUD showTaskInfoWithStatus:@"该用户已匿名"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showUserInfo:)]) {
        [self.delegate cell:self showUserInfo:_model.from];
    }
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.contentBgView];
    [_contentBgView addSubview:self.userIconImageView];
    [_contentBgView addSubview:self.userNameLabel];
    [_contentBgView addSubview:self.genderImageView];
    [_contentBgView addSubview:self.levelImageView];
    [_contentBgView addSubview:self.timeLabel];
    [_contentBgView addSubview:self.giftIconImageView];
    [_contentBgView addSubview:self.giftCountsImageView];
    [_contentBgView addSubview:self.giftsLabel];
    [_contentBgView addSubview:self.lyricsLabel];
    [_contentBgView addSubview:self.singBtn];
    [_contentBgView addSubview:self.singBtnImageView];
    [_contentBgView addSubview:self.seperateLine];
    [_contentBgView addSubview:self.songTitleLabel];
    [_contentBgView addSubview:self.showMoreBtn];
    
    [_contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10.0);
        make.right.equalTo(self.contentView).offset(-10.0);
        make.bottom.equalTo(self.contentView);
    }];
    
    [_userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentBgView).offset(16.0);
        make.left.equalTo(_contentBgView).offset(10.0);
        make.size.mas_equalTo(CGSizeMake(60.0, 60.0));
        
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView.mas_right).offset(10.0);
        make.top.equalTo(_userIconImageView).offset(9.0);
    }];
    
    [_genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userNameLabel);
        make.left.equalTo(_userNameLabel.mas_right).offset(15);
    }];
    
    [_levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userNameLabel);
        make.left.equalTo(_genderImageView.mas_right).offset(8);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView.mas_right).offset(10.0);
        make.top.equalTo(_userNameLabel.mas_bottom).offset(9.5);
    }];
    
    [_giftsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentBgView).offset(18.0);
        make.right.equalTo(_contentBgView).offset(-10.0);
    }];
    
    [_giftCountsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_giftsLabel);
        make.right.equalTo(_giftsLabel.mas_left).offset(-2);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [_giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_giftsLabel);
        make.right.equalTo(_giftCountsImageView.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(49, 49));
    }];
    
    [_singBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIconImageView.mas_bottom).offset(7.5);
        make.right.equalTo(_contentBgView).offset(-10.0);
        make.size.mas_equalTo(CGSizeMake(95, 32));
    }];

    [_singBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_singBtn).offset(-12);
        make.right.equalTo(_singBtn).offset(1.0);
        make.size.mas_equalTo(CGSizeMake(25, 55));
    }];
    
    [_lyricsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIconImageView.mas_bottom).offset(5);
        make.left.equalTo(_contentBgView).offset(10.0);
        make.right.equalTo(_singBtn.mas_left).offset(-53.5);
    }];
    
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentBgView).offset(10.0);
        make.right.equalTo(_contentBgView).offset(-10.0);
        make.top.equalTo(_lyricsLabel.mas_bottom).offset(8.0);
        make.height.equalTo(@0.5);
    }];
    
    [_songTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentBgView).offset(10.0);
        make.top.equalTo(_seperateLine.mas_bottom).offset(10);
        make.bottom.equalTo(_contentBgView).offset(-10.5);
    }];
    
    [_showMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_songTitleLabel);
        make.right.equalTo(_contentBgView).offset(-10.0);
        make.size.mas_equalTo(CGSizeMake(90, 15));
    }];
    
}


#pragma mark - getters and setters
- (void)setModel:(ZZKTVModel *)model {
    _model = model;
    [self configure];
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc] init];
        _contentBgView.backgroundColor = UIColor.whiteColor;
        _contentBgView.layer.cornerRadius = 4;
    }
    return _contentBgView;
}

- (UIImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [[UIImageView alloc] init];
        _userIconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
        [_userIconImageView addGestureRecognizer:tap];
    }
    return _userIconImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userNameLabel.font = ADaptedFontSCBoldSize(15);
        _userNameLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _userNameLabel;
}

- (UIImageView *)genderImageView {
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc] init];
    }
    return _genderImageView;
}

- (ZZLevelImgView *)levelImageView {
    if (!_levelImageView) {
        _levelImageView = [[ZZLevelImgView alloc] init];
    }
    return _levelImageView;
}

- (UIImageView *)giftIconImageView {
    if (!_giftIconImageView) {
        _giftIconImageView = [[UIImageView alloc] init];
    }
    return _giftIconImageView;
}

- (UIImageView *)giftCountsImageView {
    if (!_giftCountsImageView) {
        _giftCountsImageView = [[UIImageView alloc] init];
        _giftCountsImageView.image = [UIImage imageNamed:@"icShenghao"];
    }
    return _giftCountsImageView;
}


- (UILabel *)giftsLabel {
    if (!_giftsLabel) {
        _giftsLabel = [[UILabel alloc] init];
        _giftsLabel.text = @"X 10";
        _giftsLabel.font = ADaptedFontBoldSize(24);
        _giftsLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _giftsLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"1990-01-01";
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = RGBCOLOR(153, 153, 153);
    }
    return _timeLabel;
}

- (UIButton *)singBtn {
    if (!_singBtn) {
        _singBtn = [[UIButton alloc] init];
        _singBtn.normalTitle = @"唱歌领礼物";
        _singBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _singBtn.titleLabel.font = ADaptedFontMediumSize(12);
        _singBtn.layer.cornerRadius = 16.0;
        [_singBtn addTarget:self action:@selector(singAction) forControlEvents:UIControlEventTouchUpInside];
        _singBtn.backgroundColor = UIColor.randomColor;
    }
    return _singBtn;
}

- (UIImageView *)singBtnImageView {
    if (!_singBtnImageView) {
        _singBtnImageView = [[UIImageView alloc] init];
        _singBtnImageView.image = [UIImage imageNamed:@"icHuatong"];
    }
    return _singBtnImageView;
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _seperateLine;
}

- (UILabel *)songTitleLabel {
    if (!_songTitleLabel) {
        _songTitleLabel = [[UILabel alloc] init];
        _songTitleLabel.text = @"1990-01-01";
        _songTitleLabel.font = [UIFont systemFontOfSize:12];
        _songTitleLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _songTitleLabel;
}

- (UILabel *)lyricsLabel {
    if (!_lyricsLabel) {
        _lyricsLabel = [[UILabel alloc] init];
        _lyricsLabel.font = ADaptedFontMediumSize(13);
        _lyricsLabel.textColor = RGBCOLOR(102, 102, 102);
        _lyricsLabel.numberOfLines = 0;
    }
    return _lyricsLabel;
}

- (UIButton *)showMoreBtn {
    if (!_showMoreBtn) {
        _showMoreBtn = [[UIButton alloc] init];
        _showMoreBtn.normalTitle = @"更多歌曲";
        _showMoreBtn.normalTitleColor = RGBCOLOR(102, 102, 102);
        _showMoreBtn.titleLabel.font = ADaptedFontMediumSize(13);
        _showMoreBtn.normalImage = [UIImage imageNamed:@"icon_order_right"];
        [_showMoreBtn setImagePosition:LXMImagePositionRight spacing:3];
        [_showMoreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showMoreBtn;
}

@end
