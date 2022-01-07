//
//  ZZAttentEmptyView.m
//  zuwome
//
//  Created by angBiu on 2017/8/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZAttentEmptyView.h"

@implementation ZZAttentEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_attent_empty"];
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(183, 300.5));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0xa5a5a5);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.text = @"快去跟TA互动吧，成为TA第一个关注的人";
        [self addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(15);
        }];
    }
    
    return self;
}

@end
