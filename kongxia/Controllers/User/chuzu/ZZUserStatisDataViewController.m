//
//  ZZUserStatisDataViewController.m
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserStatisDataViewController.h"

#import "ZZRecordViewController.h"

@interface ZZUserStatisDataViewController () <UIWebViewDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL pushHideBar;

@end

@implementation ZZUserStatisDataViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _isPush = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_isPush && !_pushHideBar) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _pushHideBar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self createViews];
    
}

- (void)createViews
{
    self.view.backgroundColor = kYellowColor;
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, 60, 44)];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIImageView *leftImgView = [[UIImageView alloc] init];
    leftImgView.userInteractionEnabled = NO;
    leftImgView.image = [UIImage imageNamed:@"icon_rent_left"];
    [leftBtn addSubview:leftImgView];
    
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftBtn.mas_left).offset(15);
        make.centerY.mas_equalTo(leftBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(8, 16.5));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = @"数据统计";
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(leftBtn.mas_centerY);
    }];    
    UIView *view = [ZZViewHelper createWebView];
    view.backgroundColor = kBGColor;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
    }];
    
    _wkWebView = (WKWebView *)view;
    _wkWebView.navigationDelegate = self;
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    _wkWebView.scrollView.delegate = self;
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
    string = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"push"]) {
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:YES];

        _pushHideBar = [[aDict objectForKey:@"hidebar"] boolValue];    } else if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"present"]) {
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:NO];
    }
}

- (void)runtimePush:(NSString *)vcName dic:(NSDictionary *)dic push:(BOOL)push
{
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
    } else {
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

#pragma mark - UIButtonMethod

- (void)leftBtnClick
{
    if (_wkWebView.canGoBack) {
        [_wkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc
{
    _wkWebView.scrollView.delegate = nil;
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
