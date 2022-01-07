//
//  ZZHomeCollectionsCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/5/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZHomeCollectionsCell.h"

@interface ZZHomeCollectionsCell ()

@property (nonatomic, strong) UIView *videoChatView;

@property (nonatomic, strong) UIImageView *videoChatIconImageView;

@property (nonatomic, strong) UILabel *videoChatTitleLabel;

@property (nonatomic, strong) UILabel *videoChatSubTitleLabel;

@property (nonatomic, strong) UIView *taskView;

@property (nonatomic, strong) UIImageView *taskIconImageView;

@property (nonatomic, strong) UILabel *taskTitleLabel;

@property (nonatomic, strong) UILabel *taskSubTitleLabel;

@property (nonatomic, strong) UIImageView *rankingView;

@property (nonatomic, strong) UIImageView *firstPlaceCrownImageView;

@property (nonatomic, strong) UIImageView *firstPlaceUserIconImageView;

@property (nonatomic, strong) UIImageView *firstPlaceRankingImageView;

@property (nonatomic, strong) UIImageView *secondPlaceCrownImageView;

@property (nonatomic, strong) UIImageView *secondPlaceUserIconImageView;

@property (nonatomic, strong) UIImageView *secondPlaceRankingImageView;

@property (nonatomic, strong) UIImageView *thirdPlaceCrownImageView;

@property (nonatomic, strong) UIImageView *thirdPlaceUserIconImageView;

@property (nonatomic, strong) UIImageView *thirdPlaceRankingImageView;

@property (nonatomic, strong) UILabel *rankTitleLabel;

@property (nonatomic, strong) UILabel *rankSubTitleLabel;

@end

@implementation ZZHomeCollectionsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureTopThree:(ZZRankResponeModel *)rankResponeModel {
    
    _rankTitleLabel.text = rankResponeModel.title_one;
    _rankTitleLabel.text = rankResponeModel.title_two;
    if (rankResponeModel.result.count == 0) {
        _firstPlaceCrownImageView.hidden = YES;
        _firstPlaceRankingImageView.hidden = YES;
        _firstPlaceUserIconImageView.hidden = YES;
        _secondPlaceCrownImageView.hidden = YES;
        _secondPlaceRankingImageView.hidden = YES;
        _secondPlaceUserIconImageView.hidden = YES;
        _thirdPlaceCrownImageView.hidden = YES;
        _thirdPlaceRankingImageView.hidden = YES;
        _thirdPlaceUserIconImageView.hidden = YES;
        return;
    }
    
    _firstPlaceCrownImageView.hidden = NO;
    _firstPlaceRankingImageView.hidden = NO;
    _firstPlaceUserIconImageView.hidden = NO;
    _secondPlaceCrownImageView.hidden = NO;
    _secondPlaceRankingImageView.hidden = NO;
    _secondPlaceUserIconImageView.hidden = NO;
    _thirdPlaceCrownImageView.hidden = NO;
    _thirdPlaceRankingImageView.hidden = NO;
    _thirdPlaceUserIconImageView.hidden = NO;
    
    for (int i = 0; i < rankResponeModel.result.count; i++) {
        ZZRankModel *rankModel = rankResponeModel.result[i];
        
        UIImageView *userImageView = nil;
        CGFloat imageWidth = 0;
        if (i == 0) {
            userImageView = _firstPlaceUserIconImageView;
            imageWidth = 49;
        }
        else if (i == 1) {
            userImageView = _secondPlaceUserIconImageView;
            imageWidth = 43;
        }
        else if (i == 2) {
            userImageView = _thirdPlaceUserIconImageView;
             imageWidth = 43;
        }
        [userImageView sd_setImageWithURL:[NSURL URLWithString:[rankModel.userInfo displayAvatar]] placeholderImage:[UIImage imageNamed:@"icon_placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *roundImage = [image imageAddCornerWithRadius:imageWidth / 2 andSize:CGSizeMake(imageWidth, imageWidth)];
            userImageView.image = roundImage;
        }];
    }
}

- (void)showVideoChat {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showVideoChat)]) {
        [self.delegate showVideoChat];
    }
}

- (void)showTask {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showTasks)]) {
        [self.delegate showTasks];
    }
}

- (void)showRanks {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRanks)]) {
        [self.delegate showRanks];
    }
}

#pragma mark - Layout
- (void)layout {
    CGFloat width = (SCREEN_WIDTH - 3 * 7) / 2;
    CGFloat height = (167 - 7) / 2;
    [self.contentView addSubview:self.videoChatView];
    [_videoChatView addSubview:self.videoChatIconImageView];
    [_videoChatView addSubview:self.videoChatTitleLabel];
    [_videoChatView addSubview:self.videoChatSubTitleLabel];
    
    [self.contentView addSubview:self.taskView];
    [_taskView addSubview:self.taskIconImageView];
    [_taskView addSubview:self.taskTitleLabel];
    [_taskView addSubview:self.taskSubTitleLabel];
    
    [self.contentView addSubview:self.rankingView];
    [_rankingView addSubview:self.secondPlaceUserIconImageView];
    [_rankingView addSubview:self.secondPlaceCrownImageView];
    [_rankingView addSubview:self.secondPlaceRankingImageView];
    
    [_rankingView addSubview:self.thirdPlaceUserIconImageView];
    [_rankingView addSubview:self.thirdPlaceCrownImageView];
    [_rankingView addSubview:self.thirdPlaceRankingImageView];

    [_rankingView addSubview:self.firstPlaceUserIconImageView];
    [_rankingView addSubview:self.firstPlaceCrownImageView];
    [_rankingView addSubview:self.firstPlaceRankingImageView];
    
    [_rankingView addSubview:self.rankTitleLabel];
    [_rankingView addSubview:self.rankSubTitleLabel];
    
    [_videoChatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(7);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    
    [self.videoChatTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_videoChatView).offset(-15);
        make.centerX.equalTo(_videoChatView).offset(12);
//        make.height.equalTo(@25);
    }];
    
    [self.videoChatIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.videoChatTitleLabel);
        make.size.mas_equalTo(CGSizeMake(21, 22));
        make.trailing.equalTo(self.videoChatTitleLabel.mas_leading).offset(-3);
    }];
    
    [self.videoChatSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_videoChatView);
        make.centerY.equalTo(_videoChatView).offset(12);
//        make.height.equalTo(@20);
    }];
    
    [_taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_videoChatView.mas_bottom).offset(7.0);
        make.left.equalTo(self).offset(7);
        make.size.mas_equalTo(CGSizeMake(width, 80));
    }];
    
    [self.taskTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_taskView).offset(-15);
        make.centerX.equalTo(_taskView).offset(12);
//        make.height.equalTo(@25);
    }];
    
    [self.taskIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.taskTitleLabel);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.trailing.equalTo(self.taskTitleLabel.mas_leading).offset(-3);
    }];
    
    [self.taskSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_taskView);
        make.centerY.equalTo(_taskView).offset(12);
//        make.height.equalTo(@20);
    }];
    
    [_rankingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(_videoChatView.mas_right).offset(7);
        make.size.mas_equalTo(CGSizeMake(width, 167));
    }];
    
    [_firstPlaceUserIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rankingView);
        make.top.equalTo(_rankingView).offset(34);
        make.size.mas_equalTo(CGSizeMake(49, 49));
    }];
    
    [_secondPlaceUserIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_firstPlaceUserIconImageView.mas_centerX).offset(-17.0);
        make.top.equalTo(_firstPlaceUserIconImageView).offset(23);
        make.size.mas_equalTo(CGSizeMake(43, 43));
    }];
    
    [_thirdPlaceUserIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstPlaceUserIconImageView.mas_centerX).offset(17.0);
        make.top.equalTo(_firstPlaceUserIconImageView).offset(23);
        make.size.mas_equalTo(CGSizeMake(43, 43));
    }];
    
    [_firstPlaceCrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstPlaceUserIconImageView).offset(2.7);
        make.bottom.equalTo(_firstPlaceUserIconImageView.mas_top).offset(4);
        make.size.mas_equalTo(CGSizeMake(22.2, 17.7));
    }];
    
    [_secondPlaceCrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_secondPlaceUserIconImageView).offset(2.7);
        make.bottom.equalTo(_secondPlaceUserIconImageView.mas_top).offset(4);
        make.size.mas_equalTo(CGSizeMake(20.5, 16.5));
    }];
    
    [_thirdPlaceCrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_thirdPlaceUserIconImageView).offset(-4);
        make.bottom.equalTo(_thirdPlaceUserIconImageView.mas_top).offset(4);
        make.size.mas_equalTo(CGSizeMake(22.2, 17.7));
    }];
    
    [_firstPlaceRankingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_firstPlaceUserIconImageView);
        make.centerY.equalTo(_firstPlaceUserIconImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [_secondPlaceRankingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_secondPlaceUserIconImageView);
        make.centerY.equalTo(_secondPlaceUserIconImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(11, 11));
    }];
    
    [_thirdPlaceRankingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_thirdPlaceUserIconImageView);
        make.centerY.equalTo(_thirdPlaceUserIconImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(11, 11));
    }];
    
    [_rankTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rankingView);
        make.top.equalTo(_firstPlaceUserIconImageView.mas_bottom).offset(27.5);
        make.left.equalTo(_rankingView).offset(15.0);
        make.right.equalTo(_rankingView).offset(-15.0);
    }];
    
    [_rankSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rankingView);
        make.top.equalTo(_rankTitleLabel.mas_bottom).offset(4);
        make.left.equalTo(_rankingView).offset(15.0);
        make.right.equalTo(_rankingView).offset(-15.0);
    }];
}

#pragma mark - getters and setters
- (UIView *)videoChatView {
    if (!_videoChatView) {
        _videoChatView = [[UIView alloc] init];
        _videoChatView.backgroundColor = ColorHex(fafafa);
        _videoChatView.layer.cornerRadius = 3;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoChat)];
        [_videoChatView addGestureRecognizer:tap];
    }
    return _videoChatView;
}

- (UIView *)taskView {
    if (!_taskView) {
        _taskView = [[UIView alloc] init];
        _taskView.backgroundColor = ColorHex(fafafa);
        _taskView.layer.cornerRadius = 3;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTask)];
        [_taskView addGestureRecognizer:tap];
    }
    return _taskView;
}

- (UIImageView *)videoChatIconImageView {
    if (!_videoChatIconImageView) {
        _videoChatIconImageView = [[UIImageView alloc] init];
        _videoChatIconImageView.image = [UIImage imageNamed:@"icSpzxSy"];
    }
    return _videoChatIconImageView;
}

- (UIImageView *)taskIconImageView {
    if (!_taskIconImageView) {
        _taskIconImageView = [[UIImageView alloc] init];
        _taskIconImageView.image = [UIImage imageNamed:@"rectangle54"];
    }
    return _taskIconImageView;
}

- (UILabel *)videoChatTitleLabel {
    if (!_videoChatTitleLabel) {
        _videoChatTitleLabel = [[UILabel alloc] init];
        _videoChatTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Bold" size:16.0];
        _videoChatTitleLabel.text = @"视频咨询";
        _videoChatTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _videoChatTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _videoChatTitleLabel;
}

- (UILabel *)taskTitleLabel {
    if (!_taskTitleLabel) {
        _taskTitleLabel = [[UILabel alloc] init];
        _taskTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Bold" size:16.0];
        _taskTitleLabel.text = @"全部通告";
        _taskTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _taskTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _taskTitleLabel;
}

- (UILabel *)videoChatSubTitleLabel {
    if (!_videoChatSubTitleLabel) {
        _videoChatSubTitleLabel = [[UILabel alloc] init];
        _videoChatSubTitleLabel.font = [UIFont systemFontOfSize:13.0];
        _videoChatSubTitleLabel.text = @"线上互动 轻松收益";
        _videoChatSubTitleLabel.textColor = RGBCOLOR(153, 153, 153);
        _videoChatSubTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _videoChatSubTitleLabel;
}

- (UILabel *)taskSubTitleLabel {
    if (!_taskSubTitleLabel) {
        _taskSubTitleLabel = [[UILabel alloc] init];
        _taskSubTitleLabel.font = [UIFont systemFontOfSize:13.0];
        _taskSubTitleLabel.text = @"海量通告 报名赚钱";
        _taskSubTitleLabel.textColor = RGBCOLOR(153, 153, 153);
        _taskSubTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _taskSubTitleLabel;
}

- (UIImageView *)rankingView {
    if (!_rankingView) {
        _rankingView = [[UIImageView alloc] init];
        _rankingView.image = [UIImage imageNamed:@"homeRankBg"];
        _rankingView.layer.cornerRadius = 3;
        _rankingView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRanks)];
        [_rankingView addGestureRecognizer:tap];
    }
    return _rankingView;
}

- (UILabel *)rankTitleLabel {
    if (!_rankTitleLabel) {
        _rankTitleLabel = [[UILabel alloc] init];
        _rankTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
        _rankTitleLabel.text = @"实力排行榜";
        _rankTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _rankTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rankTitleLabel;
}

- (UILabel *)rankSubTitleLabel {
    if (!_rankSubTitleLabel) {
        _rankSubTitleLabel = [[UILabel alloc] init];
        _rankSubTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15.0];
        _rankSubTitleLabel.text = @" 全国实力代表大会";
        _rankSubTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _rankSubTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rankSubTitleLabel;
}

- (UIImageView *)firstPlaceCrownImageView {
    if (!_firstPlaceCrownImageView) {
        _firstPlaceCrownImageView = [[UIImageView alloc] init];
        _firstPlaceCrownImageView.image = [UIImage imageNamed:@"rank-1"];
        _firstPlaceCrownImageView.userInteractionEnabled = YES;
    }
    return _firstPlaceCrownImageView;
}

- (UIImageView *)secondPlaceCrownImageView {
    if (!_secondPlaceCrownImageView) {
        _secondPlaceCrownImageView = [[UIImageView alloc] init];
        _secondPlaceCrownImageView.image = [UIImage imageNamed:@"rank-2"];
        _secondPlaceCrownImageView.userInteractionEnabled = YES;
    }
    return _secondPlaceCrownImageView;
}

- (UIImageView *)thirdPlaceCrownImageView {
    if (!_thirdPlaceCrownImageView) {
        _thirdPlaceCrownImageView = [[UIImageView alloc] init];
        _thirdPlaceCrownImageView.image = [UIImage imageNamed:@"rank-3"];
        _rankingView.userInteractionEnabled = YES;
    }
    return _thirdPlaceCrownImageView;
}

- (UIImageView *)firstPlaceUserIconImageView {
    if (!_firstPlaceUserIconImageView) {
        _firstPlaceUserIconImageView = [[UIImageView alloc] init];
        _firstPlaceUserIconImageView.userInteractionEnabled = YES;
        
        _firstPlaceUserIconImageView.layer.cornerRadius = 49 / 2;
        _firstPlaceUserIconImageView.layer.borderColor = RGBCOLOR(255, 198, 66).CGColor;
        _firstPlaceUserIconImageView.layer.borderWidth = 2;
    }
    return _firstPlaceUserIconImageView;
}

- (UIImageView *)secondPlaceUserIconImageView {
    if (!_secondPlaceUserIconImageView) {
        _secondPlaceUserIconImageView = [[UIImageView alloc] init];
        _secondPlaceUserIconImageView.userInteractionEnabled = YES;
        _secondPlaceUserIconImageView.layer.cornerRadius = 43 / 2;
        _secondPlaceUserIconImageView.layer.borderColor = RGBCOLOR(184, 196, 255).CGColor;
        _secondPlaceUserIconImageView.layer.borderWidth = 2;
    }
    return _secondPlaceUserIconImageView;
}

- (UIImageView *)thirdPlaceUserIconImageView {
    if (!_thirdPlaceUserIconImageView) {
        _thirdPlaceUserIconImageView = [[UIImageView alloc] init];
        _thirdPlaceUserIconImageView.userInteractionEnabled = YES;
        _thirdPlaceUserIconImageView.layer.cornerRadius = 43 / 2;
        _thirdPlaceUserIconImageView.layer.borderColor = RGBCOLOR(255, 186, 146).CGColor;
        _thirdPlaceUserIconImageView.layer.borderWidth = 2;
    }
    return _thirdPlaceUserIconImageView;
}

- (UIImageView *)firstPlaceRankingImageView {
    if (!_firstPlaceRankingImageView) {
        _firstPlaceRankingImageView = [[UIImageView alloc] init];
        _firstPlaceRankingImageView.image = [UIImage imageNamed:@"place-1"];
        _firstPlaceRankingImageView.userInteractionEnabled = YES;
    }
    return _firstPlaceRankingImageView;
}

- (UIImageView *)secondPlaceRankingImageView {
    if (!_secondPlaceRankingImageView) {
        _secondPlaceRankingImageView = [[UIImageView alloc] init];
        _secondPlaceRankingImageView.image = [UIImage imageNamed:@"place-2"];
        _secondPlaceRankingImageView.userInteractionEnabled = YES;
    }
    return _secondPlaceRankingImageView;
}

- (UIImageView *)thirdPlaceRankingImageView {
    if (!_thirdPlaceRankingImageView) {
        _thirdPlaceRankingImageView = [[UIImageView alloc] init];
        _thirdPlaceRankingImageView.image = [UIImage imageNamed:@"place-3"];
        _thirdPlaceRankingImageView.userInteractionEnabled = YES;
    }
    return _thirdPlaceRankingImageView;
}

@end
