//
//  ZZPasswordSetViewController.m
//  zuwome
//
//  Created by angBiu on 2016/11/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPasswordSetViewController.h"
#import "ZZProtocolViewController.h"
#import "ZZSignUpS3ViewController.h"

#import "ZZPasswordInputView.h"
#import "ZZLoginAlertView.h"
#import "ZZProtocalChooseView.h"
#import "ZZLivenessHelper.h"

@interface ZZPasswordSetViewController ()

@property (nonatomic, strong) ZZLoginAlertView *alertView;
@property (nonatomic, strong) ZZPasswordInputView *pwdView;
@property (nonatomic, strong) ZZProtocalChooseView *protocalView;
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation ZZPasswordSetViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isFromAliAuthen) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isFromAliAuthen) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_user == NULL) {
        _user = [[ZZUser alloc] init];
    }
    
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationItem.title = @"设置登录密码";
    self.view.backgroundColor = kBGColor;
    self.navigationController.navigationBar.barTintColor = kGoldenRod;
    [self.view addSubview:self.pwdView];
    [self.view addSubview:self.protocalView];
    [self.view addSubview:self.nextBtn];
    
    self.protocalView.hidden = YES;
    
    WeakSelf;
    _protocalView.touchProtocal = ^{
        [weakSelf gotoProtocalView];
    };
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(_pwdView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 50));
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
}

- (void)gotoProtocalView
{
    [self.view endEditing:YES];
    ZZProtocolViewController *contrller = [[ZZProtocolViewController alloc] init];
    [self.navigationController pushViewController:contrller animated:YES];
}

- (void)nextBtnClick
{
    [MobClick event:Event_click_code_next];

    if (_pwdView.textField.text.length < 6) {
        [self.alertView showAlertMsg:@"密码至少为6位字符"];
        return;
    }
    if (_pwdView.textField.text.length > 16) {
        [self.alertView showAlertMsg:@"密码最多为16位字符"];
        return;
    }
    if (![ZZUtils isThePasswordNotTooSimpleWithPasswordString:_pwdView.textField.text]) {
        [self.alertView showAlertMsg:@"密码过于简单 请尝试字母、数字组合"];
        return ;
    }
    
//    if (!_fromSignUp && !_isQuickLogin) {
//        if (!_protocalView.isSelected) {
//            [self.alertView showAlertMsg:@"没有同意使用条款"];
//            return;
//        }
//    }
    _user.password = _pwdView.textField.text;
    [self.view endEditing:YES];
    [self gotoUpdatePhotoWithIsPush:NO];
//    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeUserLogin inController:self];
//    if (_fromSignUp) {
//        if (!_isUpdatePhone) {
//            helper.code = _code;
//        }
//    }
//    else if (_isQuickLogin) {
//        helper.quickLoginToken = _quickLoginToken;
//        helper.isQuickLogin = _isQuickLogin;
//
//    }
//    else {
//        helper.code = _code;
//    }
//    _user.password = _pwdView.textField.text;
//    helper.user = _user;
//    helper.isUpdatePhone = _isUpdatePhone;
//    helper.countryCode = _countryCode;
//    [helper start];
}

- (void)gotoUpdatePhotoWithIsPush:(BOOL)isPush {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ZZSignUpS3ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CompleteUserInfo"];
    vc.fromSignUp = _fromSignUp;
    vc.code = _code;
    vc.countryCode = _countryCode;
    vc.user = _user;
    vc.isPush = isPush;
    if (_isUpdatePhone) {
        vc.isUpdatePhone = _isUpdatePhone;
    }
    else if (_isQuickLogin) {
        vc.quickLoginToken = _quickLoginToken;
        vc.isQuickLogin = _isQuickLogin;
    }
    vc.isSkipRecognition = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (ZZLoginAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[ZZLoginAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        [self.view addSubview:_alertView];
    }
    
    return _alertView;
}

- (ZZPasswordInputView *)pwdView
{
    if (!_pwdView) {
        _pwdView = [[ZZPasswordInputView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    }
    
    return _pwdView;
}

- (ZZProtocalChooseView *)protocalView
{
    if (!_protocalView) {
        _protocalView = [[ZZProtocalChooseView alloc] initWithFrame:CGRectMake(20, _pwdView.height + _pwdView.top + 8, SCREEN_WIDTH - 40, 25) isLogin:NO];
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
