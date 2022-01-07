//
//  ZZChatTimeView.m
//  zuwome
//
//  Created by angBiu on 16/10/9.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatTimeView.h"

@implementation ZZChatTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 3;
        self.backgroundColor = HEXCOLOR(0xF0F0F0);
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = kGrayContentColor;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.backgroundColor = HEXCOLOR(0xF0F0F0);
        [self addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    
    return self;
}

@end
