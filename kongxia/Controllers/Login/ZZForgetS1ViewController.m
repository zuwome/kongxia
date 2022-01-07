//
//  ZZForgetS1ViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZForgetS1ViewController.h"
#import "ZZForgetS2ViewController.h"
#import "ZZInternationalCityViewController.h"

#import "ZZLoginAlertView.h"
#import "ZZPhoneInputView.h"

@interface ZZForgetS1ViewController ()

@property (strong, nonatomic) ZZLoginAlertView *alertView;
@property (nonatomic, strong) ZZPhoneInputView *phoneView;
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation ZZForgetS1ViewController

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
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.nextBtn];
    WeakSelf;
    self.phoneView.touchCode = ^{
        [weakSelf gotoInternationalCityView];
    };
}

- (void)nextBtnClick {
    if (isNullString(_phoneView.textField.text)) {
        [self.alertView showAlertMsg:@"手机号不能为空"];
        return;
    }
    
    if (!isNullString(ZZUserHelper.shareInstance.loginer.phone)) {
        if (![_phoneView.textField.text isEqualToString:ZZUserHelper.shareInstance.loginer.phone]) {
            [self.alertView showAlertMsg:@"手机号不一致"];
            return;
        }
    }
    [self.view endEditing:YES];
    ZZForgetS2ViewController *controller = [[ZZForgetS2ViewController alloc] init];
    controller.phone = _phoneView.textField.text;
    controller.codeString = _phoneView.codeLabel.text;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoInternationalCityView {
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

#pragma mark - Lazy

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

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _phoneView.height + _phoneView.top + 15, SCREEN_WIDTH - 40, 50)];
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
