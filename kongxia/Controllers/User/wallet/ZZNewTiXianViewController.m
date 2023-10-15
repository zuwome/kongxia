//
//  ZZNewTiXianViewController.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/12.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewTiXianViewController.h"
#import "ZZOptionTiXianCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ZZTiXianDetailNumberCell.h"
#import "ZZNewTiXianFootView.h"//确认提现footView
#import "ZZFillBankViewController.h"//银行卡填写
#import "ZZLinkWebViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ZZTransfer.h"
#import "ZZRechargeViewController.h"
#import "ZZCommissionShareToastView.h"

@interface ZZNewTiXianViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITextField *tiXianTextField;
@property(nonatomic,strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong) ZZNewTiXianFootView *footView;
/**
 是否是微信提现
 */
@property(nonatomic,assign) BOOL isWeixinTixian;
@end

@implementation ZZNewTiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    [self.view addSubview:self.tableView];
//    默认为微信提现
    self.isWeixinTixian = YES;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - tableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        ZZOptionTiXianCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZOptionTiXianCellID"];
        WS(weakSelf);
        cell.goTiXianBlock = ^(NSString *tiXianType) {
           NSLog(@"PY_ 提现方式  %@",tiXianType)
            if ([tiXianType isEqualToString:@"微信"]) {
                weakSelf.isWeixinTixian = YES;
                [weakSelf.footView changeTiXianButtonIsWeiXianTiXianType:YES];
            }else{
                [weakSelf.footView changeTiXianButtonIsWeiXianTiXianType:NO];
                weakSelf.isWeixinTixian = NO;
                [MobClick event:Event_click_choose_bank];
            }
        };
        return cell;
    }else{
        ZZTiXianDetailNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZTiXianDetailNumberCellID"];
        cell.maxMoneyNumber = [NSString stringWithFormat:@"%@",self.user.balance];
        self.tiXianTextField = cell.tiXianTextField;
        self.tiXianTextField.delegate = self;
        [ self.tiXianTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        WS(weakSelf);
        cell.allTiXianBlock = ^{
            //全部提现
            [weakSelf textFieldDidChange:weakSelf.tiXianTextField];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 68;
    }else{
        return 149;
    }
}

#pragma  mark - 输入框的

/**
 [ZZUserHelper shareInstance].min_bankcard_transfer  最低提现额度,网络状况不好第一次没有加载出来的话就默认 不需要
 提示最低提现金额  不能为10元
 */
- (void)textFieldDidChange:(UITextField *)textField {
    
    if ([textField.text doubleValue]>=([ZZUserHelper shareInstance].configModel.min_bankcard_transfer) && [textField.text doubleValue] <= (long)[ZZUserHelper shareInstance].configModel.max_bankcard_transfer) {
        
        if ([self.tiXianTextField.text doubleValue] > self.user.balance.doubleValue) {
            [self.footView changeTiXianButtonStateIsEnable:NO];
        }
        else {
            [self.footView changeTiXianButtonStateIsEnable:YES];
        }
        
    }else{
        [self.footView changeTiXianButtonStateIsEnable:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [ZZUtils limitTextFieldWithTextField:textField range:range replacementString:string];
}

- (ZZNewTiXianFootView *)footView {
    if (!_footView) {
        _footView = [[ZZNewTiXianFootView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];

        _footView.userName = self.user.realname.name;
        WS(weakSelf);
        _footView.goToTixianRule = ^{
            NSLog(@"PY_提现规则");
            ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
            controller.urlString = H5Url.withdrawalRules;
            controller.navigationItem.title = @"提现规则";
            [weakSelf.navigationController pushViewController:controller animated:YES];
        };
        
        _footView.goToTixian = ^(UIButton *sender){
            NSLog(@"PY_提现");
            [weakSelf tableViewTouchInSide];
            [weakSelf faceCheck:sender];
        };
    }
    return _footView;
}

/**
 微信提现
 */
- (void)goToWeiXinTiXian:(UIButton *)sender photo:(NSString *)url checkStatus:(NSInteger)status {
    //提现额度不能大于5万
    if ([self.tiXianTextField.text floatValue] > (long)[ZZUserHelper shareInstance].configModel.max_bankcard_transfer) {
        [ZZHUD showTastInfoErrorWithString:[NSString stringWithFormat:@"单次提现金额不得大于%ld", (long)[ZZUserHelper shareInstance].configModel.max_bankcard_transfer]];
        return ;
    }
    
    NSNumber *myBalance = self.user.balance;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:self.tiXianTextField.text];
    NSNumber *withdrawTotal = myNumber;
    
    if ([withdrawTotal compare:myBalance] == NSOrderedDescending) {
        [ZZHUD showTastInfoErrorWithString:@"提现超过最大额度"];
        return;
    }
    
    [self.view endEditing:YES];
    sender.userInteractionEnabled = NO;
    
    // 是否需要显示提示弹窗
    NSString *warning = [ZZUserDefaultsHelper objectForDestKey:@"weChatWithdrawWarning"];
    if (warning && [warning isEqualToString:@"1"]) {
        [self withdrawInWeChat:sender photo:url checkStatus:status];
    }
    else {
        [self showOkCancelAlert:@"提示" message:@"将会打开微信来关联提现的账号" confirmTitle:@"确定" confirmHandler:^(UIAlertAction * _Nonnull action) {
            [ZZUserDefaultsHelper setObject:@"1" forDestKey:@"weChatWithdrawWarning"];
            [self withdrawInWeChat:sender photo:url checkStatus:status];
        } cancelTitle:@"取消" cancelHandler:^(UIAlertAction * _Nonnull action) {
            sender.userInteractionEnabled = YES;
        }];
    }
}

- (void)withdrawInWeChat:(UIButton *)sender photo:(NSString *)url checkStatus:(NSInteger)status {
    WS(weakSelf);
    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (!error) {
            UMSocialAuthResponse *response = result;
            if (response.uid) {
                ZZTransfer *transfer = [[ZZTransfer alloc] init];
                transfer.channel = @"wx";
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *myNumber = [f numberFromString:weakSelf.tiXianTextField.text];
                transfer.amount = myNumber;//[NSNumber numberWithFloat:[weakSelf.tiXianTextField.text floatValue]];
                transfer.recipient = response.openid;
//                transfer.pic = url;
//                transfer.face_status = status;
                [transfer add:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    sender.userInteractionEnabled = YES;
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                    } else if (data) {
                        [ZZCommissionShareToastView show];
                        if (weakSelf.tiXianBlock) {
                            weakSelf.tiXianBlock();
                        }
                        if (weakSelf.isTiXian) {
                            for (UIViewController* vc in self.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[ZZRechargeViewController class]]) {
                                    [self.navigationController popToViewController:vc animated:YES];
                                    return;
                                }
                            }
                        }
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }
        } else {
            sender.userInteractionEnabled = YES;
            [ZZHUD showErrorWithStatus:@"获取信息错误"];
        }
    }];
}

/**
 去完善银行卡
 */
- (void)goToBank {
     [MobClick event:Event_click_withdraw_next];
    if ([self.tiXianTextField.text floatValue]>5000) {
        [ZZHUD showTastInfoErrorWithString:@"单次提现金额不得大于5000"];
        return ;
    }
    if ([self.tiXianTextField.text floatValue]>[self.user.balance floatValue]) {
        [ZZHUD showTastInfoErrorWithString:@"提现超过最大额度"];
        return;
    }
    ZZFillBankViewController *fillbankVC = [[ZZFillBankViewController alloc]init];
    fillbankVC.user = self.user;
    fillbankVC.isTiXian = self.isTiXian;
    fillbankVC.tiXianMoney = self.tiXianTextField.text;
    fillbankVC.tiXianBlock = self.tiXianBlock;
    [self.navigationController pushViewController:fillbankVC animated:YES];
}

/**
 *  必须先人脸识别之后才能提现
 */
- (void)faceCheck:(UIButton *)sender {
    [self goToWeiXinTiXian:sender photo:nil checkStatus:-1];
}

- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ZZOptionTiXianCell class] forCellReuseIdentifier:@"ZZOptionTiXianCellID"];

        [_tableView registerClass:[ZZTiXianDetailNumberCell class] forCellReuseIdentifier:@"ZZTiXianDetailNumberCellID"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
        tableViewGesture.numberOfTapsRequired = 1;//几个手指点击
        tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
        [_tableView addGestureRecognizer:tableViewGesture];
        _tableView.backgroundColor = HEXCOLOR(0xf8f8f8);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}

- (void)tableViewTouchInSide{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
