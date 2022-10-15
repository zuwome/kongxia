//
//  ZZRealNameTableViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHUD.h"
#import "ZZMessage.h"
#import "ZZRealNameTableViewController.h"
#import "ZZRealNameDoneViewController.h"
#import "ZZUploader.h"
#import "ZZUserHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZZRentalAgreementVC.h"
#import "ZZUserChuzuViewController.h"
#import "ZZSelfIntroduceVC.h"
#import "ZZFastChatSettingVC.h"
#import "ZZRechargeViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZRealNameAuthenticationFailedVC.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface ZZRealNameTableViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
    IBOutlet UIView *_headerView;
    NSMutableArray *_messages;
    
    IBOutlet UIButton *doneButton;
    
    IBOutlet UITextField *_nameTextField;
    IBOutlet UITextField *_codeTextField;
    IBOutlet UILabel *_alertLabel;
    IBOutlet UILabel *_infoLabel;
}

@end

@implementation ZZRealNameTableViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [ZZHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBGColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (_user.realname.name) {
        _nameTextField.text = _user.realname.name;
    }
    _codeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _codeTextField.delegate = self;
    [_codeTextField addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self createLeftButton];
    [self manageInfoLabel];
}

- (void)createLeftButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems =@[leftItem];
}

- (void)navigationLeftBtnClick
{

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - textFiled  代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_codeTextField ==textField) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else{
        return YES;
    }

}

- (IBAction)done:(UIButton *)sender {
    [MobClick event:Event_click_realname_confirm];
    if (_nameTextField.text.length == 0) {
        [ZZHUD showErrorWithStatus:@"请输入真实姓名!"];
        return;
    }
    if (_codeTextField.text.length != 15 && _codeTextField.text.length != 18) {
        [ZZHUD showErrorWithStatus:@"请输入15或18位身份证号!"];
        return;
    }

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"请务必使用本人身份证进行认证，认证成功后，将锁定您的出生日期和性别。\n若提款账户信息与您的身份证信息不一致，将无法进行提款操作。"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                [self realNameAuth];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
}

- (void)realNameAuth {
    if (_logAuthBlock) {
        _logAuthBlock();
    }

    ZZRealname *realname = [[ZZRealname alloc] init];
    [realname putParam:@{@"name":_nameTextField.text,
                         @"code":_codeTextField.text}
                  next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (_logAuthBlock) {
            _logAuthBlock();
        }
      if (error) {
          [ZZInfoToastView showWithType:ToastRealNameAuthenticationFailed action:^(NSInteger actionIndex, ToastType type) {
              if (actionIndex == 1) {
                  [self goToManuallReviewView];
              }
          }];
      } else {

          ZZRealname *realname = [[ZZRealname alloc] initWithDictionary:data error:nil];
          _user = [ZZUserHelper shareInstance].loginer;
          _user.realname = realname;
          [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];

          if (self.isRentPerfectInfo) {// 如果是从申请出租过来的，则要先更新用户信息，再进入下一步
              [self updateUserInfo];
              return ;
          }

          if (self.isOpenFastChat) {// 如果是从申请开通闪聊过来的，则要先更新用户信息，再进入下一步
              [self updateFastChat];
              return;
          }
          [self gotoDoneController];
    
          if (_successCallBack) {
              _successCallBack();
          }

          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [ZZHUD showSuccessWithStatus:@"实名认证成功"];
          });
      }
  }];
}

- (void)gotoDoneController
{
    if (_isTiXian) {
        NSMutableArray *arr = self.navigationController.viewControllers.mutableCopy;
        if (arr.count > 0) {
            [arr removeLastObject];
        }
        
        if (arr.count > 0) {
            [arr removeLastObject];
        }
        
        [self.navigationController setViewControllers:arr.copy animated:YES];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
//    ZZRealNameDoneViewController *controller = [[ZZRealNameDoneViewController alloc] init];
//    controller.user = _user;
//    controller.isTiXian = self.isTiXian;
//    controller.navigationItem.title = @"实名认证";
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goToManuallReviewView {
    ZZRealNameAuthenticationFailedVC *vc = [[ZZRealNameAuthenticationFailedVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateUserInfo {
    // 更新一下 user 信息
    WEAK_SELF();
    [ZZUser loadUser:_user.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            _user = [ZZUser yy_modelWithJSON:data];;
            [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdatedGenderStatus object:nil];
            [weakSelf gotoChuZu];
        }
    }];
}

- (void)gotoChuZu {
    
    if ([ZZUserHelper shareInstance].configModel.open_rent_need_pay_module) {   // 有开启出租收费
        
        if (_user.rent_need_pay) { //此人出租需要付费
            
            if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstProtocol]) { // 需要先去同意协议
                [self gotoRentalAgreementVC];
            } else {
                [self gotoUserChuZuVC];
            }
        } else {   //不需要付费（字段的值会根据用户是否是男性，大陆，是否已付费，老用户等条件）
            [self gotoUserChuZuVC];
        }
    } else {    // 没有开启出租收费功能
        [self gotoUserChuZuVC];
    }
}

// 出租协议
- (void)gotoRentalAgreementVC {
    
    NSMutableArray<ZZViewController *> *vcs =[self.navigationController.viewControllers mutableCopy];
    if (vcs.count >= 1) {
        [vcs removeObjectsInRange:NSMakeRange(1, vcs.count - 1)];
    }
    ZZRentalAgreementVC *vc = [ZZRentalAgreementVC new];
    vc.hidesBottomBarWhenPushed = YES;
    
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs animated:YES];
}

- (void)gotoUserChuZuVC {
    
    NSMutableArray<ZZViewController *> *vcs =[self.navigationController.viewControllers mutableCopy];
    if (vcs.count >= 1) {
        [vcs removeObjectsInRange:NSMakeRange(1, vcs.count - 1)];
    }

    [MobClick event:Event_click_me_rent];
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ZZUserChuzuViewController *controller = [sb instantiateViewControllerWithIdentifier:@"rentStart"];
//    controller.user = _user;
//    controller.hidesBottomBarWhenPushed = YES;
    //未出租状态前往申请达人，其余状态进入主题管理
    ZZViewController *controller = nil;
    if (_user.rent.status == 0) {
        controller = [[ZZChooseSkillViewController alloc] init];
    } else {
        controller = [[ZZSkillThemeManageViewController alloc] init];
    }
    controller.hidesBottomBarWhenPushed = YES;
    
    [vcs addObject:controller];
    [self.navigationController setViewControllers:vcs animated:YES];
}

// 更新用户信息，闪聊再进入下一步
- (void)updateFastChat {
    WEAK_SELF();
    [ZZUser loadUser:_user.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            _user = [ZZUser yy_modelWithJSON:data];;
            [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            [weakSelf fastChatNextPage];
        }
    }];
}

// 下一步
- (void)fastChatNextPage {
    
    NSMutableArray<ZZViewController *> *vcs =[self.navigationController.viewControllers mutableCopy];
    if (vcs.count >= 2) {
        [vcs removeObjectsInRange:NSMakeRange(2, vcs.count - 2)];
    }
    
    WEAK_SELF();
    if (_user.base_video.status == 1) {
        //如果已经有达人视频，则直接申请成功
        NSMutableDictionary *userDic = [[_user toDictionary] mutableCopy];
        [userDic setObject:@(YES) forKey:@"bv_from_qchat"];
        [_user updateWithParam:userDic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                _user = [ZZUser yy_modelWithJSON:data];
                [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
//                [weakSelf gotoFastChatSetting];
                
                // 闪聊开通成功
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_OpenFastChat object:nil];
                
                ZZFastChatSettingVC *vc = [ZZFastChatSettingVC new];
                vc.isShow = YES;
                [vcs addObject:vc];
                [weakSelf.navigationController setViewControllers:vcs animated:YES];
            }
        }];
    } else {
        //否则去录制达人视频
        ZZSelfIntroduceVC *vc = [ZZSelfIntroduceVC new];
        vc.isFastChat = YES;
        [vcs addObject:vc];
        [weakSelf.navigationController setViewControllers:vcs animated:YES];
    }
}

#pragma mark - UITextFieldMethod

- (void)textValueChange:(UITextField *)textField
{
    if (textField.text.length > 18) {
        textField.text = [textField.text substringToIndex:18];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _nameTextField) {
        [_codeTextField becomeFirstResponder];
    }
    if (textField == _codeTextField) {
        [self.view endEditing:YES];
    }
    return NO;
}

- (void)manageInfoLabel
{
    NSString *str = @"＊为确保您提现顺利，实名认证身份信息必须与提款账户认证的身份信息一致，空虾不会向第三方泄漏您的任何信息";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _infoLabel.text.length)];
    
    _infoLabel.attributedText = attributedString;
    //调节高度
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
