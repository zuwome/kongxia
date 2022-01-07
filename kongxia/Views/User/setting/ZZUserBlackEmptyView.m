//
//  ZZUserBlackEmptyView.m
//  zuwome
//
//  Created by angBiu on 2017/8/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserBlackEmptyView.h"

@implementation ZZUserBlackEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        
        CGFloat scale = SCREEN_WIDTH /375.0;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_wx_read_empty"];
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(100*scale);
            make.size.mas_equalTo(CGSizeMake(184.5, 153.5));
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = HEXCOLOR(0xa5a5a5);
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.text = @"没有黑名单记录哦";
        [self addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(57);
        }];
    }
    
    return self;
}

@end
