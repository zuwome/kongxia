//
//  ZZRookieRankHeaderView.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRookieRankHeaderView.h"
#import "ZZLevelImgView.h"

@interface ZZRookieRankHeaderView () <ZZRookieRankHeaderTopViewDelegate>

@property (nonatomic, strong) ZZRookieRankHeaderTopView *rank1View;

@property (nonatomic, strong) ZZRookieRankHeaderTopView *rank2View;

@property (nonatomic, strong) ZZRookieRankHeaderTopView *rank3View;

@property (nonatomic, copy) NSArray<ZZUser *> *top3Arr;

@end


@implementation ZZRookieRankHeaderView

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
            [_rank1View configureData:obj];
        }
        else if (idx == 1) {
            [_rank2View configureData:obj];
        }
        else {
            [_rank3View configureData:obj];
        }
    }];
}


#pragma mark - ZZRookieRankHeaderTopViewDelegate
- (void)topViewShoActions:(ZZRookieRankHeaderTopView *)view {
    NSInteger rank = view.rank;
    if (rank <= 3) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:goChat:)]) {
            [self.delegate headerView:self goChat:_top3Arr[rank - 1]];
        }
    }
}

- (void)topViewShowUserInfo:(ZZRookieRankHeaderTopView *)view {
    NSInteger rank = view.rank;
    if (rank <= 3) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:showUserInfo:)]) {
            [self.delegate headerView:self showUserInfo:_top3Arr[rank - 1]];
        }
    }
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.rank1View];
    [self addSubview:self.rank2View];
    [self addSubview:self.rank3View];
    
    [_rank1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(12);
        make.size.mas_equalTo(CGSizeMake(110, 230));
    }];
    
    [_rank2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rank1View.mas_left).offset(-15);
        make.top.equalTo(self).offset(12);
        make.size.mas_equalTo(CGSizeMake(110, 230));
    }];
    
    [_rank3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rank1View.mas_right).offset(15);
        make.top.equalTo(self).offset(12);
        make.size.mas_equalTo(CGSizeMake(110, 230));
    }];
}


#pragma mark - getters and setters
- (ZZRookieRankHeaderTopView *)rank1View {
    if (!_rank1View) {
        _rank1View = [[ZZRookieRankHeaderTopView alloc] initWithRank:1];
        _rank1View.delegate = self;
    }
    return _rank1View;
}

- (ZZRookieRankHeaderTopView *)rank2View {
    if (!_rank2View) {
        _rank2View = [[ZZRookieRankHeaderTopView alloc] initWithRank:2];
        _rank2View.delegate = self;
    }
    return _rank2View;
}

- (ZZRookieRankHeaderTopView *)rank3View {
    if (!_rank3View) {
        _rank3View = [[ZZRookieRankHeaderTopView alloc] initWithRank:3];
        _rank3View.delegate = self;
    }
    return _rank3View;
}

@end


@interface ZZRookieRankHeaderTopView ()

@end

@implementation ZZRookieRankHeaderTopView

- (instancetype)initWithRank:(NSInteger)rank {
    self = [super init];
    if (self) {
        _rank = rank;
        [self layout];
    }
    return self;
}

- (void)configureData:(ZZUser *)user {
    [_rank1UserIconImageView sd_setImageWithURL:[NSURL URLWithString:[user displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGFloat radius = _rank == 1 ? 62 / 2 : 55 / 2;
        UIImage *roundImage = [image imageAddCornerWithRadius:radius andSize:_rank1UserIconImageView.size];
        _rank1UserIconImageView.image = roundImage;
    }];

    CGFloat maxNameWidth = 53.5;
    CGFloat nameLabelWidth = 0;
    CGFloat nameWidth = [NSString findWidthForText:user.nickname havingWidth:110 andFont:_rank1UserNameLabel.font];
    nameLabelWidth = nameWidth > maxNameWidth ? maxNameWidth : nameWidth;
    _rank1UserNameLabel.text = user.nickname;
    _rank1UserNameLabel.frame = CGRectMake(0.0,
                                           _rank1UserNameLabel.top,
                                           nameLabelWidth,
                                           _rank1UserNameLabel.font.lineHeight);
    
    // 性别
    if (user.gender == 2) {
        _rank1genderImageView.image = [UIImage imageNamed:@"girl"];
    }
    else if (user.gender == 1) {
        _rank1genderImageView.image = [UIImage imageNamed:@"boy"];
    }
    
    // 等级
    [_rank1levelView setLevel:user.level];
    
    _rank1genderImageView.frame = CGRectMake(_rank1UserNameLabel.right + 5,
                                             _rank1UserNameLabel.height * 0.5 + _rank1UserNameLabel.top - 7,
                                             12,
                                             12);
    
    _rank1levelView.frame = CGRectMake(_rank1genderImageView.right + 3,
                                       _rank1UserNameLabel.height * 0.5 + _rank1UserNameLabel.top - 7,
                                       28,
                                       14);
    
    _rank1PopularityLabel.text = [NSString stringWithFormat:@"人气值: %ld", (NSInteger)user.total_score];
    
    CGFloat width = [NSString findWidthForText:_rank1PopularityLabel.text havingWidth:110 andFont:_rank1PopularityLabel.font];
    _rank1PopularityLabel.frame = CGRectMake(110 * 0.5 - width * 0.5, _rank1UserNameLabel.bottom + 4, width, _rank1PopularityLabel.font.lineHeight);
    

    // 上升下降
    if (user.is_top == 1) {
        _rank1PoUpDownImageView.image = [UIImage imageNamed:@"icUp"];
    }
    else if (user.is_top == -1) {
        _rank1PoUpDownImageView.image = [UIImage imageNamed:@"icDown"];
    }
    else if (user.is_top == 0) {
        _rank1PoUpDownImageView.image = [UIImage imageNamed:@"icBubian"];
    }
}

- (void)createBtnGradientColor {
    [self layoutIfNeeded];
    CAGradientLayer *btnGragientLayer = [ZZUtils setGradualChangingColor:_rank1ChatBtn fromColor:RGBCOLOR(249, 6, 50) toColor:RGBCOLOR(251, 2, 243) endPoint:CGPointMake(1.0, 0) locations:@[@0.3, @0.8] type:nil];
    btnGragientLayer.frame = _rank1ChatBtn.bounds;
    btnGragientLayer.cornerRadius = 16.0;
    [_rank1ChatBtn.layer addSublayer:btnGragientLayer];
    
    [_rank1ChatBtn bringSubviewToFront:_rank1ChatBtn.titleLabel];
}

#pragma mark - response method
- (void)showUserInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topViewShowUserInfo:)]) {
        [self.delegate topViewShowUserInfo:self];
    }
}

- (void)showActions {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topViewShoActions:)]) {
        [self.delegate topViewShoActions:self];
    }
}

#pragma mark - Layout
- (void)layout {
    
    CGFloat borderWidth = 72;
    CGFloat iconWidth = 62;
    CGFloat iconToTitle = 22;
    CGFloat iconToTop = 40;
    CGSize crownSize = CGSizeMake(49.0, 35.5);
    if (_rank == 1) {
        borderWidth = 72;
        iconWidth = 62;
        iconToTitle = 22;
        iconToTop = 40;
        crownSize = CGSizeMake(49.0, 35.5);
    }
    else {
        borderWidth = 65;
        iconWidth = 55;
        iconToTitle = 13;
        iconToTop = 56;
        crownSize = CGSizeMake(35, 17);
    }
    
    UIView *rank1View = [[UIView alloc] init];
    rank1View.layer.cornerRadius = borderWidth / 2;
    rank1View.layer.borderColor = RGBCOLOR(251, 2, 241).CGColor;
    rank1View.layer.borderWidth = 1.5;
    
    [self addSubview:rank1View];
    [rank1View addSubview:self.rank1UserIconImageView];
    [self addSubview:self.rank1CrownImageView];
    [self addSubview:self.rank1UserNameLabel];
    [self addSubview:self.rank1PopularityLabel];
    [self addSubview:self.rank1PoUpDownImageView];
    [self addSubview:self.rank1ChatBtn];
    [self addSubview:self.rank1genderImageView];
    [self addSubview:self.rank1levelView];
    
    rank1View.frame = CGRectMake(110 / 2 - borderWidth / 2, iconToTop, borderWidth, borderWidth);
    
    [_rank1UserIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(rank1View);
        make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
    }];
    
    [_rank1CrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rank1UserIconImageView);
        if (_rank == 1) {
            make.bottom.equalTo(rank1View.mas_top).offset(10);
        }
        else {
            make.centerY.equalTo(rank1View.mas_bottom).offset(-5);
        }
        
        make.size.mas_equalTo(crownSize);
    }];
    
    _rank1UserNameLabel.frame = CGRectMake(0.0,
                                           rank1View.bottom + iconToTitle,
                                           110,
                                           _rank1UserNameLabel.font.lineHeight);
    
    _rank1genderImageView.frame = CGRectMake(_rank1UserNameLabel.right + 5,
                                             _rank1UserNameLabel.height * 0.5 + _rank1UserNameLabel.top - 7,
                                             12,
                                             12);
    
    _rank1levelView.frame = CGRectMake(_rank1genderImageView.right + 3,
                                       _rank1UserNameLabel.height * 0.5 + _rank1UserNameLabel.top - 7,
                                       28,
                                       14);
    
    _rank1PopularityLabel.frame = CGRectMake(0.0,
                                             _rank1UserNameLabel.bottom + 4,
                                             110.0,
                                             _rank1PopularityLabel.font.lineHeight);
    [_rank1PoUpDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rank1PopularityLabel);
        make.left.equalTo(_rank1PopularityLabel.mas_right).offset(4);
    }];
    
    _rank1ChatBtn.frame = CGRectMake(110 / 2 - 81 / 2,
                                     _rank1PopularityLabel.bottom + 12,
                                     81,
                                     32);
    
    [self createBtnGradientColor];
}


#pragma mark - getters and setters
- (UIImageView *)rank1CrownImageView {
    if (!_rank1CrownImageView) {
        _rank1CrownImageView = [[UIImageView alloc] init];
        
        if (_rank == 1) {
            _rank1CrownImageView.image = [UIImage imageNamed:@"no1"];
        }
        else if (_rank == 2) {
            _rank1CrownImageView.image = [UIImage imageNamed:@"no2"];
        }
        else if (_rank == 3) {
            _rank1CrownImageView.image = [UIImage imageNamed:@"no3"];
        }
    }
    return _rank1CrownImageView;
}

- (UIImageView *)rank1UserIconImageView {
    if (!_rank1UserIconImageView) {
        _rank1UserIconImageView = [[UIImageView alloc] init];
        _rank1UserIconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
        [_rank1UserIconImageView addGestureRecognizer:tap];
    }
    return _rank1UserIconImageView;
}

- (UIImageView *)rank1PoUpDownImageView {
    if (!_rank1PoUpDownImageView) {
        _rank1PoUpDownImageView = [[UIImageView alloc] init];
        _rank1PoUpDownImageView.hidden = NO;
    }
    return _rank1PoUpDownImageView;
}

- (UILabel *)rank1UserNameLabel {
    if (!_rank1UserNameLabel) {
        _rank1UserNameLabel = [[UILabel alloc] init];
        _rank1UserNameLabel.font = [UIFont boldSystemFontOfSize:14];
        _rank1UserNameLabel.textColor = RGBCOLOR(63, 58, 58);
        _rank1UserNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rank1UserNameLabel;
}

- (UILabel *)rank1PopularityLabel {
    if (!_rank1PopularityLabel) {
        _rank1PopularityLabel = [[UILabel alloc] init];
        _rank1PopularityLabel.font = [UIFont systemFontOfSize:11];
        _rank1PopularityLabel.textColor = RGBACOLOR(63, 58, 58, 0.9);
        _rank1PopularityLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rank1PopularityLabel;
}

- (UIButton *)rank1ChatBtn {
    if (!_rank1ChatBtn) {
        _rank1ChatBtn = [[UIButton alloc] init];
        _rank1ChatBtn.normalTitle = @"私信";
        _rank1ChatBtn.normalTitleColor = UIColor.whiteColor;
        _rank1ChatBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_rank1ChatBtn addTarget:self action:@selector(showActions) forControlEvents:UIControlEventTouchUpInside];
        _rank1ChatBtn.backgroundColor = RGBCOLOR(249, 6, 50);
        _rank1ChatBtn.layer.cornerRadius = 16.0;
    }
    return _rank1ChatBtn;
}

- (ZZLevelImgView *)rank1levelView {
    if (!_rank1levelView) {
        _rank1levelView = [[ZZLevelImgView alloc] init];
        _rank1levelView.hidden = NO;
    }
    return _rank1levelView;
}

- (UIImageView *)rank1genderImageView {
    if (!_rank1genderImageView) {
        _rank1genderImageView = [[UIImageView alloc] init];
        _rank1genderImageView.hidden = NO;
    }
    return _rank1genderImageView;
}


@end
