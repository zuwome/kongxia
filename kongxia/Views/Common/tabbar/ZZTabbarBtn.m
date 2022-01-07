//
//  ZZTabbarBtn.m
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTabbarBtn.h"

@implementation ZZTabbarBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _badgeView = [[ZZBadgeView alloc] init];
        _badgeView.layer.cornerRadius = 9;
        _badgeView.clipsToBounds = YES;
        _badgeView.hidden = YES;
        [self addSubview:_badgeView];
        
        [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(3);
            make.left.mas_equalTo(self.mas_centerX).offset(6);
            make.height.mas_equalTo(@18);
        }];
        
        _redPointView = [[UIView alloc] init];
        _redPointView.backgroundColor = kRedPointColor;
        _redPointView.layer.cornerRadius = 5;
        _redPointView.clipsToBounds = YES;
        _redPointView.hidden = YES;
        [self addSubview:_redPointView];
        
        [_redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_badgeView.mas_left);
            make.top.mas_equalTo(self.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        _showImgView = [[UIImageView alloc] init];
        _showImgView.contentMode = UIViewContentModeCenter;
        _showImgView.userInteractionEnabled = NO;
        _showImgView.image = [UIImage imageNamed:@"icon_tabbar_shine"];
        _showImgView.hidden = YES;
        [self insertSubview:_showImgView atIndex:0];
        
        [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (!self.selected) {
        _showImgView.hidden = NO;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _showImgView.hidden = YES;
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _showImgView.hidden = YES;
    });
}

@end
