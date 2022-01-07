//
//  ZZOrderARFootView.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/29.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderARFootView.h"

@implementation ZZOrderARFootView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = HEXCOLOR(0xf5f5f5);
        [self addSubview: self.titleLab];
    }
    
    return self;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = CustomFont(12);
        _titleLab.textColor = RGBCOLOR(128, 128, 128);
    }
    return _titleLab;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.top.bottom.offset(0);
    }];
    
}
@end
