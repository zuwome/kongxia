//
//  ZZPlayerGuideView.m
//  zuwome
//
//  Created by angBiu on 2017/1/4.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZPlayerGuideView.h"

@implementation ZZPlayerGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIButton *bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgBtn.backgroundColor = kBlackTextColor;
        bgBtn.alpha = 0.8;
        [bgBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgView.userInteractionEnabled = NO;
        [self addSubview:bgView];
        
        UIImageView *topImgView = [[UIImageView alloc] init];
        topImgView.image = [UIImage imageNamed:@"icon_player_guide_top"];
        [bgView addSubview:topImgView];
        
        [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.centerY.mas_equalTo(bgView.mas_top).offset(SCREEN_HEIGHT/4);
            make.size.mas_equalTo(CGSizeMake(109, 58));
        }];
        
        UILabel *topLabel = [[UILabel alloc] init];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.font = [UIFont systemFontOfSize:15];
        topLabel.text = @"切换视频";
        [bgView addSubview:topLabel];
        
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topImgView.mas_bottom).offset(8);
            make.centerX.mas_equalTo(topImgView.mas_centerX);
        }];
        
        UIView *centerBgView = [[UIView alloc] init];
        [bgView addSubview:centerBgView];
        
        [centerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
        
        UIImageView *centerImgView = [[UIImageView alloc] init];
        centerImgView.image = [UIImage imageNamed:@"icon_player_guide_center"];
        [centerBgView addSubview:centerImgView];
        
        [centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(centerBgView);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        UILabel *centerLabel = [[UILabel alloc] init];
        centerLabel.textColor = [UIColor whiteColor];
        centerLabel.font = [UIFont systemFontOfSize:15];
        centerLabel.text = @"双击点赞";
        [centerBgView addSubview:centerLabel];
        
        [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(centerImgView.mas_right).offset(12);
            make.centerY.mas_equalTo(centerImgView.mas_centerY);
            make.right.mas_equalTo(centerBgView.mas_right);
        }];
        
        UIView *bottomBgView = [[UIView alloc] init];
        [bgView addSubview:bottomBgView];
        
        [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.centerY.mas_equalTo(bgView.mas_bottom).offset(-SCREEN_HEIGHT/4.0);
        }];
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.textColor = [UIColor whiteColor];
        bottomLabel.font = [UIFont systemFontOfSize:15];
        bottomLabel.text = @"查\n看\n评\n论\n";
        bottomLabel.numberOfLines = 0;
        [bottomBgView addSubview:bottomLabel];
        
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bottomBgView.mas_left);
            make.centerY.mas_equalTo(bottomBgView.mas_centerY);
        }];
        
        UIImageView *bottomImgView = [[UIImageView alloc] init];
        bottomImgView.image = [UIImage imageNamed:@"icon_player_guide_bottom"];
        [bottomBgView addSubview:bottomImgView];
        
        [bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(bottomBgView);
            make.left.mas_equalTo(bottomLabel.mas_right).offset(12);
            make.size.mas_equalTo(CGSizeMake(51, 98));
        }];
    }
    
    return self;
}

- (void)btnClick
{
    [self removeFromSuperview];
}

@end
