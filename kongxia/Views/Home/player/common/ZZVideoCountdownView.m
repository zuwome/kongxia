//
//  ZZVideoCountdownView.m
//  zuwome
//
//  Created by angBiu on 16/9/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZVideoCountdownView.h"

#import "ZZDateHelper.h"

@implementation ZZVideoCountdownView
{
    UILabel             *_hourLabel;
    UILabel             *_minuteLabel;
    UILabel             *_secondLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.image = [UIImage imageNamed:@"icon_video_re_recordbg"];
        bgImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:bgImgView];
        
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(76, 18));
        }];
        
        UIImageView *reImgView = [[UIImageView alloc] init];
        reImgView.image = [UIImage imageNamed:@"icon_video_re_record"];
        reImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:reImgView];
        
        [reImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgImgView.mas_left).offset(3);
            make.centerY.mas_equalTo(bgImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.textColor = kBlackTextColor;
        infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.text = @"重新录制";
        [self addSubview:infoLabel];
        
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bgImgView.mas_centerY);
            make.left.mas_equalTo(reImgView.mas_right);
            make.right.mas_equalTo(bgImgView.mas_right);
        }];
        
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.textColor = [UIColor whiteColor];
        _hourLabel.font = [UIFont systemFontOfSize:10];
        _hourLabel.layer.borderColor = HEXCOLOR(0x555555).CGColor;
        _hourLabel.layer.borderWidth = 0.5;
        [self addSubview:_hourLabel];
        
        [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgImgView.mas_left);
            make.top.mas_equalTo(bgImgView.mas_bottom).offset(3);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];

        _minuteLabel = [[UILabel alloc] init];
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
        _minuteLabel.textColor = [UIColor whiteColor];
        _minuteLabel.font = [UIFont systemFontOfSize:10];
        _minuteLabel.layer.borderColor = HEXCOLOR(0x555555).CGColor;
        _minuteLabel.layer.borderWidth = 0.5;
        [self addSubview:_minuteLabel];
        
        [_minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgImgView.mas_centerX);
            make.top.mas_equalTo(_hourLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.textColor = [UIColor whiteColor];
        _secondLabel.font = [UIFont systemFontOfSize:10];
        _secondLabel.layer.borderColor = HEXCOLOR(0x555555).CGColor;
        _secondLabel.layer.borderWidth = 0.5;
        [self addSubview:_secondLabel];
        
        [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgImgView.mas_right);
            make.top.mas_equalTo(_hourLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];

        UILabel *firColonLabel = [[UILabel alloc] init];
        firColonLabel.textAlignment = NSTextAlignmentCenter;
        firColonLabel.textColor = [UIColor whiteColor];
        firColonLabel.font = [UIFont systemFontOfSize:10];
        firColonLabel.text = @":";
        [self addSubview:firColonLabel];
        
        [firColonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_hourLabel.mas_centerY);
            make.left.mas_equalTo(_hourLabel.mas_right);
            make.right.mas_equalTo(_minuteLabel.mas_left);
        }];
        
        UILabel *secColonLabel = [[UILabel alloc] init];
        secColonLabel.textAlignment = NSTextAlignmentCenter;
        secColonLabel.textColor = [UIColor whiteColor];
        secColonLabel.font = [UIFont systemFontOfSize:10];
        secColonLabel.text = @":";
        [self addSubview:secColonLabel];
        
        [secColonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_hourLabel.mas_centerY);
            make.left.mas_equalTo(_minuteLabel.mas_right);
            make.right.mas_equalTo(_secondLabel.mas_left);
        }];
        
        UIButton *recordBtn = [[UIButton alloc] init];
        [recordBtn addTarget:self action:@selector(recordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:recordBtn];
        
        [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    
    return self;
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    NSMutableArray *array = [[ZZDateHelper shareInstance] getCountDownStringArrayWithInterval:timeInterval];
    
    _hourLabel.text = array[0];
    _minuteLabel.text = array[1];
    _secondLabel.text = array[2];
}

#pragma mark - UIButtonMethod

- (void)recordBtnClick
{
    if (_touchRecord) {
        _touchRecord();
    }
}

@end
