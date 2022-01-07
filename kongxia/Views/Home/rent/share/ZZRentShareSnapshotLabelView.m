//
//  ZZRentShareSnapshotLabelView.m
//  zuwome
//
//  Created by angBiu on 2016/11/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentShareSnapshotLabelView.h"

@implementation ZZRentShareSnapshotLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imgView = [[UIImageView alloc] init];
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)setIsLeft:(BOOL)isLeft
{
    if (isLeft) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(25);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(@19);
            make.right.mas_equalTo(self.mas_right).offset(-5);
        }];
        
        _imgView.image = [[UIImage imageNamed:@"icon_rent_share_label_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 25, 5, 5)];
    } else {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(5);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(@19);
            make.right.mas_equalTo(self.mas_right).offset(-25);
        }];
        
        _imgView.image = [[UIImage imageNamed:@"icon_rent_share_label_right"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 25)];
    }
}

- (void)setText:(NSString *)text
{
    NSInteger index = arc4random()%2;
    _titleLabel.text = text;
    if (index == 1) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(5);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(@19);
            make.right.mas_equalTo(self.mas_right).offset(-25);
        }];
        
        _imgView.image = [[UIImage imageNamed:@"icon_rent_share_label_right"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 25)];
    } else {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(25);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(@19);
            make.right.mas_equalTo(self.mas_right).offset(-5);
        }];
        
        _imgView.image = [[UIImage imageNamed:@"icon_rent_share_label_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 25, 5, 5)];
    }
}

@end
