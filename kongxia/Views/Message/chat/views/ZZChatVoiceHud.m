//
//  ZZChatVoiceHud.m
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatVoiceHud.h"

#import <RongIMKit/RongIMKit.h>
#import "ZZChatConst.h"

@implementation ZZChatVoiceHud
{
    NSArray *_images;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.bgView];
        self.bgView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT - 20 - self.bgView.height)/3 + self.bgView.height/2);
        
        [self.bgView addSubview:self.imgView];
        [self.bgView addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
            make.top.mas_equalTo(self.imgView.mas_bottom);
            make.bottom.mas_equalTo(self.bgView.mas_bottom);
        }];
        
        self.imgView.animationDuration    = 0.5;
        self.imgView.animationRepeatCount = -1;
        _images = @[
                    IMAGENAME(@"voice_1"),
                    IMAGENAME(@"voice_2"),
                    IMAGENAME(@"voice_3"),
                    IMAGENAME(@"voice_4"),
                    IMAGENAME(@"voice_5"),
                    IMAGENAME(@"voice_6"),
                    IMAGENAME(@"voice_7"),
                    IMAGENAME(@"voice_8")
                    ];
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    self.titleLabel.text = @"手指上滑，取消发送";
    _progress = MIN(MAX(progress, 0.f),1.f);
    [self updateImages];
}

- (void)updateImages
{
    if (_progress == 0) {
        self.imgView.animationImages = nil;
        [self.imgView stopAnimating];
        return;
    }
    if (_progress >= 0.8 ) {
        self.imgView.animationImages = @[_images[6],_images[7],_images[6]];
    } else if (_progress >= 0.4) {
        self.imgView.animationImages = @[_images[3],_images[4],_images[5],_images[4],_images[3]];
    } else {
        self.imgView.animationImages = @[_images[0],_images[1],_images[2],_images[1]];
    }
    [self.imgView startAnimating];
}

- (void)setShortImage
{
    self.imgView.image = IMAGENAME(@"audio_press_short@2x");
    self.titleLabel.text = @"录音时间短";
}

- (void)resetImage
{
    self.imgView.image = IMAGENAME(@"voice_1");
    self.titleLabel.text = @"手指上滑，取消发送";
}

- (void)setCancelImage
{
    self.imgView.image = IMAGENAME(@"return");
    self.titleLabel.text = @"松开手指，取消发送";
}

#pragma mark - Lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _bgView.backgroundColor = kBlackTextColor;
        _bgView.alpha = 0.7;
        [self addSubview:_bgView];
    }
    
    return _bgView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 18, 90, 90)];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _imgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"手指上滑，取消发送";
    }
    
    return _titleLabel;
}

@end
