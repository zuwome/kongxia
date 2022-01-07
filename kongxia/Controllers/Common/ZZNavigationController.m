//
//  ZZNavigationController.m
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZNavigationController.h"

@interface ZZNavigationController () <UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,weak) UIViewController* currentShowVC;

@end

@implementation ZZNavigationController

// 组我么的tabbar
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tabBarItem.imageInsets =  UIEdgeInsetsMake(6, 0, -6, 0);
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [self changeNavigationBarColor];
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.childViewControllers.count > 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeNavigationBarColor {
    UIColor *navColor = kYellowColor;
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        [appearance setShadowImage:[UIImage imageWithColor:navColor cornerRadius:0]];
        [appearance setBackgroundImage:[UIImage imageWithColor:navColor cornerRadius:0]];
        appearance.backgroundColor = navColor;
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance;
    }
    else {
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:navColor cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage imageWithColor:navColor cornerRadius:0]];
        self.navigationBar.translucent = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationBar.tintColor = [UIColor blackColor];
    }
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    // 解决iOS 14 popToRootViewController tabbar不自动显示问题
    if (animated) {
        UIViewController *popController = self.viewControllers.lastObject;
        popController.hidesBottomBarWhenPushed = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

@end
