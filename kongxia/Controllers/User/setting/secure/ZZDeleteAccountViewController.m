//
//  ZZDeleteAccountViewController.m
//  kongxia
//
//  Created by qiming xiao on 2020/10/6.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZDeleteAccountViewController.h"
#import "ZZForgetS1ViewController.h"
#import "MiPushSDK.h"

@interface ZZDeleteAccountViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *nextBtn;
@property (strong, nonatomic) UILabel *forgetLabel;

@end

@implementation ZZDeleteAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"注销账号";
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
    
    [self createViews];
}

- (void)forgotPassword {
    [self.view endEditing:YES];
    ZZForgetS1ViewController *controller = [[ZZForgetS1ViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)createViews
{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.forgetLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@50.0);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_passwordTextField.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.height.equalTo(@50.0);
    }];
    
    [_forgetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_nextBtn.mas_bottom).offset(15);
    }];
    
}

- (void)nextBtnClick {
    [self.view endEditing:YES];
    
    if (isNullString(_passwordTextField.text)) {
        [ZZHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    WeakSelf
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"继续操作，你的账号将会被注销，其他人将无法找到您的账号"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认注销"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                [weakSelf verifyAccount:_passwordTextField.text successHandler:^(bool isVerified) {
                    if (isVerified) {
                        [weakSelf cancelAccountRequest:_reason];
                    }
                    else {
                        [ZZHUD showErrorWithStatus:@"密码验证错误"];
                    }
                }];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
}

- (void)verifyAccount:(NSString *)password successHandler:(void(^)(bool isVerified))successHandler {
    [ZZRequest method:@"POST" path:@"/api/user/check_password" params:@{@"ZWMId":[ZZUserHelper shareInstance].loginer.ZWMId, @"password" : password} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            id check = data[@"check"];
            if (check != NULL && [check isKindOfClass: [NSNumber class]]) {
                if (successHandler) {
                    successHandler([check boolValue]);
                }
            }
        }
    }];
}

- (void)cancelAccountRequest:(NSString *)reason
{
    [ZZRequest method:@"POST" path:@"/api/user/account/newClose" params:@{@"reason":reason} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [ZZHUD showErrorWithStatus:@"您的账号已成功注销"];
            [MiPushSDK unsetAlias:[ZZUserHelper shareInstance].loginer.uid];
            
            [[RCIM sharedRCIM] logout];
            [ZZUserHelper shareInstance].firstCloseTopView = NO;
            [[[ZZUser alloc] init] logout:nil];
            [[ZZUserHelper shareInstance] clearLoginer];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserDidLogout object:self];
            });
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Lazy

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"验证登录密码";
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)forgetLabel
{
    if (!_forgetLabel) {
        _forgetLabel = [[UILabel alloc] init];
        _forgetLabel.text = @"忘记密码？";
        _forgetLabel.textColor = RGBCOLOR(153, 153, 153);
        _forgetLabel.font = ADaptedFontMediumSize(13);
        _forgetLabel.textAlignment = NSTextAlignmentCenter;
        _forgetLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPassword)];
        [_forgetLabel addGestureRecognizer:recognizer];
    }
    return _forgetLabel;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = @"请输入你的账号密码";
        _passwordTextField.backgroundColor = UIColor.whiteColor;
        _passwordTextField.textColor = kBlackTextColor;
        _passwordTextField.font = [UIFont systemFontOfSize:15];
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
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

@end
