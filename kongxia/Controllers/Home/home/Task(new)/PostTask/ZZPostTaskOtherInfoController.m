//
//  ZZPostTaskOtherInfoController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskOtherInfoController.h"

#import "ZZAllTopicsViewController.h"
#import "ZZChooseSkillViewController.h"

#import "ZZPostNormalTaskAnonymousGuid.h"
#import "ZZTaskMoneyView.h"
#import "ZZPostTaskRulesToastView.h"
#import "ZZOtherSettingCell.h"

#import "ZZPostTaskViewModel.h"

@interface ZZPostTaskOtherInfoController ()<ZZPostTaskViewModelDelegate, ZZTaskMoneyViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIButton *proceedBtn;


@end

@implementation ZZPostTaskOtherInfoController

- (instancetype)initWithViewModel:(ZZPostTaskViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        _viewModel.delegate = self;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写通告信息";
    [self layout];
    [_viewModel configTableView:self.tableview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showGuidView];
}

#pragma mark - response method
- (void)proceed {
    if (_viewModel.gender == -1) {
        [ZZHUD showErrorWithStatus:@"请选择技能"];
        return;
    }
    
    if (isNullString(_viewModel.price)) {
        [ZZHUD showErrorWithStatus:@"请填写你愿意打赏的金额"];
        return;
    }
    
    [_viewModel publishPhotos];
}


#pragma mark - ZZTaskMoneyViewDelegate
- (void)inputView:(ZZTaskMoneyView *)inputView price:(NSString *)price {
    [_viewModel choosePrice:price];
}

#pragma mark - <#delegate method#>
- (void)showRules:(ZZPostTaskViewModel *)model {
    if (_viewModel.taskType == TaskFree) {
        [ZZPostTaskRulesToastView showWithRulesType:RulesTypePostActivity];
    }
    else {
       [ZZPostTaskRulesToastView showWithRulesType:RulesTypePostTask];
    }
}

- (void)choosePrice:(ZZPostTaskViewModel *)model {
    [self showMoneyInputView];
}

- (void)viewModel:(ZZPostTaskViewModel *)model showSelection:(BOOL)canDelete {
    WeakSelf
    NSString *changeTitle = @"从相册选择";
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];
    
    if (canDelete) {
        changeTitle = @"更换";
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.viewModel choosePhoto:nil];
        }];
        [alertController addAction:okAction];
    }
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:changeTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showPhotoBrowser];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewModel:(ZZPostTaskViewModel *)model orderID:(NSString *)orderID price:(NSString *)price {
    [self goToPayViewWithOrderID:orderID price:price];
}


#pragma mark - UIImagePickerControllerDelegate, UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.viewModel choosePhoto:image];
     [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigator
/*
 钱
 */
- (void)showMoneyInputView {
   ZZTaskMoneyView *view = [ZZTaskMoneyView createWithPrice:nil taskDuration:_viewModel.durantion date:_viewModel.startTime taskType:_viewModel.taskType];
    view.delegate = self;
}

/**
 *  打开相册
 */
- (void)showPhotoBrowser {
//    IOS_11_Show
//
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picker.delegate = self;
//    //设置选择后的图片可被编辑
//    picker.allowsEditing = NO;
//    [self presentViewController:picker animated:YES completion:nil];
    
   IOS_11_Show
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setDelegate:self];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
//      IOS_11_NO_Show
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//
//        [picker dismissViewControllerAnimated:YES completion:^{
//            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//             [weakSelf edit:image];
//
//        }];
//    };
//    imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
//        [picker dismissViewControllerAnimated:YES completion:nil];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//        IOS_11_NO_Show
//
//    };
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

/**
 *   跳转到付钱页面
 */
- (void)goToPayViewWithOrderID:(NSString *)orderID price:(NSString *)price {
    ZZPayViewController *controller = [[ZZPayViewController alloc] init];
    controller.pId = orderID;
    controller.type = PayTypePrepayTonggao;
    controller.price = [price doubleValue];
    controller.hidesBottomBarWhenPushed = YES;
    controller.didPay = ^{  //支付回调
        [ZZHUD showSuccessWithStatus:@"付款成功"];
        
        NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
        [vcs removeLastObject];
        [vcs removeLastObject];
        [vcs removeLastObject];
        if ([vcs.lastObject isKindOfClass: [ZZAllTopicsViewController class]] || [vcs.lastObject isKindOfClass:[ZZChooseSkillViewController class]]) {
            [vcs removeLastObject];
        }
        
        if (![vcs.lastObject isKindOfClass: [ZZTasksViewController class]]) {
            ZZTasksViewController *tasksVC = [[ZZTasksViewController alloc] initWithTaskType: _viewModel.taskType];
            tasksVC.hidesBottomBarWhenPushed = YES;
            [vcs addObject:tasksVC];
        }
        
        [self.navigationController setViewControllers:vcs animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PublishedTaskNotification object:nil];
    };
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.proceedBtn];
    
    [_proceedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0);
        make.right.equalTo(self.view).offset(-15.0);
        make.height.equalTo(@50.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-15.0);
        } else {
            make.bottom.equalTo(self.view).offset(-15.0);
        }
    }];
    
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)showGuidView {
    if (_viewModel.taskType != TaskNormal) {
        return;
    }
    if (!_viewModel.isFirstTime) {
        return;
    }
    [ZZUserDefaultsHelper setObject:@"1" forDestKey:@"FisrtTimePostNormalTask"];
    _viewModel.isFirstTime = NO;
    CGRect btnInTableView = [_viewModel.cell convertRect:_viewModel.cell.anonymousBtn.frame toView:[UIApplication sharedApplication].keyWindow];
    [ZZPostNormalTaskAnonymousGuid showInRect:btnInTableView];
}

#pragma mark - Getter&Setter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.tableFooterView = [UIView new];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}

- (UIButton *)proceedBtn {
    if (!_proceedBtn) {
        _proceedBtn = [[UIButton alloc] init];
        _proceedBtn.normalTitle = @"立即发布";
        _proceedBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _proceedBtn.titleLabel.font = ADaptedFontMediumSize(16);
        [_proceedBtn addTarget:self action:@selector(proceed) forControlEvents:UIControlEventTouchUpInside];
        _proceedBtn.backgroundColor = kGoldenRod;
        _proceedBtn.layer.cornerRadius = 25.0;
    }
    return _proceedBtn;
}

@end
