//
//  ZZListRankView.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZListRankView.h"
#import "ZZLevelImgView.h"

@interface ZZListRankView()

@property (nonatomic, strong) ZZLevelImgView *levelView;

@property (nonatomic, strong) UILabel *rankLabel;

@property (nonatomic, strong) UIImageView *userIconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) UILabel *popularityLabel;

@property (nonatomic, strong) UIImageView *popularityImageView;

@property (nonatomic, strong) UIButton *chatBtn;

@property (nonatomic, strong) ZZUser *user;

@property (nonatomic, strong) UIImageView *rightIconImageView;

@property (nonatomic, assign) BOOL isMyRank;

@property (nonatomic, strong) CAGradientLayer *btnGragientLayer;

@property (nonatomic, strong) UIColor *labeltextColor;

@end

@implementation ZZListRankView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureMyRank:(ZZUser *)user rank:(NSInteger)rank isRookie:(BOOL)isRookie {
    _user = user;
    if (_isRookie) {
        self.backgroundColor = RGBCOLOR(15, 15, 53);
    }
    else {
        self.backgroundColor = RGBCOLOR(253, 251, 245);
    }
    _isMyRank = YES;
    
    
    _user = user;
        
    // 排名
    _rankLabel.text = [NSString stringWithFormat:@"%02ld", (long)rank];
    
    // 头像
    [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:[user displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIImage *roundImage = [image imageAddCornerWithRadius:23 andSize:_userIconImageView.size];
        _userIconImageView.image = roundImage;
    }];
    
    // 姓名
    _nameLabel.text = user.nickname;
    
    // 性别
    if (user.gender == 2) {
        _genderImageView.image = [UIImage imageNamed:@"girl"];
    }
    else if (user.gender == 1) {
        _genderImageView.image = [UIImage imageNamed:@"boy"];
    }
    else {
        _genderImageView.image = [UIImage imageNamed:@""];
    }

    // 等级
    [_levelView setLevel:user.level];
    
    if (isRookie) {
        if (user.rent.status == 0 || user.rent.status == 1) {
            _rankLabel.text = @"未上榜";
            _rankLabel.font = [UIFont boldSystemFontOfSize:16.0];
            
            // 人气值
            _popularityLabel.text = @"请先申请成为空虾达人";
            _chatBtn.normalTitle = @"成为达人";
            _popularityImageView.hidden = YES;
        }
        else {
            
            if (rank == -1 || rank == 0) {
                // 排名
                _rankLabel.text = @"未上榜";
                _rankLabel.font = [UIFont boldSystemFontOfSize:16.0];
            }
                
            _chatBtn.normalTitle = @"冲榜攻略";
            _popularityLabel.text = [NSString stringWithFormat:@"人气值：%ld", (NSInteger)_user.total_score];
            
            _popularityImageView.hidden = NO;
            
            // 上升下降
            if (_user.is_top == 1) {
                _popularityImageView.image = [UIImage imageNamed:@"icUp"];
            }
            else if (_user.is_top == -1) {
                _popularityImageView.image = [UIImage imageNamed:@"icDown"];
            }
            else if (_user.is_top == 0) {
                _popularityImageView.image = nil;
            }
        }
    }
    else {
        if (user.rent.status == 0 || user.rent.status == 1) {
            _rankLabel.text = @"未上榜";
            _rankLabel.font = [UIFont boldSystemFontOfSize:16.0];
            
            // 人气值
            _popularityLabel.text = @"请先申请成为空虾达人";
            _chatBtn.normalTitle = @"成为达人";
            _popularityImageView.hidden = YES;
        }
        else {
            if (rank == -1 || rank == 0) {
                // 排名
                _rankLabel.text = @"未上榜";
                _rankLabel.font = [UIFont boldSystemFontOfSize:16.0];
            }
            _chatBtn.normalTitle = @"冲榜攻略";
            _popularityLabel.text = [NSString stringWithFormat:@"人气值：%ld", (NSInteger)_user.total_score];
            
            _popularityImageView.hidden = NO;
            
            // 上升下降
            if (_user.is_top == 1) {
                _popularityImageView.image = [UIImage imageNamed:@"icUp"];
            }
            else if (_user.is_top == -1) {
                _popularityImageView.image = [UIImage imageNamed:@"icDown"];
            }
            else if (_user.is_top == 0) {
                _popularityImageView.image = nil;
            }
        }
    }
    
 
    _rightIconImageView.hidden = NO;
    
    [_chatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-31);
        make.size.mas_equalTo(CGSizeMake(71, 26));
    }];
    _chatBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    
    [self createBtnGradientColor];
}

- (void)configureUser:(ZZUser *)user rank:(NSInteger)rank {
    _user = user;
    
    // 排名
    _rankLabel.text = [NSString stringWithFormat:@"%02ld", (long)rank];
    
    // 头像
    [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:[user displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIImage *roundImage = [image imageAddCornerWithRadius:23 andSize:_userIconImageView.size];
        _userIconImageView.image = roundImage;
    }];
    
    // 姓名   
    _nameLabel.text = user.nickname;
    
    // 性别
    if (user.gender == 2) {
        _genderImageView.image = [UIImage imageNamed:@"girl"];
    }
    else if (user.gender == 1) {
        _genderImageView.image = [UIImage imageNamed:@"boy"];
    }
    else {
        _genderImageView.image = [UIImage imageNamed:@""];
    }

    // 等级
    [_levelView setLevel:user.level];
    
    // 人气值
    _popularityLabel.text = [NSString stringWithFormat:@"人气值：%ld", (NSInteger)_user.total_score];
    
    // 上升下降
    if (_user.is_top == 1) {
        _popularityImageView.image = [UIImage imageNamed:@"icUp"];
    }
    else if (_user.is_top == -1) {
        _popularityImageView.image = [UIImage imageNamed:@"icDown"];
    }
    else if (_user.is_top == 0) {
        _popularityImageView.image = nil;
    }
    
    if (rank <= 10) {
        _rankLabel.font = [UIFont fontWithName:@"Alibaba-PuHuiTi-M" size:20];
        [self createColor];
    }
    else {
        _rankLabel.textColor = RGBCOLOR(64, 58, 58);
        _rankLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    
    if ([_user.user isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        _chatBtn.hidden = YES;
    }
    else {
        _chatBtn.hidden = NO;
    }
    
    [self createBtnGradientColor];
    
}

- (void)createColor {
    if (_labeltextColor) {
        _rankLabel.textColor = _labeltextColor;
    }
    else {
        [self layoutIfNeeded];
        UIGraphicsBeginImageContextWithOptions(_rankLabel.bounds.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        //绘制渐变层
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef,
                                                              (__bridge CFArrayRef)@[(id)RGBCOLOR(249, 6, 50).CGColor,(id)RGBCOLOR(251, 2, 243).CGColor],
                                                              NULL);
        
        CGPoint startPoint = CGPointZero;
        CGPoint endPoint = CGPointMake(CGRectGetMaxX(_rankLabel.bounds), 0);
        CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint,  kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        //取到渐变图片
        UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
        //释放资源
        CGColorSpaceRelease(colorSpaceRef);
        CGGradientRelease(gradientRef);
        UIGraphicsEndImageContext();
        
        _labeltextColor = [UIColor colorWithPatternImage:gradientImage];
        _rankLabel.textColor = _labeltextColor;
    }
}

- (void)createBtnGradientColor {
    if (!_btnGragientLayer) {
        [self layoutIfNeeded];
        _btnGragientLayer = [ZZUtils setGradualChangingColor:_chatBtn fromColor:RGBCOLOR(249, 6, 50) toColor:RGBCOLOR(251, 2, 243) endPoint:CGPointMake(1.0, 0) locations:@[@0.3, @0.8] type:nil];
        _btnGragientLayer.frame = _chatBtn.bounds;
        _btnGragientLayer.cornerRadius = 13.0;
        [_chatBtn.layer addSublayer:_btnGragientLayer];
        
        [_chatBtn bringSubviewToFront:_chatBtn.titleLabel];
    }
}

#pragma mark - response method
- (void)actions {
    if (_isMyRank) {
        if (_user.rent.status == 0 || _user.rent.status == 1) {
            // 还未成为达人
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewShowMine:)]) {
                [self.delegate viewShowMine:self];
            }
        }
        else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewShowTips:)]) {
                [self.delegate viewShowTips:self];
            }
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(view:goChat:)]) {
            [self.delegate view:self goChat:_user];
        }
    }
}

- (void)showUserInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:showUserInfo:)]) {
        [self.delegate view:self showUserInfo:_user];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.rankLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.userIconImageView];
    [self addSubview:self.genderImageView];
    [self addSubview:self.levelView];
    [self addSubview:self.popularityLabel];
    [self addSubview:self.popularityImageView];
    [self addSubview:self.chatBtn];
    [self addSubview:self.rightIconImageView];
    
    [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
    
    [_userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_rankLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView.mas_right).offset(8);
        make.top.equalTo(_userIconImageView).offset(0.5);
    }];
    
    [_popularityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView.mas_right).offset(8);
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
    }];
    
    [_popularityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_popularityLabel);
        make.left.equalTo(_popularityLabel.mas_right).offset(8);
    }];
    
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(62, 28));
    }];
    
    [_genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.left.equalTo(_nameLabel.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [_levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.left.equalTo(_genderImageView.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(28, 14));
    }];
    
    [_rightIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(6, 11.5));
    }];
    
    [self createColor];
}

#pragma mark - getters and setters
- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.text = @"01";
        _rankLabel.font = [UIFont fontWithName:@"Alibaba-PuHuiTi-M" size:20];
        _rankLabel.textColor = RGBCOLOR(249, 6, 50);
    }
    return _rankLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"01";
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _nameLabel;
}

- (UILabel *)popularityLabel {
    if (!_popularityLabel) {
        _popularityLabel = [[UILabel alloc] init];
        _popularityLabel.text = @"01";
        _popularityLabel.font = [UIFont systemFontOfSize:13];
        _popularityLabel.textColor = RGBCOLOR(153, 153, 153);
    }
    return _popularityLabel;
}

- (ZZLevelImgView *)levelView {
    if (!_levelView) {
        _levelView = [[ZZLevelImgView alloc] init];
    }
    return _levelView;
}

- (UIImageView *)genderImageView {
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc] init];
    }
    return _genderImageView;
}

- (UIImageView *)popularityImageView {
    if (!_popularityImageView) {
        _popularityImageView = [[UIImageView alloc] init];
    }
    return _popularityImageView;
}

- (UIButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [[UIButton alloc] init];
        _chatBtn.normalTitle = @"私信";
        _chatBtn.normalTitleColor = UIColor.whiteColor;
        _chatBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_chatBtn addTarget:self action:@selector(actions) forControlEvents:UIControlEventTouchUpInside];
        _chatBtn.layer.cornerRadius = 13.0;
    }
    return _chatBtn;
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


- (UIImageView *)rightIconImageView {
    if (!_rightIconImageView) {
        _rightIconImageView = [[UIImageView alloc] init];
        _rightIconImageView.image = [UIImage imageNamed:@"icon_rightBtn"];
        _rightIconImageView.hidden = YES;
    }
    return _rightIconImageView;
}

- (void)setIsRookie:(BOOL)isRookie {
    _isRookie = isRookie;
    
    if (_isRookie) {
        _rightIconImageView.image = [UIImage imageNamed:@"icon_right_white"];
    }
}

@end
