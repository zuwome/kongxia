//
//  ZZRentalAgreementVC.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/12.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZRentalAgreementVC.h"
#import "ZZUserChuzuViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSkillThemeManageViewController.h"

@interface ZZRentalAgreementVC () <WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *selectIconButton;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) ZZUser *loginer;

@end

@implementation ZZRentalAgreementVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationWithHide:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideNavigationWithHide:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideNavigationWithHide:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideNavigationWithHide:NO];
}

- (void)hideNavigationWithHide:(BOOL)hidden {
    [self.navigationController setNavigationBarHidden:hidden animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    _wkWebView.scrollView.delegate = nil;
    _wkWebView.navigationDelegate = nil;
    
    [self.wkWebView removeFromSuperview];
    self.wkWebView = nil;
}

#pragma mark - Getter & Setter

- (ZZUser *)loginer {
    if (!_loginer) {
        _loginer = [ZZUserHelper shareInstance].loginer;
    }
    return _loginer;
}

#pragma mark - Private methods

- (void)setupUI {
    
    UIView *view = [ZZViewHelper createWebView];
    view.backgroundColor = kBGColor;
    [self.view addSubview:view];
    
    NSString *urlString = [NSString stringWithFormat:H5Url.becomeShanZuDaren];
    _wkWebView = (WKWebView *)view;
    _wkWebView.navigationDelegate = self;
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    _wkWebView.scrollView.delegate = self;
    _wkWebView.scrollView.scrollEnabled = NO;
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
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
    
    self.selectIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.selectIconButton setBackgroundImage:[UIImage imageNamed:@"iconUnselected"] forState:UIControlStateNormal];
//    [self.selectIconButton setBackgroundImage:[UIImage imageNamed:@"iconSelected"] forState:UIControlStateSelected];
//    self.selectIconButton.selected = YES;
    [self.selectIconButton setTitle:@"继续申请即表示同意" forState:UIControlStateNormal];
    [self.selectIconButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    self.selectIconButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectIconButton addTarget:self action:@selector(selectIconClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectIconButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    UIButton *seeProtocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeProtocolButton setTitle:@"《达人邀约服务协议》" forState:UIControlStateNormal];
    [seeProtocolButton setTitleColor:RGBCOLOR(74, 144, 226) forState:UIControlStateNormal];
    seeProtocolButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [seeProtocolButton addTarget:self action:@selector(seeProtocolClick:) forControlEvents:UIControlEventTouchUpInside];
    seeProtocolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeButton setTitle:@"申请成为达人" forState:UIControlStateNormal];
    [agreeButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    [agreeButton setBackgroundColor:RGBCOLOR(244, 203, 7)];
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [agreeButton addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setImage:[UIImage imageNamed:@"icon_rent_left"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton sizeToFit];
    
    [self.view addSubview:leftBarButton];
    [self.view addSubview:agreeButton];
    [self.view addSubview:self.selectIconButton];
    [self.view addSubview:seeProtocolButton];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(agreeButton.mas_top);
    }];

    [leftBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.top.equalTo(@(isIPhoneX ? 50 : 30));
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@(isIPhoneX ? (-34) : 0));
        make.height.equalTo(@50);
    }];
    
    [seeProtocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(agreeButton.mas_top).offset(-20);
        make.leading.equalTo(self.view.mas_centerX).offset(2);
        make.trailing.equalTo(@(-5));
        make.height.equalTo(@30);
    }];
    
    [self.selectIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(seeProtocolButton.mas_centerY);
        make.height.equalTo(@30);
        make.trailing.equalTo(self.view.mas_centerX).offset(-2);
        make.leading.equalTo(@5);
    }];
}

// 查看协议
- (IBAction)seeProtocolClick:(UIButton *)sender {
    
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = H5Url.invitationServiceAgreement;
    controller.hidesBottomBarWhenPushed = YES;
    controller.navigationItem.title = @"达人邀约服务协议";
    [self.navigationController pushViewController:controller animated:YES];
}

// 是否打钩
- (IBAction)selectIconClick:(UIButton *)sender {
    sender.selected = sender.isSelected ? NO : YES;
}

// 同意协议
- (IBAction)agreeClick:(UIButton *)sender {
        
    [ZZKeyValueStore saveValue:@"firstProtocol" key:[ZZStoreKey sharedInstance].firstProtocol];
    [self gotoUserChuZuVC];
}

- (void)gotoUserChuZuVC {
    [MobClick event:Event_click_me_rent];
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ZZUserChuzuViewController *controller = [sb instantiateViewControllerWithIdentifier:@"rentStart"];
//    controller.user = _loginer;
//    controller.hidesBottomBarWhenPushed = YES;
    //未出租状态前往申请达人，其余状态进入主题管理
    ZZViewController *controller = nil;
    if (_loginer.rent.status == 0) {
        controller = [[ZZChooseSkillViewController alloc] init];
    } else {
        controller = [[ZZSkillThemeManageViewController alloc] init];
    }
    controller.hidesBottomBarWhenPushed = YES;
    
    NSMutableArray<ZZViewController *> *vcs = [self.navigationController.viewControllers mutableCopy];
    [vcs removeObject:self];
    [vcs addObject:controller];
    [self.navigationController setViewControllers:vcs animated:YES];
}

- (void)leftClick {
    [self.navigationController popViewControllerAnimated:YES];
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

@end
