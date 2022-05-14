//
//  ZZIDPhotoManagerViewController.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/3.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZIDPhotoManagerViewController.h"
#import "ZZIDPhotoExampleViewController.h"

#import "ZZIDPhotoAddCell.h"
#import "ZZIDPhotoExampleCell.h"

#import "ZZUploader.h"
#import "ZZUser.h"
#import "ZZPhoto.h"

@interface ZZIDPhotoManagerViewController ()<UITableViewDelegate,UITableViewDataSource,ZZIDPhotoAddCellDelegate,ZZIDPhotoExampleCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) ZZIDPhoto *currentIDPhoto;

@property (nonatomic, strong) ZZPhoto *selectedPhoto;

@property (nonatomic, assign) BOOL isUpdate;

@property (nonatomic, strong) ZZUser *loginer;

@property (nonatomic, assign) BOOL isUploading;

@end

@implementation ZZIDPhotoManagerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _isComingFromWebView = NO;
        _isUploading = NO;
        _isUpdate = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"证件照管理";
    
    _loginer = [ZZUserHelper shareInstance].loginer;
    _currentIDPhoto = _loginer.id_photo;
    

    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn addTarget:self action:@selector(navigationRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self layout];
    [self fetchUploadTips];
    
    [self canProceedDueToInReview];
}

- (BOOL)canProceedDueToInReview {
    if (_currentIDPhoto.status == 1) {
        [ZZHUD showTaskInfoWithStatus:@"证件照审核中，暂不可操作，请等待审核结果"];
        return NO;
    }
    return YES;
}

/**
 *  保存按钮
 */
- (void)navigationRightBtnClick {
    if (![self canProceedDueToInReview]) {
        return;
    }
    // 没有选择照片
    if (!_isUpdate) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (!_selectedPhoto) {
        if (!_loginer.id_photo) {
            // 本身没有证件照 => 提示添加
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择照片" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            // 本身有证件照 => 删除 更新资料
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self saveUserInfos:YES isSame:NO];
        }
        return;
    }
    
    // 有选择照片
    [self checkIDPhotoIsOK];
}

/**
 *  返回按钮
 */
- (void)navigationLeftBtnClick {
    if (_isUpdate) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已修改，是否保存" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"保存" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self navigationRightBtnClick];
        }];
        [alert addAction:continueAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  检测证件照是不是本人
 */
- (void)checkIDPhotoIsOK {
    WEAK_SELF();
    [ZZHUD showWithStatus:@"正在保存用户信息"];
    if (!_loginer.id_photo) {
        _loginer.id_photo = [[ZZIDPhoto alloc] init];
    }
    _loginer.id_photo.pic = _selectedPhoto.url;
    [weakSelf saveUserInfos:NO isSame:NO];
}

/**
 *  保存UserInfo
 */
- (void)saveUserInfos:(BOOL)isDelete isSame:(BOOL)isSame {
   
    NSMutableDictionary *params = @{
                             @"id_photo_pic": isDelete ? @"" : _loginer.id_photo.pic,
                             }.mutableCopy;
    if (!isDelete) {
        params[@"id_photo_pic_isSame"] = @(isSame);
    }
    
    [_loginer updateWithParam:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [ZZHUD showSuccessWithStatus:@"更新成功!"];
        
        NSError *err;
        ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:&err];
        [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
    
        if (_delegate && [_delegate respondsToSelector:@selector(IDPhotoDidUpdated:needRefresh:)]) {
            [_delegate IDPhotoDidUpdated:self needRefresh:NO];
        }
        
        if (_isComingFromWebView) {
            NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
            NSArray *subArray = [array subarrayWithRange:NSMakeRange(0, array.count-2)];
            [self.navigationController setViewControllers:subArray animated:YES];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/**
 *  打开相册
 */
- (void)showPhotoBrowser {
    WEAK_SELF();
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

/**
 *  添加、上传图片到七牛
 */
- (void)addImageWithImage:(UIImage *)image {
    if (image) {
        [self uploadImage:image handler:^(BOOL isSuccess, ZZPhoto *photo) {
            if (isSuccess) {
                _selectedImage = image;
                _selectedPhoto = photo;
                _isUpdate = YES;
                
                if (_isUpdate) {
                    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                    }
                }
            }
            else {
                
            }
            [_tableView reloadData];
        }];
    }
    else {
        _selectedImage = nil;
        _selectedPhoto = nil;
        _currentIDPhoto.pic = nil;
        _isUpdate = YES;
        [_tableView reloadData];
        if (_isUpdate) {
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
        }
    }
}

/**
 *  上传头像
 */
- (void)uploadImage:(UIImage *)image
            handler:(void(^)(BOOL isSuccess, ZZPhoto *photo))handler {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSData *data = [ZZUtils userImageRepresentationDataWithImage:image];
    // 上传七牛
    [ZZUploader putData:data next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (resp) {
            ZZPhoto *photo = [[ZZPhoto alloc] init];
            photo.url = resp[@"key"];
            
            // 上传自己服务器
            [photo add:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                    if (handler) {
                        handler(NO, nil);
                    }
                } else {
                    [ZZHUD dismiss];
                    ZZPhoto *newPhoto = [[ZZPhoto alloc] initWithDictionary:data error:nil];
                    if (handler) {
                        handler(YES, newPhoto);
                    }
                }
            }];
        }
        else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [ZZHUD showErrorWithStatus:@"上传失败"];
            // 不确定是否需要, 反正先写着
            if ([ZZUserHelper shareInstance].unreadModel.open_log) {
                NSString *string = @"上传用户证件照错误";
                
                NSMutableDictionary *param = [@{@"type":string} mutableCopy];
                if ([ZZUserHelper shareInstance].uploadToken) {
                    [param setObject:[ZZUserHelper shareInstance].uploadToken forKey:@"uploadToken"];
                }
                if (info.error) {
                    [param setObject:[NSString stringWithFormat:@"%@",info.error] forKey:@"error"];
                }
                if (info.statusCode) {
                    [param setObject:[NSNumber numberWithInt:info.statusCode] forKey:@"statusCode"];
                }
                NSDictionary *dict = @{@"uid":[ZZUserHelper shareInstance].loginer.uid,
                                       @"content":[ZZUtils dictionaryToJson:param]};
                [ZZUserHelper uploadLogWithParam:dict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    
                }];
                if (handler) {
                    handler(NO, nil);
                }
            }
        }
    }];
}

- (void)fetchUploadTips {
    [ZZRequest method:@"GET" path:@"/user/upload_idphoto_tip" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        NSLog(@"%@",data);
        if (!error) {
            if (!isNullString(data[@"upload_idphoto_tip"])) {
                _currentIDPhoto.tips = data[@"upload_idphoto_tip"];
                [_tableView reloadData];
            }
            
        }
    }];
}

#pragma mark - ZZIDPhotoAddCellDelegate
- (void)cell:(ZZIDPhotoAddCell *)cell shouldAddPhoto:(BOOL)shouldAdd {
    if (![self canProceedDueToInReview]) {
        return;
    }
    
    WEAK_SELF();
    NSString *changeTitle = @"从相册选择";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    if (!isNullString(_currentIDPhoto.pic)) {
        changeTitle = @"更换";
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf addImageWithImage:nil];
        }];
        [alertController addAction:okAction];
    }
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:changeTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showPhotoBrowser];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - ZZIDPhotoExampleCellDelegate
- (void)cell:(ZZIDPhotoExampleCell *)cell shouldExampleOf:(NSInteger)index {
    ZZIDPhotoExampleViewController *viewController = [[ZZIDPhotoExampleViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSourceDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        ZZIDPhotoAddCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZIDPhotoAddCell cellIdentifier]
                                                                 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        [cell desc:_loginer.id_photo.reason];
        
        if (_selectedImage) {
            [cell idImage:_selectedImage];
        }
        else if (!isNullString(_currentIDPhoto.pic)) {
            [cell idImageStr:_currentIDPhoto.pic];
        }
        else {
            [cell idImage:nil];
        }
        
        return cell;
    }
    else {
        ZZIDPhotoExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZIDPhotoExampleCell cellIdentifier] forIndexPath:indexPath];
        [cell tips:_currentIDPhoto.tips];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    return cell;
}

#pragma mark - UI
- (void)layout {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Setter&Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 20;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[ZZIDPhotoAddCell class]
           forCellReuseIdentifier: [ZZIDPhotoAddCell cellIdentifier]];
        
        [_tableView registerClass:[ZZIDPhotoExampleCell class]
           forCellReuseIdentifier:[ZZIDPhotoExampleCell cellIdentifier]];
    }
    return _tableView;
}

@end
