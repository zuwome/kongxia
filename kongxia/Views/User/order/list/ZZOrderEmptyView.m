//
//  ZZOrderEmptyView.m
//  zuwome
//
//  Created by angBiu on 2017/8/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZOrderEmptyView.h"

@implementation ZZOrderEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        
        CGFloat scale = SCREEN_WIDTH /375.0;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_order_empty"];
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(111*scale);
            make.top.mas_equalTo(self.mas_top).offset(100*scale);
            make.size.mas_equalTo(CGSizeMake(153.5, 101.5));
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = HEXCOLOR(0xa5a5a5);
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.text = @"一个邀约也没有 你不能再低调了！";
        [self addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(20);
        }];
    }
    
    return self;
}

@end
