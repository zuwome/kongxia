//
//  ZZKTVMyGiftlyricsCell.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/16.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVMyGiftlyricsCell.h"

@interface ZZKTVMyGiftlyricsCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *lyricsLabel;

@property (nonatomic, strong) UILabel *songTitleLabel;

@property (nonatomic, strong) UIView *seperateLine;

@property (nonatomic, strong) UIImageView *giftIconImageView;

@end

@implementation ZZKTVMyGiftlyricsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    _lyricsLabel.text = _giftModel.song_list.content;
    _songTitleLabel.text = [NSString stringWithFormat:@"《%@ --- %@》", _giftModel.song_list.name, _giftModel.song_list.auth];
    
    [_giftIconImageView sd_setImageWithURL:[NSURL URLWithString:_giftModel.pd_song.gift.icon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(245, 245, 245);
    
    [self.contentView addSubview:self.bgView];
    [_bgView addSubview:self.lyricsLabel];
    [_bgView addSubview:self.songTitleLabel];
    [_bgView addSubview:self.giftIconImageView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.0);
        make.right.equalTo(self.contentView).offset(-10.0);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [_giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.right.equalTo(_bgView).offset(-10.0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [_lyricsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView).offset(10.0);
        make.left.equalTo(_bgView).offset(10);
        make.right.equalTo(_giftIconImageView.mas_left).offset(-40.0);
    }];

    [_songTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lyricsLabel.mas_bottom).offset(5.0);
        make.left.equalTo(_bgView).offset(10);
        make.right.equalTo(_giftIconImageView.mas_left).offset(-40.0);
        make.bottom.equalTo(_bgView).offset(-10.0);
    }];
}


#pragma mark - getters and setters
- (void)setGiftModel:(ZZKTVReceivedGiftModel *)giftModel {
    _giftModel = giftModel;
    [self configureData];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UILabel *)songTitleLabel {
    if (!_songTitleLabel) {
        _songTitleLabel = [[UILabel alloc] init];
        _songTitleLabel.text = @"1990-01-01";
        _songTitleLabel.font = ADaptedFontMediumSize(13);
        _songTitleLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _songTitleLabel;
}

- (UILabel *)lyricsLabel {
    if (!_lyricsLabel) {
        _lyricsLabel = [[UILabel alloc] init];
        _lyricsLabel.font = ADaptedFontMediumSize(13);
        _lyricsLabel.textColor = RGBCOLOR(153, 153, 153);
        _lyricsLabel.numberOfLines = 0;
    }
    return _lyricsLabel;
}

- (UIImageView *)giftIconImageView {
    if (!_giftIconImageView) {
        _giftIconImageView = [[UIImageView alloc] init];
    }
    return _giftIconImageView;
}

@end
