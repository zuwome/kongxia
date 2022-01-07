//
//  ZZTabbarBubbleView.m
//  zuwome
//
//  Created by angBiu on 2017/3/29.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTabbarBubbleView.h"

@implementation ZZTabbarBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.userInteractionEnabled = NO;
        
        
    }
    
    return self;
}

- (void)setType:(NSInteger)type
{
    [self removeAllSubviews];
    _type = type;
    switch (type) {
        case 1:
        {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [UIImage imageNamed:@"icon_tabbar_bubble"];
            [self addSubview:imgView];
            
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self);
                make.size.mas_equalTo(CGSizeMake(161.5, 101));
            }];
        }
            break;
        case 2:
        {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [[UIImage imageNamed:@"icon_tabbar_bubble_city"] resizableImageWithCapInsets:UIEdgeInsetsMake(48, 8, 20, 8)];
            [self addSubview:imgView];
            
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self);
            }];
            
//            NSString *titleString = [NSString stringWithFormat:@"你来到了%@",[ZZUserHelper shareInstance].cityName];
            NSString *titleString = @"你来到了新城市";
            NSString *contentString = @"快发条视频告诉身边的人";
            CGFloat titleWidth = [ZZUtils widthForCellWithText:titleString fontSize:14];
            CGFloat contentWidth = [ZZUtils widthForCellWithText:contentString fontSize:13];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.textColor = kBlackColor;
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.text = titleString;
            [imgView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(imgView.mas_centerX);
                make.top.mas_equalTo(imgView.mas_top).offset(48);
            }];
            
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.textColor = kBlackColor;
            contentLabel.font = [UIFont systemFontOfSize:13];
            contentLabel.text = contentString;
            [imgView addSubview:contentLabel];
            
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(imgView.mas_centerX);
                make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
                make.bottom.mas_equalTo(imgView.mas_bottom).offset(-20);
            }];
            
            if (titleWidth > contentWidth) {
                [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(imgView.mas_left).offset(8);
                    make.right.mas_equalTo(imgView.mas_right).offset(-8);
                }];
            } else {
                [contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(imgView.mas_left).offset(8);
                    make.right.mas_equalTo(imgView.mas_right).offset(-8);
                }];
            }
        }
            break;
        default:
            break;
    }
}

@end
