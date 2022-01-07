//
//  ZZRecordBottomView.m
//  zuwome
//
//  Created by angBiu on 2017/5/27.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRecordBottomView.h"
#import "ZZSystemToolsManager.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface ZZRecordBottomView ()

@property (nonatomic, strong) UIImageView *deleteImgView;
@property (nonatomic, strong) UIImageView *doneImgView;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIImageView *albumImageView;
@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation ZZRecordBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.image = [UIImage imageNamed:@"icon_rent_bottombg"];
        [self addSubview:bgImgView];
        
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _width = (SCREEN_WIDTH - 100) / 4.0;
        
        [self addSubview:self.deleteBtn];
        [self addSubview:self.selectPhotoBtn];
        [self addSubview:self.doneBtn];
        
        _deleteBtn.frame = CGRectZero;
        _doneBtn.frame = CGRectZero;
        _selectPhotoBtn.frame = CGRectZero;
        
        [_deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(_width, 60));
            make.left.equalTo(self).offset(_width - 30);
            make.bottom.equalTo(self).offset(- (14 + (isIPhoneX ? 34 : 0)));
        }];
        
        [_selectPhotoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.right.equalTo(self).offset(-(_width - 32));
            make.bottom.equalTo(_deleteBtn);
        }];
        
        [_doneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.right.equalTo(_selectPhotoBtn);
            make.bottom.equalTo(_deleteBtn);
        }];
    }
    return self;
}

- (void)setIsHidePhoto:(BOOL)isHidePhoto {
    _isHidePhoto = isHidePhoto;
    if (isHidePhoto) {
        [self.selectPhotoBtn removeFromSuperview];
    }
}

- (void)setDeleteSelected:(BOOL)deleteSelected {
    _deleteSelected = deleteSelected;
    if (deleteSelected) {
        _deleteImgView.image = [UIImage imageNamed:@"icon_record_delete_p"];
    }
    else {
        _deleteImgView.image = [UIImage imageNamed:@"icon_record_delete_n"];
    }
}

- (void)setDoneSelected:(BOOL)doneSelected {
    _doneSelected = doneSelected;
    if (doneSelected) {
        _doneImgView.image = [UIImage imageNamed:@"icon_record_done_p"];
    }
    else {
        _doneImgView.image = [UIImage imageNamed:@"icon_record_done_n"];
    }
}

- (void)deleteBtnClick {
    self.deleteSelected = !self.deleteSelected;
    if (_touchDelete) {
        _touchDelete();
    }
    _deleteBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _deleteBtn.userInteractionEnabled = YES;
    });
}

- (void)selectPhotoBtnClick {
    if (![ZZUtils isAllowCamera]) {
        [UIAlertController presentAlertControllerWithTitle:@"开启相机权限" message:@"在“设置-空虾”中开启相机就可以开始使用本功能哦~" doneTitle:@"设置" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                if (UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:appSettings];
                }
            }
        }];
        return;
    }
    BLOCK_SAFE_CALLS(self.selectPhotoBlock);
}

- (void)doneBtnClick {
//    if (self.doneSelected) {
//        if (_touchDone) {
//            _touchDone();
//        }
//    }
    if (_touchDone) {
        _touchDone();
    }
}

#pragma mark -
- (void)hideAllViews {
    [self hideConfigView];
    [self hideOperateView];
}

- (void)showAllViews {
    [self showConfigView];
    if (_videoCount != 0) {
        [self showOperateView];
    }
}

- (void)hideConfigView {
    self.selectPhotoBtn.hidden = YES;
}

- (void)showConfigView {
    self.selectPhotoBtn.hidden = NO;
}

- (void)hideOperateView {
    self.deleteBtn.hidden = YES;
    self.doneBtn.hidden = YES;
}

- (void)showSelectPhotoView {
    // 回删视频段为0的时候，显示相册
    self.selectPhotoBtn.hidden = NO;
}

- (void)showOperateView {
    self.selectPhotoBtn.hidden = YES;
    self.deleteBtn.hidden = NO;
    self.doneBtn.hidden = NO;
}

- (void)showVideoCoverIfNeeded {
    WEAK_SELF();
    if ([ZZUtils isAllowPhotoLibrary]) {
        __block CGSize viewSize = CGSizeZero;
        dispatch_async(dispatch_get_main_queue(), ^{
            viewSize = weakSelf.bounds.size;
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
            fetchOptions.includeHiddenAssets = NO;
            fetchOptions.includeAllBurstAssets = NO;
            if (IOS9_OR_LATER) {
                /*
                 PHAssetSourceTypeNone   都没有,就获得到就是常规的
                 PHAssetSourceTypeUserLibrary     用户所有的
                 PHAssetSourceTypeCloudShared     分享的
                 PHAssetSourceTypeiTunesSynced    iTunes 同步的
                 */
                fetchOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary | PHAssetSourceTypeiTunesSynced;
            }
            fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO],
                                             [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOptions];
            PHAsset *asset = fetchResult.firstObject;
            
            if (asset != nil) {
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.synchronous = YES;
                options.resizeMode = PHImageRequestOptionsResizeModeExact;
                CGFloat scale = [UIScreen mainScreen].scale;
                CGSize size = CGSizeMake(viewSize.width * scale, viewSize.height * scale);
                [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                                 targetSize:size
                                                                                contentMode:PHImageContentModeAspectFill
                                                                                    options:options
                                                                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                                      if (result) {
                                                                                          weakSelf.albumImageView.hidden = YES;
                                                                                          weakSelf.coverImageView.hidden = NO;
                                                                                          weakSelf.coverImageView.image = stretchImgFromMiddle(result);
                                                                                      } else {
                                                                                          weakSelf.albumImageView.image = [UIImage imageNamed:@"icVideoAlbum"];
                                                                                          weakSelf.albumImageView.hidden = NO;
                                                                                          weakSelf.coverImageView.hidden = YES;
                                                                                      }
                                                                                  });
                                                                              }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.albumImageView.hidden = NO;
                    self.coverImageView.hidden = YES;
                });
            }
        });

    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.albumImageView.hidden = NO;
            self.coverImageView.hidden = YES;
        });
    }
}

#pragma mark - lazyload
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        if (font) {
             titleLabel.font = font;
        }else{
             titleLabel.font = [UIFont systemFontOfSize:12];
        }
        
        titleLabel.text = @"回删";
        titleLabel.userInteractionEnabled = NO;
        [_deleteBtn addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_deleteBtn.mas_centerX);
            make.bottom.mas_equalTo(_deleteBtn.mas_bottom).offset(-10);
        }];
        
        _deleteImgView = [[UIImageView alloc] init];
        _deleteImgView.image = [UIImage imageNamed:@"icon_record_delete_n"];
        _deleteImgView.userInteractionEnabled = NO;
        [_deleteBtn addSubview:_deleteImgView];
        
        [_deleteImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_deleteBtn.mas_centerX);
            make.bottom.mas_equalTo(titleLabel.mas_top).offset(-8);
            make.size.mas_equalTo(CGSizeMake(25, 21.5));
        }];
    }
    return _deleteBtn;
}

- (UIButton *)selectPhotoBtn {
    if (!_selectPhotoBtn) {
        //icVideoAlbum
        _selectPhotoBtn = [[UIButton alloc] init];
        
        [_selectPhotoBtn addTarget:self action:@selector(selectPhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        if (font) {
            titleLabel.font = font;
        }else{
            titleLabel.font = [UIFont systemFontOfSize:12];
        }
        titleLabel.text = @"相册";
        titleLabel.userInteractionEnabled = NO;
        [_selectPhotoBtn addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_selectPhotoBtn.mas_centerX);
            make.bottom.mas_equalTo(_selectPhotoBtn.mas_bottom).offset(-10);
        }];
        
        self.albumImageView = [[UIImageView alloc] init];
        self.albumImageView.image = [UIImage imageNamed:@"icVideoAlbum"];
        self.albumImageView.userInteractionEnabled = NO;
        self.albumImageView.hidden = NO;
        [_selectPhotoBtn addSubview:self.albumImageView];
        
        [self.albumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_selectPhotoBtn.mas_centerX);
            make.bottom.mas_equalTo(titleLabel.mas_top).offset(-8);
            make.size.mas_equalTo(CGSizeMake(25, 21.5));
        }];
        
        self.coverImageView = [UIImageView new];
        self.coverImageView.userInteractionEnabled = NO;
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.layer.cornerRadius = 5.0f;
        [_selectPhotoBtn addSubview:self.coverImageView];
        self.coverImageView.hidden = YES;
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_selectPhotoBtn.mas_centerX);
            make.bottom.mas_equalTo(titleLabel.mas_top).offset(-8);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        //看是否要不要显示第一个视频封面
        [self showVideoCoverIfNeeded];
    }
    return _selectPhotoBtn;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc] init];
        [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = @"提交";
        titleLabel.userInteractionEnabled = NO;
        [_doneBtn addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_doneBtn.mas_centerX);
            make.bottom.mas_equalTo(_doneBtn.mas_bottom).offset(-10);
        }];
        
        _doneImgView = [[UIImageView alloc] init];
        _doneImgView.image = [UIImage imageNamed:@"icon_record_done_n"];
        _doneImgView.userInteractionEnabled = NO;
        [_doneBtn addSubview:_doneImgView];
        
        [_doneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_doneBtn.mas_centerX);
            make.bottom.mas_equalTo(titleLabel.mas_top).offset(-8);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
    return _doneBtn;
}

@end
