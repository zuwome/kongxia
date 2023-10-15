//
//  ZZTixianZfbViewController.m
//  zuwome
//
//  Created by angBiu on 16/5/25.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTixianZfbViewController.h"
#import "ZZUser.h"
#import "ZZTransfer.h"

@interface ZZTixianZfbViewController ()

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@end

@implementation ZZTixianZfbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBGColor;
    
    _nameTextField.text = _user.realname.name?_user.realname.name:_user.realname_abroad.name;
    _nameTextField.userInteractionEnabled = NO;
}

#pragma mark - UIButtonMehtod

- (IBAction)done:(UIButton *)sender {
    
    if (_accountTextField.text.length == 0) {
        [ZZHUD showErrorWithStatus:@"请输入支付宝账号!"];
        return;
    }
    [self.view endEditing:YES];
    sender.userInteractionEnabled = NO;
    ZZTransfer *transfer = [[ZZTransfer alloc] init];
    transfer.channel = @"alipay";
    transfer.amount = _amount;
    transfer.zfbName = _nameTextField.text;
    transfer.zfbAccount = _accountTextField.text;
    [transfer add:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        sender.userInteractionEnabled = YES;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [self showOkAlert:@"提示" message:@"您的提现申请已提交，请等待审核，预计1-2日到账。" confirmTitle:@"确定" confirmHandler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }];
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
