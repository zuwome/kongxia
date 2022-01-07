//
//  ZZChatStatusCountDownView.m
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatStatusCountDownView.h"

#import "ZZDateHelper.h"

#import "ZZGradientView.h"

@implementation ZZChatStatusCountDownView
{
    UILabel             *_hourLabel;
    UILabel             *_minuteLabel;
    UILabel             *_secondLabel;
    
    NSTimer             *_timer;
    NSInteger           _timeCount;
    
    OrderDetailType     _detailType;
    ZZGradientView      *_gradientView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.clipsToBounds = YES;
        
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_remindbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [self addSubview:_bgImgView];
        
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.textColor = kBlackTextColor;
        _hourLabel.font = [UIFont systemFontOfSize:10];
        _hourLabel.layer.borderColor = HEXCOLOR(0x555555).CGColor;
        _hourLabel.layer.borderWidth = 0.5;
        [self addSubview:_hourLabel];
        
        [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(4);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(2);
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-4);
        }];
        
        _minuteLabel = [[UILabel alloc] init];
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
        _minuteLabel.textColor = kBlackTextColor;
        _minuteLabel.font = [UIFont systemFontOfSize:10];
        _minuteLabel.layer.borderColor = HEXCOLOR(0x555555).CGColor;
        _minuteLabel.layer.borderWidth = 0.5;
        [self addSubview:_minuteLabel];
        
        [_minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_hourLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.textColor = kBlackTextColor;
        _secondLabel.font = [UIFont systemFontOfSize:10];
        _secondLabel.layer.borderColor = kBlackTextColor.CGColor;
        _secondLabel.layer.borderWidth = 0.5;
        [self addSubview:_secondLabel];
        
        [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-4);
            make.top.mas_equalTo(_hourLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UILabel *firColonLabel = [[UILabel alloc] init];
        firColonLabel.textAlignment = NSTextAlignmentCenter;
        firColonLabel.textColor = kBlackTextColor;
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
        secColonLabel.textColor = kBlackTextColor;
        secColonLabel.font = [UIFont systemFontOfSize:10];
        secColonLabel.text = @":";
        [self addSubview:secColonLabel];
        
        [secColonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_hourLabel.mas_centerY);
            make.left.mas_equalTo(_minuteLabel.mas_right);
            make.right.mas_equalTo(_secondLabel.mas_left);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        recognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:recognizer];
        
        _gradientView = [[ZZGradientView alloc] initWithFrame:CGRectMake(0, -30, 82, 39+60)];
        [self addSubview:_gradientView];
        [_gradientView showTime:1.5];
    }
    
    return self;
}

- (void)setData:(ZZOrder *)order type:(OrderDetailType)type
{
    _detailType = type;
    if (type == OrderDetailTypePending) {
        _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_remindbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        _titleLabel.text = order.notify_btn_text;
        _gradientView.hidden = YES;
    } else {
        _titleLabel.text = @"去付款";
        _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_allow"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        _gradientView.hidden = NO;
    }
    
    _timeCount = order.notify_count_down;
    [self setTimeinterval:_timeCount];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (order.notify_count_down) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeat) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)repeat
{
    _timeCount--;
    [self setTimeinterval:_timeCount];
    if (_timeCount == 0) {
        if (_timeOut) {
            _timeOut();
        }
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setTimeinterval:(NSTimeInterval)interval
{
    NSMutableArray *array = [[ZZDateHelper shareInstance] getCountDownStringArrayWithInterval:interval];
    
    _hourLabel.text = array[0];
    _minuteLabel.text = array[1];
    _secondLabel.text = array[2];
}

- (void)tapSelf
{
    if (_detailType == OrderDetailTypePaying) {
        if (_touchPay) {
            _touchPay();
        }
    }
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

@end
