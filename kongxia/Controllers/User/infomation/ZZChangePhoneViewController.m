//
//  ZZChangePhoneViewController.m
//  zuwome
//
//  Created by angBiu on 16/6/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChangePhoneViewController.h"
#import "ZZInternationalCityViewController.h"
#import "ZZChangePhoneLoginVerifyControllerViewController.h"

#import "ZZSMS.h"
#import "ZZLoginAlertView.h"
#import "ZZPhoneInputView.h"
#import "ZZCodeInputView.h"

@interface ZZChangePhoneViewController ()

@property (nonatomic, strong) ZZLoginAlertView *alertView;
@property (nonatomic, strong) ZZPhoneInputView *phoneView;
@property (nonatomic, strong) ZZCodeInputView *codeView;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation ZZChangePhoneViewController

- (instancetype)init {
    return [self initWithStep:ChangeMobileStepVerifyOri];
}

- (instancetype)initWithStep:(ChangeMobileStep)step {
    self = [super init];
    if (self) {
        _step = step;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = kBGColor;
    
    [self createViews];
    
    if (_step == ChangeMobileStepVerifyOri) {
        _phoneView.textField.text = _user.phone;
        self.navigationItem.title = @"修改绑定";
    }
    else {
        self.navigationItem.title = @"绑定新手机";
    }
}

#pragma mark - CreateViews

- (void)createViews
{
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.sureBtn];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = kGrayTextColor;
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.userInteractionEnabled = YES;
    if (_step == ChangeMobileStepVerifyOri) {
        infoLabel.text = @"手机号不可用 >";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mobileUnreachable)];
        [infoLabel addGestureRecognizer:tap];
    }
    else {
        infoLabel.text = @"修改绑定的手机号后，登录手机号也将一起被修改";
    }
    
    [self.view addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.top.mas_equalTo(self.codeView.mas_bottom);
        make.bottom.mas_equalTo(self.sureBtn.mas_top);
    }];
    
    WeakSelf;
    [self.codeView.sendBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.phoneView.touchCode = ^{
        [weakSelf gotoInternationalCityView];
    };
}

- (void)mobileUnreachable {
    ZZChangePhoneLoginVerifyControllerViewController *controller = [[ZZChangePhoneLoginVerifyControllerViewController alloc] init];
    controller.user = _user;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)removeCheckViewController
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [array removeObjectsInRange:NSMakeRange(3, array.count - 3)];
    [self.navigationController setViewControllers:array.copy animated:YES];
}

#pragma mark - UIButtonMethod

- (void)getCodeBtnClick
{
    if (isNullString(_phoneView.textField.text)) {
        [self.alertView showAlertMsg:@"手机号码不能为空"];
        return;
    }
    
    _codeView.sendBtn.enabled = NO;
    NSDictionary *aDict = @{@"phone":_phoneView.textField.text,
                            @"country_code":_phoneView.codeLabel.text};
    [ZZSMS sendCodeByPhone:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            _codeView.sendBtn.enabled = YES;
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            __block NSInteger count = 60;
            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
            dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(timer, ^{
                if (count == 0) {
                    _codeView.sendBtn.enabled = YES;
                    [_codeView.sendBtn setTitle:@"重发" forState:UIControlStateNormal];
                    dispatch_source_cancel(timer);
                } else {
                    _codeView.sendBtn.enabled = NO;
                    count--;
                    NSString *str = [NSString stringWithFormat:@"%lds",count];
                    [_codeView.sendBtn setTitle:str forState:UIControlStateNormal];
                }
            });
            dispatch_resume(timer);
        }
    }];
}

- (void)nextStepAction {
    if (_step == ChangeMobileStepSetNewNumber) {
        [self changePhoneAction];
    }
    else {
        [self checkOriMobile];
    }
}

- (void)checkOriMobile {
    if (isNullString(_codeView.textField.text)) {
        [self.alertView showAlertMsg:@"请输入验证码"];
        return;
    }
    
    [ZZSMS verifyPhone:[_phoneView.textField.text trimmedString] code:_codeView.textField.text next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if ([data isKindOfClass:[NSDictionary class]] && [data[@"verify"] isEqualToString:@"OK"]) {
            [self showChangePhoneController];
        }
        else {
            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
}

- (void)showChangePhoneController {
    ZZChangePhoneViewController *controller = [[ZZChangePhoneViewController alloc] initWithStep:ChangeMobileStepSetNewNumber];
    controller.user = _user;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)changePhoneAction
{
    if (isNullString(_phoneView.textField.text) && _step == ChangeMobileStepSetNewNumber) {
        [self.alertView showAlertMsg:@"手机号码不能为空"];
        return;
    }
    
    if (isNullString(_codeView.textField.text)) {
        [self.alertView showAlertMsg:@"请输入验证码"];
        return;
    }
    
    [self.view endEditing:YES];
    NSDictionary *aDict = @{@"phone":[_phoneView.textField.text trimmedString],
                            @"code":_codeView.textField.text,
                            @"country_code":_phoneView.codeLabel.text};
    [_user updatePhone:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"手机号更改成功"];
            ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:nil];
            _user.phone = user.phone;
            [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            if (_updateBlock) {
                _updateBlock();
            }
            [self removeCheckViewController];
        }
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - lazyload

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
        _phoneView = [[ZZPhoneInputView alloc] initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH, 50) showBingdinView:_step == ChangeMobileStepVerifyOri];
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

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _codeView.height + _codeView.top + 40, SCREEN_WIDTH - 40, 50)];
        _sureBtn.backgroundColor = kYellowColor;
        [_sureBtn setTitle:_step != ChangeMobileStepVerifyOri ? @"更换手机号" : @"提交" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureBtn addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sureBtn;
}

@end
