//
//  ZZLevelImgView.m
//  zuwome
//
//  Created by angBiu on 2016/10/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZLevelImgView.h"

@implementation ZZLevelImgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _levelLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor] fontSize:9 text:@""];
        [self addSubview:_levelLabel];
        
        [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right);
            make.left.mas_equalTo(self.mas_left).offset(11);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    
    return self;
}

- (void)setLevel:(NSInteger)level
{
    NSInteger index = level/10;
    if (level > 99) {
        index = 9;
    }
    self.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_level_%ld",index]];
    _levelLabel.text = [NSString stringWithFormat:@"%ld",level];
}

@end
