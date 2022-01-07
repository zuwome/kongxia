//
//  ZZRegisterRentViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRegisterRentViewController.h"

#define RentCompleteUrl @"/rent/rentinfo"

@interface ZZRegisterRentViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIButton *backBtn;    //申请达人返回按钮

@property (nonatomic, strong) NSDictionary *iDict;  //h5点击返回事件参数

@end

@implementation ZZRegisterRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBlackColor;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.backBtn];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(@(NAVIGATIONBAR_HEIGHT + 10));
        make.size.mas_equalTo(CGSizeMake(38, 44));
    }];

    self.backBtn.hidden = self.type == RentTypeRegister ? NO : YES;
    [self requestH5];
}

- (void)requestH5 {
    NSString *urlStr;
    if (self.type == RentTypeRegister) {
        urlStr = [NSString stringWithFormat:@"%@?a=%d",H5Url.registerRent,arc4random()];
    } else {
        if (([UserHelper isAvatarManualReviewing] && isNullString(UserHelper.loginer.old_avatar)) || (![UserHelper didHaveRealAvatar] && ![UserHelper didHaveOldAvatar] )) {
            urlStr = isFullScreenDevice ? H5Url.registerRentComplete_AvatarReviewing_fullScreen : H5Url.registerRentComplete_AvatarReviewing;
        }
        else {
            urlStr = [NSString stringWithFormat:@"%@%@?uid=%@&type=%@",kBase_URL,RentCompleteUrl,[ZZUserHelper shareInstance].loginer.uid,self.addType];
        }
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)dismiss {   //申请达人入口返回
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerRent {  //申请达人
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return ;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        !self.registerRentCallback ? : self.registerRentCallback(self.iDict);
    }];
}

#pragma mark -- WKWebviewDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = URL.absoluteString;
    
    if ([self isContainStingWithSumString:scheme]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

- (BOOL)isContainStingWithSumString:(NSString *)string {
    string = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSRange range = [string rangeOfString:@"zwmscheme://"];
    if (range.location != NSNotFound) {
        [self managerScheme:string];
        return YES;
    }
    return NO;
}

- (void)managerScheme:(NSString *)scheme {
    NSString *jsonStr = [scheme stringByReplacingOccurrencesOfString:@"zwmscheme://" withString:@""];
    NSDictionary *jsonDict = [ZZUtils dictionaryWithJsonString:jsonStr];
    self.iDict = [jsonDict objectForKey:@"iOS"];
    [self registerRent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (WKWebView *)webView {
    if (nil == _webView) {
        _webView = [[WKWebView alloc] init];
        _webView.backgroundColor = kBGColor;
        _webView.navigationDelegate = self;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}

- (UIButton *)backBtn {
    if (nil == _backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"icon_rent_left"] forState:(UIControlStateNormal)];
        [_backBtn addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backBtn;
}

@end
