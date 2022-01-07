//
//  ZZVideoHeadReusableView.m
//  zuwome
//
//  Created by angBiu on 2017/4/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZVideoHeadView.h"

@implementation ZZVideoHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.textColor = kGrayTextColor;
        _leftLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_leftLabel];
        
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.textColor = kGrayTextColor;
        _rightLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_rightLabel];
        
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    
    return self;
}

@end
