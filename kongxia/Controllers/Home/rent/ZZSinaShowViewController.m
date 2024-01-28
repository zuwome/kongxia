//
//  ZZSinaShowViewController.m
//  zuwome
//
//  Created by angBiu on 16/5/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSinaShowViewController.h"

#import "ZZViewHelper.h"

@interface ZZSinaShowViewController ()<UIWebViewDelegate,WKNavigationDelegate>

@end

@implementation ZZSinaShowViewController
{
    UIActivityIndicatorView *_activityIndicator;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createViews];
}

- (void)createViews
{
    UIView *view = [ZZViewHelper createWebView];
    view.backgroundColor = kBGColor;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
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
    NSURL *url = [NSURL URLWithString:_urlString];
    
    WKWebView *webview = (WKWebView *)view;
    webview.navigationDelegate = self;
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
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
