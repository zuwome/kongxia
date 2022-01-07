//
//  ZZFindAttentGuideView.m
//  zuwome
//
//  Created by angBiu on 2017/5/22.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZFindAttentGuideView.h"

@interface ZZFindAttentGuideView ()

@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIImageView *infoImgView;
@property (nonatomic, strong) UIImageView *doneImgView;

@end

@implementation ZZFindAttentGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self createViews];
        
        self.arrowImgView.image = [UIImage imageNamed:@"icon_find_guide_arrow"];
        self.infoImgView.image = [UIImage imageNamed:@"icon_find_guide_info"];
        self.doneImgView.image = [UIImage imageNamed:@"icon_rent_guide_done"];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    return self;
}

- (void)hideView
{
    [self removeFromSuperview];
    [ZZKeyValueStore saveValue:@"findAttentGuide" key:[ZZStoreKey sharedInstance].findAttentGuide];
}

- (void)createViews
{
    CGRect featureItemFrame = CGRectMake((SCREEN_WIDTH / 4.0)*3 - 32, 27, 64, 32);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) cornerRadius:0];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    shapeLayer.fillColor = [UIColor blackColor].CGColor;
    shapeLayer.opacity = 0.8;
    [self.layer addSublayer:shapeLayer];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:shapeLayer.path];
    [bezierPath appendPath:[UIBezierPath bezierPathWithRoundedRect:featureItemFrame cornerRadius:3]];
    shapeLayer.path = bezierPath.CGPath;
}

- (UIImageView *)arrowImgView
{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        [self addSubview:_arrowImgView];
        
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-SCREEN_WIDTH/4.0);
            make.top.mas_equalTo(self.mas_top).offset(83);
            make.size.mas_equalTo(CGSizeMake(50, 62));
        }];
    }
    return _arrowImgView;
}

- (UIImageView *)infoImgView
{
    if (!_infoImgView) {
        _infoImgView = [[UIImageView alloc] init];
        [self addSubview:_infoImgView];
        
        [_infoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_arrowImgView.mas_left);
            make.top.mas_equalTo(_arrowImgView.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(190, 20));
        }];
    }
    return _infoImgView;
}

- (UIImageView *)doneImgView
{
    if (!_doneImgView) {
        _doneImgView = [[UIImageView alloc] init];
        [self addSubview:_doneImgView];
        
        [_doneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_infoImgView.mas_bottom).offset(75);
            make.size.mas_equalTo(CGSizeMake(84, 44));
        }];
    }
    return _doneImgView;
}

@end
