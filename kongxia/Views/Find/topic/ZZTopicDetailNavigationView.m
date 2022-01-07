//
//  ZZTopicNavigationView.m
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTopicDetailNavigationView.h"

@implementation ZZTopicDetailNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.leftImgView.image = [UIImage imageNamed:@"icon_rent_left"];
        self.rightImgView.image = [UIImage imageNamed:@"icon_topic_share"];
        self.titleLabel.text = @"话题详情";
    }
    
    return self;
}

- (void)setPercent:(CGFloat)percent
{
    if (percent < 0.3) {
        self.leftImgView.image = [UIImage imageNamed:@"icon_rent_left"];
        self.rightImgView.image = [UIImage imageNamed:@"icon_link_share_n"];
        self.bgView.alpha = 0;
        self.titleLabel.hidden = YES;
    } else {
        self.leftImgView.image = [UIImage imageNamed:@"back"];
        self.rightImgView.image = [UIImage imageNamed:@"icon_link_share_p"];
        self.bgView.alpha = percent;
        self.titleLabel.hidden = NO;
    }
}

#pragma mark - 

- (void)leftBtnClick
{
    if (_touchLeft) {
        _touchLeft();
    }
}

- (void)rightBtnClick
{
    if (_touchRight) {
        _touchRight();
    }
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        _bgView.alpha = 0;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)leftImgView
{
    if (!_leftImgView) {
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 44));
        }];
        
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.userInteractionEnabled = NO;
        [self addSubview:_leftImgView];
        
        [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(leftBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 16.5));
        }];
    }
    return _leftImgView;
}

- (UIImageView *)rightImgView
{
    if (!_rightImgView) {
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 44));
        }];
        
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.userInteractionEnabled = NO;
        [self addSubview:_rightImgView];
        
        [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(rightBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
    }
    return _rightImgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.hidden = YES;
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(_leftImgView.mas_centerY);
        }];
    }
    return _titleLabel;
}

@end
