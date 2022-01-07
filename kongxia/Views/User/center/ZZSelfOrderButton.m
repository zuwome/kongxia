//
//  ZZSelfOrderButton.m
//  zuwome
//
//  Created by angBiu on 16/5/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSelfOrderButton.h"

@implementation ZZSelfOrderButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeBottom;
        _imgView.userInteractionEnabled = NO;
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(25);
        }];
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.textColor = [UIColor colorWithHexValue:0x858585 andAlpha:1];
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.userInteractionEnabled = NO;
        [self addSubview:_typeLabel];
        
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
        }];
        
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.layer.cornerRadius = 5;
        _badgeLabel.clipsToBounds = YES;
        _badgeLabel.userInteractionEnabled = NO;
        _badgeLabel.hidden = YES;
        [self addSubview:_badgeLabel];
        
        [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_centerX).offset(13);
            make.top.mas_equalTo(_imgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        _badgeView = [[ZZBadgeView alloc] init];
        _badgeView.cornerRadius = 7.5;
        _badgeView.offset = 5;
        _badgeView.fontSize = 9;
        _badgeView.count = 99;
        [self addSubview:_badgeView];
        
        [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_centerX).offset(13);
            make.top.mas_equalTo(_imgView.mas_top).offset(5);
            make.height.mas_equalTo(15);
        }];
    }
    
    return self;
}

@end
