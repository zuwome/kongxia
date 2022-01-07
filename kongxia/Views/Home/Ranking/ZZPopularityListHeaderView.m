//
//  ZZPopularityListHeaderView.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPopularityListHeaderView.h"

@interface ZZPopularityListHeaderView ()

@property (nonatomic, strong) UIImageView *rank1BgImageView;

@property (nonatomic, strong) UIImageView *rank2BgImageView;

@property (nonatomic, strong) UIImageView *rank3BgImageView;

@property (nonatomic, strong) UIImageView *rank1BgRankImageView;

@property (nonatomic, strong) UIImageView *rank2BgRankImageView;

@property (nonatomic, strong) UIImageView *rank3BgRankImageView;

@property (nonatomic, strong) UIImageView *rank1CrownImageView;

@property (nonatomic, strong) UIImageView *rank2CrownImageView;

@property (nonatomic, strong) UIImageView *rank3CrownImageView;

@property (nonatomic, strong) UIImageView *rank1UserIconImageView;

@property (nonatomic, strong) UIImageView *rank2UserIconImageView;

@property (nonatomic, strong) UIImageView *rank3UserIconImageView;

@property (nonatomic, strong) UILabel *rank1UserNameLabel;

@property (nonatomic, strong) UILabel *rank2UserNameLabel;

@property (nonatomic, strong) UILabel *rank3UserNameLabel;

@property (nonatomic, strong) UILabel *rank1PopularityLabel;

@property (nonatomic, strong) UILabel *rank2PopularityLabel;

@property (nonatomic, strong) UILabel *rank3PopularityLabel;

@property (nonatomic, strong) UIImageView *rank1PoUpDownImageView;

@property (nonatomic, strong) UIImageView *rank2PoUpDownImageView;

@property (nonatomic, strong) UIImageView *rank3PoUpDownImageView;

@property (nonatomic, strong) UILabel *bottomTitleLabel;

@property (nonatomic, copy) NSArray<ZZUser *> *top3Arr;

@end


@implementation ZZPopularityListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureTop3:(NSArray<ZZUser *> *)top3Arr {
    _top3Arr = top3Arr;
    [top3Arr enumerateObjectsUsingBlock:^(ZZUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [_rank1UserIconImageView sd_setImageWithURL:[NSURL URLWithString:[obj displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                UIImage *roundImage = [image imageAddCornerWithRadius:25 andSize:_rank1UserIconImageView.size];
                _rank1UserIconImageView.image = roundImage;
            }];
            
            _rank1UserNameLabel.text = obj.nickname;
            _rank1PopularityLabel.text = [NSString stringWithFormat:@"人气值: %ld", (NSInteger)obj.total_score];
            
            // 上升下降
            if (obj.is_top == 1) {
                _rank1PoUpDownImageView.image = [UIImage imageNamed:@"icUp"];
            }
            else if (obj.is_top == -1) {
                _rank1PoUpDownImageView.image = [UIImage imageNamed:@"icDown"];
            }
            else if (obj.is_top == 0) {
                _rank1PoUpDownImageView.image = [UIImage imageNamed:@"icBubian"];
            }
        }
        else if (idx == 1) {
            [_rank2UserIconImageView sd_setImageWithURL:[NSURL URLWithString:[obj displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                UIImage *roundImage = [image imageAddCornerWithRadius:25 andSize:_rank2UserIconImageView.size];
                _rank2UserIconImageView.image = roundImage;
            }];
            
            _rank2UserNameLabel.text = obj.nickname;
            _rank2PopularityLabel.text = [NSString stringWithFormat:@"人气值: %ld", (NSInteger)obj.total_score];
            
            // 上升下降
            if (obj.is_top == 1) {
                _rank2PoUpDownImageView.image = [UIImage imageNamed:@"icUp"];
            }
            else if (obj.is_top == -1) {
                _rank2PoUpDownImageView.image = [UIImage imageNamed:@"icDown"];
            }
            else if (obj.is_top == 0) {
                _rank2PoUpDownImageView.image = [UIImage imageNamed:@"icBubian"];
            }
        }
        else {
            [_rank3UserIconImageView sd_setImageWithURL:[NSURL URLWithString:[obj displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                UIImage *roundImage = [image imageAddCornerWithRadius:25 andSize:_rank3UserIconImageView.size];
                _rank3UserIconImageView.image = roundImage;
            }];
            
            _rank3UserNameLabel.text = obj.nickname;
            _rank3PopularityLabel.text = [NSString stringWithFormat:@"人气值: %ld", (NSInteger)obj.total_score];
            
            // 上升下降
            if (obj.is_top == 1) {
                _rank3PoUpDownImageView.image = [UIImage imageNamed:@"icUp"];
            }
            else if (obj.is_top == -1) {
                _rank3PoUpDownImageView.image = [UIImage imageNamed:@"icDown"];
            }
            else if (obj.is_top == 0) {
                _rank3PoUpDownImageView.image = [UIImage imageNamed:@"icBubian"];
            }
        }
    }];
}


#pragma mark - response method
- (void)showUserInfo:(UITapGestureRecognizer *)recognzier {
    NSInteger rank = recognzier.view.tag;
    if (rank > 3) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:showUserInfo:)]) {
        [self.delegate headerView:self showUserInfo:_top3Arr[rank - 1]];
    }
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.rank1BgImageView];
    [_rank1BgImageView addSubview:self.rank1UserIconImageView];
    [_rank1BgImageView addSubview:self.rank1BgRankImageView];
    [_rank1BgImageView addSubview:self.rank1CrownImageView];
    [_rank1BgImageView addSubview:self.rank1UserNameLabel];
    [_rank1BgImageView addSubview:self.rank1PopularityLabel];
    [_rank1BgImageView addSubview:self.rank1PoUpDownImageView];
    
    [_rank1BgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(12.0);
        make.size.mas_equalTo(CGSizeMake(SCALE_SET(187), SCALE_SET(93)));
    }];
    
    [_rank1BgRankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rank1BgImageView);
        make.top.equalTo(_rank1BgImageView).offset(4);
        make.size.mas_equalTo(CGSizeMake(72.0 ,20.0));
    }];
    
    [_rank1UserIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rank1BgImageView).offset(15.5);
        make.bottom.equalTo(_rank1BgImageView).offset(-13.5);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [_rank1CrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rank1UserIconImageView).offset(-10);
        make.bottom.equalTo(_rank1UserIconImageView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(25, 20));
    }];
    
    [_rank1UserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rank1UserIconImageView.mas_right).offset(4.0);
        make.right.equalTo(_rank1BgImageView).offset(-15.0);
        make.top.equalTo(_rank1UserIconImageView).offset(5.0);
    }];
    
    [_rank1PopularityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rank1UserIconImageView.mas_right).offset(4.0);
        make.top.equalTo(_rank1UserNameLabel.mas_bottom).offset(5.0);
    }];
    
    [_rank1PoUpDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rank1PopularityLabel);
        make.left.equalTo(_rank1PopularityLabel.mas_right).offset(2.0);
    }];
    
    [self addSubview:self.rank2BgImageView];
    [_rank2BgImageView addSubview:self.rank2UserIconImageView];
    [_rank2BgImageView addSubview:self.rank2BgRankImageView];
    [_rank2BgImageView addSubview:self.rank2CrownImageView];
    [_rank2BgImageView addSubview:self.rank2UserNameLabel];
    [_rank2BgImageView addSubview:self.rank2PopularityLabel];
    [_rank2BgImageView addSubview:self.rank2PoUpDownImageView];
    
    [_rank2BgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rank1BgImageView.mas_left).offset(-2);
        make.top.equalTo(self).offset(12.0);
        make.size.mas_equalTo(CGSizeMake(SCALE_SET(77), SCALE_SET(93)));
    }];
    
    [_rank2BgRankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rank2BgImageView).offset(-4);
        make.top.equalTo(_rank2BgImageView).offset(4);
        make.size.mas_equalTo(CGSizeMake(20.0 ,20.0));
    }];
    
    [_rank2UserIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rank2BgImageView);
        make.top.equalTo(_rank2BgImageView).offset(24.5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_rank2CrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rank2UserIconImageView).offset(3);
        make.bottom.equalTo(_rank2UserIconImageView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 16));
    }];
    
    [_rank2UserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rank2BgImageView);
        make.left.equalTo(_rank2BgImageView).offset(5);
        make.right.equalTo(_rank2BgImageView).offset(-5.0);
        make.top.equalTo(_rank2UserIconImageView.mas_bottom).offset(1.0);
    }];
    
    [_rank2PopularityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rank2UserNameLabel).offset(-4.0);
        make.top.equalTo(_rank2UserNameLabel.mas_bottom);
    }];
    
    [_rank2PoUpDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rank2PopularityLabel);
        make.left.equalTo(_rank2PopularityLabel.mas_right).offset(2.0);
    }];
    
    [self addSubview:self.rank3BgImageView];
    [_rank3BgImageView addSubview:self.rank3UserIconImageView];
    [_rank3BgImageView addSubview:self.rank3BgRankImageView];
    [_rank3BgImageView addSubview:self.rank3CrownImageView];
    [_rank3BgImageView addSubview:self.rank3UserNameLabel];
    [_rank3BgImageView addSubview:self.rank3PopularityLabel];
    [_rank3BgImageView addSubview:self.rank3PoUpDownImageView];
    
    [_rank3BgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rank1BgImageView.mas_right).offset(2);
        make.top.equalTo(self).offset(12.0);
        make.size.mas_equalTo(CGSizeMake(SCALE_SET(77), SCALE_SET(93)));
    }];
    
    [_rank3BgRankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rank3BgImageView).offset(-4);
        make.top.equalTo(_rank3BgImageView).offset(4);
        make.size.mas_equalTo(CGSizeMake(20.0 ,20.0));
    }];
    
    [_rank3UserIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rank3BgImageView);
        make.top.equalTo(_rank3BgImageView).offset(24.5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_rank3CrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rank3UserIconImageView).offset(-3);
        make.bottom.equalTo(_rank3UserIconImageView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 16));
    }];
    
    [_rank3UserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rank3BgImageView);
        make.left.equalTo(_rank3BgImageView).offset(5);
        make.right.equalTo(_rank3BgImageView).offset(-5.0);
        make.top.equalTo(_rank3UserIconImageView.mas_bottom).offset(1.0);
    }];
    
    [_rank3PopularityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rank3UserNameLabel).offset(-4.0);
        make.top.equalTo(_rank3UserNameLabel.mas_bottom);
    }];
    
    [_rank3PoUpDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rank3PopularityLabel);
        make.left.equalTo(_rank3PopularityLabel.mas_right).offset(2.0);
    }];
    
    
    [self addSubview:self.bottomTitleLabel];
    [_bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_rank1BgImageView.mas_bottom).offset(16.0);
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)rank1BgImageView {
    if (!_rank1BgImageView) {
        _rank1BgImageView = [[UIImageView alloc] init];
        _rank1BgImageView.image = [UIImage imageNamed:@"bg1"];
        _rank1BgImageView.userInteractionEnabled = YES;
    }
    return _rank1BgImageView;
}

- (UIImageView *)rank2BgImageView {
    if (!_rank2BgImageView) {
        _rank2BgImageView = [[UIImageView alloc] init];
        _rank2BgImageView.image = [UIImage imageNamed:@"bg2"];
        _rank2BgImageView.userInteractionEnabled = YES;
    }
    return _rank2BgImageView;
}

- (UIImageView *)rank3BgImageView {
    if (!_rank3BgImageView) {
        _rank3BgImageView = [[UIImageView alloc] init];
        _rank3BgImageView.image = [UIImage imageNamed:@"bg3"];
        _rank3BgImageView.userInteractionEnabled = YES;
    }
    return _rank3BgImageView;
}

- (UIImageView *)rank1BgRankImageView {
    if (!_rank1BgRankImageView) {
        _rank1BgRankImageView = [[UIImageView alloc] init];
        _rank1BgRankImageView.image = [UIImage imageNamed:@"bg_rank1"];
    }
    return _rank1BgRankImageView;
}

- (UIImageView *)rank2BgRankImageView {
    if (!_rank2BgRankImageView) {
        _rank2BgRankImageView = [[UIImageView alloc] init];
        _rank2BgRankImageView.image = [UIImage imageNamed:@"bg_rank2"];
    }
    return _rank2BgRankImageView;
}

- (UIImageView *)rank3BgRankImageView {
    if (!_rank3BgRankImageView) {
        _rank3BgRankImageView = [[UIImageView alloc] init];
        _rank3BgRankImageView.image = [UIImage imageNamed:@"bg_rank3"];
    }
    return _rank3BgRankImageView;
}

- (UIImageView *)rank1CrownImageView {
    if (!_rank1CrownImageView) {
        _rank1CrownImageView = [[UIImageView alloc] init];
        _rank1CrownImageView.image = [UIImage imageNamed:@"rank-1"];
    }
    return _rank1CrownImageView;
}

- (UIImageView *)rank2CrownImageView {
    if (!_rank2CrownImageView) {
        _rank2CrownImageView = [[UIImageView alloc] init];
        _rank2CrownImageView.image = [UIImage imageNamed:@"rank-2"];
    }
    return _rank2CrownImageView;
}

- (UIImageView *)rank3CrownImageView {
    if (!_rank3CrownImageView) {
        _rank3CrownImageView = [[UIImageView alloc] init];
        _rank3CrownImageView.image = [UIImage imageNamed:@"rank-3"];
    }
    return _rank3CrownImageView;
}

- (UIImageView *)rank1UserIconImageView {
    if (!_rank1UserIconImageView) {
        _rank1UserIconImageView = [[UIImageView alloc] init];
        _rank1UserIconImageView.userInteractionEnabled = YES;
        _rank1UserIconImageView.tag = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo:)];
        [_rank1UserIconImageView addGestureRecognizer:tap];
    }
    return _rank1UserIconImageView;
}

- (UIImageView *)rank2UserIconImageView {
    if (!_rank2UserIconImageView) {
        _rank2UserIconImageView = [[UIImageView alloc] init];
        _rank2UserIconImageView.userInteractionEnabled = YES;
        _rank2UserIconImageView.tag = 2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo:)];
        [_rank2UserIconImageView addGestureRecognizer:tap];
    }
    return _rank2UserIconImageView;
}


- (UIImageView *)rank3UserIconImageView {
    if (!_rank3UserIconImageView) {
        _rank3UserIconImageView = [[UIImageView alloc] init];
        _rank3UserIconImageView.userInteractionEnabled = YES;
        _rank3UserIconImageView.tag = 3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo:)];
        [_rank3UserIconImageView addGestureRecognizer:tap];
    }
    return _rank3UserIconImageView;
}

- (UIImageView *)rank1PoUpDownImageView {
    if (!_rank1PoUpDownImageView) {
        _rank1PoUpDownImageView = [[UIImageView alloc] init];
    }
    return _rank1PoUpDownImageView;
}

- (UIImageView *)rank2PoUpDownImageView {
    if (!_rank2PoUpDownImageView) {
        _rank2PoUpDownImageView = [[UIImageView alloc] init];
    }
    return _rank2PoUpDownImageView;
}

- (UIImageView *)rank3PoUpDownImageView {
    if (!_rank3PoUpDownImageView) {
        _rank3PoUpDownImageView = [[UIImageView alloc] init];
    }
    return _rank3PoUpDownImageView;
}

- (UILabel *)rank1UserNameLabel {
    if (!_rank1UserNameLabel) {
        _rank1UserNameLabel = [[UILabel alloc] init];
        _rank1UserNameLabel.font = [UIFont boldSystemFontOfSize:14];
        _rank1UserNameLabel.textColor = UIColor.whiteColor;
    }
    return _rank1UserNameLabel;
}

- (UILabel *)rank2UserNameLabel {
    if (!_rank2UserNameLabel) {
        _rank2UserNameLabel = [[UILabel alloc] init];
        _rank2UserNameLabel.font = [UIFont boldSystemFontOfSize:11];
        _rank2UserNameLabel.textColor = UIColor.whiteColor;
        _rank2UserNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rank2UserNameLabel;
}

- (UILabel *)rank3UserNameLabel {
    if (!_rank3UserNameLabel) {
        _rank3UserNameLabel = [[UILabel alloc] init];
        _rank3UserNameLabel.font = [UIFont boldSystemFontOfSize:11];
        _rank3UserNameLabel.textColor = UIColor.whiteColor;
        _rank3UserNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rank3UserNameLabel;
}

- (UILabel *)rank1PopularityLabel {
    if (!_rank1PopularityLabel) {
        _rank1PopularityLabel = [[UILabel alloc] init];
        _rank1PopularityLabel.font = [UIFont systemFontOfSize:11];
        _rank1PopularityLabel.textColor = UIColor.whiteColor;
    }
    return _rank1PopularityLabel;
}

- (UILabel *)rank2PopularityLabel {
    if (!_rank2PopularityLabel) {
        _rank2PopularityLabel = [[UILabel alloc] init];
        _rank2PopularityLabel.font = [UIFont systemFontOfSize:6];
        _rank2PopularityLabel.textColor = UIColor.whiteColor;
    }
    return _rank2PopularityLabel;
}

- (UILabel *)rank3PopularityLabel {
    if (!_rank3PopularityLabel) {
        _rank3PopularityLabel = [[UILabel alloc] init];
        _rank3PopularityLabel.font = [UIFont systemFontOfSize:6];
        _rank3PopularityLabel.textColor = UIColor.whiteColor;
    }
    return _rank3PopularityLabel;
}

- (UILabel *)bottomTitleLabel {
    if (!_bottomTitleLabel) {
        _bottomTitleLabel = [[UILabel alloc] init];
        _bottomTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _bottomTitleLabel.textColor = RGBCOLOR(153, 153, 153);
        _bottomTitleLabel.numberOfLines = 3;
        _bottomTitleLabel.text = @"根据最近30日的收益、基础值、加分值乘以好评倍数、响应率倍数、接受率倍数、定价倍数所获得分值总和作为排名依据";
        _bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomTitleLabel;
}

@end
 
