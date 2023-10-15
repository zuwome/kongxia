//
//  ZZReportViewController.m
//  zuwome
//
//  Created by angBiu on 2016/12/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZReportViewController.h"

#import "ZZReportModel.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ZZUploader.h"

#import "ZZReportTitleCell.h"
#import "ZZReportImageCell.h"
#import "ZZReportInputView.h"
#import "ZZReportBottomView.h"

@interface ZZReportViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, assign) NSInteger index;
@property (strong, nonatomic) NSMutableArray *imageArray;//上传的图片
@property (strong, nonatomic) NSMutableArray *imgUrlArray;
@property (nonatomic, assign) BOOL haveChooseImage;
@property (nonatomic, strong) ZZReportInputView *inputView;
@property (nonatomic, strong) ZZReportBottomView *bottomView;
@property (nonatomic, assign) BOOL canDone;
@property (assign, nonatomic) NSInteger imageCount;//传输第几张图片
@property (strong, nonatomic) NSString *content;
@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation ZZReportViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _isFromTask = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"举报";
    [self createNavigationRightDoneBtn];
    
    _haveChooseImage = YES;
    [self createViews];
    
    [MobClick event:Event_click_report];
}

- (void)createViews
{
    [self.navigationLeftBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [self.navigationLeftBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateHighlighted];
    [self.navigationLeftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationRightDoneBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ?self.contentArray.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"titlecell";
        
        ZZReportTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZReportTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [cell setIndexPath:indexPath index:_index array:self.contentArray];
        
        return cell;
    } else {
        static NSString *identifier = @"imagecell";
        
        ZZReportImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZReportImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        if (_haveChooseImage) {
            cell.arrowImgView.hidden = YES;
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        _index = indexPath.row;
        [self.tableView reloadData];
        if (_index == self.contentArray.count - 1) {
            [self.inputView.textView becomeFirstResponder];
        }
    } else {
        _haveChooseImage = YES;
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (_index == self.contentArray.count - 1) {
            return 165;
        } else {
            return 0.1;
        }
    } else {
        if (_haveChooseImage) {
            return (SCREEN_WIDTH - 60)/3 + 20;
        } else {
            return 0.1;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (_index == self.contentArray.count - 1) {
            return self.inputView;
        } else {
            return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        }
    } else {
        if (_haveChooseImage) {
            return self.bottomView;
        } else {
            return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        }
    }
}

#pragma mark - UIButtonMethod

- (void)leftBtnClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBtnClick
{
    [self.view endEditing:YES];
    if (_canDone) {
        [ZZHUD showErrorWithStatus:@"您已经举报过了 "];
        return;
    }
    _canDone = YES;
    _content = @"";
    if (_index == self.contentArray.count - 1) {
        if (self.inputView.textView.text.length == 0) {
            [self showOkAlert:@"提示" message:@"请输入举报原因!" confirmTitle:@"确定" confirmHandler:^(UIAlertAction * _Nonnull action) {
                _canDone = NO;
            }];
            return;
        } else {
            _content = self.inputView.textView.text;
        }
    } else {
        _content = self.contentArray[_index];
    }
    if (self.imageArray.count == 0) {
        [ZZHUD showErrorWithStatus:@"请至少上传一张图片作为凭证"];
        _canDone = NO;
        return;
    }
    
    [ZZHUD showWithStatus:@"举报中..."];
    if (self.imageArray.count) {
        _imageCount = 0;
        [self uploadPhoto:self.imageArray[0]];
    } else {
        
        if (_isFromTask) {
            NSMutableDictionary *param = @{
                                           @"content":     _content,
                                           @"img":         @"",
                                           @"report_user": UserHelper.loginer.uid,
                                           @"pd_user":     _pd_user,
                                           }.mutableCopy;
            
            if (_taskType == TaskFree) {
                param[@"pdgid"] = _pid;
            }
            else {
                param[@"pid"] = _pid;
            }
            
            [ZZTasksServer reportTaskWithParams:param.copy taskType:_taskType handler:^(ZZError *error, id data) {
                NSLog(@"%@",data);
                if (data) {
                    _canDone = NO;
                    [ZZHUD showSuccessWithStatus:@"举报成功"];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:reportSuccess:)]) {
                        [self.delegate viewController:self reportSuccess:YES];
                    }
                }
                else {
                    [ZZHUD showErrorWithStatus:error.message];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            return;
        }
        
        NSMutableDictionary *param = [@{@"content":_content} mutableCopy];
        if (_mid) {
            [param setObject:_mid forKey:@"mid"];
        }
        if (_skId) {
            [param setObject:_skId forKey:@"sk"];
        }
        if (_replyId) {
            [param setObject:_replyId forKey:@"rid"];
        }
        if (_sk_rid) {
            [param setObject:_sk_rid forKey:@"sk_rid"];
        }
        [ZZReportModel reportWithParam:param uid:_uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (data) {
                _canDone = NO;
                [ZZHUD showSuccessWithStatus:@"谢谢您的举报，我们将在2个工作日解决!"];

                [self dismissViewControllerAnimated:YES completion:^{
                }];
            } else {
                [ZZHUD showErrorWithStatus:error.message];
            }
        }];
    }
}

- (void)uploadPhoto:(UIImage *)image
{
    NSData *data = [ZZUtils imageRepresentationDataWithImage:image];
    [ZZUploader putData:data next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (resp) {
            [ZZHUD dismiss];
            [self.imgUrlArray addObject:resp[@"key"]];
            _imageCount++;
            if (self.imageArray.count > _imageCount) {
                [self uploadPhoto:self.imageArray[_imageCount]];
            } else {
                if (_isFromTask) {
                    NSMutableDictionary *param = @{
                                                   @"content": _content,
                                                   @"pid": _pid,
                                                   @"report_user": UserHelper.loginer.uid,
                                                   @"pd_user": _pd_user,
                                                   }.mutableCopy;
                    
                    if (_imgUrlArray.count != 0) {
                        NSMutableArray *imageArray = @[].mutableCopy;
                        [_imgUrlArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (!isNullString(obj)) {
                                [imageArray addObject:obj];
                            }
                        }];
                        
                        NSError *error = nil;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imageArray.copy options:NSJSONWritingPrettyPrinted error:&error];
                        
                        NSString *imgStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        param[@"imgs"] = imgStr;
                    }
                    
                    [ZZRequest method:@"POST" path:@"/api/pd/reportPd" params:param.copy next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                        NSLog(@"%@",data);
                        if (data) {
                            _canDone = NO;
                            [ZZHUD showSuccessWithStatus:@"举报成功"];
                            if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:reportSuccess:)]) {
                                [self.delegate viewController:self reportSuccess:YES];
                            }
                        }
                        else {
                            [ZZHUD showErrorWithStatus:error.message];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    return;
                }
                
                NSMutableDictionary *param = [@{@"content":_content,
                                                @"photos":self.imgUrlArray} mutableCopy];
                if (_mid) {
                    [param setObject:_mid forKey:@"mid"];
                }
                if (_skId) {
                    [param setObject:_skId forKey:@"sk"];
                }
                if (_replyId) {
                    [param setObject:_replyId forKey:@"rid"];
                }
                if (_sk_rid) {
                    [param setObject:_sk_rid forKey:@"sk_rid"];
                }
                [ZZReportModel reportWithParam:param uid:_uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (data) {
                        _canDone = NO;
                        [ZZHUD showSuccessWithStatus:@"谢谢您的举报，我们将在2个工作日解决!"];
                        [self dismissViewControllerAnimated:YES completion:^{
                        }];
                    } else {
                        [ZZHUD showErrorWithStatus:error.message];
                    }
                }];
            }
        } else {
            _canDone = NO;
            [ZZHUD showErrorWithStatus:@"上传失败"];
        }
    }];
}

#pragma mark -

- (void)selectIndexWithIndex:(NSInteger)index
{
    if (self.imageArray.count && index < self.imageArray.count) {
        [self showOkCancelSheet:nil message:nil confirmTitle:@"删除图片" confirmHandler:^(UIAlertAction * _Nonnull action) {
            [self.imageArray removeObjectAtIndex:index];
            self.bottomView.dataArray = self.imageArray;
        } cancelTitle:@"取消" cancelHandler:nil];
    } else if (index == self.imageArray.count) {
        [self addImage];
    }
}

- (void)addImage
{
    WeakSelf;
    [self showSheetActions:@"上传照片"
                   message:nil
               cancelTitle:@"取消"
             cancelHandler:nil
                   actions:@[
        [alertAction createWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
        }],
    
        [alertAction createWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
        }],
    ]];
}

- (void)addImageWithImage:(UIImage *)image
{
    [self.imageArray addObject:image];
    self.bottomView.dataArray = self.imageArray;
}

#pragma mark - Lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (NSMutableArray *)imgUrlArray
{
    if (!_imgUrlArray) {
        _imgUrlArray = [NSMutableArray array];
    }
    return _imgUrlArray;
}

- (UIView *)inputView
{
    if (!_inputView) {
        _inputView = [[ZZReportInputView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 165)];
    }
    return _inputView;
}

- (ZZReportBottomView *)bottomView
{
    WeakSelf;
    if (!_bottomView) {
        _bottomView = [[ZZReportBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH - 60)/3 + 20)];
        _bottomView.selectIndex = ^(NSInteger index) {
            [weakSelf selectIndexWithIndex:index];
        };
    }
    return _bottomView;
}

- (NSArray *)contentArray
{
    if (!_contentArray) {
        if (_isUser) {
            _contentArray = @[@"淫秽色情",@"恶意骚扰、不文明语言",@"涉嫌广告、传销等内容",@"欺诈（酒托、饭托等）",@"本人与资料内容不符",@"诱导现金或平台外交易",@"涉嫌政治及暴力等内容",@"其他"];
        } else {
            _contentArray = @[@"淫秽色情",@"恶意骚扰、不文明语言",@"涉嫌广告、传销等内容",@"欺诈（酒托、饭托等）",@"本人与资料内容不符",@"诱导现金或平台外交易",@"涉嫌政治及暴力等内容",@"其他"];
        }
    }
    return _contentArray;
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
