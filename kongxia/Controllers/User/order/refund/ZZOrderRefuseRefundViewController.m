//
//  ZZOrderRefuseRefundViewController.m
//  zuwome
//
//  Created by angBiu on 2017/8/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZOrderRefuseRefundViewController.h"

#import "ZZOrderRefundTitleCell.h"
#import "ZZOrderRefundPhotoCell.h"
#import "ZZOrderOptionTextViewCell.h"
#import "ZZOrderOptionCell.h"

#import "TPKeyboardAvoidingTableView.h"
#import "ZZRuleHelper.h"
#import "ZZOrderOptionModel.h"
#import "ZZUploader.h"

@interface ZZOrderRefuseRefundViewController () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, assign) BOOL selecteOtherReason;//其他
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) ZZOrderRefundModel *refundModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL show;

@end

@implementation ZZOrderRefuseRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"拒绝理由";
    _selecteOtherReason = YES;
    [self loadData];
}

- (void)createViews
{
    [self.view addSubview:self.tableView];
    
    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadData
{
    self.navigationRightDoneBtn.userInteractionEnabled = NO;
    [ZZRuleHelper pullRefund:@{@"type":@"refund_refuse"} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            self.navigationRightDoneBtn.userInteractionEnabled = YES;
            _refundModel = [[ZZOrderRefundModel alloc] initWithDictionary:data error:nil];
            [self createViews];
        }
    }];
}

#pragma mark - UITabelViewMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _selecteOtherReason?3:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _refundModel.yours.count+1;
    } else if (_selecteOtherReason && section == 1)  {
        return 1;
    } else {
        return _show?2:1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZZOrderOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optioncell"];
        
        if (!cell) {
            cell = [[ZZOrderOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"optioncell"];
        }
        if (indexPath.row == _refundModel.yours.count) {
            cell.titleLabel.text = @"其他";
        } else {
            ZZOrderOptionModel *model = _refundModel.yours[indexPath.row];
            cell.titleLabel.text = model.content;
        }
        if (_indexPath == indexPath) {
            cell.imgView.hidden = NO;
        } else {
            cell.imgView.hidden = YES;
        }
        return cell;
    } else if (_selecteOtherReason && indexPath.section == 1) {
        ZZOrderOptionTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textviewcell"];
        
        if (!cell) {
            cell = [[ZZOrderOptionTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textviewcell"];
        }
        _textView = cell.textView;
        _textView.delegate = self;
        _textView.placeholder = @"请输入退款原因";
        
        return cell;
    } else {
        if (indexPath.row == 0) {
            static NSString *identifier = @"titlecell";
            ZZOrderRefundTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ZZOrderRefundTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            return cell;
        } else {
            static NSString *identifier = @"cell";
            ZZOrderRefundPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ZZOrderRefundPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            [cell setData:self.imageArray];
            
            WeakSelf;
            cell.touchAdd = ^{
                [weakSelf addImgBtnClick];
            };
            cell.touchImage = ^(NSInteger index) {
                [weakSelf imgBtnClic:index];
            };
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    } else if (_selecteOtherReason && indexPath.section == 1){
        return 104;
    } else {
        if (indexPath.row == 0) {
            return 50;
        } else {
            return (SCREEN_WIDTH - 60)/3 + 20;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ((_selecteOtherReason && section == 1) || (!_selecteOtherReason && section == 0)) {
        return 0.1;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ((_selecteOtherReason && section == 1) || (!_selecteOtherReason && section == 0)) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ((_selecteOtherReason && section == 1) || (!_selecteOtherReason && section == 0)) {
        NSString *string = @"为了确保您有充分拒绝退款理由，建议上传有关截图";
        CGFloat height = [ZZUtils heightForCellWithText:string fontSize:12 labelWidth:SCREEN_WIDTH - 30];
        return height+10;
    } else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ((_selecteOtherReason && section == 1) || (!_selecteOtherReason && section == 0)) {
        NSString *string = @"为了确保您有充分拒绝退款理由，建议上传有关截图";
        CGFloat height = [ZZUtils heightForCellWithText:string fontSize:12 labelWidth:SCREEN_WIDTH - 30];
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height + 10)];
        footView.backgroundColor = kBGColor;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = kGrayTextColor;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = string;
        titleLabel.numberOfLines = 0;
        [footView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(footView.mas_left).offset(15);
            make.right.mas_equalTo(footView.mas_right).offset(-15);
            make.top.mas_equalTo(footView.mas_top).offset(5);
        }];
        
        return footView;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == _refundModel.yours.count) {
            if (!_selecteOtherReason) {
                _selecteOtherReason = YES;
                [self.tableView reloadData];
            }
        } else {
            if (_selecteOtherReason) {
                _selecteOtherReason = NO;
            }
        }
        _indexPath = indexPath;
        [self.tableView reloadData];
    } else if (_selecteOtherReason && indexPath.section == 1) {
        
    } else {
        if (!_show) {
            _show = YES;
            [self.tableView reloadData];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

- (void)addImgBtnClick
{
    WeakSelf;
    [self showSheetActions:@"上传照片"
                   message:nil
               cancelTitle:@"取消"
             cancelHandler:nil
                   actions:@[
        [alertAction createWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            IOS_11_Show
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
              IOS_11_NO_Show
                [picker dismissViewControllerAnimated:YES completion:^{
                    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                    [weakSelf.imageArray addObject:image];
                    [weakSelf.tableView reloadData];
                }];
            };
            imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
                IOS_11_NO_Show
                [picker dismissViewControllerAnimated:YES completion:nil];
            };
            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        }],
        
        [alertAction createWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (@available(iOS 11.0, *)) {
                [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
                [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
                [UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
            }
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
                if (@available(iOS 11.0, *)) {
                    [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                    [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                    [UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                }
                [picker dismissViewControllerAnimated:YES completion:^{
                    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                    [weakSelf.imageArray addObject:image];
                    [weakSelf.tableView reloadData];
                }];
            };
            imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
                [picker dismissViewControllerAnimated:YES completion:nil];
            };
            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        }],
    ]];
}

- (void)imgBtnClic:(NSInteger)index
{
    [self showOkCancelSheet:nil message:nil confirmTitle:@"删除图片" confirmHandler:^(UIAlertAction * _Nonnull action) {
        [_imageArray removeObjectAtIndex:index];
        [_tableView reloadData];
    } cancelTitle:@"取消" cancelHandler:nil];
}

- (void)rightBtnClick
{
    if (!_indexPath) {
        [ZZHUD showErrorWithStatus:@"请选择理由或填写理由"];
        return;
    }
    NSString *content = @"";
    if (_indexPath.row == _refundModel.yours.count) {
        if (_textView.text.length == 0) {
            [ZZHUD showErrorWithStatus:@"请选择理由或填写理由"];
            return;
        } else {
            content = _textView.text;
        }
    } else {
        ZZOrderOptionModel *model = _refundModel.yours[_indexPath.row];
        content = model.content;
    }
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *param = [@{@"refuse_reason":content} mutableCopy];
    
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

#pragma mark - lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
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
