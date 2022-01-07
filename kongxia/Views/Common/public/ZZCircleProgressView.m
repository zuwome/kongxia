//
//  ZZCircleProgressView.m
//  zuwome
//
//  Created by angBiu on 2017/5/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZCircleProgressView.h"

@interface ZZCircleProgressView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) CAShapeLayer *animationLayer;
@property (nonatomic, strong) CALayer *successLayer;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat width;

@end

@implementation ZZCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _width = 60;
        [self.bgView.layer addSublayer:self.animationLayer];
        self.link.paused = YES;
    }
    
    return self;
}

#pragma mark -

- (void)start
{
    self.hidden = NO;
    self.link.paused = NO;
}

- (void)success:(successBlock)success
{
    _animationLayer.path = nil;
    self.link.paused = YES;
    [self circleAnimation];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.8 * 0.5f * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [self checkAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hidden = YES;
            if (success) {
                success();
            }
        });
    });
}

- (void)failure
{
    self.link.paused = YES;
    self.hidden = YES;
}

#pragma mark - 

- (void)updateAnimation
{
    _progress += [self speed];
    if (_progress >= 1) {
        _progress = 0;
    }
    _startAngle = -M_PI_2;
    _endAngle = -M_PI_2 +_progress * M_PI * 2;
    if (_endAngle > M_PI) {
        CGFloat progress1 = 1 - (1 - _progress)/0.25;
        _startAngle = -M_PI_2 + progress1 * M_PI * 2;
    }
    CGFloat radius = _animationLayer.bounds.size.width/2.0f - 4/2.0f;
    CGFloat centerX = _animationLayer.bounds.size.width/2.0f;
    CGFloat centerY = _animationLayer.bounds.size.height/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:YES];
    path.lineCapStyle = kCGLineCapRound;
    
    _animationLayer.path = path.CGPath;
}

-(CGFloat)speed
{
    if (_endAngle > M_PI) {
        return 0.3/60.0f;
    }
    return 2/60.0f;
}

//画圆
-(void)circleAnimation{
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = CGRectMake(0, 0, _width, _width);
    [self.successLayer addSublayer:circleLayer];
    circleLayer.fillColor =  [[UIColor clearColor] CGColor];
    circleLayer.strokeColor  = kYellowColor.CGColor;
    circleLayer.lineWidth = 4;
    circleLayer.lineCap = kCALineCapRound;
    
    CGFloat lineWidth = 5.0f;
    CGFloat radius = self.successLayer.bounds.size.width/2.0f - lineWidth/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circleLayer.position radius:radius startAngle:-M_PI/2 endAngle:M_PI*3/2 clockwise:true];
    circleLayer.path = path.CGPath;
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 0.5f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
//    checkAnimation.delegate = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [circleLayer addAnimation:checkAnimation forKey:nil];
}

//对号
-(void)checkAnimation
{
    CGFloat a = _width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*2.7/10,a*5.4/10)];
    [path addLineToPoint:CGPointMake(a*4.5/10,a*7/10)];
    [path addLineToPoint:CGPointMake(a*7.8/10,a*3.8/10)];
    
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    checkLayer.path = path.CGPath;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = kYellowColor.CGColor;
    checkLayer.lineWidth = 4;
    checkLayer.lineCap = kCALineCapRound;
    checkLayer.lineJoin = kCALineJoinRound;
    [self.successLayer addSublayer:checkLayer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 0.2f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
//    checkAnimation.delegate = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [checkLayer addAnimation:checkAnimation forKey:nil];
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(_width, _width));
        }];
    }
    return _bgView;
}

- (CAShapeLayer *)animationLayer
{
    if (!_animationLayer) {
        _animationLayer = [CAShapeLayer layer];
        _animationLayer.bounds = CGRectMake(0, 0, _width, _width);
        _animationLayer.position = CGPointMake(_width/2.0f, _width/2.0);
        _animationLayer.fillColor = [UIColor clearColor].CGColor;
        _animationLayer.strokeColor = kYellowColor.CGColor;
        _animationLayer.lineWidth = 4;
        _animationLayer.lineCap = kCALineCapRound;
    }
    return _animationLayer;
}

- (CALayer *)successLayer
{
    if (!_successLayer) {
        _successLayer = [CALayer layer];
        _successLayer.bounds = CGRectMake(0, 0, _width, _width);
        _successLayer.position = CGPointMake(_width/2, _width/2);
        [self.bgView.layer addSublayer:_successLayer];
    }
    return _successLayer;
}

- (CADisplayLink *)link
{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAnimation)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _link;
}

@end
