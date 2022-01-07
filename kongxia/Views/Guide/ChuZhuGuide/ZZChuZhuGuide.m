//
//  ZZChuZhuGuide.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChuZhuGuide.h"
@interface ZZChuZhuGuide()
//提示框
@property (strong, nonatomic) UIView *alertView;
//知道了
@property (strong, nonatomic) UIButton *knowButton;

/**
 出租的一级标题
 */
@property (strong, nonatomic) UILabel *chuZuTitleLab;

/**
出租的子标题
 */
@property (strong, nonatomic) UILabel *chuZuSubTitleLab;

/**
 左侧的图片
 */
@property (strong, nonatomic) UIImageView *chuZhuImageView;

/**
 竖着的线
 */
@property (strong, nonatomic) UIView *lineView;


/**
 小的view
 */
@property (strong, nonatomic) UIButton *alerSmallView;

/**
 去申请的小的image
 */
@property (strong, nonatomic) UIImageView *alerSmallImageView;

/**
 去申请
 */
@property (strong,nonatomic) UILabel *goToApplyLab;
@property(nonatomic,copy)void(^goToApply)(void);
@end
@implementation ZZChuZhuGuide

- (instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.chuZhuImageView];
        [self.alertView addSubview:self.chuZuTitleLab];
        [self.alertView addSubview:self.chuZuSubTitleLab];
        [self.alertView addSubview:self.knowButton];
        [self addSubview:self.alerSmallView];
        [self addSubview:self.lineView];
        [self.alerSmallView addSubview:self.goToApplyLab];
        [self.alerSmallView addSubview:self.alerSmallImageView];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        [self addGestureRecognizer:tap1];
        
    }
    return self;
}


/**
 显示闪聊引导页
 
 @param view 去申请的view覆盖的cell
 */
+ (void)ShowChuZhuGuideWithShowView:(UIView *)view goToApply:(void(^)(void))goToApplyCallBlack {
     NSLog(@"PY_当前覆盖的view%@",NSStringFromCGRect(view.frame));
    [[[ZZChuZhuGuide alloc]init] showView:view goToApply:goToApplyCallBlack];
}

- (void)showView:(UIView *)showView goToApply:(void(^)(void))goToApplyCallBlack{
    if (goToApplyCallBlack) {
       self.goToApply = goToApplyCallBlack;
    }
    self.alerSmallView.center = CGPointMake(self.alerSmallView.center.x, showView.center.y+NAVIGATIONBAR_HEIGHT);
    
    self.lineView.frame = CGRectMake(CGRectGetMidX(self.alerSmallView.frame)-0.5, CGRectGetMaxY(self.alertView.frame), 1, CGRectGetMinY(self.alerSmallView.frame)-CGRectGetMaxY(self.alertView.frame));

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
    } completion:nil];
}
#pragma mark - 约束
- (void)layoutSubviews {
    
    [self.chuZhuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self.alertView.mas_centerY);
        make.width.height.mas_equalTo(AdaptedWidth(75));
    }];
    
    [self.chuZuTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {        make.centerY.mas_equalTo(self.chuZhuImageView.mas_centerY).multipliedBy(0.5); make.left.mas_equalTo(self.chuZhuImageView.mas_right).with.offset(18);
        
        make.right.offset(-18);
    }];
    
    [self.chuZuSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-18);
     make.centerY.mas_equalTo(self.chuZhuImageView.mas_centerY).multipliedBy(1.2); make.left.mas_equalTo(self.chuZhuImageView.mas_right).with.offset(18);

    }];
    [self.goToApplyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.alerSmallImageView.mas_left).offset(-AdaptedWidth(4.5));
        make.centerY.mas_equalTo(self.alerSmallView.mas_centerY);
    }];
    [self.knowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-AdaptedWidth(9));
        make.bottom.offset(-AdaptedWidth(5));

    }];
    [self.alerSmallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-AdaptedWidth(5));
        make.centerY.mas_equalTo(self.alerSmallView.mas_centerY);
    }];
    
}

#pragma mark - 懒加载

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT*0.27, SCREEN_WIDTH-30, 124)];
        _alertView.backgroundColor = RGBCOLOR(255, 255, 255);
        _alertView.clipsToBounds = YES;
        _alertView.layer.cornerRadius = 4.5;
    }
    return _alertView;
}

- (UIImageView *)chuZhuImageView {
    
    if (!_chuZhuImageView) {
        _chuZhuImageView = [[UIImageView alloc]init];
        _chuZhuImageView.image = [UIImage imageNamed:@"chuzuGuideImage"];
    }
    return _chuZhuImageView;
}

-(UILabel *)chuZuTitleLab {
    if (!_chuZuTitleLab) {
        _chuZuTitleLab = [[UILabel alloc]init];
        _chuZuTitleLab.text = @"成为达人 分享时间";
        UIFont *fontFirst = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
        if (fontFirst != nil) {
            _chuZuTitleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
        }
        else{
            _chuZuTitleLab.font =  [UIFont systemFontOfSize:17];
        }
        _chuZuTitleLab.textColor = [UIColor blackColor];
        _chuZuTitleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _chuZuTitleLab;
}

- (UILabel *)chuZuSubTitleLab {
    if (!_chuZuSubTitleLab) {
        _chuZuSubTitleLab = [[UILabel alloc]init];
        _chuZuSubTitleLab.textColor = RGBCOLOR(155, 155, 155);
        UIFont *fontFirst = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
        if (fontFirst != nil) {
            _chuZuSubTitleLab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        }
        else{
            _chuZuSubTitleLab.font =  [UIFont systemFontOfSize:14];
        }
        _chuZuSubTitleLab.textAlignment = NSTextAlignmentLeft;
        _chuZuSubTitleLab.numberOfLines = 2;
        _chuZuSubTitleLab.text = [NSString stringWithFormat:@"Hi  %@,\n%@",[ZZUserHelper shareInstance].loginer.nickname,@"解锁多种赚钱新方式"];
        
    }
    return _chuZuSubTitleLab;
}

- (UIButton *)knowButton {
    if (!_knowButton) {
        _knowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_knowButton setTitle:@"知道了" forState:UIControlStateNormal];
        [_knowButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        _knowButton.titleLabel.font  = [UIFont systemFontOfSize:15];
        [_knowButton setTitleColor:RGBCOLOR(74, 144, 226) forState:UIControlStateNormal];
    }
    return _knowButton;
}

-(UIButton *)alerSmallView {
    if (!_alerSmallView) {
        _alerSmallView = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.78, AdaptedHeight(385), SCREEN_WIDTH*0.22-14, 32)];
        _alerSmallView.backgroundColor = RGBCOLOR(255, 255, 255);
        _alerSmallView.clipsToBounds = YES;
        _alerSmallView.layer.cornerRadius = 4;
        [_alerSmallView addTarget:self action:@selector(goToApplyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alerSmallView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.alerSmallView.frame)-0.5, CGRectGetMaxY(self.alertView.frame), 1, CGRectGetMinY(self.alerSmallView.frame)-CGRectGetMaxY(self.alertView.frame))];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (UIImageView *)alerSmallImageView {
    if (!_alerSmallImageView ) {
        _alerSmallImageView = [[UIImageView alloc]init];
        _alerSmallImageView.image = [UIImage imageNamed:@"chuZhu_invalidName"];
    }
    return _alerSmallImageView;
}

- (UILabel *)goToApplyLab {
    if (!_goToApplyLab) {
        _goToApplyLab = [[UILabel alloc]init];
        _goToApplyLab.text = @"去申请";
        _goToApplyLab.font = [UIFont systemFontOfSize:12];
        _goToApplyLab.textColor = RGBCOLOR(244, 203, 7 );
        _goToApplyLab.textAlignment = NSTextAlignmentCenter;
    }
    return _goToApplyLab;
}
#pragma mark - 点击消失

- (void)click {
    [self dissMiss];
}

- (void)goToApplyClick {
    [self dissMiss];
    if (self.goToApply) {
        self.goToApply();
    }
}

/**
 消失
 */
- (void)dissMiss {
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
@end
