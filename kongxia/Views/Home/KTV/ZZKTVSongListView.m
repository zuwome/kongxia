//
//  ZZKTVSongListView.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/9.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVSongListView.h"

@interface ZZKTVSongListView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton *actionBtn;

@property (nonatomic, strong) UIView *line;

@end

@implementation ZZKTVSongListView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)setDidSelect:(BOOL)isSelect {
    _actionBtn.selected = isSelect;
}

#pragma mark - response method
- (void)addAction {
//    _actionBtn.selected = !_actionBtn.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:addSong:)]) {
        [self.delegate view:self addSong:_songModel];
    }
}


#pragma mark - Layout
- (void)layout {
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.actionBtn];
    [self addSubview:self.line];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(18.0);
        make.left.equalTo(self).offset(15);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(6.0);
        make.right.equalTo(self).offset(-116);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-18.0);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@0.5);
    }];
    
    [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
}


#pragma mark - getters and setters
- (void)setSongModel:(ZZKTVSongModel *)songModel {
    _songModel = songModel;
    _titleLabel.text = [NSString stringWithFormat:@"%@ --- %@", _songModel.name, _songModel.auth];
    _subTitleLabel.text = _songModel.content;
    _actionBtn.selected = songModel.isSelected;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ADaptedFontMediumSize(15);
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textColor = RGBCOLOR(153, 153, 153);
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc] init];
        _actionBtn.normalImage = [UIImage imageNamed:@"changpaicTianjia"];
        _actionBtn.selectedImage = [UIImage imageNamed:@"icShanchu"];
        [_actionBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    return _line;
}


@end
