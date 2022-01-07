//
//  ZZUserEditHeadView.m
//  zuwome
//
//  Created by angBiu on 2017/3/8.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserEditHeadView.h"

#import "ZZUserEditPhotoCell.h"
#import "ZZUserEditPhotoAddCell.h"
#import "ZZUserEditPhotoEmptyCell.h"
#import "ZZCircleProgressView.h"
#import "ZZUploadPhotoExampleView.h"

#import "ZZUploader.h"
#import "PECropViewController.h"
#import "ZZPhoto.h"

static NSString *photoIdentifier = @"photo";
static NSString *photoAddIdentifier = @"photoadd";
static NSString *photoEmptyIdentifier = @"photoempty";

@interface ZZUserEditHeadView ()<PECropViewControllerDelegate>

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSMutableArray *uploadImgArray;//上传中得图片
@property (nonatomic, strong) UILabel *userIconLabel;
@property (nonatomic, strong) RACollectionViewReorderableTripletLayout *layout;
@property (nonatomic, strong) NSString *errorString;

@end

@implementation ZZUserEditHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.collectionView];
        _userIconLabel = [[UILabel alloc] init];
        
        _userIconLabel.text = @"头像";
        _userIconLabel.textColor = UIColor.whiteColor;
        _userIconLabel.textAlignment = NSTextAlignmentCenter;
        _userIconLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _userIconLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        [_collectionView addSubview:_userIconLabel];
        _userIconLabel.frame = CGRectMake(5, 5, 40.0, 20.0);
    }
    
    return self;
}

- (void)setPhotos:(NSMutableArray<ZZPhoto *> *)photos {
    _photos = photos;
    [self.imgArray removeAllObjects];
    [self.uploadImgArray removeAllObjects];
    [self.urlArray removeAllObjects];
    
    [self.imgArray addObjectsFromArray:photos];
    [self.urlArray addObjectsFromArray:photos];
    [self.collectionView reloadData];
}

- (void)showErrorStatusImage:(NSString *)errorString {
    _errorString = errorString;
    ZZPhoto *photo = self.urlArray[0];
    photo.status = 0;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView {
    return 5.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView {
    return 5.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView {
    return 5.f;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section
{
    return RACollectionViewTripletLayoutStyleSquare; //same as default !
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}

- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview
{
    return .3f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if (indexPath.row < self.imgArray.count) {
        ZZUserEditPhotoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:photoIdentifier forIndexPath:indexPath];
        cell.type = _type;
        id photo = self.imgArray[indexPath.row];
        id photo1 = self.urlArray[indexPath.row];
        BOOL canTouch = YES;
        
        cell.errorView.hidden = YES;
        cell.coverBgView.hidden = YES;
        cell.contentView.layer.borderWidth = 0;
        cell.progressView.hidden = YES;
        
        //用户头像只有首张显示审核不通过原因，技能图片每张都要显示不通过原因
        if ((indexPath.row == 0 || _type == EditTypeSkill) && ![photo1 isKindOfClass:[UIImage class]]) {
            ZZPhoto *model = (ZZPhoto *)photo1;
            // 头像状态
            if (model.status == 0) {
                cell.contentView.layer.borderWidth = 1;
                cell.errorView.hidden = NO;
                cell.coverBgView.hidden = NO;
                
                // 因为人工审核失败
                if (_isAvatarManuaReviewing == 3 && _type != EditTypeSkill) {
                    cell.errorLabel.text = @"抱歉！头像审核失败,请重新上传";
                }
                else {
                    cell.errorLabel.text = _type != EditTypeSkill ? _errorString : @"审核失败";
                }
            }
            else {
                if (_isAvatarManuaReviewing == 1 && _type != EditTypeSkill) {
                    cell.contentView.layer.borderWidth = 1;
                    cell.errorView.hidden = NO;
                    cell.errorLabel.text = @"人工审核中头像暂不可操作";
                    cell.coverBgView.hidden = NO;
                }
            }
        }
        
        if ([photo1 isKindOfClass:[UIImage class]]) {
            cell.imgView.image = photo1;
            cell.coverBgView.hidden = NO;
            canTouch = NO;
            cell.progressView.hidden = NO;
            [cell.progressView start];
        }
        else {
            if ([photo isKindOfClass:[UIImage class]]) {
                cell.imgView.image = photo;
            }
            else {
                ZZPhoto *model = (ZZPhoto *)photo;
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.url]];
            }
        }
        
        if (canTouch) {
            __weak typeof(cell) _cell = cell;
            cell.touchSelf = ^{
                [weakSelf tapPhotoAtCell:_cell];
            };
        }
        return cell;
    }
    else if (indexPath.row == self.imgArray.count) {
        ZZUserEditPhotoAddCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:photoAddIdentifier forIndexPath:indexPath];
        cell.type = _type;
        cell.touchSelf = ^{
            [weakSelf addPhotoWithIndexPath:indexPath];
        };
        return cell;
    }
    else {
        ZZUserEditPhotoEmptyCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:photoEmptyIdentifier forIndexPath:indexPath];
        return cell;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.imgArray.count) {
        if (indexPath.row == 0) {
            // 照片是否属于审核中
            if (loginedUser.avatar_manual_status == 1) {
                return NO;
            }
        }
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)fromIndexPath
    canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    if (toIndexPath.row >= self.imgArray.count) {
        return NO;
    }
    else {
        if (toIndexPath.row == 0) {
            // 照片是否属于审核中
            if (_type == EditTypeUser) {
                if (loginedUser.avatar_manual_status == 1) {
                    return NO;
                }
            }
        }
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)fromIndexPath
    didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    if (toIndexPath.row == 0) {
        // 照片是否属于审核中
        if (_type == EditTypeUser) {
            if (loginedUser.avatar_manual_status == 1) {
                return;
            }
        }
    }
    _isUpdate = YES;
    id photo = [self.imgArray objectAtIndex:fromIndexPath.row];
    if (photo) {
        [self.imgArray removeObjectAtIndex:fromIndexPath.row];
        [self.imgArray insertObject:photo atIndex:toIndexPath.row];
    }
    id photo1 = [self.urlArray objectAtIndex:fromIndexPath.row];
    if (photo1) {
        [self.urlArray removeObjectAtIndex:fromIndexPath.row];
        [self.urlArray insertObject:photo1 atIndex:toIndexPath.row];
    }
    if (_type == EditTypeUser && fromIndexPath.row == 0) {
        [self hideErrorInfo:fromIndexPath];
    } else if (_type == EditTypeUser && toIndexPath.row == 0) {
        [self hideErrorInfo:toIndexPath];
    }
}

- (void)hideErrorInfo:(NSIndexPath *)indexPath
{
    ZZUserEditPhotoCell *cell = (ZZUserEditPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.errorView.hidden = YES;
        cell.coverBgView.hidden = YES;
        cell.contentView.layer.borderWidth = 0;
    });
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self finishRecognizer];
}

- (void)finishRecognizer
{
    if (!_layout.recognizerFinish) {
        [_layout finishRecognizer];
    }
}

#pragma mark -
- (void)tapPhotoAtCell:(UICollectionViewCell *)cell {
    [self finishRecognizer];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    // 头像选项：拍照，从手机相册选择
    if (_type == EditTypeUser && indexPath.row == 0) {
        // 照片是否属于审核中
        if (loginedUser.avatar_manual_status == 1) {
            [UIAlertController presentAlertControllerWithTitle:@"温馨提醒"
                                                       message:@"头像正在人工审核，您可以上传其他副头像"
                                                     doneTitle:@"知道了"
                                                   cancelTitle:nil
                                                 completeBlock:nil];
            return;
        }
        
        UIActionSheet *sheets = [UIActionSheet showInView:_weakCtl.view
                                                withTitle:nil
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@[@"拍照",@"从手机相册选择"]
                                                 tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                                                     switch (buttonIndex) {
                                                         case 0:
                                                             _isReplaceHead = YES;
                                                             [self gotoCamera];
                                                             break;
                                                         case 1:
                                                             _isReplaceHead = YES;
                                                             [self gotoAlbum];
                                                             break;
                                                         default: break;
                                                     }
                                                 }];
        
        ZZUploadPhotoExampleView *exampleView = [ZZUploadPhotoExampleView showPhotos:_type == EditTypeUser ? PhotoUserInfo : PhotoUserSkill showin:[UIApplication sharedApplication].keyWindow];
        [exampleView show];
        
        sheets.willDismissBlock = ^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            [exampleView hide];
        };
    }
    else {    //其余选项：删除
        [UIActionSheet showInView:_weakCtl.view
                        withTitle:nil
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:@"删除"
                otherButtonTitles:nil
                         tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                             switch (buttonIndex) {
                                 case 0: {
                                     _isUpdate = YES;
                                     if (indexPath.row < self.imgArray.count) {
                                         [self.imgArray removeObjectAtIndex:indexPath.row];
                                         [self.urlArray removeObjectAtIndex:indexPath.row];
                                     }
                        
                                     [self.collectionView reloadData];
                                 } break;
                                 default: break;
                             }
                         }];
    }
}

- (void)addPhotoWithIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:Event_click_edit_uploadimage];
    UIActionSheet *sheets = [UIActionSheet showInView:_weakCtl.view
                                            withTitle:nil
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
    
    ZZUploadPhotoExampleView *exampleView = [ZZUploadPhotoExampleView showPhotos:_type == EditTypeUser ? PhotoUserInfo : PhotoUserSkill showin:[UIApplication sharedApplication].keyWindow];
    [exampleView show];

    sheets.willDismissBlock = ^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        [exampleView hide];
    };
    
}

//相册
- (void)gotoAlbum {
    WeakSelf;
   IOS_11_Show
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setDelegate:self];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
      IOS_11_NO_Show
        [[UIApplication sharedApplication] setStatusBarHidden:YES];

        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
             [weakSelf edit:image];

        }];
    };
    imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        IOS_11_NO_Show

    };
    [_weakCtl.navigationController presentViewController:imgPicker animated:YES completion:nil];
}
//编辑相册
-(void)edit:(UIImage *)originalImage{
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = originalImage;
    controller.keepingCropAspectRatio = YES;
    UIImage *image = originalImage;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    [controller resetCropRect];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];

    
    [_weakCtl presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
     [self uploadPhoto:croppedImage];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{

    [controller dismissViewControllerAnimated:YES completion:NULL];
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
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setAllowsEditing:YES];
    [imgPicker setDelegate:self];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            [weakSelf uploadPhoto:image];
        }];
    };
    imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    [_weakCtl.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

- (void)uploadPhoto:(UIImage *)image
{
    if (!image) {
        [ZZHUD showErrorWithStatus:@"请重试"];
        return;
    }
    [self.uploadImgArray addObject:image];
    ZZPhoto *photo = nil;
    __weak typeof(photo)weakPhoto = photo;
    __block NSInteger index = 0;
    if (_isReplaceHead) {
        [self.imgArray replaceObjectAtIndex:0 withObject:image];
        [self.urlArray replaceObjectAtIndex:0 withObject:image];
        weakPhoto = self.imgArray[0];
    } else {
        [self.imgArray addObject:image];
        [self.urlArray addObject:image];
        index = self.imgArray.count - 1;
    }
    [self.collectionView reloadData];
    _isUploading = YES;
    BOOL isHeadPhoto = _isReplaceHead;
    _isReplaceHead = NO;
    
    NSData *data = [ZZUtils userImageRepresentationDataWithImage:image];
    [ZZUploader putData:data next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        __strong typeof(weakPhoto)strongPhoto = weakPhoto;
        if (resp) {
            ZZPhoto *photo = [[ZZPhoto alloc] init];
            photo.url = resp[@"key"];
            [photo add:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                    [self uploadError:image isHeadPhoto:isHeadPhoto photo:strongPhoto];
                } else {
                    _isUpdate = YES;
                    [ZZHUD dismiss];
                    ZZPhoto *newPhoto = [[ZZPhoto alloc] initWithDictionary:data error:nil];
                    if ([self.urlArray containsObject:image]) {
                        index = [self.urlArray indexOfObject:image];
                        [self.urlArray replaceObjectAtIndex:index withObject:newPhoto];
                    }
                    [self.uploadImgArray removeObject:image];
                    [self checkHaveFinishedUpload];
                    
                    [self.collectionView performBatchUpdates:^{
                        NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
                        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
                    } completion:^(BOOL finished) {
                        NSInteger index = [self.imgArray indexOfObject:image];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                        ZZUserEditPhotoCell *cell = (ZZUserEditPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                        cell.coverBgView.hidden = NO;
                        cell.progressView.hidden = NO;
                        __weak typeof(cell)weakCell = cell;
                        [cell.progressView success:^{
                            weakCell.coverBgView.hidden = YES;
                        }];
                    }];
                }
            }];
        } else {
            [ZZHUD showErrorWithStatus:@"上传失败"];
            [self uploadError:image isHeadPhoto:isHeadPhoto photo:strongPhoto];
            
            if ([ZZUserHelper shareInstance].unreadModel.open_log) {
                NSString *string = @"上传用户图片错误";
                
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
            }
        }
    }];
}

- (void)uploadError:(UIImage *)image isHeadPhoto:(BOOL)isHeadPhoto photo:(ZZPhoto *)photo
{
    if (isHeadPhoto) {
        if ([self.imgArray containsObject:image]) {
            NSInteger index = [self.imgArray indexOfObject:image];
            if (index<self.imgArray.count) {
                [self.imgArray replaceObjectAtIndex:index withObject:photo];
                [self.urlArray replaceObjectAtIndex:index withObject:photo];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                ZZUserEditPhotoCell *cell = (ZZUserEditPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [cell.progressView failure];
            }
        }
    } else {
        [self.imgArray removeObject:image];
        [self.urlArray removeObject:image];
    }
    [self reloadData];
}

- (void)reloadData
{
    [self checkHaveFinishedUpload];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
//检测是否还有图片在上传
- (void)checkHaveFinishedUpload
{
    _isUploading = NO;
    for (id object in self.urlArray) {
        if ([object isKindOfClass:[UIImage class]]) {
            _isUploading = YES;
            break;
        }
    }
}

#pragma mark - lazyload

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _layout = [[RACollectionViewReorderableTripletLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZZUserEditPhotoCell class] forCellWithReuseIdentifier:photoIdentifier];
        [_collectionView registerClass:[ZZUserEditPhotoAddCell class] forCellWithReuseIdentifier:photoAddIdentifier];
        [_collectionView registerClass:[ZZUserEditPhotoEmptyCell class] forCellWithReuseIdentifier:photoEmptyIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSMutableArray *)imgArray
{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (NSMutableArray *)uploadImgArray
{
    if (!_uploadImgArray) {
        _uploadImgArray = [NSMutableArray array];
    }
    return _uploadImgArray;
}

- (NSMutableArray *)urlArray
{
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (void)setType:(PhotoEditType)type {
    _type = type;
    [_userIconLabel setHidden:!(_type == EditTypeUser)];
}

@end
