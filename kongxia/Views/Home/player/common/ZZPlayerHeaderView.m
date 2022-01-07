//
//  ZZPlayerHeaderView.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPlayerHeaderView.h"

@implementation ZZPlayerHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self addSubview: self.titleLab];
        [self setUpConstraints];
    }
    
    return self;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
       _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = kGrayContentColor;
    }
    return _titleLab;
}

/**
 设置约束
 */
- (void)setUpConstraints {
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.offset(0);
        make.height.equalTo(@(55));
        make.bottom.equalTo(self.mas_bottom);
    }];
}
@end
