//
//  ZZHomeStatusView.m
//  zuwome
//
//  Created by angBiu on 16/9/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeStatusView.h"

@implementation ZZHomeStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [UIImage imageNamed:@"icon_user_statusbg"];
        _bgImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_bgImgView];
        
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _statusImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _statusImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_statusImgView];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.text = @"NEW";
        [self addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    
    return self;
}

- (void)setUser:(ZZUser *)user type:(NSInteger)type
{
    self.hidden = NO;
    if (user.mark.is_new_rent) {
        _statusImgView.image = [UIImage imageNamed:@"ic_new"];
        _statusLabel.hidden = YES;
        _statusImgView.hidden = NO;
    } else if (user.mark.is_flighted_user) {
        _statusLabel.hidden = YES;
        _statusImgView.hidden = NO;
        _statusImgView.image = [UIImage imageNamed:@"icon_user_plane"];
        
    } else if (user.mark.is_short_distance_user) {
        _statusLabel.hidden = YES;
        _statusImgView.hidden = NO;
        _statusImgView.image = [UIImage imageNamed:@"icon_user_car"];
    } else {
        self.hidden = YES;
    }
    
    switch (type) {
        case 1:
        {
            [_statusImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(34, 19));
            }];
        }
            break;
        case 2:
        {
            [_statusImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(50, 28));
            }];
        }
            break;
            case 3:
            {
                [_statusImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.mas_centerX);
                    make.centerY.mas_equalTo(self.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(27, 16));
                }];
            }
                break;
        default:
            break;
    }
}

@end
