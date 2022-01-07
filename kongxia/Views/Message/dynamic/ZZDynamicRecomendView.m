//
//  ZZDynamicRecomendView.m
//  zuwome
//
//  Created by angBiu on 2017/2/20.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZDynamicRecomendView.h"

@interface ZZDynamicRecomendView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *shineImgView;

@end

@implementation ZZDynamicRecomendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon_dynamic_recommend"];
        _imgView.clipsToBounds = YES;
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(46.5, 26.5));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = HEXCOLOR(0x555555);
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.text = @"系统推荐";
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_imgView.mas_bottom).offset(3);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }
    
    return self;
}

- (void)viewAnimation
{
//    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
//    positionAnimation.duration = 0.5;
//    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    //配置起始位置（fromeVaue）和终止位置（toValue）
//    positionAnimation.fromValue = @(-_shineImgView.width);
//    positionAnimation.toValue = @(46.5);
//    positionAnimation.repeatCount = 3;
//    positionAnimation.removedOnCompletion = NO;
//    [self.shineImgView.layer addAnimation:positionAnimation forKey:@"position"];
}

- (UIImageView *)shineImgView
{
    if (!_shineImgView) {
        CGFloat scale = 138/200.0;
        CGFloat width = 26.5/scale;
        _shineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-width, 0, 26.5/scale, 26.5)];
        _shineImgView.image = [UIImage imageNamed:@"icon_white_shine"];
        [_imgView addSubview:_shineImgView];
    }
    return _shineImgView;
}

@end
