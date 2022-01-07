//
//  ZZliveStreamHeadView.m
//  zuwome
//
//  Created by angBiu on 2017/7/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZliveStreamHeadView.h"

@interface ZZliveStreamHeadView ()

@property (nonatomic, strong) CAShapeLayer *yellowLayer;

@end

@implementation ZZliveStreamHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        
        _headImgView = [[UIImageView alloc] init];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    if (progress<0) {
        _progress = 0;
    } else if (progress > 1) {
        _progress = 1;
    }
    self.yellowLayer.strokeEnd = progress;
}

- (void)drawRect:(CGRect)rect
{
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(2.5, 2.5)];
    [path addLineToPoint:CGPointMake(width - 2.5, 2.5)];
    [path addLineToPoint:CGPointMake(width - 2.5, height - 2.5)];
    [path addLineToPoint:CGPointMake(2.5, height - 2.5)];
    [path closePath];
    [path stroke];
    
    _yellowLayer = [CAShapeLayer layer];
    _yellowLayer.strokeColor = kYellowColor.CGColor;
    _yellowLayer.lineWidth = 5;
    _yellowLayer.fillColor =  [UIColor clearColor].CGColor;
    _yellowLayer.lineCap = kCALineCapSquare;
    _yellowLayer.path = path.CGPath;
    [self.layer addSublayer:_yellowLayer];
}

@end
