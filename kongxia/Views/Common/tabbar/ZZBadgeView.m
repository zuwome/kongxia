//
//  ZZBadgeView.m
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZBadgeView.h"

@implementation ZZBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_badgeLabel];
        
        [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
        }];
        
        self.clipsToBounds = YES;
        self.userInteractionEnabled = NO;
        self.cornerRadius = 9;
        self.offset = 5;
        self.fontSize = 13;
        self.backgroundColor = HEXCOLOR(0xF32426);
    }
    
    return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setFontSize:(NSInteger)fontSize
{
    _fontSize = fontSize;
    _badgeLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)setCount:(NSInteger)count
{
    _count = count;
    NSString *string = [NSString stringWithFormat:@"%ld",count];
    if (count > 99) {
        string = @"99+";
    }
    _badgeLabel.text = string;
    if (count < 10) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_cornerRadius*2);
        }];
    } else {
        CGFloat width = [ZZUtils widthForCellWithText:string fontSize:_fontSize];
        if (width+_offset*2 > _cornerRadius*2) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width+_offset*2);
            }];
        } else {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(_cornerRadius*2);
            }];
        }
    }
    if (count == 0) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

@end
