//
//  ZZKTVMyTasksCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVMyTasksCell.h"
#import "ZZKTVConfig.h"

@interface ZZKTVMyTasksCell ()

@property (nonatomic, strong) UIView *contentBgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *recivedStatusLabel;

@property (nonatomic, strong) UIImageView *recivedStatusImageView;

@property (nonatomic, strong) UIView *seperateLine;

@property (nonatomic, strong) UILabel *lyricsLabel;

@property (nonatomic, strong) UILabel *giftCountsLabel;

@property (nonatomic, strong) UIImageView *giftIconImageView;

@property (nonatomic, strong) UIImageView *giftCountsImageView;

@end

@implementation ZZKTVMyTasksCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    _recivedStatusLabel.text = [NSString stringWithFormat:@"派发领取中%ld/%ld", (_taskModel.gift_count - _taskModel.gift_last_count), _taskModel.gift_count];
    
    _lyricsLabel.text = _taskModel.song_list.firstObject.content;
    
    _giftCountsLabel.text = [NSString stringWithFormat:@"%ld", _taskModel.gift_count];
    
    [_giftIconImageView sd_setImageWithURL:[NSURL URLWithString:_taskModel.gift.icon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    _timeLabel.text = [[ZZDateHelper shareInstance] currentTimeDescriptForKTV:_taskModel.created_at];
}


#pragma mark - response method
- (void)showDetails {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showDetails:)]) {
        [self.delegate cell:self showDetails:_taskModel];
    }
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(245, 245, 245);
    [self.contentView addSubview:self.contentBgView];
    [_contentBgView addSubview:self.titleLabel];
    [_contentBgView addSubview:self.timeLabel];
    [_contentBgView addSubview:self.recivedStatusImageView];
    [_contentBgView addSubview:self.recivedStatusLabel];
    [_contentBgView addSubview:self.seperateLine];
    [_contentBgView addSubview:self.lyricsLabel];
    [_contentBgView addSubview:self.giftIconImageView];
    [_contentBgView addSubview:self.giftCountsImageView];
    [_contentBgView addSubview:self.giftCountsLabel];
    
    [_contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10.0);
        make.right.equalTo(self.contentView).offset(-10.0);
        make.bottom.equalTo(self.contentView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentBgView).offset(10);
        make.top.equalTo(_contentBgView).offset(11);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentBgView).offset(10);
        make.top.equalTo(_titleLabel.mas_bottom).offset(4);
    }];
    
    [_recivedStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentBgView).offset(-10);
        make.top.equalTo(_contentBgView).offset(25);
        make.size.mas_equalTo(CGSizeMake(6, 11.5));
    }];
    
    [_recivedStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_recivedStatusImageView);
        make.right.equalTo(_recivedStatusImageView.mas_left).offset(-6);
    }];
    
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentBgView).offset(10.0);
        make.right.equalTo(_contentBgView).offset(-10.0);
        make.top.equalTo(_timeLabel.mas_bottom).offset(8.0);
        make.height.equalTo(@0.5);
    }];
    
    [_lyricsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentBgView).offset(10);
        make.top.equalTo(_seperateLine.mas_bottom).offset(10.0);
        make.width.equalTo(@(SCALE_SET(186.5)));
        make.bottom.equalTo(_contentBgView).offset(-10.0);
        make.height.greaterThanOrEqualTo(@(37.0));
    }];
    
    [_giftCountsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_seperateLine.mas_bottom).offset(12.0);
        make.right.equalTo(_contentBgView).offset(-10.0);
    }];
    
    [_giftCountsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_giftCountsLabel);
        make.right.equalTo(_giftCountsLabel.mas_left).offset(-2);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [_giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_giftCountsLabel);
        make.right.equalTo(_giftCountsImageView.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(49, 49));
    }];
}


#pragma mark - getters and setters
- (void)setTaskModel:(ZZKTVModel *)taskModel {
    _taskModel = taskModel;
    [self configureData];
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc] init];
        _contentBgView.backgroundColor = UIColor.whiteColor;
    }
    return _contentBgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"发起唱趴";
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.font = ADaptedFontSCBoldSize(16);
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"1990";
        _timeLabel.textColor = RGBCOLOR(153, 153, 153);
        _timeLabel.font = ADaptedFontMediumSize(12);
    }
    return _timeLabel;
}

- (UILabel *)recivedStatusLabel {
    if (!_recivedStatusLabel) {
        _recivedStatusLabel = [[UILabel alloc] init];
        _recivedStatusLabel.text = @"派发领取中";
        _recivedStatusLabel.textColor = RGBCOLOR(29, 125, 212);
        _recivedStatusLabel.font = ADaptedFontMediumSize(14);
        _recivedStatusLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetails)];
        [_recivedStatusLabel addGestureRecognizer:tap];
    }
    return _recivedStatusLabel;
}

- (UIImageView *)recivedStatusImageView {
    if (!_recivedStatusImageView) {
        _recivedStatusImageView = [[UIImageView alloc] init];
        _recivedStatusImageView.image = [UIImage imageNamed:@"icGengduoWddch"];
    }
    return _recivedStatusImageView;
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    return _seperateLine;
}

- (UILabel *)lyricsLabel {
    if (!_lyricsLabel) {
        _lyricsLabel = [[UILabel alloc] init];
        _lyricsLabel.text = @"1\n2\n3\n4";
        _lyricsLabel.textColor = RGBCOLOR(153, 153, 153);
        _lyricsLabel.font = ADaptedFontMediumSize(13);
        _lyricsLabel.numberOfLines = 0;
    }
    return _lyricsLabel;
}

- (UILabel *)giftCountsLabel {
    if (!_giftCountsLabel) {
        _giftCountsLabel = [[UILabel alloc] init];
        _giftCountsLabel.text = @"16";
        _giftCountsLabel.textColor = RGBCOLOR(153, 153, 153);
        _giftCountsLabel.font = ADaptedFontBoldSize(24);
        _giftCountsLabel.textAlignment = NSTextAlignmentRight;
    }
    return _giftCountsLabel;
}

- (UIImageView *)giftCountsImageView {
    if (!_giftCountsImageView) {
        _giftCountsImageView = [[UIImageView alloc] init];
        _giftCountsImageView.image = [UIImage imageNamed:@"icShenghao"];
    }
    return _giftCountsImageView;
}

- (UIImageView *)giftIconImageView {
    if (!_giftIconImageView) {
        _giftIconImageView = [[UIImageView alloc] init];
    }
    return _giftIconImageView;
}

@end
