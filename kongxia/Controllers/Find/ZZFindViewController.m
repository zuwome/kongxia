//
//  ZZFindViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFindViewController.h"
#import "ZZFindHotViewController.h"
#import "ZZAttentDynamicViewController.h"
#import "ZZRecommendVideoViewController.h"
#import "ZZTabBarViewController.h"

#import "ZZFindTypeView.h"
#import "ZZListScrollView.h"
#import "ZZFindAttentGuideView.h"
#import "ZZNotNetEmptyView.h"
#import "UIViewController+NJKFullScreenSupport.h"

@interface ZZFindViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) ZZFindTypeView *typeView;
@property (nonatomic, strong) ZZListScrollView *scrollView;
@property (nonatomic, strong) ZZRecommendVideoViewController *recommendVC;
@property (nonatomic, strong) ZZFindHotViewController *hotCtl;
@property (nonatomic, strong) ZZAttentDynamicViewController *dynamicCtl;
@property (nonatomic, strong) ZZFindAttentGuideView *guideView;

@end

@implementation ZZFindViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self managerUnread];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.scrollEnabled = YES;
    [self enableScroll];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ZZTabBarViewController sharedInstance] hideBubbleView];
    [[ZZTabBarViewController sharedInstance] hideRentBubble];
    
    [self moveBar:MAXFLOAT];
    [self showOrHideBar:YES];
    
    if (_guideView) {
        [_guideView hideView];
    }
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createViews];
    
    // 双击tab 刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarRefresh) name:KMsg_TabbarRefreshNotification object:nil];
}

#pragma mark -- Notification Implementation
- (void)tabbarRefresh {
    if ([[UIViewController currentDisplayViewController] isKindOfClass: [self class]]) {
        NSUInteger index = _scrollView.contentOffset.x / SCREEN_WIDTH;
        
        if (index == 0) {
            [self.recommendVC.collectionView.mj_header beginRefreshing];
        }
        else if (index == 1) {
            [self.hotCtl.collectionView.mj_header beginRefreshing];
        }
        else if (index == 2) {
            [self.dynamicCtl.tableView.mj_header beginRefreshing];
        }
        
    }
}


- (void)createViews
{
    [self.view addSubview:self.typeView];
    [self.view addSubview:self.scrollView];
    
    _scrollView.frame = CGRectMake(0.0, _typeView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - _typeView.bottom - TABBAR_HEIGHT);

    [self initControllers];

}

- (void)initControllers
{
    WeakSelf;
    
    self.recommendVC = [[ZZRecommendVideoViewController alloc] init];
    self.recommendVC.hidesBottomBarWhenPushed = YES;
    self.recommendVC.didScroll = ^(CGFloat offset) {
//        [weakSelf moveBar:offset];
    };
    self.recommendVC.didScrollStatus = ^(BOOL isShow) {
//        [weakSelf showOrHideBar:isShow];
    };

    [self addChildViewController:self.recommendVC];
    
    _hotCtl = [[ZZFindHotViewController alloc] init];
    _hotCtl.didScroll = ^(CGFloat offset) {
//        [weakSelf moveBar:offset];
        weakSelf.scrollView.scrollEnabled = NO;
    };
    _hotCtl.didScrollStatus = ^(BOOL isShow) {
//        [weakSelf showOrHideBar:isShow];
    };
    _hotCtl.didStartScroll = ^{
        weakSelf.scrollView.scrollEnabled = NO;
    };
    _hotCtl.didEndScroll = ^{
        weakSelf.scrollView.scrollEnabled = YES;
    };
    [self addChildViewController:_hotCtl];
    
    _dynamicCtl = [[ZZAttentDynamicViewController alloc] init];
    _dynamicCtl.didScroll = ^(CGFloat offset) {
//        [weakSelf moveBar:offset];
    };
    _dynamicCtl.didScrollStatus = ^(BOOL isShow) {
//        [weakSelf showOrHideBar:isShow];
    };
    [self addChildViewController:_dynamicCtl];
    
//    _hotCtl.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.height);
    _hotCtl.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
    _dynamicCtl.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
    [self.scrollView addSubview:_hotCtl.view];
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    
    [MobClick event:Event_click_hot_mmd];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self enableScroll];
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [_typeView setLineIndex:index];
    // 添加控制器
    UIViewController *newController = self.childViewControllers[index];
    
    if (index == 2) {
        [MobClick event:Event_click_dynamic_following];
        [ZZUserHelper shareInstance].unreadModel.dynamic_following = NO;
        _typeView.rightRedPointView.hidden = YES;
    } else if (index == 1){
        [MobClick event:Event_click_hot_mmd];
    } else {//index = 0
        
    }
    if (newController.view.superview) return;
    
    newController.view.frame = CGRectMake(index*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
    [self.scrollView addSubview:newController.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    [self enableScroll];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [_typeView setLineViewOffset:self.scrollView.contentOffset.x/2.0];
    CGFloat scale = (SCREEN_WIDTH - 120.0f) / SCREEN_WIDTH;//按百分比计算偏移量
    [_typeView setLineViewOffset:self.scrollView.contentOffset.x / 3.0 * scale];
    [self unableScroll];
}

- (void)enableScroll
{
    _hotCtl.collectionView.scrollEnabled = YES;
    _dynamicCtl.tableView.scrollEnabled = YES;
    _recommendVC.collectionView.scrollEnabled = YES;
}

- (void)unableScroll
{
    _hotCtl.collectionView.scrollEnabled = NO;
    _dynamicCtl.tableView.scrollEnabled = NO;
    _recommendVC.collectionView.scrollEnabled = NO;
}

- (void)typeBtnClick:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
}

- (void)managerUnread
{
    if (_scrollView.contentOffset.x == SCREEN_WIDTH) {
        if ([ZZUserHelper shareInstance].unreadModel.dynamic_following) {
            _typeView.rightRedPointView.hidden = NO;
        } else {
            _typeView.rightRedPointView.hidden = YES;
        }
    }
}
#pragma mark - NavigationBarAndTabbarAnimation

- (void)moveBar:(CGFloat)offset
{
    //-24和20分别是 _topView 最高点和最低点的y值
    CGFloat y = fmin(fmax(_typeView.frame.origin.y + offset, -NAVIGATIONBAR_HEIGHT), 0);
    if (offset>0) {
        _typeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
    } else {
        _typeView.frame = CGRectMake(0, y, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
    }
    [self moveTabBar:-offset animated:YES];
}

//隐藏或者显示tabbar
- (void)showOrHideBar:(BOOL)isShow
{
    if (isShow) {
        [self showTabBar:YES];
    } else {
        [self hideTabBar:YES];
    }
}

#pragma mark - lazyload

- (ZZFindTypeView *)typeView
{
    WeakSelf;
    if (!_typeView) {
        _typeView = [[ZZFindTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        _typeView.selectIndex = ^(NSInteger index) {
            [weakSelf typeBtnClick:index];
        };
    }
    return _typeView;
}

- (ZZListScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[ZZListScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 0);
    }
    return _scrollView;
}

- (ZZFindAttentGuideView *)guideView
{
    if (!_guideView) {
        _guideView = [[ZZFindAttentGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _guideView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
