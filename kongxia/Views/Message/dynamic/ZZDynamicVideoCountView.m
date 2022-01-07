//
//  ZZDynamicVideoBtnView.m
//  zuwome
//
//  Created by angBiu on 2017/2/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZDynamicVideoCountView.h"

@implementation ZZDynamicVideoCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.bottom.mas_equalTo(self);
        }];
        
        _imgView = [[UIImageView alloc] init];
        [bgView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = kGrayContentColor;
        _countLabel.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(5);
            make.right.mas_equalTo(bgView.mas_right);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
    }
    
    return self;
}

@end
