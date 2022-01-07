//
//  ZZKTVMyGiftUserInfoCell.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/16.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVMyGiftUserInfoCell.h"
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>

@interface ZZKTVMyGiftUserInfoCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) FLAnimatedImageView *playingGifImageView;

@property (nonatomic, strong) UIImageView *userIconImageView;

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) ZZLevelImgView *levelImageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *profitLabel;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIView *lineView;



@end

@implementation ZZKTVMyGiftUserInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:[_giftModel.from displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIImage *roundImage = [image imageAddCornerWithRadius:30 andSize:CGSizeMake(60, 60)];
        _userIconImageView.image = roundImage;
    }];
    
    _userNameLabel.text = _giftModel.from.nickname;
    
    // 性别
    if (_giftModel.from.gender == 2) {
        _genderImageView.image = [UIImage imageNamed:@"girl"];
    }
    else if (_giftModel.from.gender == 1) {
        _genderImageView.image = [UIImage imageNamed:@"boy"];
    }
    else {
        _genderImageView.image = [UIImage imageNamed:@""];
    }
    
    // 等级
    [_levelImageView setLevel:_giftModel.from.level];
    
    // 时间
    _timeLabel.text = [[ZZDateHelper shareInstance] currentTimeDescriptForKTV:_giftModel.created_at];

    _playBtn.selected = _giftModel.isSongPlaying;
    
    if (_giftModel.isSongPlaying) {
        [self showPlayingAnimation];
    }
    else {
        [self hidePlayingAnimation];
    }
}

#pragma mark - response method
- (void)playAction {

    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:startPlay:)]) {
        [self.delegate cell:self startPlay:_giftModel];
    }
}

- (void)showUserInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showUserInfo:)]) {
        [self.delegate cell:self showUserInfo:_giftModel];
    }
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(245, 245, 245);
    
    [self.contentView addSubview:self.bgView];
    [_bgView addSubview:self.userIconImageView];
    [_bgView addSubview:self.userNameLabel];
    [_bgView addSubview:self.genderImageView];
    [_bgView addSubview:self.levelImageView];
    [_bgView addSubview:self.profitLabel];
    [_bgView addSubview:self.timeLabel];
    [_bgView addSubview:self.playBtn];
    [_bgView addSubview:self.lineView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10.0);
        make.right.equalTo(self.contentView).offset(-10.0);
        make.bottom.equalTo(self.contentView);
    }];
    
    [_userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView).offset(15);
        make.left.equalTo(_bgView).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView.mas_right).offset(10.0);
        make.top.equalTo(_bgView).offset(24);
    }];
    
    [_genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userNameLabel);
        make.left.equalTo(_userNameLabel.mas_right).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [_levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userNameLabel);
        make.left.equalTo(_genderImageView.mas_right).offset(8.0);
        make.size.mas_equalTo(CGSizeMake(28, 14));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameLabel);
        make.top.equalTo(_userNameLabel.mas_bottom).offset(5);
    }];
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView);
        make.top.equalTo(_userIconImageView.mas_bottom).offset(8.0);
        make.size.mas_equalTo(CGSizeMake(125, 36));
    }];
    
    [_profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_playBtn);
        make.right.equalTo(_bgView).offset(-10.0);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(15.0);
        make.right.equalTo(_bgView).offset(-15.0);
        make.bottom.equalTo(_bgView);
        make.height.equalTo(@0.5);
    }];
}

- (void)showPlayingAnimation {
    [_bgView addSubview:self.playingGifImageView];
    [_playingGifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_playBtn);
        make.right.equalTo(_playBtn).offset(-8.5);
        make.size.mas_equalTo(CGSizeMake(59, 27));
    }];
}

- (void)hidePlayingAnimation {
    [_playingGifImageView removeFromSuperview];
    _playingGifImageView = nil;
}

#pragma mark - getters and setters
- (void)setGiftModel:(ZZKTVReceivedGiftModel *)giftModel {
    _giftModel = giftModel;
    [self configureData];
}

- (void)setProfite_rate:(double)profite_rate {
    _profite_rate = profite_rate;
    _profitLabel.text = [NSString stringWithFormat:@"¥%.2f", _giftModel.pd_song.gift.price * _profite_rate];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (FLAnimatedImageView *)playingGifImageView {
    if (!_playingGifImageView) {
        _playingGifImageView = [[FLAnimatedImageView alloc] init];
        NSURL *gifLocalUrl = [[NSBundle mainBundle] URLForResource:@"KTV_playing" withExtension:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfURL:gifLocalUrl];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
        _playingGifImageView.animatedImage = image;
        _playingGifImageView.userInteractionEnabled = NO;
        [_playingGifImageView stopAnimating];
    }
    return _playingGifImageView;
}

- (UIImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [[UIImageView alloc] init];
        _userIconImageView.backgroundColor = UIColor.randomColor;
        _userIconImageView.layer.cornerRadius = 30.0;
        _userIconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
        [_userIconImageView addGestureRecognizer:tap];
    }
    return _userIconImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
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

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = RGBCOLOR(153, 153, 153);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        _playBtn.normalTitle = @"开始";
        _playBtn.selectedTitle = @"暂停";
        _playBtn.normalTitleColor = RGBCOLOR(250, 77, 46);
        _playBtn.titleLabel.font = ADaptedFontMediumSize(12);
        _playBtn.normalImage = [UIImage imageNamed:@"SongPlayBtn"];
        _playBtn.selectedImage = [UIImage imageNamed:@"icTingzhi"];
        [_playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.backgroundColor = RGBCOLOR(255, 243, 230);
        _playBtn.layer.cornerRadius = 2;
        
        [_playBtn setImagePosition:LXMImagePositionLeft spacing:5];
        _playBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -70.0, 0, 0);
    }
    return _playBtn;
}

- (UILabel *)profitLabel {
    if (!_profitLabel) {
        _profitLabel = [[UILabel alloc] init];
        _profitLabel.font = ADaptedFontSCBoldSize(19);
        _profitLabel.textColor = RGBCOLOR(63, 58, 58);
        _profitLabel.textAlignment = NSTextAlignmentRight;
    }
    return _profitLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _lineView;
}

@end
