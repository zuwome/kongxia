//
//  ZZLabelView.m
//  zuwome
//
//  Created by angBiu on 16/8/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZLabelView.h"

@implementation ZZLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 2;
        self.layer.borderColor = kBlackTextColor.CGColor;
        self.layer.borderWidth = 0.5;
        self.clipsToBounds = YES;
        
        _labelBtn = [[UIButton alloc] init];
        [self addSubview:_labelBtn];
        
        [_labelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.userInteractionEnabled = NO;
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    
    return self;
}

@end
