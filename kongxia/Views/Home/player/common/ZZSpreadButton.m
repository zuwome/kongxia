//
//  ZZSpreadButton.m
//  zuwome
//
//  Created by angBiu on 2017/5/4.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSpreadButton.h"

#import "ZZSpreadView.h"

@interface ZZSpreadButton ()

@property (nonatomic, strong) ZZSpreadView *spreadView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImage *normalImg;
@property (nonatomic, strong) UIImage *selectedImg;
@property (nonatomic, assign) BOOL isSelected;

@end

@implementation ZZSpreadButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imgView.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)setImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    self.spreadView.hidden = NO;
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageSize);
    }];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        _normalImg = image;
    } else {
        _selectedImg = image;
    }
}

- (void)setSelected:(BOOL)selected
{
    _isSelected = selected;
    if (selected) {
        self.imgView.image = _selectedImg;
    } else {
        self.imgView.image = _normalImg;
    }
}

- (void)animate
{
    if (_isSelected) {
        [self popOutsideWithDuration: 0.5];
        [self.spreadView animate];
    } else {
        [self popInsideWithDuration: 0.5];
    }
}

- (void)popOutsideWithDuration: (NSTimeInterval) duringTime
{
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration: duringTime delay: 0 options: 0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime: 0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          self.imgView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 1 / 3.0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          self.imgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 2 / 3.0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          self.imgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      }];
    } completion: ^(BOOL finished) {
        
    }];
}

- (void)popInsideWithDuration: (NSTimeInterval) duringTime
{
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration: duringTime delay: 0 options: 0 animations: ^{\
        [UIView addKeyframeWithRelativeStartTime: 0
                                relativeDuration: 1 / 2.0
                                      animations: ^{
                                          self.imgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 1 / 2.0
                                relativeDuration: 1 / 2.0
                                      animations: ^{
                                          self.imgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      }];
    } completion: ^(BOOL finished) {
        
    }];
}

#pragma mark - lazyload

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _imgView;
}

- (ZZSpreadView *)spreadView
{
    if (!_spreadView) {
        _spreadView = [[ZZSpreadView alloc] initWithFrame:CGRectMake(0, 0, _imageSize.width, _imageSize.height)];
        _spreadView.userInteractionEnabled = NO;
        [self addSubview:_spreadView];
        CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        _spreadView.center = CGPointMake(size.width/2.0, size.height/2.0);
    }
    return _spreadView;
}

@end
