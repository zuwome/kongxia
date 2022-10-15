//
//  ZZCodeSignViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZCodeSignViewController.h"
#import "ZZInternationalCityViewController.h"
#import "ZZPasswordSetViewController.h"
#import "ZZActivityUrlNetManager.h"//活动管理类
#import "ZZProtocolViewController.h"

#import "ZZSMS.h"
#import "ZZLoginAlertView.h"
#import "ZZPhoneInputView.h"
#import "ZZCodeInputView.h"
#import "ZZPayHelper.h"
#import "ZZProtocalChooseView.h"

@interface ZZCodeSignViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) ZZLoginAlertView *alertView;
@property (nonatomic, strong) ZZPhoneInputView *phoneView;
@property (nonatomic, strong) ZZCodeInputView *codeView;
@property (nonatomic, strong) ZZProtocalChooseView *protocalView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) ZZUser *loginer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timerCount;

@end

@implementation ZZCodeSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationItem.title = @"验证码登录";
    self.view.backgroundColor = kBGColor;
    
    [self createViews];
}

- (void)createViews
{
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.protocalView];
    
    if (_showInfo) {
        UILabel *infoLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kGrayContentColor fontSize:14 text:@"未注册的手机将自动创建账号"];
        [self.view addSubview:infoLabel];
        
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.loginBtn.mas_left);
            make.top.mas_equalTo(self.codeView.mas_bottom).offset(15);
        }];
    }
    
    self.phoneView.textField.text = _phoneString;
    self.phoneView.text = _codeString;
    [self.codeView.sendBtn addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
    
    WeakSelf;
    self.phoneView.touchCode = ^{
        [weakSelf gotoInternationalCityView];
    };
    
    [_protocalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(280));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        }
    }];
}

- (void)sendCode:(UIButton *)sender
{
    [MobClick event:Event_click_codelogin_getcode];
    if (isNullString(_phoneView.textField.text)) {
        [self.alertView showAlertMsg:@"手机号不能为空"];
        return;
    }
    sender.enabled = NO;
    NSDictionary *aDict = @{@"phone":_phoneView.textField.text,
                            @"country_code":_phoneView.codeLabel.text};
    [ZZSMS sendCodeByPhone:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            sender.enabled = YES;
            [ZZHUD showErrorWithStatus:error.message];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        _timerCount++;
        _codeView.sendBtn.enabled = NO;
        if (_timerCount >= 60) {
            _codeView.sendBtn.enabled = YES;
            [_codeView.sendBtn setTitle:@"重发" forState:UIControlStateNormal];
            return;
        }
        
        [_codeView.sendBtn setTitle:[NSString stringWithFormat:@"%is", 60 - _timerCount] forState:UIControlStateDisabled];
    });
}

- (void)loginBtnClick
{
    [MobClick event:Event_click_codelogin_login];
    [self.view endEditing:YES];
    _loginer = [[ZZUser alloc] init];
    _loginer.phone = _phoneView.textField.text;
    if (isNullString(_phoneView.textField.text)) {
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
    
    _loginBtn.enabled = NO;
    WS(weakSelf);
    NSDictionary *aDict = @{@"phone":_loginer.phone,
                            @"code":_codeView.textField.text,
                            @"country_code":_phoneView.codeLabel.text};
    [_loginer loginByCode:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
           dispatch_async(dispatch_get_main_queue(), ^{
        _loginBtn.enabled = YES;
           });
        if (error) {
            if (error.code == 8000) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIAlertController presentAlertControllerWithTitle:@"提示" message:error.message doneTitle:@"知道了" cancelTitle:nil showViewController:self completeBlock:nil];
                    return ;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ZZHUD showErrorWithStatus:error.message];
                });
            }
        } else {
            
            ///验证码登录添加人脸识别 -  只有设备首次登录会
//            NSNumber* isneedfacetest = data[@"isneedfacetest"] ;
//            if ([isneedfacetest integerValue] == 1) {
//                 _loginer = [[ZZUser alloc] initWithDictionary:data[@"user"] error:nil];
//                [ZZUserHelper shareInstance].publicToken = data[@"access_token"];
//                [ZZUserHelper shareInstance].uploadToken = data[@"upload_token"];
//                NSLog(@"PY_ 启用人脸识别");
//                ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeDevicesLoginFirst inController:self];
//                helper.checkSuccess = ^{
//                    [weakSelf oldLoginWithDic:data liveCheckInfo:nil];
//                };
//                // 陌生设备登录
//                helper.newDeviceLoginBlock = ^(BOOL isSuccess, NSString *url, NSString *message) {
//                    [weakSelf newDeviceLoginLiveCheckFailAction:data liveCheckInfo:@{@"isSuccess" : @(isSuccess), @"imageURL": url, @"message": message}];
//                };
//
//                [helper start];
//                return ;
//            }
            //旧的逻辑
            [weakSelf oldLoginWithDic:data liveCheckInfo:nil];
            
            
        }
    }];
}

/**
 *  使用新设备登录,需要去人脸对比,假如对比失败,默认成功继续登录,但是这时候的token是不能用的,所以要再掉一个接口,然而 后台不回去读header里面的UUID,所以要手动拼一个UUID给他
 */
- (void)newDeviceLoginLiveCheckFailAction:(NSDictionary *)userData liveCheckInfo:(NSDictionary *)liveCheckInfo {
    if ([liveCheckInfo[@"isSuccess"] boolValue]) {
        [self oldLoginWithDic:userData liveCheckInfo:liveCheckInfo];
        return;
    }
    
    
    NSString *uuid = [WBKeyChain keyChainLoadWithKey:DEVICE_ONLY_KEY];
    if (isNullString(uuid)) {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [WBKeyChain keyChainSave:uuid key:DEVICE_ONLY_KEY];
    }
    [ZZRequest method:@"GET" path:@"/updateUserToken" params:@{@"uid": userData[@"user"][@"uid"], @"uuid": uuid} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self oldLoginWithDic:userData liveCheckInfo:liveCheckInfo];
    }];
}

/**
 旧的登录逻辑判断
 */
- (void)oldLoginWithDic:(NSDictionary *)data liveCheckInfo:(NSDictionary *)liveCheckInfo {
    WeakSelf;
    BOOL accountCancel = [self isUserAccountCancel:data block:^{
        ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
        userHelper.uploadToken = data[@"upload_token"];
        if (data[@"access_token"]) {
            //当账号重启用或者不是新注册的账号
            if ((weakSelf.loginer.photos.count != 0 && weakSelf.loginer.faces.count != 0)||_loginer.have_close_account == YES) {
                
                userHelper.oAuthToken = data[@"access_token"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [userHelper saveLoginer:[weakSelf.loginer toDictionary] postNotif:YES];
                    userHelper.countryCode = weakSelf.phoneView.codeLabel.text;
                    //登录成功开启内购漏单检测
                    [ZZPayHelper startManager];
                    [ZZActivityUrlNetManager requestHtmlActivityUrlDetailInfo];//h5活动页
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserLogin object:self];
                    
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    [self updateLog:data liveCheckInfo:liveCheckInfo];
                });
            } else  {
                [ZZUserHelper shareInstance].publicToken = data[@"access_token"];
                [weakSelf gotoLiveCheck:NO];
            }
        } else {
            [weakSelf gotoPasswordSetView];
        }
    }];
    
    if (!accountCancel) {
        
        ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
        _loginer = [ZZUser yy_modelWithJSON:data[@"user"]];// [[ZZUser alloc] initWithDictionary:data[@"user"] error:nil];
        userHelper.uploadToken = data[@"upload_token"];
        if (data[@"access_token"]) {
            userHelper.oAuthToken = data[@"access_token"];
            [ZZUserHelper shareInstance].publicToken = data[@"access_token"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [userHelper saveLoginer:[_loginer toDictionary] postNotif:YES];
                userHelper.countryCode = _phoneView.codeLabel.text;
                //登录成功开启内购漏单检测
                [ZZPayHelper startManager];
                [ZZActivityUrlNetManager requestHtmlActivityUrlDetailInfo];//h5活动页
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserLogin object:self];
                
                [self.view endEditing:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                [self updateLog:data liveCheckInfo:liveCheckInfo];
            });
            
        } else {
            [self gotoPasswordSetView];
        }
    }

}

- (BOOL)isUserAccountCancel:(id)data block:(void (^)(void))block
{
    [self.view endEditing:YES];
    _loginer = [ZZUser yy_modelWithJSON:data[@"user"]];// [[ZZUser alloc] initWithDictionary:data[@"user"] error:nil];
    if (_loginer.have_close_account) {
        ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
        userHelper.uploadToken = data[@"upload_token"];
        [UIAlertView showWithTitle:@"该帐号已被注销" message:@"是否重新启用该帐号" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认启用"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [ZZUserHelper shareInstance].publicToken = data[@"access_token"];
                NSLog(@"PY_ 启用人脸识别");
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

- (void)updateLog:(NSDictionary *)data liveCheckInfo:(NSDictionary *)liveCheckInfo {
    if (!data || !data[@"user"] || isNullString(liveCheckInfo[@"message"]) || isNullString(liveCheckInfo[@"imageURL"])) {
        return;
    }
    NSString *uuid = [WBKeyChain keyChainLoadWithKey:DEVICE_ONLY_KEY];
    if (isNullString(uuid)) {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [WBKeyChain keyChainSave:uuid key:DEVICE_ONLY_KEY];
    }
    [ZZRequest method:@"POST"
                 path:[NSString stringWithFormat:@"/saveNewDevLog?uuid=%@",uuid]
               params:@{
                   @"from"   : data[@"user"][@"uid"],
                   @"status" : liveCheckInfo[@"message"],
                   @"img"    : liveCheckInfo[@"imageURL"],
                   @"uuid"   : uuid,
               }
                 next:nil];
}

#pragma mark - navigation
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

- (void)gotoLiveCheck:(BOOL)hasCode
{
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeUserLogin inController:self];
    helper.user = _loginer;
    if (hasCode) {
        helper.code = _codeView.textField.text;
    }
    [helper start];
}

- (void)gotoPasswordSetView
{
    ZZPasswordSetViewController *controller = [[ZZPasswordSetViewController alloc] init];
    controller.user = _loginer;
    controller.code = _codeView.textField.text;
    controller.countryCode = _phoneView.codeLabel.text;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - lazyload
- (ZZProtocalChooseView *)protocalView
{
    if (!_protocalView) {
        _protocalView = [[ZZProtocalChooseView alloc] initWithFrame:CGRectMake(20, _loginBtn.bottom + 8, SCREEN_WIDTH - 40, 25) isLogin:YES];
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

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _codeView.height + _codeView.top + 50, SCREEN_WIDTH - 40, 50)];
        _loginBtn.backgroundColor = kYellowColor;
        [_loginBtn setTitle:@"验证并登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginBtn;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

@end
