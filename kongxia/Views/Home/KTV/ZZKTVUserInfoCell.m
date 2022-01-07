//
//  ZZKTVUserInfoCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVUserInfoCell.h"
#import "ZZLevelImgView.h"
#import "ZZKTVConfig.h"
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>

@interface ZZKTVUserInfoCell ()

@property (nonatomic, strong) FLAnimatedImageView *playingGifImageView;

@property (nonatomic, strong) UIImageView *userIconImageView;

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) ZZLevelImgView *levelImageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *giftLabel;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation ZZKTVUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)didReceivedGift:(BOOL)didReceived giftModel:(ZZGiftModel *)giftModel {
    _giftLabel.text = didReceived ? [NSString stringWithFormat:@"1个%@", giftModel.name] : @"未领取礼物";
}

- (void)configureData {
    [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:[_receiverModel.to displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIImage *roundImage = [image imageAddCornerWithRadius:35.5 andSize:CGSizeMake(71, 71)];
        _userIconImageView.image = roundImage;
    }];
    
    _userNameLabel.text = _receiverModel.to.nickname;
    
    // 性别
    if (_receiverModel.to.gender == 2) {
        _genderImageView.image = [UIImage imageNamed:@"girl"];
    }
    else if (_receiverModel.to.gender == 1) {
        _genderImageView.image = [UIImage imageNamed:@"boy"];
    }
    else {
        _genderImageView.image = [UIImage imageNamed:@""];
    }
    
    // 等级
    [_levelImageView setLevel:_receiverModel.to.level];
    
    // 时间
    _timeLabel.text = [[ZZDateHelper shareInstance] currentTimeDescriptForKTV:_receiverModel.created_at];

    _playBtn.selected = _receiverModel.isSongPlaying;
    
    if (_receiverModel.isSongPlaying) {
        [self showPlayingAnimation];
    }
    else {
        [self hidePlayingAnimation];
    }
}

- (void)configureLeadModelData {
   [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:[_songModel.to displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIImage *roundImage = [image imageAddCornerWithRadius:35.5 andSize:CGSizeMake(71, 71)];
        _userIconImageView.image = roundImage;
    }];
    
    _userNameLabel.text = _songModel.to.nickname;
    
    // 性别
    if (_songModel.to.gender == 2) {
        _genderImageView.image = [UIImage imageNamed:@"girl"];
    }
    else if (_songModel.to.gender == 1) {
        _genderImageView.image = [UIImage imageNamed:@"boy"];
    }
    else {
        _genderImageView.image = [UIImage imageNamed:@""];
    }
    
    // 等级
    [_levelImageView setLevel:_songModel.to.level];
    
    // 时间
    _timeLabel.text = [[ZZDateHelper shareInstance] currentTimeDescriptForKTV:_songModel.created_at];
    
    _playBtn.selected = _songModel.isSongPlaying;
    
    if (_songModel.isSongPlaying) {
        [self showPlayingAnimation];
    }
    else {
        [self hidePlayingAnimation];
    }
}

#pragma mark - response method
- (void)playAction {
    id model = nil;
    if (_receiverModel) {
        model = _receiverModel;
    }
    else if (_songModel) {
        model = _songModel;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:startPlay:)]) {
        [self.delegate cell:self startPlay:model];
    }
}

- (void)showUserInfo {
    id model = nil;
    if (_receiverModel) {
        model = _receiverModel;
    }
    else if (_songModel) {
        model = _songModel;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showUserInfo:)]) {
        [self.delegate cell:self showUserInfo:model];
    }
}


#pragma mark - Layout
- (void)layout {
    [self.contentView addSubview:self.userIconImageView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.genderImageView];
    [self.contentView addSubview:self.levelImageView];
    [self.contentView addSubview:self.giftLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.playBtn];
    
    [self.contentView addSubview:self.lineView];
    
    [_userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(71, 71));
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView.mas_right).offset(10.0);
        make.top.equalTo(self.contentView).offset(20.5);
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
    
    [_giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15.0);
        make.top.equalTo(self.contentView).offset(23);
    }];
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView.mas_right).offset(10.0);
        make.top.equalTo(_userNameLabel.mas_bottom).offset(6.0);
        make.size.mas_equalTo(CGSizeMake(125, 36));
    }];
    
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15.0);
        make.top.equalTo(_giftLabel.mas_bottom).offset(5);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameLabel);
        make.right.equalTo(self.contentView).offset(-15.0);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

- (void)showPlayingAnimation {
    [self addSubview:self.playingGifImageView];
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
- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    _playBtn.selected = isPlaying;
}

- (void)setReceiverModel:(ZZKTVReceiveUserModel *)receiverModel {
    _receiverModel = receiverModel;
    [self configureData];
}

- (void)setSongModel:(ZZKTVLeadSongModel *)songModel {
    _songModel = songModel;
    [self configureLeadModelData];
}


- (UIImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [[UIImageView alloc] init];
        _userIconImageView.backgroundColor = UIColor.randomColor;
        _userIconImageView.layer.cornerRadius = 71.0 / 2;
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
        _timeLabel.font = ADaptedFontMediumSize(12);
        _timeLabel.textColor = RGBCOLOR(153, 153, 153);
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        _playBtn.normalTitle = @"播放";
        _playBtn.selectedTitle = @"停止";
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

- (UILabel *)giftLabel {
    if (!_giftLabel) {
        _giftLabel = [[UILabel alloc] init];
        _giftLabel.font = ADaptedFontMediumSize(14);
        _giftLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _giftLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _lineView;
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

@end
