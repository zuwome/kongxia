//
//  ZZFillBankViewController.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZFillBankViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ZZFillBankCell.h"
#import "ZZFillBankView.h"
#import "ZZLinkWebViewController.h"//提现规则
#import "ZZRechargeViewController.h"
@interface ZZFillBankViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) ZZFillBankView *footView;
@property (nonatomic,strong) NSString *lastFillCardNumber;
@end

@implementation ZZFillBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"填写银行卡";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ZZFillBankCell class] forCellReuseIdentifier:@"ZZFillBankCellID"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
        tableViewGesture.numberOfTapsRequired = 1;//几个手指点击
        tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
        [_tableView addGestureRecognizer:tableViewGesture];
        _tableView.backgroundColor = HEXCOLOR(0xf8f8f8);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 160;
        
        _tableView.tableFooterView = self.footView;
        _tableView.tableFooterView.height = 120;
    }
    return _tableView;
}
- (ZZFillBankView *)footView {
    if (!_footView) {
        _footView = [[ZZFillBankView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        WS(weakSelf);
        _footView.goToTixian = ^(UIButton *sender){
            [MobClick event:Event_click_withdraw_sure];

            [weakSelf goToTixian:sender isCheck:YES];
        };
    }
    return _footView;
}

- (void)goToCheckCurrentUser:(UIButton *)sender {
    sender.enabled = YES;
    [self.view endEditing:YES];
    //银行卡提现 不需要刷脸了
    [self goToTixian:sender isCheck:NO];

//    WS(weakSelf);
//    LiveCheck01ViewController *controller = [[LiveCheck01ViewController alloc] init];
//    controller.user = [ZZUserHelper shareInstance].loginer;
//    controller.type = NavigationTypeTiXian;
//    controller.checkSuccess = ^{
//        [weakSelf goToTixian:sender isCheck:NO];
//    };
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
}

/**
  银行卡提现
 @param isCheck 是否校验
 */
- (void)goToTixian:(UIButton *)sender isCheck:(BOOL)isCheck {
       NSString *bankString = [self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSDictionary *params = @{@"cardNo":bankString//卡号
                                 ,@"amount":self.tiXianMoney
                                 ,@"onlycheck":@(isCheck)
                                 };
        [ZZRequest method:@"POST" path:@"/api/user/transfer_tocard" params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            sender.enabled = YES;
            if (error) {
                if ([error.type isEqualToString:@"nosupport"]) {
                     NSLog(@"PY_弹出自定义的弹窗告诉用户该银行卡不支持提现");
                       [UIAlertView showWithTitle:@"提示" message:@"您填写的银行卡目前暂不支持提现" cancelButtonTitle:@"取消" otherButtonTitles:@[@"查看提现规则"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                           if (buttonIndex) {
                               ZZLinkWebViewController *linkViewController = [[ZZLinkWebViewController alloc]init];
                               linkViewController.urlString = H5Url.withdrawalRules;
                               linkViewController.navigationItem.title = @"提现规则";
                               [self.navigationController pushViewController:linkViewController animated:YES];
                           }
                       }];
                }else{
                [ZZHUD showTastInfoErrorWithString:error.message];
                }
            }else if(data) {
             
                if (isCheck) {
                    [self goToCheckCurrentUser:sender];

                    return ;
                }
                [UIAlertView showWithTitle:@"提示" message:@"您的提现申请已提交，请等待审核，预计1-2日到账。" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    if (self.tiXianBlock) {
                        self.tiXianBlock();
                    }
                    if (self.isTiXian) {
                        for (UIViewController* vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[ZZRechargeViewController class]]) {
                                [self.navigationController popToViewController:vc animated:YES];
                                return;
                            }
                        }
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }];
            }
        }];

}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZFillBankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZFillBankCellID"];
    cell.userName = self.user.realname.name;
    self.textField = cell.carNumberTextField;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    cell.detailClickBlock = ^(UIButton *sender){
        sender.enabled = NO;
        [UIAlertView showWithTitle:@"提示" message:@"为了保证提现成功，只能填写实名认证一致的本人的银行卡" cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        sender.enabled = YES;
        }];
    };

    return cell;
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (self.lastFillCardNumber.length < textField.text.length) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        textField.text =  [self restructuringInputTextFieldString:textField.text];
    }
    if (textField.text.length>=24) {
        textField.text = [textField.text substringToIndex:24];
    }
    self.lastFillCardNumber = textField.text;
    if (textField.text.length>0) {
        [self.footView changeTiXianButtonStateIsEnable:YES];
    }else{
        [self.footView changeTiXianButtonStateIsEnable:NO];
    }
    self.lastFillCardNumber = textField.text;
}


/**
 重组字符串 每隔4位插入空格

 @param string 当前输入的
 */
- (NSString *)restructuringInputTextFieldString:(NSString *)string {
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < string.length; i++) {
        count++;
        doneTitle = [doneTitle stringByAppendingString:[string substringWithRange:NSMakeRange(i, 1)]];
        if (count == 4) {
            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
        }
    }
    return doneTitle;
}

- (void)tableViewTouchInSide{
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
