//
//  ZZSignUpS1ViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSignUpS1ViewController.h"
#import "ZZPasswordSetViewController.h"
#import "ZZCodeSignViewController.h"
#import "ZZProtocolViewController.h"
#import "ZZInternationalCityViewController.h"
#import "ZZActivityUrlNetManager.h"//活动管理类

#import "ZZLoginAlertView.h"
#import "ZZPhoneInputView.h"
#import "ZZProtocalChooseView.h"
#import "ZZCodeInputView.h"
#import "ZZSMS.h"
#import "ZZPayHelper.h"

@interface ZZSignUpS1ViewController ()

@property (strong, nonatomic) ZZLoginAlertView *alertView;
@property (nonatomic, strong) ZZPhoneInputView *phoneView;
@property (nonatomic, strong) ZZCodeInputView *codeView;
@property (nonatomic, strong) ZZProtocalChooseView *protocalView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timerCount;

@end

@implementation ZZSignUpS1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = kBGColor;
    
    if (!_user) {
        _user = [[ZZUser alloc] init];
    }
    
    [self createViews];
}

- (void)createViews
{
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.protocalView];
    [self.view addSubview:self.nextBtn];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(_codeView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 50));
    }];
    
    [_protocalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(320));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        }
    }];
    _phoneView.textField.text = _phoneString;
    _phoneView.text = _codeString;
    
    WeakSelf;
    _protocalView.touchProtocal = ^{
        [weakSelf gotoProtocalView];
    };
    
    _protocalView.touchPrivate = ^{
        [weakSelf gotoPrivate];
    };
    
    _phoneView.touchCode = ^{
        [weakSelf gotoInternationalCityView];
    };
    [_codeView.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - UIButtonMethod
 
- (void)nextBtnClick
{
    [MobClick event:Event_click_register_next];
    NSString *phone = [_phoneView.textField.text trimmedString];
    if (isNullString(phone)) {
        [self.alertView showAlertMsg:@"手机号不能为空"];
        return;
    }
    if (isNullString(_codeView.textField.text)) {
        [self.alertView showAlertMsg:@"验证码不能为空"];
        return;
    }
    
//    if (!_protocalView.isSelected) {
//        [self.alertView showAlertMsg:@"没有同意使用条款"];
//        return;
//    }
    
    [self.view endEditing:YES];

    _nextBtn.enabled = NO;
    
    _user.phone = phone;
    NSMutableDictionary *aDict = [@{@"phone":_user.phone,
                            @"code":_codeView.textField.text,
                            @"country_code":_phoneView.codeLabel.text} mutableCopy];
    if (_isUpdatePhone) {
        [ZZUser checkPhoneAndCode:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            _nextBtn.enabled = YES;
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [self gotoPasswordSetView];
            }
        }];
    } else {
        
        //weibo、wechat、qq 老用户登录绑定
        if (_user.wechat) {
            [aDict setObject:[_user.wechat toDictionary] forKey:@"wechat"];
        }
        if (_user.weibo) {
            [aDict setObject:[_user.weibo toDictionary] forKey:@"weibo"];
        }
        if (_user.qq) {
            [aDict setObject:[_user.qq toDictionary] forKey:@"qq"];
        }
        if (_user.appleIDSignIn) {
            [aDict setObject:[_user.appleIDSignIn toDictionary] forKey:@"appleIDSignIn"];
        }
        [_user loginByCode:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            _nextBtn.enabled = YES;
            if (error) {
                if (error.code == 8000) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIAlertController presentAlertControllerWithTitle:@"提示" message:error.message doneTitle:@"知道了" cancelTitle:nil showViewController:self completeBlock:nil];
                        return ;
                    });
                }else{
                [ZZHUD showErrorWithStatus:error.message];
                }
            } else {
                ZZUser *currentRegistUser = [ZZUser yy_modelWithJSON:data[@"user"]];// [[ZZUser alloc] initWithDictionary:data[@"user"] error:nil];
                ///验证码登录添加人脸识别 -  只有设备首次登录会
                NSNumber* isneedfacetest = data[@"isneedfacetest"];
                if ([isneedfacetest integerValue]==1) {
                    [ZZUserHelper shareInstance].publicToken = data[@"access_token"];
                    [ZZUserHelper shareInstance].uploadToken = data[@"upload_token"];
                    NSLog(@"PY_ 启用人脸识别");
                    WS(weakSelf);
                    [weakSelf gotoLiveCheck:NavigationTypeDevicesLoginFirst success:^{
                        [weakSelf deactivateTheUserToReactivateTheFaceWithUser:currentRegistUser dic:data];
                    }];
                    //验证码登录添加人脸识别 -  只有设备首次登录会
                    return ;
                }
                [self deactivateTheUserToReactivateTheFaceWithUser:currentRegistUser dic:data];
            }
        }];
    }
}

/**
 注销用户刷脸重启用,不是就注册登录
 */
- (void)deactivateTheUserToReactivateTheFaceWithUser:(ZZUser *)userInfo dic:(id)userDic {
    ZZWechat *weChat = _user.wechat;
    ZZWeibo *weBo = _user.weibo;
    ZZQQ *qq = _user.qq;
    
    ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
    _user = [ZZUser yy_modelWithJSON:userDic[@"user"]];// [[ZZUser alloc] initWithDictionary:userDic[@"user"] error:nil];
    userHelper.uploadToken = userDic[@"upload_token"];
    _user.wechat = weChat;
    _user.weibo = weBo;
    _user.qq = qq;
    if (userInfo.have_close_account) {
        ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
        userHelper.uploadToken = userDic[@"upload_token"];
        [UIAlertView showWithTitle:@"该帐号已被注销" message:@"是否重新启用该帐号" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认启用"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                NSLog(@"PY_先进行人脸识别");
                [ZZUserHelper shareInstance].publicToken = userDic[@"access_token"];
                [self gotoLiveCheck:NavigationTypeRestartPhone success:^{
                    [ZZRequest method:@"POST" path:@"/api/user/account/recover" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                        if (error) {
                            [ZZHUD showErrorWithStatus:error.message];
                        } else {
                            [ZZHUD showSuccessWithStatus:@"您的账号已被重新激活"];
                            [self jumpHomeVCWithUserInfo:userHelper userDic:userDic];

                        }
                    }];
                }];
            }
        }];
    }
    else{
        
        if (userDic[@"access_token"]) {
            // 注册时不确定人脸识别
            [ZZHUD showSuccessWithStatus:@"该手机号已注册，已直接登录"];
            [self jumpHomeVCWithUserInfo:userHelper userDic:userDic];
            
        } else {
            [self gotoPasswordSetView];
        }
    }
}
- (void)jumpHomeVCWithUserInfo:(ZZUserHelper *)userHelper userDic:(NSDictionary *)userDic {
    userHelper.oAuthToken = userDic[@"access_token"];


    [ZZUserHelper shareInstance].publicToken = userDic[@"access_token"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [userHelper saveLoginer:_user postNotif:YES];
        userHelper.countryCode = _phoneView.codeLabel.text;
        //注册成功开启内购漏单检测
        [ZZPayHelper startManager];
        [ZZActivityUrlNetManager requestHtmlActivityUrlDetailInfo];//h5活动页
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserLogin object:self];
        
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)gotoLiveCheck:(NavigationType)type success:(void(^)(void))success
{
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:type inController:self];
    helper.user = _user;
    helper.checkSuccess = ^{
        if (success) {
            success();
        }
    };
    [helper start];
}

- (void)gotoPasswordSetView
{
    ZZPasswordSetViewController *controller = [[ZZPasswordSetViewController alloc] init];
    controller.user = _user;
    controller.code = _codeView.textField.text;
    controller.countryCode = _phoneView.codeLabel.text;
    controller.isUpdatePhone = _isUpdatePhone;
    controller.fromSignUp = YES;
    controller.isFromAliAuthen = _isFromAliAuthen;
    [self.navigationController pushViewController:controller animated:YES];
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

- (void)sendBtnClick:(UIButton *)sender
{
    [MobClick event:Event_click_register_getcode];
    NSString *phone = [_phoneView.textField.text trimmedString];
    if (isNullString(phone)) {
        [self.alertView showAlertMsg:@"手机号不能为空"];
        return;
    }
   
    NSDictionary *aDict = @{@"phone":_phoneView.textField.text,
                            @"country_code":_phoneView.codeLabel.text};
    [ZZSMS sendCodeByPhone:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [self.alertView showAlertMsg:error.message];
        } else {
            _timerCount = 0;
            if (!_timer) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(updateResendTimer)
                                                        userInfo:nil
                                                         repeats:YES];
            }
            
        }
        
    }];
}

- (void)updateResendTimer
{
    _timerCount++;
    _codeView.sendBtn.enabled = NO;
    if (_timerCount >= 60) {
        _codeView.sendBtn.enabled = YES;
        [_codeView.sendBtn setTitle:@"重发" forState:UIControlStateNormal];
        return;
    }
    
    [_codeView.sendBtn setTitle:[NSString stringWithFormat:@"%is", 60 - _timerCount] forState:UIControlStateDisabled];
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
        _phoneView = [[ZZPhoneInputView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    }
    
    return _phoneView;
}

- (ZZCodeInputView *)codeView
{
    if (!_codeView) {
        _codeView = [[ZZCodeInputView alloc] initWithFrame:CGRectMake(0, _phoneView.height + _phoneView.top + 10, SCREEN_WIDTH, 50)];
    }
    
    return _codeView;
}

- (ZZProtocalChooseView *)protocalView
{
    if (!_protocalView) {
        _protocalView = [[ZZProtocalChooseView alloc] initWithFrame:CGRectMake(20, _codeView.height + _codeView.top + 8, SCREEN_WIDTH - 40, 25) isLogin:NO];
    }
    
    return _protocalView;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _protocalView.height + _protocalView.top + 15, SCREEN_WIDTH - 40, 50)];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.layer.cornerRadius = 3;
        _nextBtn.backgroundColor = kYellowColor;
    }
    
    return _nextBtn;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
