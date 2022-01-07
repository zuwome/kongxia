//
//  ZZChatBurnVersionView.m
//  zuwome
//
//  Created by angBiu on 2017/8/23.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZChatBurnVersionView.h"

@implementation ZZChatBurnVersionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.51);
        
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 3;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(310*scale);
        }];
        
        UIImageView *topImgView = [[UIImageView alloc] init];
        topImgView.image = [UIImage imageNamed:@"icon_chat_burn_version"];
        [bgView addSubview:topImgView];
        
        [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(bgView);
            make.height.mas_equalTo(118.5*scale);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        [bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topImgView.mas_bottom).offset(18);
            make.left.mas_equalTo(bgView.mas_left).offset(26);
            make.right.mas_equalTo(bgView.mas_right).offset(-26);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
//        [btn setTitle:@"知道了" forState:UIControlStateNormal];
//        [btn setTitleColor:kBlackColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.backgroundColor = kYellowColor;
        btn.layer.cornerRadius = 3;
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(17);
            make.right.mas_equalTo(bgView.mas_right).offset(-17);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(16);
            make.height.mas_equalTo(@0);
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-13);
        }];
    }
    
    return self;
}

- (void)setInfoString:(NSString *)infoString
{
    _infoString = infoString;
    
    _titleLabel.attributedText = [ZZUtils setLineSpace:infoString space:5 fontSize:15 color:kBlackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)show:(BOOL)animated {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    window.alpha = 0.5;
    [window addSubview:self];
    animated ?
    [self shakeToShow:self] :
    nil;
}

- (void)shakeToShow:(UIView *)aView{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)btnClick
{
    [self removeFromSuperview];
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end
