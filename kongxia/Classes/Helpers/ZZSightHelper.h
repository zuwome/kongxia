//
//  ZZSightHelper.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/6.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 小视频的
 */

typedef NS_ENUM(NSInteger, CameraState) {
    CameraStateIdle    = 0,
    CameraStateCapturing,
    CameraStateRecording,
    CameraStateSuccess,
    CameraStateFail    = 400,
};

typedef NS_ENUM(NSInteger, CameraType) {
    CameraTypeFontCamera    = 0,
    CameraTypeBackCamera
};

@class ZZSightHelper;

@protocol ZZSightHelperDelegate <NSObject>

- (void)helper:(ZZSightHelper *)helper finishRecording:(NSURL *)recordedFile;

- (void)helper:(ZZSightHelper *)helper recording:(CGFloat)duration;

@end


@interface ZZSightHelper : NSObject

@property (nonatomic, assign) NSUInteger maximunDuration;

@property (nonatomic, assign) CameraState               cameraState;

@property (nonatomic, assign) CameraType                cameraType;

@property (nonatomic, weak) id<ZZSightHelperDelegate> delegate;

@property (nonatomic,   copy) NSString *moviePath;

@property (nonatomic, strong) UIImage *tookImage;

#pragma mark - 视频类
@property (nonatomic,   weak) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) AVCaptureSession           *captureSession;

// 照片输出流对象
@property (nonatomic, strong)AVCaptureStillImageOutput   *stillImageOutput;

@property (nonatomic, strong) AVCaptureDevice            *videoCaptureDevice;

@property (nonatomic, strong) AVCaptureDeviceInput       *videoDeviceInput;

@property (nonatomic, strong) AVCaptureVideoDataOutput   *videoOutput;

@property (nonatomic, strong) AVCaptureConnection        *videoConnection;

@property (nonatomic, strong) AVCaptureDevice            *audioCaptureDevice;

@property (nonatomic, strong) AVCaptureDeviceInput       *audioDeviceInput;

@property (nonatomic, strong) AVCaptureAudioDataOutput   *audioOutput;

@property (nonatomic, strong) AVCaptureConnection        *audioConnection;

@property (nonatomic, strong) AVAssetWriter              *assetWriter;

@property (nonatomic, strong) AVAssetWriterInput         *videoWriter;

@property (nonatomic, strong) AVAssetWriterInput         *audioWriter;

- (void)startCaptureWithCompleteBlock:(void(^)(void))block;

- (void)releaseCaptureSession;

- (void)reset;

/*
 关闭摄像头
 */
- (void)stopCapture;

/*
 切换摄像头
 */
- (void)switchCamera;

/*
 拍照
 */
- (void)takePictureWithCompleteHandler:(void(^)(UIImage *image))completeBlock;

/*
 开始录像
 */
- (void)startRecording;

/*
 结束录像
 */
- (void)stopRecording;

- (void)saveVideoToAssetsLibrary;

- (void)savePhotoTooAssetsLibrary;

@end
