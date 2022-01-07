//
//  ZZSignInView.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSignInView.h"
#import "CABasicAnimation+Ext.h"//动画

@interface ZZSignInView()<UIGestureRecognizerDelegate>

/**
 没签到的lab
 */
@property (nonatomic,strong) UILabel *notSinInLab;

/**
 签到的lab
 */
@property (nonatomic,strong) UILabel *sinInLab;

@end
@implementation ZZSignInView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
     
        [self addSubview:self.imageView];
        [self addSubview:self.sinInLab];
        [self addSubview:self.notSinInLab];
        self.layer.cornerRadius = 40;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        tap1.delegate = self;
        [self addGestureRecognizer:tap1];
        
    }
    return self;
}

- (void)flipAnimation   {
    [UIView beginAnimations:@"flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:NO];
    [UIView commitAnimations];
    
    [NSObject asyncWaitingWithTime:0.25 completeBlock:^{
        self.imageView.image = [UIImage imageNamed:@"signIn_integral_selected"];
        self.sinInLab.hidden = NO;
        self.notSinInLab.hidden = YES;
    }];

}

- (void)setModel:(ZZIntegralModel *)model {

        _model = model;
        if (_model.is_sign) {
            //已经签到
            self.sinInLab.hidden = NO;
            self.notSinInLab.hidden = YES;
            self.imageView.image = [UIImage imageNamed:@"signIn_integral_selected"];
        }else{
            //还没有签到
            self.sinInLab.hidden = YES;
            [self updateNotSignInLabStringModel:model];
            self.imageView.image = [UIImage imageNamed:@"signIn_integral_unSelected"];
            self.notSinInLab.hidden = NO;
        }
}
#pragma mark - 签到的点击事件
- (void)click {
    if (!self.model.is_sign) {
        if (self.signInBlock) {
            self.signInBlock();
        }
    }
}

/**
 签到成功后更新数据

 @param model
 */
- (void)updateNotSignInLabStringModel:(ZZIntegralModel *)model  {
   
    NSInteger integer = [self.model.sign_task.day integerValue];
    NSArray *array = self.model.sign_task.score_list;
    NSString *signString = [NSString stringWithFormat:@"签到\n+%@积分",array[integer]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:signString];
    
    //签到
    NSRange signStr = [signString rangeOfString:@"签到"];
        //积分
    NSRange jiFenRange = [signString rangeOfString:@"积分"];

    [attrString addAttribute:NSFontAttributeName
                       value:ADaptedFontSCBoldSize(17)
                       range:NSMakeRange(signStr.location,signStr.length)];

    [attrString addAttribute:NSFontAttributeName
                       value:ADaptedFontSCBoldSize(15)
                       range:NSMakeRange(jiFenRange.location,jiFenRange.length)];

    [attrString addAttribute:NSFontAttributeName
                       value:ADaptedFuturaBoldSize(15)
                       range:NSMakeRange(signStr.location+signStr.length,signString.length-4)];
    self.notSinInLab.attributedText = attrString;
}




#pragma mark - 约束
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.sinInLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.notSinInLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark -  懒加载


- (UILabel *)sinInLab {
    if (!_sinInLab) {
        _sinInLab = [[UILabel alloc]init];
        _sinInLab.font = ADaptedFontMediumSize(17);
        _sinInLab.textColor = RGBCOLOR(99, 84, 41);
        _sinInLab.textAlignment = NSTextAlignmentCenter;
        _sinInLab.text = @"已签到";
        _notSinInLab.hidden = YES;

    }
    return _sinInLab;
}

- (UILabel *)notSinInLab {
    if (!_notSinInLab) {
        _notSinInLab = [[UILabel alloc]init];
        _notSinInLab.textColor = RGBCOLOR(99, 84, 41);
        _notSinInLab.textAlignment = NSTextAlignmentCenter;
        _notSinInLab.numberOfLines = 0;
    }
    return _notSinInLab;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

@end
