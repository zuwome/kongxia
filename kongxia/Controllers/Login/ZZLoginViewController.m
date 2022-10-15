//
//  ZZLoginViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZLoginViewController.h"
#import "ZZSignUpS1ViewController.h"
#import "ZZCodeSignViewController.h"
#import "ZZForgetS1ViewController.h"
#import "ZZInternationalCityViewController.h"
#import "ZZProtocolViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "ZZLoginAlertView.h"
#import "ZZPhoneInputView.h"
#import "ZZPasswordInputView.h"
#import "ZZPayHelper.h"
#import "ZZActivityUrlNetManager.h"//活动管理类
#import "ZZProtocalChooseView.h"

#import "AppleIDSignInHelper.h"
#import "ZZLivenessHelper.h"

@interface ZZLoginViewController ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic, strong) ZZLoginAlertView *alertView;
@property (nonatomic, strong) ZZPhoneInputView *phoneView;
@property (nonatomic, strong) ZZPasswordInputView *pwdView;
@property (nonatomic, strong) ZZProtocalChooseView *protocalView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *wxBtn;
@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic, strong) UIButton *wbBtn;
@property (nonatomic, strong) UIButton *codeLoginBtn;
@property (nonatomic, strong) UIButton *forgetBtn;


@property (nonatomic, strong) ZZUser *loginer;
@property (nonatomic, assign) BOOL isPublick;

@property (nonatomic, strong) UIButton *appleIDBtn;

@property (nonatomic, strong) AppleIDSignInHelper *appleSignInHelper;

@end

@implementation ZZLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popupWindowTips:) name:kMsg_NoticeToWindows object:nil];
    self.navigationItem.title = @"登录";
    self.navigationController.navigationBar.barTintColor = kGoldenRod;
    
    self.view.backgroundColor = kBGColor;
    [self createNavigationView];
    [self createViews];
}

- (void)popupWindowTips:(NSNotification *)notification {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的帐号在其它设备登陆" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

- (void)createNavigationView
{
    [self.navigationLeftBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [self.navigationLeftBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateHighlighted];
    [self.navigationLeftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 20);
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *leftBarButon = [[UIBarButtonItem alloc]initWithCustomView:btn];
    //    btnItem.width = kLeftEdgeInset;
    self.navigationItem.rightBarButtonItems = @[btnItem, leftBarButon];
}

- (void)createViews
{
    [self.view addSubview:self.protocalView];
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.pwdView];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.codeLoginBtn];
    [self.view addSubview:self.forgetBtn];
    [self.view addSubview:self.wxBtn];
    [self.view addSubview:self.wbBtn];
    [self.view addSubview:self.qqBtn];
    
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(20.0);
        make.height.equalTo(@50);
    }];
    
    [_pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_phoneView.mas_bottom).offset(10.0);
        make.height.equalTo(@50);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@50);
        make.top.equalTo(_pwdView.mas_bottom).offset(15);
    }];

    [_codeLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(_loginBtn.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(90, 36));
    }];

    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(_loginBtn.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(90, 36));
    }];
    
    [_protocalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(280));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        }
    }];
    
    if (self.appleSignInHelper.canuserAppleIDSignIn) {
        CGFloat offset = (SCREEN_WIDTH - 4 * 45) / 5;
        
        [self.view addSubview:self.appleIDBtn];
        
        [self.wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(offset);
            make.bottom.mas_equalTo(self.wbBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
        [self.wbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.wxBtn.mas_right).offset(offset);
            make.bottom.mas_equalTo(_protocalView.mas_top).offset(-10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];

        [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.wbBtn.mas_right).offset(offset);
            make.bottom.mas_equalTo(self.wbBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
        [self.appleIDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.qqBtn.mas_right).offset(offset);
            make.bottom.mas_equalTo(self.wbBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
    }
    else {
        [self.wbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(_protocalView.mas_top).offset(-10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
        [self.wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.loginBtn.mas_left).offset(30);
            make.bottom.mas_equalTo(self.wbBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
        [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.loginBtn.mas_right).offset(-30);
            make.bottom.mas_equalTo(self.wbBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
    }
    
    
    
    UILabel *infoLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentCenter textColor:kGrayTextColor fontSize:13 text:@"or社交账号快速登录"];
    [self.view addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.wbBtn.mas_top).offset(-10);
    }];
    
    WeakSelf;
    self.phoneView.touchCode = ^{
        [weakSelf gotoInternationalCityView];
    };
    
    if (![WXApi isWXAppInstalled]) {
        self.wxBtn.hidden = YES;
    }
}

#pragma mark - UIButtonMethod

- (void)leftBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBtnClick
{
    [MobClick event:Event_click_login_register];
    [self.view endEditing:YES];
    ZZSignUpS1ViewController *controller = [[ZZSignUpS1ViewController alloc] init];
    controller.phoneString = _phoneView.textField.text;
    controller.codeString = _phoneView.codeLabel.text;
    controller.user = _loginer;
    controller.isFromAliAuthen = _isFromAliAuthen;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)codeLoginBtnClick {
    [MobClick event:Event_click_login_codelogin];
    [self gotoCodeSignView:YES];
}

- (void)forgetBtnClick
{
    [MobClick event:Event_click_login_forget];
    [self.view endEditing:YES];
    ZZForgetS1ViewController *controller = [[ZZForgetS1ViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)wxBtnClick
{
    [MobClick event:Event_click_login_wx];
    [self.view endEditing:YES];
    
//    if (!_protocalView.isSelected) {
//        [self.alertView showAlertMsg:@"没有同意使用条款"];
//        return;
//    }
    
    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (!error) {
            UMSocialAuthResponse *response = result;
            if (response.openid && response.uid) {
                [ZZHUD showWithStatus:@"正在登录..."];
                [[ZZUser new] loginWithWechat:response.openid token:response.accessToken next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showInfoWithStatus:error.message];
                    } else {
                        [ZZHUD dismiss];
                        WeakSelf;
                        BOOL accountCancel = [self isUserAccountCancel:data block:^{
                            if ([weakSelf loginEndByResData:data]) {
                                if (weakSelf.isPublick) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self dismissViewControllerAnimated:YES completion:^{
                                            if ([ZZUserHelper shareInstance].location) {
                                                [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                                            }
                                        }];
                                    });
                                }
                            } else {
                                weakSelf.loginer.wechat.wx = response.openid;
                                weakSelf.loginer.wechat.unionid = data[@"user"][@"wechat"][@"unionid"];
                                [weakSelf rightBtnClick];
                            }
                        }];
                        if (!accountCancel) {
                            if ([self loginEndByResData:data]) {
                                if (_isPublick) {
                                    return ;
                                }
                                
                                
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self dismissViewControllerAnimated:YES completion:^{
                                        if ([ZZUserHelper shareInstance].location) {
                                            [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                                        }
                                    }];
                                });
                            } else {
                                _loginer.wechat.wx = response.openid;
                                _loginer.wechat.unionid = data[@"user"][@"wechat"][@"unionid"];
                                [self rightBtnClick];
                            }
                        }
                    }
                }];
            } else {
                [ZZHUD showErrorWithStatus:@"登录错误"];
            }
        }
    }];
}

- (void)wbBtnClick
{
    [MobClick event:Event_click_login_wb];
    [self.view endEditing:YES];

//    if (!_protocalView.isSelected) {
//        [self.alertView showAlertMsg:@"没有同意使用条款"];
//        return;
//    }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *userInfo = result;
        if (userInfo.iconurl) {
            [[ZZUser new] loginWithWeibo:userInfo.uid token:userInfo.accessToken nick:userInfo.name avatar:userInfo.iconurl profileURL:[NSString stringWithFormat:@"http://weibo.com/u/%@",userInfo.uid] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    [ZZHUD showInfoWithStatus:error.message];
                } else {
                    [ZZHUD dismiss];
                    WeakSelf;
                    BOOL accountCancel = [self isUserAccountCancel:data block:^{
                        if ([weakSelf loginEndByResData:data]) {
                            if (!weakSelf.isPublick) {
                                NSDictionary *param = @{@"weibo":@{@"access_token":userInfo.accessToken,
                                                                   @"uid":userInfo.uid,
                                                                   @"userName":userInfo.name,
                                                                   @"iconURL":userInfo.iconurl,
                                                                   @"profileURL":[NSString stringWithFormat:@"http://weibo.com/u/%@",userInfo.uid]}};
                                [[ZZUserHelper shareInstance] updateUserWeiboWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                    if (data) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [weakSelf dismissViewControllerAnimated:YES completion:^{
                                                if ([ZZUserHelper shareInstance].location) {
                                                    [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                                                }
                                            }];
                                        });
                                    }
                                }];
                            }
                        } else {
                            weakSelf.loginer.weibo.uid = userInfo.uid;
                            weakSelf.loginer.weibo.iconURL = userInfo.iconurl;
                            weakSelf.loginer.weibo.userName = userInfo.name;
                            weakSelf.loginer.weibo.profileURL = [NSString stringWithFormat:@"http://weibo.com/u/%@",userInfo.uid];
                            weakSelf.loginer.weibo.accessToken = userInfo.accessToken;
                            [weakSelf rightBtnClick];
                        }
                    }];
                    if (!accountCancel) {
                        if ([self loginEndByResData:data]) {
                            if (_isPublick) {
                                return ;
                            }
  
                            NSDictionary *param = @{@"weibo":@{@"uid":userInfo.uid,
                                                               @"userName":userInfo.name,
                                                               @"iconURL":userInfo.iconurl,
                                                               @"profileURL":[NSString stringWithFormat:@"http://weibo.com/u/%@",userInfo.uid]}};
                            [[ZZUserHelper shareInstance] updateUserWeiboWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                if (data) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self dismissViewControllerAnimated:YES completion:^{
                                            
                                            if ([ZZUserHelper shareInstance].location) {
                                                [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                                            }
                                        }];
                                    });
                                }
                            }];
                        } else {
                            _loginer.weibo.uid = userInfo.uid;
                            _loginer.weibo.iconURL = userInfo.iconurl;
                            _loginer.weibo.userName = userInfo.name;
                            _loginer.weibo.profileURL = [NSString stringWithFormat:@"http://weibo.com/u/%@",userInfo.uid];
                            _loginer.weibo.accessToken = userInfo.accessToken;
                            [self rightBtnClick];
                        }
                    }
                }
            }];
        } else {
            [ZZHUD showErrorWithStatus:@"登录错误"];
        }
    }];
}

- (void)qqBtnClick
{
    [MobClick event:Event_click_login_qq];
    [self.view endEditing:YES];
    
//    if (!_protocalView.isSelected) {
//        [self.alertView showAlertMsg:@"没有同意使用条款"];
//        return;
//    }
    
    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        if (!error) {
            UMSocialAuthResponse *response = result;
            if (response.openid) {
                [[ZZUser new] loginWithQQ:response.uid token:response.accessToken next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showInfoWithStatus:error.message];
                    } else {
                        [ZZHUD dismiss];
                        WeakSelf;
                        BOOL accountCancel = [self isUserAccountCancel:data block:^{
                            if ([weakSelf loginEndByResData:data]) {
                                if (!weakSelf.isPublick) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [weakSelf dismissViewControllerAnimated:YES completion:^{
                                            if ([ZZUserHelper shareInstance].location) {
                                                [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                                            }
                                        }];
                                    });
                                }
                            } else {
                                weakSelf.loginer.qq.openid = response.openid;
                                [weakSelf rightBtnClick];
                            }
                        }];
                        if (!accountCancel) {
                            if ([self loginEndByResData:data]) {
                                if (_isPublick) {
                                    return ;
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self dismissViewControllerAnimated:YES completion:^{
                                
                                        if ([ZZUserHelper shareInstance].location) {
                                            [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                                        }
                                    }];
                                });
                            } else {
                                _loginer.qq.openid = response.openid;
                                [self rightBtnClick];
                            }
                        }
                    }
                }];
            } else {
                [ZZHUD showErrorWithStatus:@"登录错误"];
            }
        }
    }];
}

- (void)appleIDBtnClick {
    // 苹果ID 登录

    WeakSelf
    [self.appleSignInHelper signIn:^(NSDictionary *appleIDSignInInfos, NSError *error) {
        if (error) {
            if (error.code != 1001) {
                [ZZHUD showErrorWithStatus:error.localizedDescription];
            }
        }
        else {
            [ZZHUD show];
            [ZZRequest method:@"POST" path:@"/user/verify_id_token" params:appleIDSignInInfos next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                }
                else {
                    [ZZHUD dismiss];
                    if (!data[@"action"]) {
                        BOOL accountCancel = [self isUserAccountCancel:data block:^{
                            if ([weakSelf loginEndByResData:data]) {
                                if (weakSelf.isPublick) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self dismissViewControllerAnimated:YES completion:^{
                                            if ([ZZUserHelper shareInstance].location) {
                                                [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                                            }
                                        }];
                                    });
                                }
                            }
                            else {
                                ZZAppleIDSignIn *signIn = [[ZZAppleIDSignIn alloc] init];
                                signIn.user = appleIDSignInInfos[@"user"];
                                signIn.identityToken = appleIDSignInInfos[@"identityToken"];
                                signIn.authorizationCode = appleIDSignInInfos[@"authorizationCode"];
                                weakSelf.loginer.appleIDSignIn = signIn;
                                [weakSelf rightBtnClick];
                            }
                        }];
                        
                        if (!accountCancel) {
                            if ([self loginEndByResData:data]) {
                                if (_isPublick) {
                                    return ;
                                }
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self dismissViewControllerAnimated:YES completion:^{
                                        if ([ZZUserHelper shareInstance].location) {
                                            [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                                        }
                                    }];
                                });
                            } else {
                                ZZAppleIDSignIn *signIn = [[ZZAppleIDSignIn alloc] init];
                                signIn.user = appleIDSignInInfos[@"user"];
                                signIn.identityToken = appleIDSignInInfos[@"identityToken"];
                                signIn.authorizationCode = appleIDSignInInfos[@"authorizationCode"];
                                weakSelf.loginer.appleIDSignIn = signIn;
                                [self rightBtnClick];
                            }
                        }
                    }
                    else if([data[@"action"] isEqualToString:@"reauth"]) {
                        [ZZHUD showErrorWithStatus:@"认证过期,重新认证"];
                        [self appleIDBtnClick];
                    }
                    else {
                        if (!weakSelf.loginer) {
                            weakSelf.loginer = [[ZZUser alloc] init];
                        }
                        
                        ZZAppleIDSignIn *signIn = [[ZZAppleIDSignIn alloc] init];
                        signIn.user = appleIDSignInInfos[@"user"];
                        signIn.identityToken = appleIDSignInInfos[@"identityToken"];
                        signIn.authorizationCode = appleIDSignInInfos[@"authorizationCode"];
                        weakSelf.loginer.appleIDSignIn = signIn;
                        [self rightBtnClick];
                    }
                }
                
            }];
        }
    }];
}

- (void)loginBtnClick
{
    [MobClick event:Event_click_login_login];
    if (_phoneView.textField.text.length == 0) {
        [self.alertView showAlertMsg:@"手机号不能为空"];
        return;
    }
    
//    if (!_protocalView.isSelected) {
//        [self.alertView showAlertMsg:@"没有同意使用条款"];
//        return;
//    }
    
    ZZUser *user = [[ZZUser alloc] init];
    [self.view endEditing:YES];
    [ZZHUD showWithStatus:@"正在登录..."];
    NSDictionary *aDict = @{@"phone":[_phoneView.textField.text trimmedString],
                            @"password":_pwdView.textField.text,
                            @"country_code":_phoneView.codeLabel.text};
    [user login:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZHUD dismiss];
        if (error) {
            if (error.code == 4044) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIAlertView showWithTitle:@"提示" message:@"该手机尚未注册，请点击立即注册" cancelButtonTitle:@"取消" otherButtonTitles:@[@"立即注册"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [self rightBtnClick];
                        }
                    }];
                });
            } else if (error.code == 4045) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIAlertView showWithTitle:@"提示" message:@"密码错误，请选择验证码登录或重新输入" cancelButtonTitle:@"重新输入" otherButtonTitles:@[@"验证码登录"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [self gotoCodeSignView:NO];
                        }
                    }];
                });
            }else if (error.code == 8000) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     [UIAlertController presentAlertControllerWithTitle:@"提示" message:error.message doneTitle:@"知道了" cancelTitle:nil showViewController:self completeBlock:nil];
                });
            }
            else {
                [self.alertView showAlertMsg:error.message];
            }

        } else {
            WeakSelf;
            BOOL accountCancel = [self isUserAccountCancel:data block:^{
                [weakSelf loginEndByResData:data];
                if (!weakSelf.isPublick) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf dismissViewControllerAnimated:YES completion:^{
                            if ([ZZUserHelper shareInstance].location) {
                                [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                            }
                        }];
                    });
                }
            }];
            if (!accountCancel) {
                
                [self loginEndByResData:data];
                if (!_isPublick) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view endEditing:YES];
                        [self dismissViewControllerAnimated:YES completion:^{
                            if ([ZZUserHelper shareInstance].location) {
                                [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                            }
                        }];
                    });
                }
            }
        }
    }];
}

- (BOOL)isUserAccountCancel:(id)data block:(void (^)(void))block
{
    [self.view endEditing:YES];
  
    _loginer = [ZZUser yy_modelWithJSON:data[@"user"]]; //[[ZZUser alloc] initWithDictionary:data[@"user"] error:nil];
    if (_loginer.have_close_account) {
        ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
        userHelper.uploadToken = data[@"upload_token"];
        [UIAlertView showWithTitle:@"该帐号已被注销" message:@"是否重新启用该帐号" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认启用"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                NSLog(@"PY_先进行人脸识别");
                [ZZUserHelper shareInstance].publicToken = data[@"access_token"];
                ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeRestartPhone inController:self];
                helper.checkSuccess = ^{
                    [ZZRequest method:@"POST" path:@"/api/user/account/recover" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                        if (error) {
                            [ZZHUD showErrorWithStatus:error.message];
                        } else {
                            [ZZHUD showSuccessWithStatus:@"您的账号已被重新激活"];
                            block();
                        }
                    }];
                };
                [helper start];
            }
        }];
        return YES;
    }
    return NO;
}

- (BOOL)loginEndByResData:(id)data
{
    ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
    userHelper.uploadToken = data[@"upload_token"];
    
    if (!data[@"access_token"]) {
        return NO;
    }
    if (!_loginer.phone) {
        ZZSignUpS1ViewController *s1 = [[ZZSignUpS1ViewController alloc] init];
        s1.phoneString = _phoneView.textField.text;
        s1.codeString = _phoneView.codeLabel.text;
        s1.user = _loginer;
        s1.isUpdatePhone = YES;
        [self.navigationController pushViewController:s1 animated:YES];
        _isPublick = YES;
        userHelper.publicToken = data[@"access_token"];
        return YES;
    }
    if (data[@"access_token"]) {
        userHelper.oAuthToken = data[@"access_token"];
        [userHelper saveLoginer:[_loginer toDictionary] postNotif:YES];
        userHelper.countryCode = _phoneView.codeLabel.text;
        
           //登录成功开启内购漏单检测
        [ZZPayHelper startManager];
        [ZZActivityUrlNetManager requestHtmlActivityUrlDetailInfo];//h5活动页

        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserLogin object:self];
     
        
        return YES;
    } else {
        return NO;
    }
}

- (void)gotoLiveCheck
{
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeUserLogin inController:self];
    helper.user = _loginer;
    [helper start];
}

- (void)gotoInternationalCityView
{
    [self.view endEditing:YES];
    WeakSelf;
    ZZInternationalCityViewController *controller = [[ZZInternationalCityViewController alloc] init];
    controller.selectedCode = ^(NSString *code){
        weakSelf.phoneView.text = code;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoCodeSignView:(BOOL)showInfo
{
    [self.view endEditing:YES];
    ZZCodeSignViewController *controller = [[ZZCodeSignViewController alloc] init];
    controller.phoneString = _phoneView.textField.text;
    controller.codeString = _phoneView.codeLabel.text;
    controller.showInfo = showInfo;
    controller.isFromAliAuthen = _isFromAliAuthen;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoProtocalView
{
    [self.view endEditing:YES];
    ZZProtocolViewController *contrller = [[ZZProtocolViewController alloc] init];
    [self.navigationController pushViewController:contrller animated:YES];
}

- (void)gotoPrivate {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = H5Url.privacyProtocol;
    controller.navigationItem.title = @"空虾隐私权政策";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Lazyload

- (ZZLoginAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[ZZLoginAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        [self.view addSubview:_alertView];
    }
    
    return _alertView;
}

- (ZZPhoneInputView *)phoneView
{
    if (!_phoneView) {
        _phoneView = [[ZZPhoneInputView alloc] initWithFrame:CGRectZero];
    }
    
    return _phoneView;
}

- (ZZPasswordInputView *)pwdView
{
    WeakSelf;
    if (!_pwdView) {
        _pwdView = [[ZZPasswordInputView alloc] initWithFrame:CGRectZero];
        _pwdView.textField.returnKeyType = UIReturnKeyDone;
        _pwdView.textField.enablesReturnKeyAutomatically = YES;
        _pwdView.touchReturn = ^{
            [weakSelf loginBtnClick];
        };
    }
    
    return _pwdView;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _pwdView.bottom + 15, SCREEN_WIDTH - 40, 50)];
        _loginBtn.backgroundColor = kYellowColor;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginBtn;
}

- (UIButton *)wxBtn
{
    if (!_wxBtn) {
        _wxBtn = [[UIButton alloc] init];
        [_wxBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [_wxBtn addTarget:self action:@selector(wxBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _wxBtn;
}

- (UIButton *)wbBtn
{
    if (!_wbBtn) {
        _wbBtn = [[UIButton alloc] init];
        [_wbBtn setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
        [_wbBtn addTarget:self action:@selector(wbBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _wbBtn;
}

- (UIButton *)qqBtn
{
    if (!_qqBtn) {
        _qqBtn = [[UIButton alloc] init];
        [_qqBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [_qqBtn addTarget:self action:@selector(qqBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _qqBtn;
}

- (UIButton *)appleIDBtn
{
    if (!_appleIDBtn) {
        _appleIDBtn = [[UIButton alloc] init];
        [_appleIDBtn setImage:[UIImage imageNamed:@"ic_pingguoID"] forState:UIControlStateNormal];
        [_appleIDBtn addTarget:self action:@selector(appleIDBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _appleIDBtn;
}



- (UIButton *)codeLoginBtn
{
    if (!_codeLoginBtn) {
        _codeLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _loginBtn.height + _loginBtn.top + 5, 90, 36)];
        [_codeLoginBtn addTarget:self action:@selector(codeLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kGrayContentColor fontSize:14 text:@"验证码登录"];
        titleLabel.userInteractionEnabled = NO;
        [_codeLoginBtn addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_codeLoginBtn.mas_left);
            make.centerY.mas_equalTo(_codeLoginBtn.mas_centerY);
        }];
    }
    
    return _codeLoginBtn;
}

- (UIButton *)forgetBtn
{
    if (!_forgetBtn) {
        _forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 90, _codeLoginBtn.top, 90, 36)];
        [_forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kGrayContentColor fontSize:14 text:@"忘记密码"];
        titleLabel.userInteractionEnabled = NO;
        [_forgetBtn addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_forgetBtn.mas_right);
            make.centerY.mas_equalTo(_forgetBtn.mas_centerY);
        }];
    }
    
    return _forgetBtn;
}

- (ZZProtocalChooseView *)protocalView
{
    if (!_protocalView) {
        _protocalView = [[ZZProtocalChooseView alloc] initWithFrame:CGRectMake(20, _pwdView.bottom + 8, 200, 25) isLogin:YES];
        _protocalView.isLogin = YES;
        WeakSelf;
        _protocalView.touchProtocal = ^{
            [weakSelf gotoProtocalView];
        };
        
        _protocalView.touchPrivate = ^{
            [weakSelf gotoPrivate];
        };
    }
    
    return _protocalView;
}

- (AppleIDSignInHelper *)appleSignInHelper {
    if (!_appleSignInHelper) {
        _appleSignInHelper = [[AppleIDSignInHelper alloc] init];
    }
    return _appleSignInHelper;
}

- (void)dealloc
{
    [ZZUserHelper shareInstance].publicToken = nil;
    _appleSignInHelper = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
