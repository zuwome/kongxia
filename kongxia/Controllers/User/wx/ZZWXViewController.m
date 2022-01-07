//
//  ZZWXViewController.m
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZWXViewController.h"
#import "ZZChatViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZRentViewController.h"
#import "ZZUserCenterViewController.h"

#import "ZZWXTypeView.h"
#import "ZZMyWxView.h"
#import "ZZWXReadedView.h"
#import "ZZWXGuideView.h"
#import "ZZFastChatAgreementVC.h"

@interface ZZWXViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) ZZWXTypeView *typeView;
@property (nonatomic, strong) ZZScrollView *scrollView;
@property (nonatomic, strong) ZZMyWxView *myWxViwe;
@property (nonatomic, strong) ZZWXReadedView *readedView;
@property (nonatomic, strong) ZZWXGuideView *guideView;

@end

@implementation ZZWXViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!UserHelper.configModel.wechat_new) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else {
        if ([self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] isKindOfClass:[ZZRentViewController class]]) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void)createViews
{
    if (!_user) {
        _user = [ZZUserHelper shareInstance].loginer;
    }
    
    
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.myWxViwe];
    [self.scrollView addSubview:self.readedView];
    self.myWxViwe.user = _user;
    
    if (!UserHelper.configModel.wechat_new) {
        [self.view addSubview:self.typeView];
    }
    else {
        self.title = @"我的微信号";
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstMyWxGuide] && !_user.have_wechat_no) {
        [self.view addSubview:self.guideView];
    }
}

- (void)popToLast {
    if (!UserHelper.configModel.wechat_new) {
        return;
    }
    
    if ([self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] isKindOfClass:[ZZWechatOrdersViewController class]]
        || [self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] isKindOfClass:[ZZUserCenterViewController class]] ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [_typeView setLineIndex:index];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_typeView setLineViewOffset:self.scrollView.contentOffset.x/2.0];
}

- (void)typeBtnClick:(NSInteger)index
{
    [_myWxViwe.textField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
}

- (void)gotoChatView:(ZZUser *)user
{
    ZZChatViewController *controller = [[ZZChatViewController alloc] init];
    controller.uid = user.uid;
    controller.nickName = user.nickname;
    controller.user = user;
    controller.portraitUrl = user.avatar;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoGuideView
{
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = H5Url.findWechatNoGuide;
    controller.navigationItem.title = @"如何找到自己的微信号";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoUserPageView:(ZZUser *)user
{
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.user = user;
    controller.uid = user.uid;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - lazyload

- (ZZScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[ZZScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT-SafeAreaBottomHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        CGSize contentSize = CGSizeZero;
        if (!UserHelper.configModel.wechat_new) {
            contentSize = CGSizeMake(SCREEN_WIDTH * 2,
                                            SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - SafeAreaBottomHeight);
        }
        else {
            contentSize = CGSizeMake(SCREEN_WIDTH,
                                     SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - SafeAreaBottomHeight);
            
            
        }
            
        _scrollView.contentSize = contentSize;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (ZZWXTypeView *)typeView
{
    WeakSelf;
    if (!_typeView) {
        _typeView = [[ZZWXTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        _typeView.touchLeft = ^{
            [ZZHUD dismiss];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _typeView.selectIndex = ^(NSInteger index) {
            [weakSelf typeBtnClick:index];
        };
    }
    return _typeView;
}

- (ZZMyWxView *)myWxViwe {
    WeakSelf;
    if (!_myWxViwe) {
        _myWxViwe = [[ZZMyWxView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT-SafeAreaBottomHeight)];
        
        _myWxViwe.touchGuide = ^{
            [weakSelf gotoGuideView];
        };
        _myWxViwe.wxUpdate = ^{
            if (weakSelf.wxUpdate) {
                weakSelf.wxUpdate();
            }
            [weakSelf popToLast];
        };
        _myWxViwe.open_SanChat = ^{
            NSLog(@"PY_可以去开通闪聊");
            
            BOOL canProceed = [UserHelper canOpenQuickChatWithBlock:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
                
            }];
            
            if (!canProceed) {
                return;
            }
            
            ZZFastChatAgreementVC *vc = [ZZFastChatAgreementVC new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _myWxViwe;
}

- (ZZWXReadedView *)readedView {
    WeakSelf;
    if (!_readedView) {
        _readedView = [[ZZWXReadedView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT -SafeAreaBottomHeight)];
        _readedView.gotoChatView = ^(ZZUser *user) {
            [weakSelf gotoChatView:user];
        };
        _readedView.gotoUserPage = ^(ZZUser *user) {
            [weakSelf gotoUserPageView:user];
        };
        _readedView.canScroll = ^(BOOL canScroll) {
            weakSelf.scrollView.scrollEnabled = canScroll;
        };
    }
    return _readedView;
}

- (ZZWXGuideView *)guideView
{
    if (!_guideView) {
        _guideView = [[ZZWXGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
