//
//  ZZRecordInfoView.m
//  zuwome
//
//  Created by angBiu on 2016/12/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRecordInfoView.h"

@implementation ZZRecordInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = HEXACOLOR(0x000000, 0.8);
        bgView.layer.cornerRadius = 12.5;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.backgroundColor = HEXACOLOR(0x000000, 0.8);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"点击开始录制视频";
        [bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(10);
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
            make.top.bottom.mas_equalTo(bgView);
        }];
    }
    
    return self;
}

@end
