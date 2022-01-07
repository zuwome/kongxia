//
//  ZZRealNameAuthenticationFailedVC.m
//  zuwome
//
//  Created by 潘杨 on 2018/7/5.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRealNameAuthenticationFailedVC.h"
#import "ZZRealNameTableViewController.h"
#import "ZZRealNameFailureHelper.h"
#import "ZZInputWithTitleView.h"
#import "ZZAuthenticationFailedUploadImageView.h"
#import "ZZUploader.h"
@interface ZZRealNameAuthenticationFailedVC ()<UIImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong) UILabel *topTip;

@property (nonatomic,strong) UIButton *submitAuditButton;

/**
 用户的身份名
 */
@property (nonatomic,strong) ZZInputWithTitleView *nameTitleView;


/**
 用户的身份证
 */
@property (nonatomic,strong) ZZInputWithTitleView *userCardTitleView;

/**
 上传图片
 */
@property (nonatomic,strong) ZZAuthenticationFailedUploadImageView *uploadImageView;


/**
 上传的图片
 */
@property (nonatomic,strong) UIImage *image;
@end

@implementation ZZRealNameAuthenticationFailedVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"提交证件";
    self.navigationItem.title = @"身份信息人工审核";
    self.view.backgroundColor = kBGColor;
    [self setUI];
}

- (void)setUI {

    [self.view addSubview:self.topTip];
    [self.topTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.equalTo(@32);
    }];
    [self.view addSubview:self.submitAuditButton];
    
    [self.submitAuditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(-SafeAreaBottomHeight -15);
        make.height.equalTo(@50);
    }];
    
    [self.view addSubview:self.nameTitleView];
    
    [self.nameTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.topTip.mas_bottom).offset(8);
        make.height.equalTo(@50);
    }];
    
    [self.view addSubview:self.userCardTitleView];

    [self.userCardTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.nameTitleView.mas_bottom).offset(0);
        make.height.equalTo(@50);
    }];
    
    [self.view addSubview:self.uploadImageView];
    [self.uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.userCardTitleView.mas_bottom).offset(8);
    make.height.equalTo(self.uploadImageView.mas_width).multipliedBy(347/375.0f);
    }];
    
}


/**
 姓名
 */
- (ZZInputWithTitleView *)nameTitleView {
    if (!_nameTitleView) {
        _nameTitleView = [[ZZInputWithTitleView alloc]initWithFrame:CGRectZero withTitle:@"姓名" placeholderTitle:@"请输入真实姓名"];

    }
    return _nameTitleView;
}

/**
 身份证
 */
- (ZZInputWithTitleView *)userCardTitleView {
    if (!_userCardTitleView) {
        _userCardTitleView = [[ZZInputWithTitleView alloc]initWithFrame:CGRectZero withTitle:@"身份证" placeholderTitle:@"请输入身份证号码"];
        _userCardTitleView.promptTextField.keyboardType = UIKeyboardTypeAlphabet;
    }
    return _userCardTitleView;
}



/**
 顶部提示
 */
- (UILabel *)topTip {
    if (!_topTip) {
        _topTip = [[UILabel alloc]init];
        _topTip.backgroundColor = RGBCOLOR(248, 243, 208);
        _topTip.font = CustomFont(14);
        _topTip.text = @"实名认证后的身份信息不可更改";
        _topTip.textColor = RGBCOLOR(221, 162, 0);
        _topTip.textAlignment = NSTextAlignmentCenter;
    }
    return _topTip;
}


/**
 提交审核
 */
- (UIButton *)submitAuditButton {
    if (!_submitAuditButton) {
        _submitAuditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitAuditButton addTarget:self action:@selector(submitAuditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _submitAuditButton.layer.cornerRadius = 3;
        _submitAuditButton.backgroundColor = RGBCOLOR(244, 203, 7);
        _submitAuditButton.titleLabel.font = CustomFont(15);
        [_submitAuditButton setTitle:@"提交审核" forState:UIControlStateNormal];
        [_submitAuditButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        
    }
    return _submitAuditButton;
}

/**
 上传图片

 */
- (ZZAuthenticationFailedUploadImageView *)uploadImageView {
    if (!_uploadImageView) {
        _uploadImageView = [[ZZAuthenticationFailedUploadImageView alloc]initWithFrame:CGRectZero];
        WS(weakSelf);
        _uploadImageView.uploadImageBlock = ^(UIButton *sender) {
            [weakSelf uploadImageViewWithButton:sender];
        };
    }
    return _uploadImageView;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 提交审核


/**
 点击提交按钮  判断是否合格  同时上传图片到七牛

 @param sender
 */
- (void)submitAuditButtonClick:(UIButton *)sender {

     NSLog(@"PY_用户上传完证据提交审核");
    sender.enabled = NO;
    [UIAlertController presentAlertControllerWithTitle:@"提示" message:@"请务必使用本人身份证进行认证,\n认证成功后,将锁定您的出生日期和\n性别。若提款账户信息与您的身\n份信息不一致,将无法进行提款\n操作" doneTitle:@"确定" cancelTitle:@"取消" showViewController:self completeBlock:^(BOOL index) {
        sender.enabled = YES;

        if (index) {
            return ;
        }
        
        if (isNullString(self.nameTitleView.promptTextField.text)) {
            [ZZHUD showTastInfoErrorWithString:@"输入您的真实姓名"];
            return;
        }
       
        NSString *userName =  [ZZUtils removeSpaceAndNewline:self.nameTitleView.promptTextField.text];

        if (isNullString(userName)) {
            [ZZHUD showTastInfoErrorWithString:@"真实姓名不能为空格"];
            return;
        }
        
        if (isNullString(self.userCardTitleView.promptTextField.text)) {
            [ZZHUD showTastInfoErrorWithString:@"输入您的真实身份证号"];
            return;
        }
        
        NSString *userNameCard =[ZZUtils removeSpaceAndNewline:self.userCardTitleView.promptTextField.text];
        if (isNullString(userNameCard)) {
            [ZZHUD showTastInfoErrorWithString:@"真实身份证号不能为空格"];
            return;
        }
        
        if (!self.image) {
            [ZZHUD showTastInfoErrorWithString:@"请上传本人手持证件正面照片"];
            return;
        }
        
        NSData *data = [ZZUtils userImageRepresentationDataWithImage:self.image];
        
        [ZZHUD showTaskInfoWithStatus:@"上传中"];
        [ZZUploader putData:data next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            if (resp) {
                [self uploadServer:@{@"name":userName,
                                     @"code":userNameCard,
                                     @"pic":resp[@"key"],
                                     }];
            }else{
                [ZZHUD showErrorWithStatus:@"上传失败"];
            }
            
        }];
        
    }];
}

/**
 上传给服务器审核
 */
-  (void)uploadServer:(NSDictionary *)dic {
    [ZZRealNameFailureHelper uploadDic:dic DetailInfoSuccess:^(ZZRealNameFailureModel *model) {
        [ZZHUD dismiss];
        [UIAlertController presentAlertControllerWithTitle:@"资料提交成功,请耐心等待" message:nil doneTitle:@"好的" cancelTitle:nil showViewController:self completeBlock:^(BOOL index) {
//            [self.navigationController popViewControllerAnimated:YES];
            NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
            [array removeLastObject];
            if ([array[array.count - 1] isKindOfClass:[ZZRealNameTableViewController class]]) {
                [array removeLastObject];
            }
            [self.navigationController setViewControllers:array animated:YES];
        }];
    } failure:^(ZZError *error) {
        if (error) {
            [ZZHUD showTastInfoErrorWithString:error.message];
        }
    }];
}
#pragma  mark - 选择图片

- (void)uploadImageViewWithButton:(UIButton *)sender {
    [self.view endEditing:YES];
    [UIActionSheet showInView:self.view
                    withTitle:@"上传照片"
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"拍照",@"从手机相册选择"]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                         if (buttonIndex ==0) {
                             [self gotoCamera];
                         }
                         if (buttonIndex ==1) {
                             [self gotoAlbum];
                         }
                         
                     }];
}

//相册
- (void)gotoAlbum
{
    WeakSelf;
    IOS_11_Show
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setAllowsEditing:YES];
    [imgPicker setDelegate:self];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        IOS_11_NO_Show
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            [weakSelf uploadPhoto:image];
            
        }];
    };
    imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        IOS_11_NO_Show
        
    };
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}




//拍照
- (void)gotoCamera
{
    if (![ZZUtils isAllowCamera]) {
        return;
    }
    if ([ZZUtils isConnecting]) {
        return;
    }
    WeakSelf;
       IOS_11_Show
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
//    [imgPicker setAllowsEditing:YES];
    [imgPicker setDelegate:self];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        IOS_11_NO_Show

        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [weakSelf uploadPhoto:image];
        }];
    };
    imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

- (void)uploadPhoto:(UIImage *)image
{
    self.image = image;
    [self.uploadImageView.uploadImageButton setImage:image forState:UIControlStateNormal];
}
- (void)navigationLeftBtnClick
{
    [super navigationLeftBtnClick];
    _image = nil;
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
