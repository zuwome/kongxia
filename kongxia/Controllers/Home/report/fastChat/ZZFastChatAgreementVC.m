//
//  ZZFastChatAgreementVC.m
//  zuwome
//
//  Created by YuTianLong on 2018/1/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZFastChatAgreementVC.h"
#import "ZZSelfIntroduceVC.h"
#import "ZZFastChatSettingVC.h"
#import "ZZPerfectPictureViewController.h"
#import "ZZRealNameListViewController.h"

@interface ZZFastChatAgreementVC () <WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) ZZUser *loginer;

@end

@implementation ZZFastChatAgreementVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationWithHide:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideNavigationWithHide:YES];
}

- (void)viewWillDisappear:(BOOL)animated {//将要消失
    [super viewWillDisappear:animated];
    [self hideNavigationWithHide:NO];
    
    NSLog(@"%@将要消失", self);
}

- (void)viewDidDisappear:(BOOL)animated {//消失之后
    [super viewDidDisappear:animated];
    [self hideNavigationWithHide:NO];
    
    NSLog(@"%@消失之后", self);
}

- (void)hideNavigationWithHide:(BOOL)hidden {
    [self.navigationController setNavigationBarHidden:hidden animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogin:)
                                                 name:kMsg_UserLogin
                                               object:nil];

    [self setupUI];
}

- (void)dealloc {
    NSLog(@"%@已释放", self);
    [_wkWebView removeFromSuperview];
    _wkWebView.scrollView.delegate = nil;
    _wkWebView.navigationDelegate = nil;
    _wkWebView = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter

- (ZZUser *)loginer {
    if (!_loginer) {
        _loginer = [ZZUserHelper shareInstance].loginer;
    }
    return _loginer;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        
        UIView *view = [ZZViewHelper createWebView];
        view.backgroundColor = kBGColor;
        _wkWebView = (WKWebView *)view;
        _wkWebView.navigationDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.scrollView.delegate = self;
        _wkWebView.scrollView.scrollEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _wkWebView;
}

#pragma mark - Private methods

- (void)userDidLogin:(NSNotification *)notificatio {
    if ([ZZUserHelper shareInstance].isLogin) {

        _loginer = [ZZUserHelper shareInstance].loginer;
        
        if (_loginer.open_qchat) {//已经开通则显示介绍h5
            
            [_wkWebView removeFromSuperview];
            _wkWebView = nil;
            [self.agreeButton removeFromSuperview];
            
            _activityIndicator.hidesWhenStopped = YES;
            [_activityIndicator startAnimating];

            [self.view addSubview:self.wkWebView];
            [self.view sendSubviewToBack:self.wkWebView];
            [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.top.bottom.equalTo(@0);
            }];
            [_activityIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.wkWebView.mas_centerX);
                make.centerY.mas_equalTo(self.wkWebView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
                [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5Url.fastChatIntroduce]]];
            }];
        } else {//反则直接进入下一步
            [self agreeClick:nil];
        }
    }
}

- (void)setupUI {
    
    [self.view addSubview:self.wkWebView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_activityIndicator];
    
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.wkWebView.mas_centerX);
        make.centerY.mas_equalTo(self.wkWebView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _activityIndicator.hidesWhenStopped = YES;
    [_activityIndicator startAnimating];

    self.agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeButton setTitle:@"立即申请" forState:UIControlStateNormal];
    if (self.loginer.base_video.status == 0) {
        [_agreeButton setTitle:@"立即申请" forState:UIControlStateNormal];
    } else if (self.loginer.base_video.status == 1) {
        [_agreeButton setTitle:@"您已录制达人视频，立即申请开通" forState:UIControlStateNormal];
    } else if (self.loginer.base_video.status == 2) {
        [_agreeButton setTitle:@"达人视频审核失败，重新申请" forState:UIControlStateNormal];
    }
    [_agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_agreeButton setBackgroundColor:RGBCOLOR(244, 203, 7)];
    [_agreeButton setBackgroundImage:stretchImgFromMiddle([UIImage imageNamed:@"icon_fastChatAgreementBg"]) forState:UIControlStateNormal];
    _agreeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_agreeButton addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];

    // icon_oval1 / icon_rectangle
    UIButton *roundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [roundBtn setBackgroundImage:[UIImage imageNamed:@"icon_oval1"] forState:UIControlStateNormal];
    [roundBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];

    // right Btn
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_rectangle"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setImage:[UIImage imageNamed:@"icon_rent_left"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton sizeToFit];

    [self.view addSubview:leftBarButton];
    [self.view addSubview:self.agreeButton];
    
    [self.agreeButton addSubview:roundBtn];
    [roundBtn addSubview:rightBtn];

    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.bottom.mas_equalTo(@0);
    }];

    [leftBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(@(isIPhoneX ? 40 : 20));
        make.width.equalTo(@44);
        make.height.equalTo(@44);
    }];
    
    [_agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@27);
        make.trailing.equalTo(@(-27));
        make.bottom.equalTo(@(-10 - (isIPhoneX ? (34) : 0)));
        make.height.equalTo(@54);
    }];
    
    [roundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreeButton.mas_centerY);
        make.trailing.equalTo(@(-7.5));
        make.width.height.equalTo(@38);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(roundBtn);
        make.centerY.equalTo(roundBtn).offset(-1);//感觉有点偏下
        make.width.equalTo(@8);
        make.height.equalTo(@16.5);
    }];
    
    NSString *urlString = @"";

    if ([ZZUserHelper shareInstance].isLogin) {
        if ([ZZUserHelper shareInstance].loginer.open_qchat) {
            if ([ZZUserHelper shareInstance].loginer.base_video.status == 2) {
                //视频审核失败
                urlString = H5Url.fastChatOpeon;
            } else {
                // 有开通的情况下
                urlString = H5Url.fastChatIntroduce;
                [self.agreeButton removeFromSuperview];
                [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.trailing.top.bottom.equalTo(@0);
                }];
            }
        } else {
            urlString = H5Url.fastChatOpeon;
        }
    } else {
        urlString = H5Url.fastChatOpeon;
    }
    [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }];
}

- (void)leftClick {
    [self.navigationController popViewControllerAnimated:YES];
}

// 申请成为闪聊达人
- (IBAction)agreeClick:(UIButton *)sender {
    [MobClick event:Event_click_Open_FastChat];
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    
    if ([self isReturnWithType:NavigationTypeOpenFastChat]) {
        return;
    }
    
    WEAK_SELF();
    // 如果服务端有开启需要验证身份证，并且当前账户没有实名认证过 或者 失败，则需要再去验证身份证
    if ([ZZUserHelper shareInstance].configModel.qchat.need_idcard_verify &&
        ((self.loginer.realname.status == 0 || self.loginer.realname.status == 3) && (self.loginer.realname_abroad.status == 0 || self.loginer.realname_abroad.status == 3))) {// 需要先去完善身份证信息
        
        [UIAlertController presentAlertControllerWithTitle:@"身份信息异常，请进行身份验证" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.user = self.loginer;
                controller.isOpenFastChat = YES;
                
                [weakSelf.navigationController pushViewController:controller animated:YES];
            } else {
//                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
        return;
    }

    if (self.loginer.gender_status == 2) {// 本身性别有误，也需要验证身份证
        
        [UIAlertController presentAlertControllerWithTitle:@"身份信息异常，请进行身份验证" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.user = self.loginer;
                controller.isOpenFastChat = YES;
                
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
        }];
        return ;
    }
    if (self.loginer.base_video.status == 1) {
        //如果已经有达人视频，则直接申请成功
        NSMutableDictionary *userDic = [@{@"base_video" : [self.loginer.base_video toDictionary]} mutableCopy];
        [userDic setObject:@(YES) forKey:@"bv_from_qchat"];
        [self.loginer updateWithParam:userDic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                NSError *err;
                ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:&err];
                [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                [weakSelf gotoFastChatSetting];
            }
        }];
    } else {
        if ([ZZUserHelper shareInstance].loginer.base_video.status == 2) {
            // 审核失败
            ZZSelfIntroduceVC *vc = [ZZSelfIntroduceVC new];
            vc.reviewStatus = ZZVideoReviewStatusFail;
            vc.loginer = [ZZUserHelper shareInstance].loginer;
            vc.isFastChat = YES;
            [self.navigationController pushViewController:vc animated:YES];

        } else {
            //否则去录制达人视频
            ZZSelfIntroduceVC *vc = [ZZSelfIntroduceVC new];
            vc.isFastChat = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)gotoFastChatSetting {
    // 闪聊开通成功
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_OpenFastChat object:nil];

    ZZFastChatSettingVC *vc = [ZZFastChatSettingVC new];
    vc.isShow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    NSMutableArray<ZZViewController *> *vcs = [self.navigationController.viewControllers mutableCopy];
    [vcs removeObject:self];
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs animated:YES];
}

// 提取方法 统一判断是否需要去完善头像/人脸
- (BOOL)isReturnWithType:(NavigationType)type {
    WEAK_SELF();
    // 如果没有人脸
    if ([ZZUserHelper shareInstance].loginer.faces.count == 0) {
        
        NSString *tips = @"目前账户安全级别较低，将进行身份识别，否则不能申请开通";
        
        [UIAlertController presentAlertControllerWithTitle:tips message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            
            if (!isCancelled) {
                // 去验证人脸
                [weakSelf gotoVerifyFace:type];
            }
        }];
        return YES;
    }
    
    // 如果没有头像
    BOOL canProceed = [UserHelper canOpenQuickChatWithBlock:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
        if (!success) {
            if (infoIncompleteType == 2) {
                if (!isCancel) {
                    [weakSelf gotoUploadPicture:type];
                }
            }
        }
    }];
    if (!canProceed) {
        return YES;
    }
    return NO;
//    ZZPhoto *photo = [ZZUserHelper shareInstance].loginer.photos_origin.firstObject;
//    if (photo == nil || photo.face_detect_status != 3) {
//
//        NSString *tips = @"你未上传本人正脸五官清晰照，不能申请开通，请前往进行上传真实头像";
//
//        [UIAlertController presentAlertControllerWithTitle:tips message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
//
//            if (!isCancelled) {
//                // 去上传真实头像
//                [weakSelf gotoUploadPicture:type];
//            }
//        }];
//        return YES;
//    }
//    return NO;
}

// 没有人脸，则验证人脸
- (void)gotoVerifyFace:(NavigationType)type {
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:type inController:self];
    helper.user = [ZZUserHelper shareInstance].loginer;
    [helper start];
}

// 没有头像，则上传真实头像
- (void)gotoUploadPicture:(NavigationType)type {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.type = type;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
