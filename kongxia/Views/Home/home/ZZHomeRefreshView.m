//
//  ZZHomeRefreshView.m
//  zuwome
//
//  Created by angBiu on 2017/5/5.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZHomeRefreshView.h"

@implementation ZZHomeRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = HEXACOLOR(0x000000, 0.72);
        bgView.layer.cornerRadius = 18;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
            
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = @"点击\"X\"，TA将不会在新鲜中出现";
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(12);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"icon_home_cancel"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(viewHide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).offset(12);
            make.right.mas_equalTo(self.mas_right).offset(-6);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(21, 21));
        }];
    }
    
    return self;
}

- (void)viewShow
{
    self.hidden = NO;
    [ZZKeyValueStore saveValue:@"ZZHomeRefreshView" key:[ZZStoreKey sharedInstance].homeRefreshView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self viewHide];
    });
}

- (void)viewHide
{
    [ZZKeyValueStore saveValue:@"ZZHomeRefreshView" key:[ZZStoreKey sharedInstance].homeRefreshView];
    [self removeFromSuperview];
}

@end
