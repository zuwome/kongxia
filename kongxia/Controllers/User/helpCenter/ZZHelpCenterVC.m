//
//  ZZHelpCenterVC.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/27.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZHelpCenterVC.h"
#import "ZZRentViewController.h"
#import "ZZRecordViewController.h"

#import "ZZViewHelper.h"
#import "ZZRightShareView.h"
#import "ZZLinkWebNavigationView.h"
#import "ZZTopicDetailViewController.h"
#import "ZZChatServerViewController.h"

@interface ZZHelpCenterVC () <UIWebViewDelegate, WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) ZZLinkWebNavigationView *navigationView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL pushHideBar;

@end

@implementation ZZHelpCenterVC

- (void)viewWillAppear:(BOOL)animated {//将要出现
    [super viewWillAppear:animated];
    [self hideNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {//出现之后
    [super viewDidAppear:animated];
    [self hideNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated { //将要消失
    [super viewWillDisappear:animated];
    [self hideNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated {  //消失之后
    [super viewDidDisappear:animated];
    [self hideNavigationBarHidden:NO];
}

- (void)hideNavigationBarHidden:(BOOL)hidden {
    [self.navigationController setNavigationBarHidden:hidden animated:NO];
//    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    if ([ZZUserHelper shareInstance].isLogin) {
//        NSRange range1 = [_urlString rangeOfString:[NSString stringWithFormat:@"%@",[kBase_URL stringByReplacingOccurrencesOfString:@"https://" withString:@""]]];
//        NSRange range2 = [_urlString rangeOfString:@"access_token="];
//        if (range1.location != NSNotFound && range2.location == NSNotFound) {
//            _urlString = [NSString stringWithFormat:@"%@?access_token=%@",_urlString,[ZZUserHelper shareInstance].oAuthToken];
//        }
//    }
    
    [self createViews];
    [self createNavLeftButton];
}

- (void)createNavLeftButton
{
    // 先计算页面导航栏和状态栏的高度，因为导航栏也是H5，H5根据不同手机屏幕，高度会变化，比例 width / height = 5
    CGFloat navHeight = NAVIGATIONBAR_HEIGHT - 20.0f;
    // 返回按钮是前端自己写的，y 根据不同的高度要变化
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, navHeight / 2.0 + 20 - (25 / 2.0), 40, 25);
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:leftBtn];
}

- (void)leftBtnClick
{
    if (_wkWebView.canGoBack) {
        [_wkWebView goBack];
        
        [_wkWebView reload];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)leftDismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createViews
{
    UIView *view = [ZZViewHelper createWebView];
    view.backgroundColor = kBGColor;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@(0));
    }];
    
    _wkWebView = (WKWebView *)view;
    _wkWebView.navigationDelegate = self;
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    _wkWebView.scrollView.delegate = self;
    if (@available(iOS 11.0, *)) {
        _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_activityIndicator];
    
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _activityIndicator.hidesWhenStopped = YES;
    [_activityIndicator startAnimating];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *URL = navigationAction.request.URL;
    NSLog(@"%@", URL);
    NSString *scheme = URL.absoluteString;
    NSLog(@"%@",scheme);
    if ([self isContainStingWithSumString:scheme]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//
////    NSURL *URL = navigationResponse.response.URL;
////    NSLog(@"%@", URL);
////    NSString *scheme = URL.absoluteString;
////    NSLog(@"%@",scheme);
////
////    decisionHandler(WKNavigationResponsePolicyCancel);
//}

- (BOOL)isContainStingWithSumString:(NSString *)string {
    string = [string stringByRemovingPercentEncoding];
    
    NSRange range = [string rangeOfString:@"zwmscheme://"];
    if (range.location == NSNotFound) {
        return NO;
    } else {
        [self managerScheme:string];
        return YES;
    }
}

- (void)managerScheme:(NSString *)scheme
{
    NSString *jsonString = [scheme stringByReplacingOccurrencesOfString:@"zwmscheme://" withString:@""];
    NSDictionary *dictionary = [ZZUtils dictionaryWithJsonString:jsonString];
    NSDictionary *aDict = [dictionary objectForKey:@"iOS"];
    NSLog(@"jsonString : %@", jsonString);
    NSLog(@"dictionary : %@", dictionary);
    NSLog(@"aDict : %@", aDict);
    if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"push"]) {
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:YES];
        _pushHideBar = [[aDict objectForKey:@"hidebar"] boolValue];
    } else if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"present"]) {
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:NO];
    }
}

- (void)runtimePush:(NSString *)vcName dic:(NSDictionary *)dic push:(BOOL)push
{
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    
    if ([vcName isEqualToString: @"ZZChatServerViewController"]) {
        [ZZServerHelper showServer];
        return;
    }
    //类名(对象名)
    NSString *class = vcName;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象(写到这里已经可以进行随机页面跳转了)
    id instance = [[newClass alloc] init];
    
    //下面是传值－－－－－－－－－－－－－－
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([ZZUtils checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            [instance setValue:obj forKey:key];
        } else {
            NSLog(@"不包含key=%@的属性",key);
        }
    }];
    if ([instance isKindOfClass:[ZZRecordViewController class]]) {
        [ZZUtils checkRecodeAuth:^(BOOL authorized) {
            if (authorized) {
                [self navigationMethod:instance push:push];
            }
        }];
    } else {
        if ([instance isKindOfClass:[NSClassFromString(@"ZZChatServerViewController") class]]) {
            ZZChatServerViewController *chatService = (ZZChatServerViewController *)instance;
            chatService.conversationType = ConversationType_CUSTOMERSERVICE;
            chatService.targetId = kCustomerServiceId;
            chatService.title = @"客服";
        }
        [self navigationMethod:instance push:push];
    }
}

- (void)navigationMethod:(id)instance push:(BOOL)push
{
    if (push) {
        _isPush = YES;
        [self.navigationController pushViewController:instance animated:YES];
    } else {
        ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:instance];
        [self presentViewController:navCtl animated:YES completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat scale = 0;
    
    if (offset <= 0) {
        scale = 0;
    } else if (0<offset && offset<64) {
        scale = (64-offset)/64.0;
    } else {
        scale = 1;
    }
    [self.navigationView setViewAlphaScale:scale];
}

//- (ZZLinkWebNavigationView *)navigationView
//{
//    WeakSelf;
//    if (!_navigationView) {
//        _navigationView = [[ZZLinkWebNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
//        _navigationView.touchLeft = ^{
//            [weakSelf leftBtnClick];
//        };
//        _navigationView.touchRight = ^{
//            [weakSelf rightBtnClick];
//        };
//    }
//    return _navigationView;
//}

- (void)dealloc
{
    _wkWebView.scrollView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
