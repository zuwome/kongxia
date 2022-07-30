//
//  ZZForgetS2ViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZForgetS2ViewController.h"

#import "ZZLoginAlertView.h"
#import "ZZPasswordInputView.h"
#import "ZZCodeInputView.h"
#import "ZZSMS.h"

@interface ZZForgetS2ViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) ZZLoginAlertView *alertView;
@property (nonatomic, strong) ZZPasswordInputView *pwdView;
@property (nonatomic, strong) ZZCodeInputView *codeView;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timerCount;

@end

@implementation ZZForgetS2ViewController

- (instancetype)initWithShouldVerifyFace:(BOOL)shouldVerifyFace {
    self = [super init];
    if (self) {
        _shouldVerifyFace = shouldVerifyFace;
    }
    return self;
}

- (instancetype)init {
    return [self initWithShouldVerifyFace:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationItem.title = @"重置密码";
    self.view.backgroundColor = kBGColor;
    [self createViews];
}

- (void)createViews
{
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.pwdView];
    [self.view addSubview:self.sureBtn];
    
    [self.codeView.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendBtnClick:(UIButton *)sender
{
    NSDictionary *aDict = @{@"phone":_phone,
                            @"country_code":_codeString};
    [ZZSMS sendCodeByPhone:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            NSLog(@"error");
            [self.alertView showAlertMsg:error.message];
        } else {
            NSLog(@"success");
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

- (void)sureBtnClick
{
    ZZUser *user = [[ZZUser alloc] init];
    user.phone = _phone;
    
    user.password = _pwdView.textField.text;

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
    
    if (_shouldVerifyFace) {
        NSLog(@"PY_ 启用人脸识别");
        WeakSelf
        ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeChangePwd inController:self];
        helper.checkSuccessBlock = ^(NSString *photo) {

            if (!isNullString(photo)) {
                [weakSelf confirmWithFace:photo user:user];
            }
            else {
                [ZZHUD showErrorWithStatus:@"人脸识别失败请重试"];
            }
        };
        [helper start];
    }
    else {
        [self confirmWithFace:nil user:user];
    }
}

- (void)confirmWithFace:(NSString *)face user:(ZZUser *)user {
    _sureBtn.enabled = NO;
    [self.view endEditing:YES];
    NSMutableDictionary *aDict = [@{@"phone":_phone,
                            @"password":_pwdView.textField.text,
                            @"code":_codeView.textField.text,
                            @"country_code":_codeString,
                            } mutableCopy];
    
    if (!isNullString(face)) {
        aDict[@"pic"] = face;
    }
    
    [user resetPassword:aDict.copy next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZHUD dismiss];
        _sureBtn.enabled = YES;
        if (error) {
            [UIAlertController presentAlertControllerWithTitle:@"抱歉 没认出您来" message:@"哎呀 有外星人入侵，请确保是您本人操作" doneTitle:@"重试" cancelTitle:@"返回" showViewController:self completeBlock:^(BOOL isCancelled) {
                if (isCancelled) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        } else {
            [ZZHUD showSuccessWithStatus:@"修改成功"];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
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

- (ZZCodeInputView *)codeView
{
    if (!_codeView) {
        _codeView = [[ZZCodeInputView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    }
    
    return _codeView;
}

- (ZZPasswordInputView *)pwdView
{
    if (!_pwdView) {
        _pwdView = [[ZZPasswordInputView alloc] initWithFrame:CGRectMake(0, _codeView.height + _codeView.top + 10, SCREEN_WIDTH, 50)];
        _pwdView.infoLabel.text = @"新密码";
    }
    
    return _pwdView;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _pwdView.height + _pwdView.top + 15, SCREEN_WIDTH - 40, 50)];
        _sureBtn.backgroundColor = kYellowColor;
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sureBtn;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
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
