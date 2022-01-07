//
//  ZZUserLevelViewController.m
//  zuwome
//
//  Created by angBiu on 16/10/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserLevelViewController.h"
#import "HttpDNS.h"
#import "ZZNotNetEmptyView.h" //没网络的占位图
#import "ZZAlertNotNetEmptyView.h" // 已经加载过数据下拉加载的时候显示的
#import "WBReachabilityManager.h"

@interface ZZUserLevelViewController () <UIWebViewDelegate,WKNavigationDelegate>
{
    UIActivityIndicatorView         *_activityIndicator;
    ZZNotNetEmptyView *_notNetEmptyView;
}

@end

@implementation ZZUserLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的等级";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getIp];
}

- (void)getIp
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/level/page",kBase_URL,[ZZUserHelper shareInstance].loginer.uid];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createViewsWithUrlString:urlString];
    });
}

- (void)createViewsWithUrlString:(NSString *)urlString
{
    UIView *view = [ZZViewHelper createWebView];
    view.backgroundColor = kBGColor;
    [self.view addSubview:view];
    view.frame = self.view.frame;

    if (IOS8_OR_LATER) {
        WKWebView *webview = (WKWebView *)view;
        webview.navigationDelegate = self;
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10]];
    } else {
        UIWebView *webview = (UIWebView *)view;
        webview.delegate = self;
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10]];
    }
    _notNetEmptyView = [ZZNotNetEmptyView showNotNetWorKEmptyViewWithTitle:nil imageName:nil frame:view.frame viewController:self];
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_activityIndicator];
    
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    if (!GetReachabilityManager().isReachable) {
        return;//没有网络就不显示加载菊花了
    }
    _activityIndicator.hidesWhenStopped = YES;
    [_activityIndicator startAnimating];
}

#pragma mark - WKNavigationDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
    _notNetEmptyView.hidden= NO;

}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
    _notNetEmptyView.hidden = NO;
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
    _notNetEmptyView.hidden = YES;

    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
    _notNetEmptyView.hidden = YES;
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
