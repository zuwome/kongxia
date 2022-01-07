//
//  ZZChangePhoneLoginVerifyControllerViewController.m
//  kongxia
//
//  Created by qiming xiao on 2021/9/7.
//  Copyright © 2021 TimoreYu. All rights reserved.
//

#import "ZZChangePhoneLoginVerifyControllerViewController.h"
#import "ZZLoginAlertView.h"
#import "ZZPhoneInputView.h"
#import "ZZPasswordInputView.h"
#import "ZZInternationalCityViewController.h"
#import "ZZUser.h"
#import "ZZChangePhoneViewController.h"

@interface ZZChangePhoneLoginVerifyControllerViewController ()

@property (nonatomic, strong) ZZLoginAlertView *alertView;
@property (nonatomic, strong) ZZPhoneInputView *phoneView;
@property (nonatomic, strong) ZZPasswordInputView *pwdView;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation ZZChangePhoneLoginVerifyControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换绑定手机";
    self.view.backgroundColor = kBGColor;
    [self createViews];
    _phoneView.textField.text = _user.phone;
}

- (void)createViews
{
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.pwdView];
    [self.view addSubview:self.loginBtn];
    
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

- (void)showChangePhoneController {
    ZZChangePhoneViewController *controller = [[ZZChangePhoneViewController alloc] initWithStep:ChangeMobileStepSetNewNumber];
    controller.user = _user;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loginBtnClick
{
    [self.view endEditing:YES];
    [ZZHUD showWithStatus:@"验证中..."];
    NSDictionary *param = @{@"ZWMId":_user.ZWMId,
                            @"password":_pwdView.textField.text};
    
    [ZZRequest method:@"POST" path:@"/api/user/check_password" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZHUD dismiss];
        if ([data[@"check"] isKindOfClass:[NSNumber class]] && [data[@"check"] boolValue]) {
            [self showChangePhoneController];
        }
        else {
            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
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
        _phoneView.userInteractionEnabled = NO;
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
        [_loginBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginBtn;
}


@end
