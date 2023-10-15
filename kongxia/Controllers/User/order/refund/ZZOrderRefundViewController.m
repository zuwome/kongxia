//
//  ZZOrderRefundViewController.m
//  zuwome
//
//  Created by angBiu on 16/9/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrderRefundViewController.h"
#import "ZZOrderDetailViewController.h"
#import "ZZChatViewController.h"

#import "ZZOrderRefundTitleCell.h"
#import "ZZOrderRefundPhotoCell.h"

#import "TPKeyboardAvoidingTableView.h"
#import "ZZOrder.h"
#import "ZZUploader.h"

@interface ZZOrderRefundViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    TPKeyboardAvoidingTableView     *_tableView;
    UITextView                      *_textView;
    UILabel                         *_countLabel;
    NSMutableArray                  *_imageArray;
    BOOL                            _show;
}

@end

@implementation ZZOrderRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"对方无法赴约";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationRightDoneBtn];
    
    [self createViews];
}

- (void)createViews
{
    _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kBGColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    _imageArray = [NSMutableArray array];
    
    [self createHeadView];
    
    [self.navigationRightDoneBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 205)];
    headView.backgroundColor = [UIColor whiteColor];
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.textColor = kBlackTextColor;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.placeholder = @"请输入申请原因";
    _textView.delegate = self;
    _textView.text = _reasonString;
    [headView addSubview:_textView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left).offset(15);
        make.right.mas_equalTo(headView.mas_right).offset(-15);
        make.top.mas_equalTo(headView.mas_top).offset(10);
        make.height.mas_equalTo(@160);
    }];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.textColor = kGrayTextColor;
    _countLabel.font = [UIFont systemFontOfSize:12];
    _countLabel.text = [NSString stringWithFormat:@"0/200"];
    [headView addSubview:_countLabel];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headView.mas_right).offset(-15);
        make.bottom.mas_equalTo(headView.mas_bottom).offset(-20);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = kBGColor;
    [headView addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left);
        make.right.mas_equalTo(headView.mas_right);
        make.bottom.mas_equalTo(headView.mas_bottom);
        make.height.mas_equalTo(@15);
    }];
    
    _tableView.tableHeaderView = headView;
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _show ? 2:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *identifier = @"titlecell";
        
        ZZOrderRefundTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZOrderRefundTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        if (_show) {
            cell.arrowImgView.hidden = YES;
        } else {
            cell.arrowImgView.hidden = NO;
        }
        
        return cell;
    } else {
        static NSString *identifier = @"cell";
        
        ZZOrderRefundPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZOrderRefundPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [cell setData:_imageArray];
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    } else {
        return (SCREEN_WIDTH - 60)/3 + 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (SCREEN_WIDTH - 60)/3 + 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH - 60)/3 + 40)];
    footView.backgroundColor = kBGColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = kBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"申请提交之后，若对方同意退款或24小时内不操作意向金都将退回您的钱包，若对方不同意，将由平台进行判定。";
    titleLabel.numberOfLines = 0;
    [footView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footView.mas_left).offset(15);
        make.right.mas_equalTo(footView.mas_right).offset(-15);
        make.top.mas_equalTo(footView.mas_top).offset(15);
    }];
    
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0 && !_show) {
        _show = YES;
        [_tableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIButtonMethod

- (void)rightBtnClick
{
    if (isNullString(_textView.text)) {
        [ZZHUD showErrorWithStatus:@"请输入申请原因!"];
        return;
    }
    NSMutableDictionary *param = [@{@"price":[NSNumber numberWithDouble:_order.deposit*_percent],
                                    @"dispute":[NSNumber numberWithBool:NO],
                                    @"is_deposit":[NSNumber numberWithBool:YES],
                                    @"remarks":_textView.text,
                                    @"reason_type":[NSNumber numberWithInteger:1]} mutableCopy];
    if (_imageArray.count) {
        [ZZHUD showWithStatus:@"图片上传中..."];
        [ZZUploader uploadImages:_imageArray progress:^(CGFloat progress) {

        } success:^(NSArray *urlArray) {
            [param setObject:urlArray forKey:@"photos"];
            NSDictionary *aDict = @{@"refund":param};
            [self refundDepositWithParam:aDict];
        } failure:^{
            [ZZHUD showErrorWithStatus:@"图片上传失败!"];
        }];
    } else {
        NSDictionary *aDict = @{@"refund":param};
        [self refundDepositWithParam:aDict];
    }
}

//意向金退款
- (void)refundDepositWithParam:(NSDictionary *)param
{
    [ZZHUD showWithStatus:@"正在申请退意向金.."];
    [ZZOrder refundOrder:param status:_order.status orderId:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            if (_successCallBack) {
                _successCallBack();
            }
            _order.refund.price = [NSNumber numberWithDouble:_order.deposit*_percent];
            _order.refund.dispute = NO;
            _order.refund.remarks = _textView.text;
            for (UIViewController *ctl in self.navigationController.viewControllers) {
                if ([ctl isKindOfClass:[ZZOrderDetailViewController class]]) {
                    [self.navigationController popToViewController:ctl animated:YES];
                    break;
                }
                if ([ctl isKindOfClass:[ZZChatViewController class]]) {
                    [self.navigationController popToViewController:ctl animated:YES];
                    break;
                }
            }
        }
    }];
}

- (void)addImgBtnClick
{
    WeakSelf;
    [self showSheetActions:@"上传照片"
                   message:nil
               cancelTitle:@"取消"
             cancelHandler:nil
                   actions:@[
        [alertAction createWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setDelegate:self];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
                [picker dismissViewControllerAnimated:YES completion:^{
                    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                    [_imageArray addObject:image];
                    [_tableView reloadData];
                }];
            };
            imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
                [picker dismissViewControllerAnimated:YES completion:nil];
            };
            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        }],
        
        [alertAction createWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            IOS_11_Show
                 UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                 [imgPicker setDelegate:self];
                 [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                 imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
                 IOS_11_NO_Show
                     [picker dismissViewControllerAnimated:YES completion:^{
                         UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                         [_imageArray addObject:image];
                         [_tableView reloadData];
                     }];
                 };
                 imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
                     IOS_11_NO_Show
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

#pragma mark - UITextViewMethod

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%ld/200",textView.text.length];
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
