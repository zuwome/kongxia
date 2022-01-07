//
//  ZZUserCenterRespondItemView.m
//  zuwome
//
//  Created by angBiu on 2017/4/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserCenterRespondItemView.h"

@implementation ZZUserCenterRespondItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _titleLaebl = [[UILabel alloc] init];
        _titleLaebl.textColor = kGrayContentColor;
        _titleLaebl.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLaebl];
        
        [_titleLaebl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_centerY).offset(-4);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kGrayContentColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_centerY).offset(4);
        }];
    }
    
    return self;
}

@end
