 //
//  ZZLinkWebViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZLinkWebViewController.h"
#import "ZZRentViewController.h"
#import "ZZRecordViewController.h"

#import "ZZViewHelper.h"
#import "ZZRightShareView.h"
#import "ZZLinkWebNavigationView.h"
#import "ZZTopicDetailViewController.h"
#import "ZZTabBarViewController.h"
#import "ZZChatServerViewController.h"
#import "ZZIntegralNaVView.h"
#import "WXApi.h"
#import "ZZUserEditViewController.h"
#import "ZZIDPhotoManagerViewController.h"
#import "ZZPrivateChatPayManager.h"

#import "kongxia-Swift.h"
@interface ZZLinkWebViewController () <UIWebViewDelegate,WKNavigationDelegate,UIScrollViewDelegate, UIGestureRecognizerDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) ZZLinkWebNavigationView *navigationView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) ZZRightShareView *shareView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, assign) BOOL pushHideBar;
@property (nonatomic, assign) BOOL isUploadToken;
@property (nonatomic, assign) BOOL isShowedSayHiFinishedView;
/**

 是否是自定义的黑色导航是的话就要改变状态栏
 */
@property (nonatomic,assign) BOOL isCustomBlackNav;
@end

@implementation ZZLinkWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isPush) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else if (!_isHideBar) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    if (_isPushNOHideNav) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if (self.isCustomBlackNav) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 不懂为什么要 = NO
    if (!_isFromPay) {
        _isPush = NO;
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isPush && !_pushHideBar) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if (self.isCustomBlackNav) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _pushHideBar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([ZZUserHelper shareInstance].isLogin) {
        NSRange range1 = [_urlString rangeOfString:[NSString stringWithFormat:@"%@",[kBase_URL stringByReplacingOccurrencesOfString:@"https://" withString:@""]]];
        NSRange range2 = [_urlString rangeOfString:@"access_token="];
        if (range1.location != NSNotFound && range2.location == NSNotFound) {
            _urlString = [NSString stringWithFormat:@"%@?access_token=%@",_urlString,[ZZUserHelper shareInstance].oAuthToken];
        }
    }
    
    [self createViews];
    if (_isHideBar) {
        [self.view addSubview:self.navigationView];
        if (!_showShare) {
            self.navigationView.rightBtn.hidden = YES;
        }
    }
    else {
        [self createNavLeftButton];
        if (_showShare) {
            [self createRightBtn];
        }
    }
    if (_isPush&&_isShowLeftButton) {
        [self showNavLeftButton];
    }

}

- (void)navigationLeftBtnClick {
    [ZZHUD dismiss];
    if (self.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 设置黑色的背景

 @param titleNav 当前的导航的名称
 @param isUploadToken  是否上传token
 */
- (void)setCustomNavTitle:(NSString *)titleNav  isUploadToken:(BOOL)isUploadToken {
    _isCustomBlackNav = YES;
    _isUploadToken = YES;
    ZZIntegralNaVView *view = [[ZZIntegralNaVView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) titleNavLabTitile:titleNav rightTitle:nil];
    [self.view addSubview:view];
    WS(weakSelf);
    view.leftNavClickBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}

- (void)setUpLongPressAction {
    UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [self.wkWebView addGestureRecognizer:longPressed];
}

- (void)createNavLeftButton {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems =@[leftItem];
}


- (void)showNavLeftButton {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20,NAVIGATIONBAR_HEIGHT/2.0f-10, 44,44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
    [self.view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createLeftBtn {
    [self.navigationLeftBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [self.navigationLeftBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateHighlighted];
    [self.navigationLeftBtn addTarget:self action:@selector(leftDismissView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftBtnClick {
    if (IOS8_OR_LATER) {
        if (_wkWebView.canGoBack) {
            if (_isShowedSayHiFinishedView) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [_wkWebView goBack];
        }
        else {
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } else {
        if (_webView.canGoBack) {
            if (_isShowedSayHiFinishedView) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [_webView goBack];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)leftDismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createRightBtn {
    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn setImage:[UIImage imageNamed:@"icon_link_share_p"] forState:UIControlStateNormal];
    [self.navigationRightDoneBtn setImage:[UIImage imageNamed:@"icon_link_share_p"] forState:UIControlStateHighlighted];
    [self.navigationRightDoneBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightBtnClick {
    [MobClick event:Event_click_activity_right_share];
    WeakSelf;
    if (!_shareView) {
        _shareView = [[ZZRightShareView alloc] initWithFrame:[UIScreen mainScreen].bounds withController:weakSelf];
        _shareView.shareUrl = _urlString;
        _shareView.shareTitle = _shareTitle;
        _shareView.shareContent = _shareContent;
        _shareView.userImgUrl = _imgUrl;
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_imgUrl];
        _shareView.shareImg = image;
        _shareView.itemCount = 4;
        [self.view.window addSubview:_shareView];
    }
    else {
        [_shareView show];
    }
}

- (void)createViews {
    UIView *view = [ZZViewHelper createWebView];
    view.backgroundColor = kBGColor;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        if (self.isCustomBlackNav) {
            make.top.offset(NAVIGATIONBAR_HEIGHT);
        }
        else{
            make.top.offset(0);
        }
    }];
    
    NSString *oAuthToken = [ZZUserHelper shareInstance].oAuthToken;
    if (!oAuthToken) {
        oAuthToken = [ZZUserHelper shareInstance].publicToken;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    if (self.isUploadToken) {
        [request setValue:oAuthToken forHTTPHeaderField:@"X-Api-Token"];
    }
    
    if (IOS8_OR_LATER) {
        _wkWebView = (WKWebView *)view;
        _wkWebView.navigationDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.scrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
            [_wkWebView loadRequest:request ];
        }];
    }
    else {
        _webView = (UIWebView *)view;
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
            [_webView loadRequest:request];
        }];
    }
    
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

- (void)webViewSayHiAction {
    if ([ZZUserHelper shareInstance].loginer.gender != 2) {
        return;
    }
    
    if ([[ZZSayHiHelper sharedInstance] didTodayShowWithSayHiType:SayHiTypeDailyLogin]) {
        return;
    }
    
    if ([ZZUserHelper shareInstance].loginer.rent.status == 0) {
        // 非达人身份（待审核、和去申请）
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还不是达人，暂时无法获取私信收益。去申请成为达人" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不体验" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"去申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self jumpToMyPage];
        }];
        [alertController addAction:doneAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([ZZUserHelper shareInstance].loginer.rent.status == 1) {
        if ([UserHelper.loginer isAvatarManualReviewing]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"头像正在人工审核中，暂时无法获取私信收益，请等待审核结果" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:doneAction];
            
            UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            if ([rootVC presentedViewController] != nil) {
                rootVC = [UIAlertController findAppreciatedRootVC];
            }
            [rootVC presentViewController:alertController animated:YES completion:nil];
        }
        else {
            [UIAlertController presentAlertControllerWithTitle:@"温馨提示"
                                                       message:@"您未上传本人正脸五官清晰照，暂不可体验一键打招呼"
                                                     doneTitle:@"去上传"
                                                   cancelTitle:@"取消"
                                                 completeBlock:^(BOOL isCancelled) {
                                                     if (!isCancelled) {
                                                         [self gotoUploadPicture];
                                                     }
                                                 }];
        }
    }
    else if ([ZZUserHelper shareInstance].loginer.rent.status == 2) {
        // 已是达人
        if ([ZZUserHelper shareInstance].loginer.open_charge) {
            // 开启私信收益
            [self showSayHi:NO];
        }
        else {
            // 未开启私信收益
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您未开启私信收益，无法获得私信打赏" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不体验" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self openOpenCharge];
            }];
            [alertController addAction:doneAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else if ([ZZUserHelper shareInstance].loginer.rent.status == 3) {
        // 被下架
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您已被系统下架, 暂时无法体验一键打招呼, 请联系客服更改达人状态" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)jumpToMyPage {
    ZZTabBarViewController *rootVC = (ZZTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [rootVC setSelectIndex:3];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openOpenCharge {
    [ZZPrivateChatPayManager modifyPrivateChatPayState:1 callBack:^(NSInteger state) {
        if (state != -1) {
            [ZZHUD showTaskInfoWithStatus:@"私信收益开启成功"];
            [self showSayHi:YES];
        }
    }];
}

- (void)showSayHi:(BOOL)needDelay {
    WeakSelf
    [[ZZSayHiHelper sharedInstance] showSayHiWithType:SayHiTypeDailyLogin canAlwaysShow:YES finishBlock:^(BOOL isEmpty) {
        _isShowedSayHiFinishedView = YES;
        if (isEmpty) {
            ZZLinkWebViewController *webview = [[ZZLinkWebViewController alloc] init];
            webview.urlString = H5Url.inviteDaren;
            webview.isPush = YES;
            webview.isHideBar = YES;
            webview.hidesBottomBarWhenPushed = YES;
            NSMutableArray<__kindof UIViewController *> *arr = weakSelf.navigationController.viewControllers.mutableCopy;
            if (arr.count > 0 && [arr.lastObject isKindOfClass: [ZZLinkWebViewController class]]) {
                [arr removeLastObject];
            }
            [arr addObject:webview];
            [weakSelf.navigationController setViewControllers:arr.copy animated:NO];
        }
    }];
}

/**
 没有头像，则上传真实头像
 */
- (void)gotoUploadPicture {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    //    vc.from = _user;//不需要用到
    vc.type = NavigationTypePublishTask;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = request.URL;
    NSString *scheme = URL.absoluteString;
    NSLog(@"%@",scheme);

    if ([self isContainStingWithSumString:scheme]) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = URL.absoluteString;
    NSLog(@"%@",scheme);
    
    if ([self isContainStingWithSumString:scheme]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

- (BOOL)isContainStingWithSumString:(NSString *)string {
    string = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSRange range = [string rangeOfString:@"zwmscheme://"];
    if (range.location == NSNotFound) {
        if ([string isEqualToString:@"weixin://"]) {
            //判断是否安装了微信
            if (![WXApi isWXAppInstalled]) {
                [UIAlertController presentAlertControllerWithTitle:@"当前设备尚未安装微信" message:nil doneTitle:@"我知道了" cancelTitle:nil completeBlock:nil];
            }
            else{
                NSURL * url = [NSURL URLWithString:@"weixin://"];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                //先判断是否能打开该url
                if (canOpen)
                {   //打开微信
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
            return YES;
        }
        return NO;
    }
    else {
        [self managerScheme:string];
        return YES;
    }
   
}

- (void)managerScheme:(NSString *)scheme {
    NSString *jsonString = [scheme stringByReplacingOccurrencesOfString:@"zwmscheme://" withString:@""];
    NSDictionary *dictionary = [ZZUtils dictionaryWithJsonString:jsonString];
    NSDictionary *aDict = [dictionary objectForKey:@"iOS"];
    NSString *pushmethod = [aDict objectForKey:@"pushmethod"];
    if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"push"]) {
        
        if ([aDict[@"vcname"] isEqualToString:@"ThemeManageActivity"]) {
            // 获取更高收益的返回
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        if ([aDict[@"vcname"] isEqualToString:@"HomeGreetingActivity"]) {
            // 获取更高收益
            [self webViewSayHiAction];
            return;
        }
        
        if ([aDict[@"vcname"] isEqualToString:@"ZZIDPhotoManagerViewController"]) {
            // 如果没登录，需先登录
            if (![ZZUserHelper shareInstance].isLogin) {
                [self gotoLoginView];
                return;
            }
                
            [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:YES];
            return;
        }
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:YES];
        _pushHideBar = [[aDict objectForKey:@"hidebar"] boolValue];
    }
    else if ([[aDict objectForKey:@"pushmethod"] isEqualToString:@"present"]) {
        [self runtimePush:[aDict objectForKey:@"vcname"] dic:[aDict objectForKey:@"dic"] push:NO];
    }
    else  if ([[aDict objectForKey:@"vcname"] isEqualToString:@"appStoreAccent"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://finance-app.itunes.apple.com/account/edit/billing-info"]];
    }
    else if ([[aDict objectForKey:@"vcname"] isEqualToString:@"savePic"]) {
        if (aDict[@"pic"] != NULL && [aDict[@"pic"] isKindOfClass: [NSString class]]) {
            NSString *pic = (NSString *)aDict[@"pic"];
            
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"是否保存图片到相册" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self saveImageToDiskWithUrl:pic];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertVC addAction:okAction];
            [alertVC addAction:cancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
    else if ([pushmethod rangeOfString:@"tabbar-"].location != NSNotFound) {
        ZZTabBarViewController *controller = [ZZTabBarViewController sharedInstance];
        NSInteger integer = [[pushmethod replaceOldString:@"tabbar-" WithNewString:@""] integerValue];
        [controller setSelectIndex:integer];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    

}

- (void)runtimePush:(NSString *)vcName dic:(NSDictionary *)dic push:(BOOL)push {
    // 如果没登录，需先登录
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
    }
    else if ([instance isKindOfClass:[ZZChatServerViewController class]]) {
        ZZChatServerViewController *chatService = [[ZZChatServerViewController alloc] init];
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = kCustomerServiceId;
        chatService.title = @"客服";
        chatService.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController :chatService animated:YES];
    }
    else if ([instance isKindOfClass:[ZZIDPhotoManagerViewController class]]) {
        _isPush = YES;
        ZZIDPhotoManagerViewController *viewControoler = [[ZZIDPhotoManagerViewController alloc] init];
        viewControoler.hidesBottomBarWhenPushed = YES;
        viewControoler.isComingFromWebView = YES;
        [self.navigationController pushViewController:viewControoler
                                             animated:YES];
    }
    else {
        if ([instance isKindOfClass:[NSClassFromString(@"ZZTopicDetailViewController") class]]) {
            ZZTopicDetailViewController *instaceVC = (ZZTopicDetailViewController *)instance;
            instaceVC.groupId = dic[@"groupId"];
        }
        [self navigationMethod:instance push:push];
    }
}

- (void)navigationMethod:(id)instance push:(BOOL)push {
    if (push) {
        _isPush = YES;
        [self.navigationController pushViewController:instance animated:YES];
    }
    else {
        ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:instance];
        [self presentViewController:navCtl animated:YES completion:nil];
    }
}

- (void)saveImageToDiskWithUrl:(NSString *)imageUrl{
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
    
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    NSURLSessionDownloadTask  *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return ;
        }
        NSData * imageData = [NSData dataWithContentsOfURL:location];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage * image = [UIImage imageWithData:imageData];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
    
    [task resume];
}

#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo{
    NSString*message =@"";
    if(!error) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"成功保存到相册" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else{
        message = [error description];
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isHideNavigationBarWhenUp) {
        return;
    }
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat scale = 0;
    
    if (offset <= 0) {
        scale = 0;
    } else if (0 < offset && offset < NAVIGATIONBAR_HEIGHT) {
        scale = offset / NAVIGATIONBAR_HEIGHT;
    } else {
        scale = 1;
    }
    [self.navigationView setViewAlphaScale:scale];
}

- (ZZLinkWebNavigationView *)navigationView {
    WeakSelf;
    if (!_navigationView) {
        _navigationView = [[ZZLinkWebNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        _navigationView.touchLeft = ^{
            [weakSelf leftBtnClick];
        };
        _navigationView.touchRight = ^{
            [weakSelf rightBtnClick];
        };
    }
    return _navigationView;
}

- (void)dealloc {
    _webView.scrollView.delegate = nil;
    _wkWebView.scrollView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
