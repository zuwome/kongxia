//
//  PhotoAlbumViewController.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/5/25.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//


/**
 * WARNING: 本自定义相册只做演示用，若用于上线的 APP 中，则需按需求修改。
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "ZZVideoUploadStatusView.h"

@interface PLSScrollView : UIView

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images;

@property(strong, nonatomic) UIScrollView *scrollView;

@property(strong, nonatomic) NSMutableArray *images;

@property(strong, nonatomic) NSMutableArray *imageViews;

@property (strong, nonatomic) NSMutableArray *selectedAssets;

- (void)addImage:(UIImage *)image;

@end


@interface PHAsset (PLSImagePickerHelpers)

- (NSURL *)movieURL;

@end


@interface PLSAssetCell : UICollectionViewCell

@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (assign, nonatomic) PHImageRequestID imageRequestID;
@property (strong, nonatomic) UIView *maskView;
@property (nonatomic,assign) BOOL isDaRen;//是达人
@end


@interface PhotoAlbumViewController : UICollectionViewController
@property (nonatomic, assign) RecordType type;
@property (nonatomic, strong) ZZTopicGroupModel *selectedModel;
@property (nonatomic, assign) ShowHUDType showType;
@property (nonatomic, assign) BOOL isShowTopUploadStatus;// 是否在状态栏显示上传进度
@property (nonatomic, assign) BOOL isUploadAfterCompleted;//是否在上传完达人视频之后直接更新到User，再更新到服务器。（YES:在闪租录制成为达人，需要直接更新。 NO：表示在编辑资料上传视频，不需要直接更新，主动点保存才更新）
@property (assign, nonatomic) NSInteger maxSelectCount;
@property (nonatomic, strong) NSURL *exportURL;//相册视频最后要到处的路径
@property (nonatomic, assign) BOOL is_base_sk;
@property (nonatomic, assign) BOOL isFastChat;//是否是录制闪聊视频

@property (nonatomic,assign) BOOL isDaRen;//是达人

@end

