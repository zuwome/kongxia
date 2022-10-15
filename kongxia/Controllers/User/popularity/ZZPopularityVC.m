//
//  ZZPopularityVC.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/12.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZPopularityVC.h"
#import "ZZSelfIntroduceVC.h"
#import "ZZSendVideoManager.h"
#import "ZZVideoUploadStatusView.h"
#import "ZZRegisterRentViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZPopularityRulesVC.h"
@interface ZZPopularityVC () <WKNavigationDelegate,UIScrollViewDelegate,WBSendVideoManagerObserver>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic ,assign) BOOL isRefresh;

@property (nonatomic ,strong) ZZVideoUploadStatusView  *statusModel;
@property (nonatomic, strong) ZZSKModel *sk;//录制的达人视频，临时保存，更新成功后=nil
@property (nonatomic, strong) ZZUser *user;

@property (nonatomic, copy) NSString *url;

@end

@implementation ZZPopularityVC

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    if (self.isRefresh) {
          [self clearTheCache];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isRefresh = YES;
   
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    
    [GetSendVideoManager() addObserver:self];
    self.isRefresh = NO;
    [self setupUI];
   }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    _wkWebView.navigationDelegate = nil;
    _wkWebView.scrollView.delegate = nil;
    
    [_wkWebView removeFromSuperview];
    _wkWebView = nil;
}

#pragma mark - Private methods
- (void)showDetails {
    ZZPopularityRulesVC *vc = [[ZZPopularityRulesVC alloc] init];
    [vc.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)setupUI {
    
    self.view.backgroundColor = HEXCOLOR(0x262626);
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100 - 15, STATUSBAR_HEIGHT, 100, 44)];
    rightBtn.normalTitle = @"排名规则";
    rightBtn.normalTitleColor = UIColor.whiteColor;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(showDetails) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];

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
    titleLabel.text = @"冲榜攻略";
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
    
    _url = [NSString stringWithFormat:@"%@/user/%@/priority/page?v=%@", kBase_URL, [ZZUserHelper shareInstance].loginer.uid, [UIApplication version]] ;
    _url = [_url stringByReplacingOccurrencesOfString:@" " withString:@""];
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];

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
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"决定是否在其响应已知后允许或取消导航。");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"terminate");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@",error.localizedDescription);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@",error.localizedDescription);
}

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
    NSString *vcName = [aDict objectForKey:@"vcname"];
    if (vcName) {
         NSLog(@"PY_当前跳转的界面是%@",vcName);
    
        [self clickWhenH5ButtonClickJumpVCWithVCString:vcName dic:aDict];
    }
}

#pragma mark - 根据h5对应的按钮跳转到对应的iOS界面

- (void)clickWhenH5ButtonClickJumpVCWithVCString:(NSString *)vCName dic:(NSDictionary *)dic {
    NSString *can = [dic objectForKey:@"canJump"];
    Class objcVC = NSClassFromString(vCName);
    if (!objcVC) {
        NSLog(@"PY_h5跳转iOS参数错误 %@",vCName);
        return;
    }
    //跳转出租
    if ([vCName isEqualToString:@"ZZUserChuzuViewController"]) {
        if ([ZZUserHelper shareInstance].loginer.rent.status == 0) {
            WeakSelf
            ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
            registerRent.type = RentTypeRegister;
            [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
                ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }];
            [self.navigationController presentViewController:registerRent animated:YES completion:nil];
        } else {
            ZZSkillThemeManageViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if ([can isEqualToString:@"1"]) {
        //为1的时候是storboard跳转的
        NSString *identifier = [dic objectForKey:@"id"];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* controller = [sb instantiateViewControllerWithIdentifier:identifier];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        UIViewController *vc= [(UIViewController *)[objcVC alloc] init];
        if ([vc isKindOfClass:[ZZSelfIntroduceVC class]]) {
            ZZSelfIntroduceVC *introduceVC = (ZZSelfIntroduceVC *)vc;
            [self pushInstroduceVC:introduceVC];
            return;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pushInstroduceVC:(ZZSelfIntroduceVC *)introduceVC {
    introduceVC.isShowTopUploadStatus = YES;
    introduceVC.isUploadAfterCompleted = YES;
    ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
    if (loginer.base_video.status == 0) {
        introduceVC.reviewStatus = ZZVideoReviewStatusNoRecord;
        if (loginer.base_video.sk.id) {//当前有录制还未保存，也算进入成功页面
            introduceVC.reviewStatus = ZZVideoReviewStatusSuccess;
            introduceVC.loginer = loginer;
        }
    } else if (loginer.base_video.status == 1) {
        introduceVC.reviewStatus = ZZVideoReviewStatusSuccess;
        introduceVC.loginer = loginer;
    } else if (loginer.base_video.status == 2) {
        introduceVC.reviewStatus = ZZVideoReviewStatusFail;
        introduceVC.loginer = loginer;
        if (_sk) {//当_sk有值时，说明处于审核失败情况下，他又重新录制了
            introduceVC.reviewStatus = ZZVideoReviewStatusSuccess;
            introduceVC.loginer.base_video.sk = _sk;
        }
    }
    [self.navigationController pushViewController:introduceVC animated:YES];

}

/**
 清理缓存
 */
- (void)clearTheCache {
    //跳转回来要清理缓存,并刷新界面
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }];
   
}

#pragma mark - 达人视频
// 视频开始发送, 点小飞机以后
- (void)videoStartSendingVideoUploadStatus:(ZZVideoUploadStatusView *)model {
    self.statusModel = model;
}

// 视频发送进度
- (void)videoSendProgress:(NSString *)progress {
    
}

// 视频发送完成
- (void)videoSendSuccessWithVideoId:(ZZSKModel *)sk {
        _sk = sk;
    WEAK_SELF();
    // 闪租页面的录制达人视频 需要直接更新到User-服务器
    if (_statusModel.isUploadAfterCompleted) {
        _user = [ZZUserHelper shareInstance].loginer;
        if (_sk) {// 如果达人视频上传成功的话，则保存的时候需要将 sk 整个Model一起上传
            _user.base_video.sk = sk;
            _user.base_video.status = 1;
        }
        
        [ZZHUD showWithStatus:@"更新信息"];
        [_user updateWithParam:[_user toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"更新成功"];
                ZZUser *user = [ZZUser yy_modelWithJSON:data];
                [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadCompleted object:nil];
                [weakSelf clearTheCache];
            }
        }];
    }
    
    _statusModel = nil;

}

// 视频发送失败
- (void)videoSendFailWithError:(NSDictionary *)error {
    
}




- (void)leftBtnClick
{
    if (_wkWebView.canGoBack) {
        [_wkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
