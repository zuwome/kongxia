//
//  ZZRealNameZMBindViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/7.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRealNameZMBindViewController.h"
#import "ZZRealNameInfoView.h"
#import "ZZRealNameInputView.h"
#import "ZZRealNameListViewController.h"

#import "ZZUser.h"
#import "ZZUserHelper.h"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface ZZRealNameZMBindViewController ()<UITextFieldDelegate>
{
    UITextField                 *_nameTF;//姓名
    UITextField                 *_codeTF;//身份证
    BOOL                        _isPush;
}

@end

@implementation ZZRealNameZMBindViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kYellowColor cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kYellowColor cornerRadius:0]];
    self.navigationController.navigationBar.tintColor = kYellowColor;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0]];
    self.navigationController.navigationBar.tintColor = kBlackTextColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"绑定芝麻信用";
    self.view.backgroundColor = kBGColor;
    [self createViews];
}

- (void)createViews
{
    ZZRealNameInfoView *infoView = [[ZZRealNameInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
    infoView.infoLabel.text = @"请输入个人资料信息用于绑定";
    [self.view addSubview:infoView];
    
    ZZRealNameInputView *nameView = [[ZZRealNameInputView alloc] init];
    nameView.textField.placeholder = @"请输入真实姓名";
    nameView.titleLabel.text = @"姓名";
    [self.view addSubview:nameView];
    
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoView.mas_bottom).offset(15);
        make.left.mas_equalTo(infoView.mas_left);
        make.right.mas_equalTo(infoView.mas_right);
        make.height.mas_equalTo(@50);
    }];
    
    ZZRealNameInputView *codeView = [[ZZRealNameInputView alloc] init];
    codeView.textField.placeholder = @"请输入身份证号码";
    codeView.titleLabel.text = @"身份证";
    [self.view addSubview:codeView];
    
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameView.mas_bottom).offset(15);
        make.left.mas_equalTo(infoView.mas_left);
        make.right.mas_equalTo(infoView.mas_right);
        make.height.mas_equalTo(@50);
    }];
    
    _nameTF = nameView.textField;
    _codeTF = codeView.textField;
    _codeTF.delegate = self;
    _codeTF.keyboardType = UIKeyboardTypeASCIICapable;
    if (_user.realname.name) {
        _nameTF.text = _user.realname.name;
        _nameTF.userInteractionEnabled = NO;
    } else if (_user.realname_abroad.name) {
        _nameTF.text = _user.realname_abroad.name;
        _nameTF.userInteractionEnabled = NO;
    }
    
    UIButton *applyBtn = [[UIButton alloc] init];
    [applyBtn setTitle:@"提交到支付宝进行授权" forState:UIControlStateNormal];
    [applyBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    applyBtn.backgroundColor = kYellowColor;
    applyBtn.layer.cornerRadius = 1.5;
    [applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyBtn];
    
    [applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(codeView.mas_bottom).offset(40);
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(@50);
    }];
}

#pragma mark - textFiled  代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField ==_codeTF) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else{
        return YES;
    }
}



#pragma mark - UIButtonMethod

- (void)applyBtnClick
{
    if (_nameTF.text.length == 0) {
        [ZZHUD showErrorWithStatus:@"请输入真实姓名!"];
        return;
    }
    if (_codeTF.text.length != 15 && _codeTF.text.length != 18) {
        [ZZHUD showErrorWithStatus:@"请输入15或18位身份证号!"];
        return;
    }
    
    NSDictionary *param = @{@"name":_nameTF.text,
                            @"code":_codeTF.text};
    [ZZRequest method:@"GET" path:@"/api/user/zmxy/params" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
//            [[ALCreditService sharedService] queryUserAuthReq:@"1000532"
//                                                         sign:[data objectForKey:@"sign"]
//                                                       params:[data objectForKey:@"params"]
//                                                    extParams:nil
//                                                     selector:@selector(callBackResult:)
//                                                       target:self];
        }
    }];
}

- (void)callBackResult:(NSMutableDictionary*)dic
{
    if ([[dic objectForKey:@"authResult"] isEqualToString:@"success"] && [dic objectForKey:@"params"]) {
        NSDictionary *param = @{@"params":[dic objectForKey:@"params"],
                                @"client":@"app",
                                @"name":_nameTF.text,
                                @"code":_codeTF.text};
        [ZZRequest method:@"POST" path:@"/zmxy/notif/5p4ggl" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [MobClick event:Event_click_realname_confirm];
                [ZZHUD showSuccessWithStatus:@"绑定成功"];
                ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:nil];
                _user.zmxy = user.zmxy;
                _user.realname = user.realname;
                [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
                for (UIViewController *ctl in self.navigationController.viewControllers) {
                    if ([ctl isKindOfClass:[ZZRealNameListViewController class]]) {
                        if (_successCallBack) {
                            _successCallBack();
                        }
                        [self.navigationController popToViewController:ctl animated:YES];
                        break;
                    }
                }
            }
        }];
    } else {
        [ZZHUD showErrorWithStatus:@"绑定失败"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
