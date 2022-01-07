//
//  ZZFindHotHeadView.m
//  zuwome
//
//  Created by angBiu on 2017/4/27.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZFindHotHeadView.h"

@implementation ZZFindHotHeadView

- (instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray *)array
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.3) imageLinkURL:array placeHoderImageName:nil pageControlShowStyle:UIPageControlShowStyleCenter];
        _adView.pageControl.currentPageIndicatorTintColor = kYellowColor;
        [self addSubview:_adView];
        
        _topicView = [[ZZFindHotTopicView alloc] initWithFrame:CGRectMake(0, _adView.height, SCREEN_WIDTH, 120)];
        _topicView.hidden = YES;
        [self addSubview:_topicView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"精选视频";
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(8);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.height.mas_equalTo(@50);
        }];
    }
    
    return self;
}

@end
