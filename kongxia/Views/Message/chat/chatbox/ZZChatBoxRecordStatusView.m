//
//  ZZChatBoxRecordStatusView.m
//  zuwome
//
//  Created by angBiu on 2017/7/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZChatBoxRecordStatusView.h"

@interface ZZChatBoxRecordStatusView ()

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ZZChatBoxRecordStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.statusLabel.text = @"上滑取消";
        self.backgroundColor = HEXCOLOR(0xF8F8F8);
        
        [self insideStatus];
    }
    
    return self;
}

- (void)setDuration:(NSInteger)duration
{
    _duration = duration;
    self.timeLabel.text = [NSString stringWithFormat:@"（%ld\"）",duration];
}

- (void)insideStatus
{
    self.statusLabel.text = @"上滑取消";
    self.statusLabel.textColor = HEXCOLOR(0xB4B4B4);
    self.timeLabel.textColor = kYellowColor;
}

- (void)outsideStatus
{
    self.statusLabel.text = @"松开取消";
    self.statusLabel.textColor = HEXCOLOR(0xFC2F52);
    self.timeLabel.textColor = HEXCOLOR(0xFC2F52);
}

#pragma mark - lazyload

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        UIView *bgView = [[UIView alloc] init];
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerX.mas_equalTo(self);
        }];
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = HEXCOLOR(0xB4B4B4);
        _statusLabel.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.mas_equalTo(bgView);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kYellowColor;
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.text = @"（ 5”）";
        [bgView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.mas_equalTo(bgView);
            make.left.mas_equalTo(_statusLabel.mas_right).offset(5);
        }];
    }
    return _statusLabel;
}

@end
