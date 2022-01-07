//
//  ZZSnatchEmptyView.m
//  zuwome
//
//  Created by angBiu on 2017/8/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSnatchEmptyView.h"

@implementation ZZSnatchEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        self.clipsToBounds = YES;
        
        CGFloat scale = SCREEN_WIDTH /375.0;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_task_empty"];
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(50*scale);
            make.size.mas_equalTo(CGSizeMake(159.5, 159.5));
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = HEXCOLOR(0xa5a5a5);
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.text = @"一大波任务在来的路上 等会再来";
        [self addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(20);
        }];
    }
    
    return self;
}

@end
