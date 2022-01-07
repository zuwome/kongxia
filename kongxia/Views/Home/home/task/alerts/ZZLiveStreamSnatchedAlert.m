//
//  ZZLiveStreamSnatchedView.m
//  zuwome
//
//  Created by angBiu on 2017/7/26.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamSnatchedAlert.h"

@interface ZZLiveStreamSnatchedAlert ()

@property (nonatomic, strong) UIImageView *bgImgView;

@end

@implementation ZZLiveStreamSnatchedAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.85);
        
        self.bgImgView.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)sureBtnClick
{
    if (_touchSure) {
        _touchSure(_aDict);
    }
}

#pragma mark - lazyload

- (UIImageView *)bgImgView
{
    if (!_bgImgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        if (scale>1) {
            scale = 1;
        }
        
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.layer.cornerRadius = 4;
        _bgImgView.image = [UIImage imageNamed:@"icon_livestream_full_bg"];
        [self addSubview:_bgImgView];
        
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(315*scale);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_livestream_full"];
        [_bgImgView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgImgView.mas_centerX);
            make.top.mas_equalTo(_bgImgView.mas_top).offset(25);
            make.size.mas_equalTo(CGSizeMake(258.5*scale, 149*scale));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"已经有达人抢了您的1V1在线视频任务，快来选择达人吧";
        [_bgImgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgImgView.mas_left).offset(20);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-20);
            make.top.mas_equalTo(imgView.mas_bottom).offset(8);
        }];
        
        UIButton *sureBtn = [[UIButton alloc] init];
        [sureBtn setTitle:@"立即选取" forState:UIControlStateNormal];
        [sureBtn setTitleColor:HEXCOLOR(0x3f3a3a) forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        sureBtn.layer.cornerRadius = 3;
        sureBtn.backgroundColor = kYellowColor;
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgImgView addSubview:sureBtn];
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(14);
            make.left.mas_equalTo(_bgImgView.mas_left).offset(18);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-18);
            make.bottom.mas_equalTo(_bgImgView.mas_bottom).offset(-15);
            make.height.mas_equalTo(@44);
        }];
    }
    return _bgImgView;
}

@end
