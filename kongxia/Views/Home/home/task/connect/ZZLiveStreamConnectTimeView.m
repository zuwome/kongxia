//
//  ZZLiveStreamConnectTimeView.m
//  zuwome
//
//  Created by angBiu on 2017/7/19.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamConnectTimeView.h"

@interface ZZLiveStreamConnectTimeView ()

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ZZLiveStreamConnectTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.36);
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.text = @"00:00";
        [self addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).offset(6);
            make.right.mas_equalTo(self.mas_right).offset(-6);
        }];
    }
    
    return self;
}

- (void)setDuring:(NSInteger)during
{
    NSInteger minute = during/60;
    NSInteger second = during % 60;
    
    NSString *string = @"";
    if (minute > 9) {
        string = [NSString stringWithFormat:@"%ld",minute];
    } else {
        string = [NSString stringWithFormat:@"0%ld",minute];
    }
    if (second > 9) {
        string = [NSString stringWithFormat:@"%@:%ld",string,second];
    } else {
        string = [NSString stringWithFormat:@"%@:0%ld",string,second];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeLabel.text = string;
    });
}

@end
