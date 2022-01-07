//
//  ZZFindRecordProgressView.m
//  zuwome
//
//  Created by angBiu on 2017/5/27.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRecordProgressView.h"

@interface ZZRecordProgressView ()

@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UIView *redLineView;
@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, strong) UIView *minLineView;//最小指示块
@end

@implementation ZZRecordProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _maxDuration = 30;
        
        _grayLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _grayLineView.backgroundColor = HEXCOLOR(0x9A9A9A);
        [self addSubview:_grayLineView];
        
        _firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _firstLineView.backgroundColor = kYellowColor;
        _firstLineView.tag = 100;
        [self addSubview:_firstLineView];
        _firstLineView.width = 0;
        _lastView = _firstLineView;
        
        _redLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _redLineView.backgroundColor = kRedColor;
        [self addSubview:_redLineView];
        _redLineView.width = 0;
        [self isHiddenProgress:YES];
        [self addSubview:self.minLineView];
    }
    
    return self;
}
- (UIView *)minLineView {
    if (!_minLineView) {
        _minLineView = [[UIView alloc]init];
        _minLineView.frame = CGRectMake(self.width*(6/_maxDuration), 0, 3, 4);
        _minLineView.backgroundColor = [UIColor whiteColor];
    }
    return _minLineView;
}

- (void)setLastSumDuration:(CGFloat)lastSumDuration
{
    if (lastSumDuration > _lastSumDuration) {
        CGFloat duration = lastSumDuration - _lastSumDuration;
        [self.timeArray addObject:@(duration)];
        [self setCurrentDuration:duration];
        _lastView.width = _lastView.width - 1;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
        view.backgroundColor = kYellowColor;
        view.tag = _lastView.tag+1;
        [self addSubview:view];
        [self bringSubviewToFront:_redLineView];
        
        view.left = _lastView.left + _lastView.width + 1;
        _lastView = view;
    }
    _lastSumDuration = lastSumDuration;
}


/**
 隐藏

 @param isHiddenProgress YES 隐藏  NO  不隐藏
 */
- (void)isHiddenProgress:(BOOL)isHiddenProgress {
    self.firstLineView.hidden = isHiddenProgress;
    self.redLineView.hidden = isHiddenProgress;
    self.grayLineView.hidden = isHiddenProgress;
    self.minLineView.hidden = isHiddenProgress;
}
- (void)setCurrentDuration:(CGFloat)currentDuration
{
 
    _currentDuration = currentDuration;
    _lastView.width = self.width*(currentDuration/_maxDuration);
    CGFloat sum = currentDuration + _lastSumDuration;
    _redLineView.width = 0;
    _grayLineView.left = self.width*(sum/_maxDuration);
    _grayLineView.width = SCREEN_WIDTH - _grayLineView.left;
    if (sum >= _minDuration) {
        [self isVideoDurationEnough:YES];
        self.minLineView.hidden =YES;
    }else{
        [self bringSubviewToFront:self.minLineView];
    }
    if (sum >= _maxDuration) {
        if (_delegate && [_delegate respondsToSelector:@selector(videoReachMaxDuration)]) {
            [_delegate videoReachMaxDuration];
        }
    }
}

- (void)willRemoveLastVideo
{
    [self bringSubviewToFront:self.minLineView];
    if (self.timeArray.count == 1) {
        _redLineView.frame = _firstLineView.frame;
    } else {
        UIView *view = [self viewWithTag:_lastView.tag - 1];
        _redLineView.frame = view.frame;
        if (view.frame.origin.x<(self.width*(6/_maxDuration))) {
            self.minLineView.hidden = NO;
        }
    }
}

- (void)removeLastVideo
{
    [self bringSubviewToFront:self.minLineView];

    if (self.timeArray.count == 1) {
        [self removeAllVideo];
    } else {
        UIView *view = [self viewWithTag:_lastView.tag - 1];
        view.width = 0;
        [_lastView removeFromSuperview];
        _lastView = view;
        _redLineView.width = 0;
        [self.timeArray removeLastObject];
        CGFloat sum = 0;
        for (NSNumber *number in self.timeArray) {
            sum = sum + [number floatValue];
        }
        self.lastSumDuration = sum;
        _grayLineView.left = _lastView.left;
        _grayLineView.width = SCREEN_WIDTH - _grayLineView.left;
        if (sum < _minDuration) {
            [self isVideoDurationEnough:NO];
        }
    }
}

- (void)removeAllVideo
{
    [self removeAllSubviews];
    [self addSubview:_grayLineView];
    [self addSubview:_firstLineView];
    [self addSubview:_redLineView];
    [self addSubview:self.minLineView];
    [self.timeArray removeAllObjects];
    _redLineView.width = 0;
    _firstLineView.width = 0;
    _grayLineView.left = 0;
    _grayLineView.width = SCREEN_WIDTH - _grayLineView.left;
    _lastSumDuration = 0;
    _lastView = _firstLineView;
    [self isVideoDurationEnough:NO];
}

- (void)isVideoDurationEnough:(BOOL)enough {
    if (_delegate && [_delegate respondsToSelector:@selector(progressView:videoDurationLongEnough:)]) {
        [_delegate progressView:self videoDurationLongEnough:enough];
    }
}

#pragma mark - lazyload

- (NSMutableArray *)timeArray
{
    if (!_timeArray) {
        _timeArray = [NSMutableArray array];
    }
    return _timeArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
