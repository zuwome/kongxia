//
//  ZZSignupHeaderView.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZSignupHeaderView.h"

@implementation ZZSignupHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)layout {
    
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12.0);
        make.left.equalTo(self).offset(15.0);
        make.bottom.equalTo(self).offset(-12.0);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _titleLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _titleLabel;
}

@end
