//
//  ZZBillingRecordsViewController.m
//  zuwome
//
//  Created by 潘杨 on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZBillingRecordsViewController.h"
#import "ZZBalanceViewController.h"
#import "ZZMeBiRecordViewController.h"
#import "SubTitleView.h"
@interface ZZBillingRecordsViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource,SubTitleViewDelegate>
@property (nonatomic, strong) SubTitleView *subTitleView;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation ZZBillingRecordsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"账单记录";
    [self.view addSubview:self.subTitleView];

    [self configSubViews];

}
- (void)configSubViews
{
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitleView.mas_bottom).with.offset(2);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}


- (NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        ZZBalanceViewController *balanceVC = [[ZZBalanceViewController alloc]init];
        ZZMeBiRecordViewController *meBiRecordVC = [[ZZMeBiRecordViewController alloc]init];
        _viewControllers = [NSMutableArray arrayWithObjects:balanceVC,meBiRecordVC, nil];
    }
    return _viewControllers;
}
/**
 *  子标题
 **/
- (SubTitleView *)subTitleView
{
    if (!_subTitleView) {
        _subTitleView = [[SubTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _subTitleView.delegate = self;
        _subTitleView.titleArray = @[@"余额记录",@"么币记录"];
        _subTitleView.selectTag = (NSInteger)self.recordStyle;
    }
    return _subTitleView;
}


- (void)subTitleViewDidSelected:(SubTitleView *)titleView atIndex:(NSInteger)index title:(NSString *)title {
    
    UIViewController *vc  =  self.viewControllers[index];
      [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
- (NSInteger)indexForViewController:(UIViewController *)controller {
    return [self.viewControllers indexOfObject:controller];
}

#pragma mark - UIPageViewControllerDelegate/UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexForViewController:viewController];
    if(index == 0 || index == NSNotFound) {
        return nil;
    }
    return [self.viewControllers objectAtIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexForViewController:viewController];
    if(index == NSNotFound || index == self.viewControllers.count - 1) {
        return nil;
    }
    return [self.viewControllers objectAtIndex:index + 1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.viewControllers.count;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    UIViewController *viewController = self.pageViewController.viewControllers[0];
    NSUInteger index = [self indexForViewController:viewController];
    [self.subTitleView transToShowAtIndex:index];
}

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationNone] forKey:UIPageViewControllerOptionSpineLocationKey];
        UIPageViewController *page = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        page.delegate = self;
        page.dataSource = self;
        if (self.recordStyle== BillingRecordsStyle_MeBi) {
            UIViewController *vc  =  self.viewControllers[1];
            [page setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }else {
                    [page setViewControllers:@[[self.viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }

        [self addChildViewController:page];
        [self.view addSubview:page.view];
        _pageViewController = page;
    }
    return _pageViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
