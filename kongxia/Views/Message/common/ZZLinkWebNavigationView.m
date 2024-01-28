//
//  ZZLinkWebNavigationView.m
//  zuwome
//
//  Created by angBiu on 2017/3/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLinkWebNavigationView.h"

@interface ZZLinkWebNavigationView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZZLinkWebNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height)];
        bgImgView.image = [UIImage imageNamed:@"icon_rent_topbg"];
        [self addSubview:bgImgView];
        
        [self addSubview:self.bgView];
        
        [self setViewAlphaScale:0];
    }
    
    return self;
}

- (void)setViewAlphaScale:(CGFloat)scale
{
    NSLog(@"%.2f",scale);
    self.bgView.alpha = scale;
    if (scale < 0.05) {
        self.leftImgView.image = [UIImage imageNamed:@"icon_rent_left"];
        self.rightImgView.image = [UIImage imageNamed:@"icon_link_share_n"];
    } else {
        self.leftImgView.image = [UIImage imageNamed:@"back"];
        self.rightImgView.image = [UIImage imageNamed:@"icon_link_share_p"];
    }
}

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

#pragma mark -

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        _bgView.alpha = 0;
        _bgView.clipsToBounds = YES;
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
        [_bgView addSubview:effectview];
    }
    return _bgView;
}

- (UIImageView *)leftImgView
{
    if (!_leftImgView) {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 44)];
        [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.userInteractionEnabled = NO;
        _leftImgView.contentMode = UIViewContentModeLeft;
        [leftBtn addSubview:_leftImgView];
        
        [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftBtn.mas_left).offset(15);
            make.top.bottom.right.mas_equalTo(leftBtn);
        }];
    }
    return _leftImgView;
}

- (UIImageView *)rightImgView
{
    if (!_rightImgView) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44)];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.userInteractionEnabled = NO;
        _rightImgView.contentMode = UIViewContentModeRight;
        [_rightBtn addSubview:_rightImgView];
        
        [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_rightBtn.mas_right).offset(-15);
            make.centerY.mas_equalTo(_rightBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(17, 16.5));
        }];
    }
    return _rightImgView;
}

@end
