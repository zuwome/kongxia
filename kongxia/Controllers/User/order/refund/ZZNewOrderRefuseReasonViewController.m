//
//  ZZNewOrderRefuseReasonViewController.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewOrderRefuseReasonViewController.h"
#import "ZZOrderARSelectButtonCell.h"
#import "ZZOrderArUploadImageCell.h"
#import "ZZApplyUploadView.h"
#import "ZZRuleHelper.h"
#import "ZZOrderOptionModel.h"
#import "ZZOrderRefuseReasonCell.h"
#import "ZZUploader.h"
@interface ZZNewOrderRefuseReasonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) ZZApplyUploadView *bottomView;
@property (strong, nonatomic) UIButton *submitButton;//提交按钮
@property (strong, nonatomic) NSMutableArray *imageArray;//上传的图片
@property (nonatomic, strong) ZZOrderRefundModel *refundModel;
@property (nonatomic,strong)  ZZOrderARBaseCell *lastSelectCell;

@end

@implementation ZZNewOrderRefuseReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"拒绝理由";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.bottom.equalTo(self.submitButton.mas_top);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.equalTo(@49);
        make.bottom.equalTo(@(-SafeAreaBottomHeight));
    }];
    self.tableView.tableFooterView  =  self.bottomView;
    [self loadData];
}

- (void)loadData
{
    NSDictionary *param =@{@"type":@"refund_refuse"};//退全款
    if (!self.order.paid_at) {
        //拒绝的意向金
        param =@{@"type":@"refund_refuse_deposit"};
    }
    [ZZRuleHelper pullRefund:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _refundModel = [[ZZOrderRefundModel alloc] initWithDictionary:data error:nil];
            [self.tableView reloadData];
        }
    }];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        [_tableView registerClass:[ZZOrderArUploadImageCell class] forCellReuseIdentifier:@"ZZOrderArUploadImageCellID"];
        [_tableView registerClass:[ZZOrderARSelectButtonCell class] forCellReuseIdentifier:@"ZZOrderARSelectButtonCellID"];
        [_tableView registerClass:[ZZOrderRefuseReasonCell class] forCellReuseIdentifier:@"ZZOrderRefuseReasonCellID"];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}


- (ZZApplyUploadView *)bottomView
{
    WeakSelf;
    if (!_bottomView) {
        _bottomView = [[ZZApplyUploadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH - 60)/3.0f + 40)];
        _bottomView.selectMaxNumber = 6;
        _bottomView.selectIndex = ^(NSInteger index) {
            [weakSelf selectIndexWithIndex:index];
        };
    }
    return _bottomView;
}
#pragma mark - UITableViewMethod
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
         return self.refundModel.reason.count+1;
    }else{
         return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.refundModel.reason.count-1>=indexPath.row) {
            return 50;
        }else{
            return 154;
        }
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (self.refundModel.reason.count-1>=indexPath.row) {
            ZZOrderARSelectButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZOrderARSelectButtonCellID"];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ZZOrderOptionModel *model = self.refundModel.reason[indexPath.row];
            cell.currentTitle = model.content;
            cell.model = model;
            WS(weakSelf);
            cell.selecetBlock = ^(ZZOrderARSelectButtonCell *currentCell) {
                if (currentCell.button.selected == NO) {
                    weakSelf.lastSelectCell = nil;
                    return ;
                }
                
                [weakSelf changeCellSelect:currentCell];
            };
            return cell;
        }else{
            ZZOrderRefuseReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZOrderRefuseReasonCellID"];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.currentTitle = @"其他";
            WS(weakSelf);
            cell.selecetBlock = ^(ZZOrderRefuseReasonCell *currentCell) {
                if (currentCell.button.selected == NO) {
                    weakSelf.lastSelectCell = nil;
                    return ;
                }
                [weakSelf changeCellSelect:currentCell];
            };
            return cell;
        }
        
    }else{
        ZZOrderArUploadImageCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"ZZOrderArUploadImageCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.uploadInstructions = @"(必填)";
        return cell;
        
    }


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

- (void)changeCellSelect:(ZZOrderARBaseCell *)currentCell {
    if (self.lastSelectCell) {
        self.lastSelectCell.button.selected = NO;
        if ([self.lastSelectCell isKindOfClass:[ZZOrderRefuseReasonCell class]]) {
            ZZOrderRefuseReasonCell *lastCell = (ZZOrderRefuseReasonCell*)self.lastSelectCell;
            [lastCell.textView resignFirstResponder];
        }
    }
    self.lastSelectCell = currentCell;
   
}
#pragma mark -

- (void)selectIndexWithIndex:(NSInteger)index
{
    if (self.imageArray.count && index < self.imageArray.count) {
        [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除图片" otherButtonTitles:nil tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {

            if (buttonIndex == 1) {
                return ;
            }
            [self.imageArray removeObjectAtIndex:index];
            self.bottomView.dataArray = self.imageArray;
        }];
    } else if (index == self.imageArray.count) {
        [self addImage];
    }
}
- (void)addImage
{
    WeakSelf;
    [UIActionSheet showInView:self.view
                    withTitle:@"上传照片"
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"拍照上传",@"相册上传"]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                         if (buttonIndex ==0) {
                             UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                             [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                             imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
                             imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
                                 [picker dismissViewControllerAnimated:YES completion:^{
                                     UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                                     [weakSelf addImageWithImage:image];
                                 }];
                             };
                             imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
                                 [picker dismissViewControllerAnimated:YES completion:nil];
                             };
                             [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
                         }
                         if (buttonIndex ==1) {
                             IOS_11_Show
                             UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                             [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                             imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
                                 IOS_11_NO_Show
                                 [picker dismissViewControllerAnimated:YES completion:^{
                                     UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                                     [weakSelf addImageWithImage:image];
                                 }];
                             };
                             imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
                                 IOS_11_NO_Show
                                 [picker dismissViewControllerAnimated:YES completion:nil];
                             };
                             [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
                         }
                     }];
}
- (void)addImageWithImage:(UIImage *)image
{
    [self.imageArray addObject:image];
    self.bottomView.dataArray = self.imageArray;
    if (((self.imageArray.count+1)/3)>=1) {
        if (self.bottomView.height != (SCREEN_WIDTH - 60)/3.0f*2+60) {
            self.bottomView.height = (SCREEN_WIDTH - 60)/3.0f*2+60;
            self.tableView.tableFooterView.height  =  self.bottomView.height;
            self.tableView.tableFooterView = self.bottomView;
        }

    }else{
        if (self.bottomView.height != (SCREEN_WIDTH - 60)/3.0f+40) {
            self.bottomView.height =  (SCREEN_WIDTH - 60)/3.0f+40;
            self.tableView.tableFooterView.height  =  self.bottomView.height;
            self.tableView.tableFooterView = self.bottomView;
        }
    }

}
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_submitButton setBackgroundColor:RGBCOLOR(244, 203, 7)];
    }
    return _submitButton;
}

/**
 提交
 */
- (void)submitButtonClick {
    if (!self.lastSelectCell) {
        [ZZHUD showErrorWithStatus:@"请选择理由或填写理由"];
        return;
    }
    [self.view endEditing:YES];
    NSString * currentSelectReason;
    if ([self.lastSelectCell isKindOfClass:[ZZOrderARSelectButtonCell class]]) {
        ZZOrderARSelectButtonCell *lastCell = (ZZOrderARSelectButtonCell*)self.lastSelectCell;
        currentSelectReason = lastCell.currentTitle;
    }else{
        ZZOrderRefuseReasonCell *cell =  (ZZOrderRefuseReasonCell*)self.lastSelectCell;
        NSString *string =  [cell.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        currentSelectReason = string;
    }
    if (isNullString(currentSelectReason)) {
        [ZZHUD showTastInfoErrorWithString:@"请输入拒绝原因"];
        return;
    }
    if (_imageArray.count<=0) {
        [ZZHUD showTastInfoErrorWithString:@"请上传证据"];
        return;
    }
    NSMutableDictionary *param = [@{@"refuse_reason":currentSelectReason} mutableCopy];
    if (_imageArray.count) {
        [ZZHUD showWithStatus:@"图片上传中..."];
        [ZZUploader uploadImages:_imageArray progress:^(CGFloat progress) {
        } success:^(NSArray *urlArray) {
            [param setObject:urlArray forKey:@"refuse_photos"];
            [self refuseRefund:param];
        } failure:^{
            [ZZHUD showErrorWithStatus:@"图片上传失败!"];
        }];
    } else {
        [self refuseRefund:param];
    }
}
- (void)refuseRefund:(NSDictionary *)param
{
    [ZZHUD showWithStatus:@"正在操作"];
    [_order refundNo:_order.status param:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            _order.status = data[@"status"];
            if (_callBack) {
                _callBack(_order.status);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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
