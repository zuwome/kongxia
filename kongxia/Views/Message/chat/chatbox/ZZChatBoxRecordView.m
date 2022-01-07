//
//  ZZChatBoxRecordView.m
//  zuwome
//
//  Created by angBiu on 2017/7/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZChatBoxRecordView.h"

@interface ZZChatBoxRecordView ()

@property (nonatomic, strong) UIView *recordView;
@property (nonatomic, strong) UIImageView *recordImgView;
@property (nonatomic, strong) UIView *progressLineView;
@property (nonatomic, assign) BOOL outBounds;//超出范围

@end

@implementation ZZChatBoxRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF8F8F8);
        
        self.recordView.hidden = NO;
        self.recordImgView.hidden = NO;
        [self addSubview:self.progressLineView];
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    NSLog(@"%.2f",progress);
    _progress = progress;
    if (progress == 0) {
        _progressLineView.width = 0.1;
    } else {
        _progressLineView.width = SCREEN_WIDTH*progress;
    }
}

- (void)beginAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.8]; // 结束时的倍率
    animation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.2];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.5;
    group.removedOnCompletion = NO;
    group.repeatCount = HUGE_VALF;
    group.animations = @[animation,opacityAnimation];
    
    [self.recordView.layer addAnimation:group forKey:@"group"];
}

- (void)endAnimation
{
    _startRecord = NO;
    [self.recordView.layer removeAllAnimations];
}

#pragma mark -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([ZZUtils isBan]) {
        return;
    }
    
    CGPoint location = [[[event allTouches] anyObject] locationInView:self];
    if (CGRectContainsPoint(self.recordView.frame, location)) {
        //是否是当前的点击区域
        self.recordView.userInteractionEnabled =  NO;
        NSLog(@"PY_录音_当前的区域不可以交互");
        [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
            self.recordView.userInteractionEnabled =  YES;
            NSLog(@"PY_录音_当前的区域不可以交互");
        }];
        _startRecord = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(recordViewDidBeginRecord)]) {
            [_delegate recordViewDidBeginRecord];
        }
        [self beginAnimation];
    } else {
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[[event allTouches] anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.frame, location)) {
        NSLog(@"out");
        _outBounds = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(recordView:insideView:)]) {
            [_delegate recordView:self insideView:NO];
        }
    } else {
        NSLog(@"in");
        _outBounds = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(recordView:insideView:)]) {
            [_delegate recordView:self insideView:YES];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endRecord];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endRecord];
}

- (void)endRecord
{
    if (_startRecord) {
        [self endAnimation];
        if (_outBounds) {
            if (_delegate && [_delegate respondsToSelector:@selector(recordViewDidCancelRecord)]) {
                [_delegate recordViewDidCancelRecord];
            }
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(recordViewDidEndRecord)]) {
                [_delegate recordViewDidEndRecord];
            }
        }
    }
}

#pragma mark - lazyload

- (UIView *)recordView
{
    if (!_recordView) {
        _recordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
        _recordView.backgroundColor = HEXACOLOR(0xF4CB07, 0.2);
        _recordView.layer.cornerRadius = 41;
        _recordView.clipsToBounds = YES;
        [self addSubview:_recordView];
        
        _recordView.center = CGPointMake(SCREEN_WIDTH/2.0, self.height/2.0);
    }
    return _recordView;
}

- (UIImageView *)recordImgView
{
    if (!_recordImgView) {
        _recordImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 61, 61)];
        _recordImgView.image = [UIImage imageNamed:@"icon_chat_box_record"];
        _recordImgView.userInteractionEnabled = NO;
        [self addSubview:_recordImgView];
        
        _recordImgView.center = _recordView.center;
    }
    return _recordImgView;
}

- (UIView *)progressLineView
{
    if (!_progressLineView) {
        _progressLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 3)];
        _progressLineView.backgroundColor = kYellowColor;
    }
    return _progressLineView;
}

@end
