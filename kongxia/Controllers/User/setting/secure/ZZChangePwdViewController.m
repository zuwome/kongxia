//
//  ZZChangePwdViewController.m
//  zuwome
//
//  Created by angBiu on 16/9/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChangePwdViewController.h"

#import "ZZLoginAlertView.h"
#import "ZZForgetS1ViewController.h"
@interface ZZChangePwdViewController () <UITextFieldDelegate>
{
    UITextField             *_oldTF;
    UITextField             *_newTF;
}
@property (nonatomic, strong) ZZLoginAlertView *alertView;

/**
 隐藏就密码
 */
@property (nonatomic, strong) UIButton *hideOldPassWordBtn;

/**
 隐藏新密码
 */
@property (nonatomic, strong) UIButton *hideNewPassWordBtn;


/**
 wang
 */
@property (nonatomic, strong) UIButton *forgetPassWordBtn;

@end

@implementation ZZChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = kBGColor;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self createViews];
}

- (void)createViews
{
    UIView *oldBgView = [[UIView alloc] init];
    oldBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oldBgView];
    
    [oldBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(40);
        make.height.mas_equalTo(@50);
    }];
    
    UILabel *oldInfoLabel = [[UILabel alloc] init];
    oldInfoLabel.textAlignment = NSTextAlignmentLeft;
    oldInfoLabel.textColor = kBlackTextColor;
    oldInfoLabel.font = [UIFont systemFontOfSize:15];
    oldInfoLabel.text = @"旧密码";
    [oldBgView addSubview:oldInfoLabel];
    
    [oldInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oldBgView.mas_left).offset(15);
        make.top.mas_equalTo(oldBgView.mas_top);
        make.bottom.mas_equalTo(oldBgView.mas_bottom);

    }];
    
    _oldTF = [[UITextField alloc] init];
    _oldTF.textAlignment = NSTextAlignmentLeft;
    _oldTF.textColor = kBlackTextColor;
    _oldTF.placeholder = @"请输入旧密码";
    _oldTF.font = CustomFont(15);
    [_oldTF setValue:CustomFont(15) forKeyPath:@"placeholderLabel.font"];

    _oldTF.returnKeyType = UIReturnKeyDone;
    _oldTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _oldTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _oldTF.secureTextEntry = YES;
    _oldTF.delegate = self;
    [oldBgView addSubview:_oldTF];
    
    [oldBgView addSubview:self.hideOldPassWordBtn];

    [self.hideOldPassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(_oldTF.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_oldTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oldBgView.mas_left).offset(84);
        make.right.equalTo(self.hideOldPassWordBtn.mas_left).offset(-2);
        make.top.mas_equalTo(oldBgView.mas_top);
        make.bottom.mas_equalTo(oldBgView.mas_bottom);
    }];
    
    

    UIView *newBgView = [[UIView alloc] init];
    newBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:newBgView];
    
    [newBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(oldBgView.mas_bottom).offset(10);
        make.height.mas_equalTo(@50);
    }];
    
    UILabel *newInfoLabel = [[UILabel alloc] init];
    newInfoLabel.textAlignment = NSTextAlignmentLeft;
    newInfoLabel.textColor = kBlackTextColor;
    newInfoLabel.font = [UIFont systemFontOfSize:15];
    newInfoLabel.text = @"新密码";
    [newBgView addSubview:newInfoLabel];
    
    [newInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(newBgView.mas_left).offset(15);
        make.top.mas_equalTo(newBgView.mas_top);
        make.bottom.mas_equalTo(newBgView.mas_bottom);
        
    }];
    
    _newTF = [[UITextField alloc] init];
    _newTF.textAlignment = NSTextAlignmentLeft;
    _newTF.textColor = kBlackTextColor;
    _newTF.placeholder = @"请输入新密码";
    [_newTF setValue:CustomFont(15) forKeyPath:@"placeholderLabel.font"];
    _newTF.returnKeyType = UIReturnKeyDone;
    _newTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _newTF.secureTextEntry = YES;
    _newTF.delegate = self;
    _newTF.font = CustomFont(15);

    [newBgView addSubview:_newTF];
  
    [newBgView addSubview:self.hideNewPassWordBtn];
    
    [self.hideNewPassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(_newTF.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    
    [_newTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(newBgView.mas_left).offset(84);
        make.right.mas_equalTo(self.hideNewPassWordBtn.mas_left).offset(-2);
        make.top.mas_equalTo(newBgView.mas_top);
        make.bottom.mas_equalTo(newBgView.mas_bottom);
    }];
    
    [self.view addSubview:self.forgetPassWordBtn];
    
    [self.forgetPassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@44);
        make.top.equalTo(newBgView.mas_bottom).offset(8);
    }];
    
    
}

#pragma mark - UIButtonMethod

- (void)rightBtnClick
{
    if (_oldTF.text.length < 6 || _newTF.text.length < 6) {
        [ZZHUD showErrorWithStatus:@"密码必须大于6位"];
        return;
    }
    
    if (_newTF.text.length < 6) {
        [self.alertView showAlertMsg:@"密码至少为6位字符"];
        return;
    }
    if (_newTF.text.length > 16) {
        [self.alertView showAlertMsg:@"密码最多为16位字符"];
        return;
    }
    if ([_oldTF.text isEqualToString:_newTF.text]){
        [self.alertView showAlertMsg:@"新旧密码相同"];
        return;
    }

    if (![ZZUtils isThePasswordNotTooSimpleWithPasswordString:_newTF.text]) {
        [self.alertView showAlertMsg:@"密码过于简单 请尝试字母、数字组合"];
        return ;
    }
    
    
    [ZZHUD showWithStatus:@"正在保存"];
    ZZUser *user = [[ZZUser alloc] init];
    user.password = _oldTF.text;
    [user changePassword:_newTF.text next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UITextFieldMethod

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (ZZLoginAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[ZZLoginAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        [self.view addSubview:_alertView];
    }
    
    return _alertView;
}

- (UIButton *)hideOldPassWordBtn {
    if (!_hideOldPassWordBtn) {
        _hideOldPassWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hideOldPassWordBtn addTarget:self action:@selector(hideOldPassWordClick:) forControlEvents:UIControlEventTouchUpInside];
        [_hideOldPassWordBtn setImage:[UIImage imageNamed:@"icMimaBukejian"] forState:UIControlStateNormal];
        
        [_hideOldPassWordBtn setImage:[UIImage imageNamed:@"icMimaKejian"] forState:UIControlStateSelected];
    }
    return _hideOldPassWordBtn;
    
}


-(UIButton *)hideNewPassWordBtn {
    if (!_hideNewPassWordBtn) {
        _hideNewPassWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hideNewPassWordBtn addTarget:self action:@selector(hideNewPassWordClick:) forControlEvents:UIControlEventTouchUpInside];
        [_hideNewPassWordBtn setImage:[UIImage imageNamed:@"icMimaBukejian"] forState:UIControlStateNormal];
    
        [_hideNewPassWordBtn setImage:[UIImage imageNamed:@"icMimaKejian"] forState:UIControlStateSelected];

    }
    return _hideNewPassWordBtn;
}

- (UIButton *)forgetPassWordBtn {
    if (!_forgetPassWordBtn) {
        _forgetPassWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPassWordBtn addTarget:self action:@selector(forgetPassWordBtnPassWord) forControlEvents:UIControlEventTouchUpInside];
        _forgetPassWordBtn.titleLabel.font = CustomFont(14);
        [_forgetPassWordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPassWordBtn setImage:[UIImage imageNamed:@"rectangle896"] forState:UIControlStateNormal];
        [_forgetPassWordBtn setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        _forgetPassWordBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 64, 0, 2.5);
        _forgetPassWordBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 30);
    }
    return _forgetPassWordBtn;
}

/**
 新密码的显示与隐藏
 */
- (void)hideNewPassWordClick:(UIButton *)sender {
    _newTF.secureTextEntry =  sender.selected ;

    sender.selected =!sender.selected;
   
}

/**
 旧密码的显示与隐藏
 */
- (void)hideOldPassWordClick:(UIButton *)sender {
    _oldTF.secureTextEntry =  sender.selected ;

    sender.selected =!sender.selected;
    
}



/**
 忘记密码
 */
- (void)forgetPassWordBtnPassWord {
    [MobClick event:Event_click_login_forget];
    [self.view endEditing:YES];
    ZZForgetS1ViewController *controller = [[ZZForgetS1ViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
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
