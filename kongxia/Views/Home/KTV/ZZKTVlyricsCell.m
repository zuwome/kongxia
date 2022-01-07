//
//  ZZKTVlyricsCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVlyricsCell.h"

@interface ZZKTVlyricsCell()

@property (nonatomic, strong) UILabel *lyricsLabel;

@property (nonatomic, strong) UILabel *songTitleLabel;

@property (nonatomic, strong) UIView *seperateLine;

@end
 
@implementation ZZKTVlyricsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}


#pragma mark - Layout
- (void)layout {
    [self.contentView addSubview:self.lyricsLabel];
    [self.contentView addSubview:self.songTitleLabel];
    [self.contentView addSubview:self.seperateLine];
    
    [_lyricsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];

    [_songTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(_lyricsLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}


#pragma mark - getters and setters
- (void)setSongModel:(ZZKTVSongModel *)songModel {
    _songModel = songModel;
    
    _lyricsLabel.text = _songModel.content;
    _songTitleLabel.text = [NSString stringWithFormat:@"《%@ --- %@》", _songModel.name, _songModel.auth];
    
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

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _seperateLine;
}

@end
