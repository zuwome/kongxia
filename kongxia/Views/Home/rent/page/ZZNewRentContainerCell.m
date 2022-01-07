//
//  ZZNewRentContainerCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/10/9.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewRentContainerCell.h"

@interface ZZNewRentContainerCell () <UIScrollViewDelegate>

@end

@implementation ZZNewRentContainerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.scrollView];
}

- (void)setInfoCtrl:(ZZRentInfoViewController *)infoCtrl {
    if (_infoCtrl) {
        return;
    }
    _infoCtrl = infoCtrl;
    
    CGFloat contentHeight = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 40 - _marginBottom;
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, contentHeight);
    
    [self.scrollView addSubview:infoCtrl.view];
    [infoCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.scrollView);
        make.bottom.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, contentHeight));
    }];
}

- (void)setDynamicCtrl:(ZZRentDynamicViewController *)dynamicCtrl {
    if (_dynamicCtrl) {
        return;
    }
    _dynamicCtrl = dynamicCtrl;
    [self.scrollView addSubview:dynamicCtrl.view];
    [dynamicCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.equalTo(self.scrollView);
        make.leading.equalTo(self.infoCtrl.view.mas_trailing);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(self.infoCtrl.view.mas_height);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.didScroll ? : self.didScroll(scrollView.contentOffset.x);
}

- (ZZScrollView *)scrollView {
    if (nil == _scrollView) {
        _scrollView = [[ZZScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
