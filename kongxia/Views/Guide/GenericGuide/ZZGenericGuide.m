//
//  ZZGenericGuide.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//
#import "ZZViewHelper.h"
#import "ZZTabBarViewController.h"
#import "ZZGenericGuide.h"
#import "ZZRecordViewController.h"
#import "ZZTopicDetailViewController.h"
#import "ZZLinkWebViewController.h"
@interface ZZGenericGuide ()<WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL pushHideBar;

@end

@implementation ZZGenericGuide

+ (void)showAlertH5ActiveViewWithModel:(ZZActivityUrlModel *)model viewController:(UIViewController *)viewController {
    [[[ZZGenericGuide alloc]init] showAlertH5ActiveViewModel:model viewController:viewController];
}

- (void)showAlertH5ActiveViewModel:(ZZActivityUrlModel *)model viewController:(UIViewController *)viewController{
    self.viewController = viewController;
      self.model = model;
    [self setUIWithModel:model viewController:viewController];
  
}
- (void)setUIWithModel:(ZZActivityUrlModel *)model viewController:(UIViewController *)viewController{

    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.h5_url]]];
    [self addSubview:self.activityIndicator];
    [self addSubview:self.wkWebView];
    [self setUpTheConstraints];
    [self showView:nil];
}
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] init];
        _wkWebView.navigationDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.scrollView.delegate = self;
        _wkWebView.scrollView.scrollEnabled = YES;
        [_wkWebView setOpaque:NO];
        _wkWebView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _wkWebView;
}
- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] init];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_activityIndicator startAnimating];

    }
    return _activityIndicator;
}


- (void)setUpTheConstraints {
    
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
    }];
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = URL.absoluteString;
    NSLog(@"%@",scheme);
    if ([self isContainStingWithSumString:scheme]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
- (BOOL)isContainStingWithSumString:(NSString *)string
{
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
  
    NSString *pushmethod = [aDict objectForKey:@"pushmethod"];
    if (isNullString(pushmethod)) {
        [self dissMissCurrent];
        return;
    }
    if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"push"]) {
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:YES];
        _pushHideBar = [[aDict objectForKey:@"hidebar"] boolValue];
    } else if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"present"]) {
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:NO];
        
    }else  if ([[aDict objectForKey:@"vcname"] isEqualToString:@"appStoreAccent"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://finance-app.itunes.apple.com/account/edit/billing-info"]];
        [self dissMissCurrent];
    }else if ([pushmethod rangeOfString:@"tabbar-"].location != NSNotFound) {
        [self dissMissCurrent];
        ZZTabBarViewController *controller = [ZZTabBarViewController sharedInstance];
        NSInteger integer = [[pushmethod replaceOldString:@"tabbar-" WithNewString:@""] integerValue];
        [controller setSelectIndex:integer];
        [self.viewController.navigationController popToRootViewControllerAnimated:NO];
    }
    
}
#pragma mark - 根据h5对应的按钮跳转到对应的iOS界面
- (void)runtimePush:(NSString *)vcName dic:(NSDictionary *)dic push:(BOOL)push
{
    [self dissMissCurrent];
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
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
    } else if ([instance isKindOfClass:[ZZLinkWebViewController class]]) {
      
        ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
        controller.urlString = self.model.detailUrl;
        controller.title = self.model.h5_name;
        controller.isPushNOHideNav = YES;
        [self.viewController.navigationController pushViewController:controller animated:YES];
    }
    else {
        if ([instance isKindOfClass:[NSClassFromString(@"ZZTopicDetailViewController") class]]) {
            ZZTopicDetailViewController *instaceVC = (ZZTopicDetailViewController *)instance;
            instaceVC.groupId = dic[@"groupId"];
        }
        [self navigationMethod:instance push:push];
    }
}

- (void)navigationMethod:(id)instance push:(BOOL)push
{
    if (push) {
        _isPush = YES;
        
        [self.viewController.navigationController pushViewController:instance animated:YES];
    } else {
        ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:instance];
        [self.viewController presentViewController:navCtl animated:YES completion:nil];
    }
}
- (void)gotoLoginView
{
    NSLog(@"PY_登录界面%s",__func__);
    [[LoginHelper sharedInstance] showLoginViewIn:self.viewController];
}


/**
 清理缓存
 */
- (void)clearTheCache {
    //跳转回来要清理缓存,并刷新界面
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PeopleTOP_URLStr([ZZUserHelper shareInstance].loginer.uid)]]];
    }];
    
}

- (void)dealloc {
    _wkWebView.navigationDelegate = nil;
    _wkWebView.scrollView.delegate = nil;
    
    [_wkWebView removeFromSuperview];
    _wkWebView = nil;
}

@end
