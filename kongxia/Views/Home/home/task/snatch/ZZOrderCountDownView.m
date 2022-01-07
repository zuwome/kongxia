//
//  ZZOrderCountDownView.m
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZOrderCountDownView.h"

@interface ZZOrderCountDownView ()

@property (nonatomic, assign) CGFloat width;

@end

@implementation ZZOrderCountDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _width = [ZZUtils widthForCellWithText:@"55" fontSize:12] + 4;
        
        self.minuteLabel.text = @"00";
        self.secondLabel.text = @"00";
    }
    
    return self;
}

- (void)setTime:(long)time
{
    _time = time;
    if (time <= 0) {
        self.minuteLabel.text = @"--";
        self.secondLabel.text = @"--";
    } else {
        NSInteger during = time/1000;
        if (time >= 0) {
            self.minuteLabel.text = [NSString stringWithFormat:@"0%ld",during/60];
            NSInteger second = during % 60;
            if (second > 9) {
                self.secondLabel.text = [NSString stringWithFormat:@"%ld",second];
            } else {
                self.secondLabel.text = [NSString stringWithFormat:@"0%ld",second];
            }
        }
    }
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    self.minuteLabel.textColor = color;
    self.secondLabel.textColor = color;
}

#pragma mark - lazyload

- (UILabel *)minuteLabel
{
    if (!_minuteLabel) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = HEXCOLOR(0x3F3A3A);
        bgView.layer.cornerRadius = 3;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(self);
        }];
        
        _minuteLabel = [[UILabel alloc] init];
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
        _minuteLabel.textColor = [UIColor whiteColor];
        _minuteLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:_minuteLabel];
        
        [_minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left);
            make.right.mas_equalTo(bgView.mas_right);
            make.width.mas_equalTo(_width);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
    }
    return _minuteLabel;
}

- (UILabel *)secondLabel
{
    if (!_secondLabel) {
        UILabel *centenLabel = [[UILabel alloc] init];
        centenLabel.textColor = HEXCOLOR(0x3F3A3A);
        centenLabel.font = [UIFont systemFontOfSize:13];
        centenLabel.text = @":";
        [self addSubview:centenLabel];
        
        [centenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_minuteLabel.superview.mas_right).offset(3);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = HEXCOLOR(0x3F3A3A);
        bgView.layer.cornerRadius = 3;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(centenLabel.mas_right).offset(3);
            make.top.bottom.right.mas_equalTo(self);
        }];
        
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.textColor = [UIColor whiteColor];
        _secondLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:_secondLabel];
        
        [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left);
            make.right.mas_equalTo(bgView.mas_right);
            make.width.mas_equalTo(_width);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
    }
    return _secondLabel;
}

@end
