//
//  ZZChuzuBubbleView.m
//  zuwome
//
//  Created by angBiu on 16/7/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChuzuBubbleView.h"

@implementation ZZChuzuBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXCOLOR(0xf2f6f9);
        self.layer.cornerRadius = 2;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(3);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-3);
            make.left.mas_equalTo(self.mas_left).offset(3);
            make.right.mas_equalTo(self.mas_right).offset(-3);
            make.height.mas_equalTo(@22);
        }];
    }
    
    return self;
}

@end
