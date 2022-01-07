//
//  ZZFindVideoTimeView.m
//  zuwome
//
//  Created by angBiu on 2016/12/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFindVideoTimeView.h"

@implementation ZZFindVideoTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kBlackTextColor;
        bgView.alpha = 0.2;
        bgView.layer.cornerRadius = 2;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _typeImgView = [[UIImageView alloc] init];
        [self addSubview:_typeImgView];
        
        [_typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(5);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.right.mas_equalTo(bgView.mas_right).offset(-5);
        }];
    }
    
    return self;
}

@end
