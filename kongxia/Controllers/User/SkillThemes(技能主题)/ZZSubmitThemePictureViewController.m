//
//  ZZSubmitThemePictureViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSubmitThemePictureViewController.h"
#import "ZZPictureExampleViewController.h"
#import "ZZSkillCameraViewController.h"
#import "PECropViewController.h"

#import "ZZThemePictureCell.h"
#import "ZZThemePictureFooter.h"

#import "ZZUploader.h"
#import "ZZPhoto.h"

@interface ZZSubmitThemePictureViewController () <PECropViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *uploadArray;  //存储正在上传的uiimage对象, 设置转圈遮罩用
@property (nonatomic, assign) BOOL isChange;    //判断图片拖拽后是否在原cell范围内
@property (nonatomic, strong) NSMutableArray *cellAttributesArray;

@property (nonatomic, strong) ZZThemePictureCell *moveCell;

@end

@implementation ZZSubmitThemePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitialData];
    [self createRightBarButton];
    [self createView];
}

- (void)createRightBarButton {
    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.navigationRightDoneBtn setTitle:@"保存" forState:UIControlStateHighlighted];
    [self.navigationRightDoneBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.title = @"上传技能图片";
    self.view.backgroundColor = RGBCOLOR(245, 245, 245);
}

- (void)saveClick {
    if (![self checkPhotosStatus]) {
        [ZZHUD showTastInfoErrorWithString:@"上传失败或正在上传"];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        !self.savePhotoCallback ? : self.savePhotoCallback((NSArray<ZZPhoto> *)self.pictureArray);
    }
}

- (BOOL)savePhotoManual {
    //当此controller作为childContorller加入其它控制器时，通过此方法手动调用返回图片数据回调
    BOOL flag = [self checkPhotosStatus];
    if (flag) {
        !self.savePhotoCallback ? : self.savePhotoCallback((NSArray<ZZPhoto> *)self.pictureArray);
    } else {
        [ZZHUD showTastInfoErrorWithString:@"上传失败或正在上传"];
    }
    return flag;
}

- (BOOL)checkPhotosStatus { //查看图片上传状态，存在正上传或上传失败则返回NO
    BOOL flag = YES;
    for (id photo in self.pictureArray) {
        if (![photo isKindOfClass:[ZZPhoto class]]) {
            flag = NO;
            break;
        }
    }
    return flag;
}

- (void)setInitialData {
    
}

- (void)createView {
    [self.view addSubview:self.picCollect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//添加图片
- (void)addPicture {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传照片" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromCamera];
    }];
    [alert addAction:cameraAction];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromAlbum];
    }];
    [alert addAction:albumAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//删除图片
- (void)deletePictureAtIndexPath:(NSIndexPath *)indexPath {
    id photo = [self.pictureArray objectAtIndex:indexPath.row];
    if ([self.uploadArray containsObject:photo]) {
        [self.uploadArray removeObject:photo];
    }
    [self.pictureArray removeObjectAtIndex:indexPath.row];
    [self.picCollect reloadData];
}
//上传图片
- (void)uploadPhoto:(UIImage *)image {
    [self.pictureArray addObject:image];
    [self.uploadArray addObject:image];
    [self.picCollect reloadData];
    
    NSData *imageData = [ZZUtils userImageRepresentationDataWithImage:image];
    [ZZUploader putData:imageData next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.pictureArray indexOfObject:image] inSection:0];
        ZZThemePictureCell *cell = (ZZThemePictureCell *)[self.picCollect cellForItemAtIndexPath:indexPath];
        if (resp) {
            [cell.progressView success:^{
                ZZPhoto *photo = [[ZZPhoto alloc] init];
                photo.url = [kQNPrefix_url stringByAppendingString:key];
                [self.pictureArray replaceObjectAtIndex:indexPath.row withObject:photo];
                [self.picCollect reloadItemsAtIndexPaths:@[indexPath]];
            }];
        } else {
            [self.uploadArray removeObject:image];
            [cell.progressView failure];
        }
    }];
}
//拍照
- (void)takePhotoFromCamera {
    [ZZSkillThemesHelper queryCameraAuthorization:^(BOOL isAuth) {
        if (isAuth) {
            ZZSkillCameraViewController *controller = [[ZZSkillCameraViewController alloc] init];
            [controller setPhotoCallback:^(UIImage *image) {
//                [self uploadPhoto:image];
                [self edit:image];
            }];
            [self.navigationController presentViewController:controller animated:YES completion:nil];
        }
    }];
}
//从相册选择
- (void)takePhotoFromAlbum {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.navigationBar.translucent = NO;
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [self edit:image];
        }];
    };
    imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    };
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}
//图片裁剪
- (void)edit:(UIImage *)originalImage{
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
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - PECropViewControllerDelegate methods
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect {
    [controller dismissViewControllerAnimated:YES completion:NULL];
    [self uploadPhoto:croppedImage];
}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -- collectionviewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger itemCount = self.pictureArray.count >= 3 ? 3 : self.pictureArray.count + 1;
    return itemCount;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZThemePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ThemePictureIdentifier forIndexPath:indexPath];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.2;
    [cell addGestureRecognizer:longPress];
    
    if (indexPath.row >= self.pictureArray.count) {
        cell.cellType = ThemePictureTypeAdd;
    } else {
        if (indexPath.row == 0) {
            cell.cellType = ThemePictureTypeCover;
        } else {
            cell.cellType = ThemePictureTypePicture;
        }
        id photo = self.pictureArray[indexPath.row];
        if ([photo isKindOfClass:[UIImage class]]) {
            [cell.themePicture setImage:photo];
            if ([self.uploadArray containsObject:photo]) {
                [cell.progressView start];
            }
        } else {
            ZZPhoto *model = (ZZPhoto *)photo;
            [cell.themePicture sd_setImageWithURL:[NSURL URLWithString:model.url]];
        }
    }
    [cell setAddPicture:^{
        [self addPicture];
    }];
    [cell setDeletePicture:^{
        [self deletePictureAtIndexPath:indexPath];
    }];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    ZZThemePictureFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ThemePictureFooterIdentifier forIndexPath:indexPath];
    [footer setCheckPictureExample:^{
        ZZPictureExampleViewController *controller = [[ZZPictureExampleViewController alloc] init];
        controller.topic = self.topic;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    return footer;
}
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    //获取当前cell所对应的indexpath
    ZZThemePictureCell *cell = (ZZThemePictureCell *)longPress.view;
    if (![cell isKindOfClass:[ZZThemePictureCell class]]) {
        return ;
    }
    NSIndexPath *cellIndexpath = [self.picCollect indexPathForCell:cell];
    if (cellIndexpath.row >= self.pictureArray.count) { //添加图片按钮不能移动
        return ;
    }
    //将此cell 移动到视图的前面
    [self.picCollect bringSubviewToFront:cell];
    _isChange = NO;
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            //将第一个cell的封面标识去掉
            NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
            ZZThemePictureCell *firstCell = (ZZThemePictureCell *)[self.picCollect cellForItemAtIndexPath:index];
            firstCell.cellType = ThemePictureTypePicture;
            //使用数组将collectionView每个cell的 UICollectionViewLayoutAttributes 存储起来。
            [self.cellAttributesArray removeAllObjects];
            for (int i = 0; i < self.pictureArray.count; i++) {
                [self.cellAttributesArray addObject:[self.picCollect layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            //在移动过程中，使cell的中心与移动的位置相同。
            cell.center = [longPress locationInView:self.picCollect];
            for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
                //判断移动cell的indexpath，是否和目的位置相同，如果相同isChange为YES,然后将数据源交换
                if (CGRectContainsPoint(attributes.frame, cell.center) && cellIndexpath != attributes.indexPath) {
                    _isChange = YES;
                    id photo = self.pictureArray[cellIndexpath.row];
                    [self.pictureArray removeObjectAtIndex:cellIndexpath.row];
                    [self.pictureArray insertObject:photo atIndex:attributes.indexPath.row];
                    [self.picCollect moveItemAtIndexPath:cellIndexpath toIndexPath:attributes.indexPath];
                }
            }
        } break;
        case UIGestureRecognizerStateEnded: {
            //如果没有改变，直接返回原始位置
            if (!_isChange) {
                cell.center = [self.picCollect layoutAttributesForItemAtIndexPath:cellIndexpath].center;
            }
            //恢复第一个cell的封面标识
            NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
            ZZThemePictureCell *firstCell = (ZZThemePictureCell *)[self.picCollect cellForItemAtIndexPath:index];
            firstCell.cellType = ThemePictureTypeCover;
            
        } break;
        default: break;
    }
}
#pragma mark -- lazy load
- (UICollectionView *)picCollect {
    if (nil == _picCollect) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        layout.itemSize = CGSizeMake(PictureCollectionItemHeight, PictureCollectionItemHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, PictureCollectionFooterHeight);
        
        _picCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _picCollect.backgroundColor = [UIColor whiteColor];
        _picCollect.delegate = self;
        _picCollect.dataSource = self;
        _picCollect.showsVerticalScrollIndicator = NO;
        _picCollect.showsHorizontalScrollIndicator = NO;
        [_picCollect registerClass:[ZZThemePictureCell class] forCellWithReuseIdentifier:ThemePictureIdentifier];
        [_picCollect registerClass:[ZZThemePictureFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ThemePictureFooterIdentifier];
    }
    return _picCollect;
}
- (NSMutableArray *)pictureArray {
    if (nil == _pictureArray) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}
- (NSMutableArray *)uploadArray {
    if (nil == _uploadArray) {
        _uploadArray = [NSMutableArray array];
    }
    return _uploadArray;
}
- (NSMutableArray *)cellAttributesArray {
    if (nil == _cellAttributesArray) {
        _cellAttributesArray = [NSMutableArray array];
    }
    return _cellAttributesArray;
}

@end
