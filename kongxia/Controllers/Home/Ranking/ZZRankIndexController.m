//
//  ZZRankIndexController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRankIndexController.h"
#import "ZZPopularityListController.h"
#import "ZZRookieRankController.h"
#import "ZZPopularityVC.h"
#import "kongxia-Swift.h"

@interface ZZRankIndexController () <ZZRankIndexHeaderViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) ZZRankIndexHeaderView *headerView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ZZRankIndexController

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentPage = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigations];
    [self layout];
    [self initViewControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - response method
- (void)showRules {
    [self showTips];
}


#pragma mark ZZRankIndexHeaderViewDelegate
- (void)header:(ZZRankIndexHeaderView *)header select:(NSInteger)index {
    _currentPage = index;
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0)];
    }];
    
    if (_currentPage == 1) {
        ZZPopularityListController *vc = (ZZPopularityListController *)self.childViewControllers[_currentPage];
        if (vc.isTheFirstTime) {
            [vc fresh];
        }
    }
    else if (_currentPage == 2) {
        ZZRookieRankController *vc = (ZZRookieRankController *)self.childViewControllers.lastObject;
        if (vc.isTheFirstTime) {
            [vc fresh];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    if (_currentPage == 1) {
        ZZPopularityListController *vc = (ZZPopularityListController *)self.childViewControllers[_currentPage];
        if (vc.isTheFirstTime) {
            [vc fresh];
        }
    }
    else if (_currentPage == 2) {
        ZZRookieRankController *vc = (ZZRookieRankController *)self.childViewControllers.lastObject;
        if (vc.isTheFirstTime) {
            [vc fresh];
        }
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_headerView offetSet:scrollView.contentOffset.x];
}


#pragma mark - Navigator
- (void)showTips {
    ZZPopularityVC *vc = [[ZZPopularityVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Layout
- (void)layoutNavigations {
    self.title = @"空虾排行榜";
}

- (void)layout {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_headerView.mas_bottom);
    }];
}

- (void)initViewControllers {
    [self.view layoutIfNeeded];
    // 添加子控制器
    ZZRankingViewController *vc3 = [[ZZRankingViewController alloc] init];
    vc3.parentController = self;
    vc3.view.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - _headerView.bottom);
    if (vc3.isTheFirstTime) {
        [vc3 fresh];
    }
    
    ZZPopularityListController *vc1 = [[ZZPopularityListController alloc] init];
    vc1.parentController = self;
    vc1.view.frame = CGRectMake(SCREEN_WIDTH, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - _headerView.bottom);
    
    
    ZZRookieRankController *vc2 = [[ZZRookieRankController alloc] init];
    vc2.parentController = self;
    vc2.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - _headerView.bottom);
    
    [self addChildViewController:vc3];
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    
    [self.scrollView addSubview:self.childViewControllers[0].view];
    [self.scrollView addSubview:self.childViewControllers[1].view];
    [self.scrollView addSubview:self.childViewControllers[2].view];
}

#pragma mark getters and setters
- (ZZRankIndexHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ZZRankIndexHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 40.0)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end



@interface ZZRankIndexHeaderView ()

@property (nonatomic, strong) UILabel *popularityLabel;

@property (nonatomic, strong) UILabel *rookieLabel;

@property (nonatomic, strong) UILabel *wealthLabel;

@property (nonatomic, strong) UIView *navigatorBar;

@end

@implementation ZZRankIndexHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}


#pragma mark public Method
- (void)offetSet:(CGFloat)offsetX {
    CGFloat currentOffset = 0.0;
    CGFloat gap = _rookieLabel.center.x - _wealthLabel.center.x;
    if (offsetX >= 0 && offsetX <= SCREEN_WIDTH) {
        gap = _popularityLabel.center.x - _wealthLabel.center.x ;
        currentOffset = (gap / SCREEN_WIDTH) * offsetX;
    }
    else {
        gap = _rookieLabel.center.x - _popularityLabel.center.x ;
        currentOffset = (gap / SCREEN_WIDTH) * (offsetX - SCREEN_WIDTH) + (_popularityLabel.center.x - _wealthLabel.center.x);
    }

    [_navigatorBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_wealthLabel).offset(currentOffset);
    }];

    if (offsetX == 0) {
        _wealthLabel.font = ADaptedFontSCBoldSize(16);
        _popularityLabel.font = ADaptedFontMediumSize(16);
        _rookieLabel.font = ADaptedFontMediumSize(16);
    }
    else if (offsetX == SCREEN_WIDTH) {
        _popularityLabel.font = ADaptedFontSCBoldSize(16);
        _wealthLabel.font = ADaptedFontMediumSize(16);
        _rookieLabel.font = ADaptedFontMediumSize(16);
    }
    else if (offsetX == SCREEN_WIDTH * 2) {
        _rookieLabel.font = ADaptedFontSCBoldSize(16);
        _popularityLabel.font = ADaptedFontMediumSize(16);
        _wealthLabel.font = ADaptedFontMediumSize(16);
    }
}

#pragma mark response method
- (void)select:(UITapGestureRecognizer *)recoginzier {
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:select:)]) {
        [self.delegate header:self select:recoginzier.view.tag];
    }
}


#pragma mark Layout
- (void)layout {
    [self addSubview:self.popularityLabel];
    [self addSubview:self.rookieLabel];
    [self addSubview:self.wealthLabel];
    [self addSubview:self.navigatorBar];
    
    [_popularityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [_wealthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_popularityLabel.mas_left).offset(-29);
    }];
    
    [_rookieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_popularityLabel.mas_right).offset(29);
    }];
    
    [_navigatorBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_wealthLabel);
        make.bottom.equalTo(self).offset(-5);
        make.width.equalTo(@(14));
        make.height.equalTo(@3.0);
    }];
}


#pragma mark getters and setters
- (UIView *)navigatorBar {
    if (!_navigatorBar) {
        _navigatorBar = [[UIView alloc] init];
        _navigatorBar.backgroundColor = RGBCOLOR(249, 6, 50);
        _navigatorBar.layer.cornerRadius = 1.5;
    }
    return _navigatorBar;
}

- (UILabel *)popularityLabel {
    if (!_popularityLabel) {
        _popularityLabel = [[UILabel alloc] init];
        _popularityLabel.textColor = RGBCOLOR(63, 58, 58);
        _popularityLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _popularityLabel.text = @"人气榜";
        _popularityLabel.textAlignment = NSTextAlignmentCenter;
        _popularityLabel.tag = 1;
        _popularityLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
        [_popularityLabel addGestureRecognizer:tap];
    }
    return _popularityLabel;
}

- (UILabel *)rookieLabel {
    if (!_rookieLabel) {
        _rookieLabel = [[UILabel alloc] init];
        _rookieLabel.textColor = RGBCOLOR(63, 58, 58);
        _rookieLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _rookieLabel.text = @"新人榜";
        _rookieLabel.textAlignment = NSTextAlignmentCenter;
        _rookieLabel.tag = 2;
        _rookieLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
        [_rookieLabel addGestureRecognizer:tap];
    }
    return _rookieLabel;
}

- (UILabel *)wealthLabel {
    if (!_wealthLabel) {
        _wealthLabel = [[UILabel alloc] init];
        _wealthLabel.textColor = RGBCOLOR(63, 58, 58);
        _wealthLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _wealthLabel.text = @"实力榜";
        _wealthLabel.textAlignment = NSTextAlignmentCenter;
        _wealthLabel.tag = 0;
        _wealthLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
        [_wealthLabel addGestureRecognizer:tap];
    }
    return _wealthLabel;
}

@end
