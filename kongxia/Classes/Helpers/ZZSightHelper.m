//
//  ZZSightHelper.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/6.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZSightHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import "JX_GCDTimerManager.h"

#define DocumentsPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

@interface ZZSightHelper ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic,   copy) dispatch_queue_t captureQueue;

@property (nonatomic, assign) CGFloat currentRecordTime;

@property (nonatomic, assign) CMTime startTime;

@end

@implementation ZZSightHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        _maximunDuration = 15.0;
        _currentRecordTime = 0.0;
        _cameraState          = CameraStateIdle;
        _cameraType           = CameraTypeBackCamera;
        _captureQueue         = dispatch_queue_create("cn.qiuyouqun.im.wclrecordengine.capture", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - public Method
- (void)startCaptureWithCompleteBlock:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self initCaptureSession]) {
            [_captureSession startRunning];
            if (block) {
                block();
            }
        }
    });
}

- (void)stopCapture {
    [_captureSession stopRunning];
}

- (void)switchCamera {
    NSString *errorString = [self switchCameraDevices];
    if (errorString) {
        NSLog(@"%@",errorString);
        [ZZHUD showTaskInfoWithStatus:errorString];
    }
}

- (void)takePictureWithCompleteHandler:(void (^)(UIImage *))completeBlock {
    WeakSelf
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        return;
    }
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        NSLog(@"拍照成功!!!!");
        weakSelf.tookImage = image;
        if (completeBlock) {
            completeBlock(image);
        }
    }];
}

- (void)startRecording {
    @synchronized(self) {
        NSLog(@"**********record begin**********");
        if (!_isRecording) {
            [self reset];
            _isRecording = YES;
        }
    }
}

- (void)stopRecording {
    _currentRecordTime = 0;
    NSLog(@"**********record stopped**********");
    
    if (!_isRecording) {
        return;
    }
    
    _isRecording = NO;
    
    if (_assetWriter.status == AVAssetWriterStatusUnknown ||
        _assetWriter.status == AVAssetWriterStatusCompleted ||
        _assetWriter.status == AVAssetWriterStatusFailed ||
        _assetWriter.status == AVAssetWriterStatusCancelled) {
        NSLog(@"asset writer was in an unexpected state (%@)", @(_assetWriter.status));
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZZHUD show];
    });
    
    [_videoWriter markAsFinished];
    [_audioWriter markAsFinished];
    if (_assetWriter && _assetWriter.status == AVAssetWriterStatusWriting) {
        [_assetWriter finishWritingWithCompletionHandler:^{
           dispatch_async(dispatch_get_main_queue(), ^{
                [ZZHUD dismiss];
            });
            
            if (_assetWriter.status == AVAssetWriterStatusCompleted) {
                [self cameraStateDidChanged:CameraStateSuccess];
                if (self.delegate && [self.delegate respondsToSelector:@selector(helper:finishRecording:)]) {
                    [self.delegate helper:self finishRecording:[NSURL fileURLWithPath:_moviePath]];
                }
            }
            else {
                [self cameraStateDidChanged:CameraStateFail];
            }
        }];
    }
    else {
        NSLog(@"**********record fail**********");
    }
}

#pragma mark - private method
- (void)cameraStateDidChanged:(CameraState)cameratState {
    _cameraState = cameratState;
}

- (BOOL)initCaptureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;

        //设置视频录制的方向
        self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
        NSError *error = nil;
        
        // camera input
        _videoDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        if (error) {
            NSLog(@"error:%@",error.localizedDescription);
            return NO;
        }

        if ([_captureSession canAddInput:_videoDeviceInput]) {
            [_captureSession addInput:_videoDeviceInput];
        }
        else {
            NSLog(@"can't add Camera");
            return NO;
        }

        // audio input
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        _audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        if (error) {
            NSLog(@"error:%@",error.localizedDescription);
            return NO;
        }

        if ([_captureSession canAddInput:_audioDeviceInput]) {
            [_captureSession addInput:_audioDeviceInput];
        }
        else {
            NSLog(@"can't add audio");
            return NO;
        }

        // camera output
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoOutput setSampleBufferDelegate:self queue:self.captureQueue];
        NSDictionary* setcapSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                        nil];
        _videoOutput.videoSettings = setcapSettings;
        if ([_captureSession canAddOutput:_videoOutput]) {
            [_captureSession addOutput:_videoOutput];
        }
        else {
            NSLog(@"can't add video output");
            return NO;
        }

        // audio output
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [_audioOutput setSampleBufferDelegate:self queue:self.captureQueue];
        if ([_captureSession canAddOutput:_audioOutput]) {
            [_captureSession addOutput:_audioOutput];
        }
        else {
            NSLog(@"can't add audio output");
            return NO;
        }

        // video connection
        _videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
        _videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;

        // audio connection
        _audioConnection = [self.audioOutput connectionWithMediaType:AVMediaTypeAudio];

        // 图片
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
        [self.stillImageOutput setOutputSettings:outputSettings];
        if ([_captureSession canAddOutput:self.stillImageOutput]) {
            [_captureSession addOutput:self.stillImageOutput];
        }
        
        return YES;
    }
    return YES;
}

- (void)configureRecordingTime:(CMSampleBufferRef)sampleBuffer {
    CMTime dur = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    if (self.startTime.value == 0) {
        self.startTime = dur;
    }
    CMTime sub = CMTimeSubtract(dur, self.startTime);
    self.currentRecordTime = CMTimeGetSeconds(sub);
    NSLog(@"********************************duration is %.2f",_currentRecordTime);
    if (self.delegate && [self.delegate respondsToSelector:@selector(helper:recording:)]) {
        [self.delegate helper:self recording:CMTimeGetSeconds(sub)];
    }
}

- (void)releaseCaptureSession {
    [self cameraStateDidChanged:CameraStateIdle];
    [_captureSession stopRunning];
    
    [_captureSession.inputs enumerateObjectsUsingBlock:^(__kindof AVCaptureInput * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_captureSession removeInput:obj];
    }];
    
    [_captureSession.outputs enumerateObjectsUsingBlock:^(__kindof AVCaptureOutput * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_captureSession removeOutput:obj];
    }];
    
    _captureSession = nil;
    
    [_previewLayer removeFromSuperlayer];
    _previewLayer = nil;
}

- (void)reset {
    [self cameraStateDidChanged:CameraStateCapturing];
    _startTime = kCMTimeZero;
    _currentRecordTime = 0.0;
    _assetWriter = nil;
    _videoWriter = nil;
    _audioWriter = nil;
}

- (void)cancel {
    _isRecording = NO;
    if (_assetWriter && _assetWriter.status == AVAssetWriterStatusWriting) {
        [_assetWriter finishWritingWithCompletionHandler:^{
            
        }];
    }
    [_captureSession stopRunning];
    _captureSession = nil;
    [self reset];
    [_previewLayer removeFromSuperlayer];
    _previewLayer = nil;
    _captureQueue = nil;
}

- (NSString *)createFileLocalPath {
    NSString *fileName = [[NSUUID UUID] UUIDString];
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970] * 1000 * 1000;
    NSString *fileNamea = [NSString stringWithFormat:@"ChatSight%@%ld.mp4",fileName,timeInterval];
    NSString *filePath = [DocumentsPath stringByAppendingPathComponent:fileNamea];
    _moviePath = filePath;
    return filePath;
}

#pragma mark - Camera
//返回前置摄像头
- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

//返回后置摄像头
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

//用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    //返回和视频录制相关的所有默认设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //遍历这些设备返回跟position相关的设备
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (NSString *)switchCameraDevices {
    AVCaptureDevice *cameraDevice;
    if (_cameraType == CameraTypeBackCamera) {
        _cameraType = CameraTypeFontCamera;
        cameraDevice = [self frontCamera];
    }
    else {
        _cameraType = CameraTypeBackCamera;
        cameraDevice = [self backCamera];
    }
    
    NSError *error;
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:&error];
    if (!videoDeviceInput || error) {
        [_captureSession commitConfiguration];
        return @"Switching Camera, error:Creating new Camera Fail";
    }
    
    [_captureSession beginConfiguration];
    
    // Swtiching Capture Device Input
    [_captureSession removeInput:_videoDeviceInput];
    if (![_captureSession canAddInput:videoDeviceInput]) {
        [_captureSession commitConfiguration];
        return @"Switching Camera, error:Can't add new Device Input";
    }
    [_captureSession addInput:videoDeviceInput];
    _videoDeviceInput = videoDeviceInput;
    
    // Swtiching Capture Device Output
    [_captureSession removeOutput:_videoOutput];
    dispatch_queue_t captureQueue = dispatch_queue_create("com.cc.captureQueue", DISPATCH_QUEUE_SERIAL);
    AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
    [videoOut setAlwaysDiscardsLateVideoFrames:YES];
    [videoOut setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
    [videoOut setSampleBufferDelegate:self queue:captureQueue];
    if (![_captureSession canAddOutput:videoOut]) {
        [_captureSession commitConfiguration];
        return @"Switching Camera, error:Can't add new Device Output";
    }
    [_captureSession addOutput:videoOut];
    _videoOutput                      = videoOut;
    _videoConnection                  = [videoOut connectionWithMediaType:AVMediaTypeVideo];
    _videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [_captureSession commitConfiguration];
    return nil;
}

#pragma mark - Asset Write
- (void)initAssetWriter:(NSError *)error {
    NSString *filePath = [self createFileLocalPath];
    _assetWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:filePath] fileType:AVFileTypeMPEG4 error:&error];
    _assetWriter.shouldOptimizeForNetworkUse = YES;
    if (_assetWriter) {
        [self cameraStateDidChanged:CameraStateRecording];
    }
}

- (void)initAudioWrite:(CMFormatDescriptionRef)currentFormatDescription {
    const AudioStreamBasicDescription *asbd = CMAudioFormatDescriptionGetStreamBasicDescription(currentFormatDescription);
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                              [ NSNumber numberWithInt: asbd->mChannelsPerFrame], AVNumberOfChannelsKey,
                              [ NSNumber numberWithFloat: asbd->mSampleRate], AVSampleRateKey,
                              [ NSNumber numberWithInt: 128000], AVEncoderBitRateKey,
                              nil];
    //初始化音频写入类
    _audioWriter = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:settings];
    //表明输入是否应该调整其处理为实时数据源的数据
    _audioWriter.expectsMediaDataInRealTime = YES;
    //将音频输入源加入
    if ([_assetWriter canAddInput:_audioWriter]) {
        [_assetWriter addInput:_audioWriter];
    }
}

// create video asset write
- (void)initVideoWrite:(CMFormatDescriptionRef)currentFormatDescription {
    CGFloat bitsPerPixel;
    CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(currentFormatDescription);
    NSUInteger numPixels = dimensions.width * dimensions.height;
    NSUInteger bitsPerSecond;
    
    if (numPixels < (640 * 480)){
        bitsPerPixel = 4.05;
    } else {
        bitsPerPixel = 11.4;
    }
    
    bitsPerSecond = numPixels * bitsPerPixel;
    NSDictionary *videoCompressionSettings = @{AVVideoCodecKey:AVVideoCodecH264,
                                               AVVideoWidthKey:[NSNumber numberWithInteger:dimensions.width],
                                               AVVideoHeightKey:[NSNumber numberWithInteger:dimensions.height],
                                               AVVideoCompressionPropertiesKey:@{AVVideoAverageBitRateKey:[NSNumber numberWithInteger:bitsPerSecond],
                                                                                 AVVideoMaxKeyFrameIntervalKey:[NSNumber numberWithInteger:30]}
                                               };
    if ([_assetWriter canApplyOutputSettings:videoCompressionSettings forMediaType:AVMediaTypeVideo]) {
        _videoWriter = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoCompressionSettings];
        //表明输入是否应该调整其处理为实时数据源的数据
        _videoWriter.expectsMediaDataInRealTime = YES;
        _videoWriter.transform = [self transformFromCurrentVideoOrientationToOrientation:AVCaptureVideoOrientationPortrait];
        if ([_assetWriter canAddInput:_videoWriter]) {
            [_assetWriter addInput:_videoWriter];
        }
        else {
            NSLog(@"can not add video input");
        }
    }
    else {
        NSLog(@"video setting is wrong");
    }
}

//通过这个方法写入数据
- (BOOL)encodeFrame:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)isVideo {
    //数据是否准备写入
    if (CMSampleBufferDataIsReady(sampleBuffer)) {
        //写入状态为未知,保证视频先写入
        if (_assetWriter.status == AVAssetWriterStatusUnknown && isVideo) {
            //获取开始写入的CMTime
            CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            //开始写入
            [_assetWriter startWriting];
            [_assetWriter startSessionAtSourceTime:startTime];
        }
        //写入失败
        if (_assetWriter.status == AVAssetWriterStatusFailed) {
//            NSLog(@"writer error %@", _assetWriter.error.localizedDescription);
            return NO;
        }
        //判断是否是视频
        if (isVideo) {
            //视频输入是否准备接受更多的媒体数据
            if (_videoWriter.readyForMoreMediaData == YES) {
                //拼接数据
                [_videoWriter appendSampleBuffer:sampleBuffer];
//                NSLog(@"+++++++++++++++++++writing video");
                return YES;
            }
        }else {
            //音频输入是否准备接受更多的媒体数据
            if (_audioWriter.readyForMoreMediaData) {
                //拼接数据
                [_audioWriter appendSampleBuffer:sampleBuffer];
//                NSLog(@"-------------------writing audio");
                return YES;
            }
        }
    }
    return NO;
}

//将视频流存储到系统相册中。此步骤在视屏拍摄完成后掉用。调用位置为在AVCaptureFileOutputRecordingDelegate系统提供的代理方法中，实现保存功能
- (void)saveVideoToAssetsLibrary {
    ALAssetsLibrary *libraty = [[ALAssetsLibrary alloc]init];
    if ([libraty videoAtPathIsCompatibleWithSavedPhotosAlbum:[NSURL fileURLWithPath:_moviePath]]) {
        ALAssetsLibraryWriteImageCompletionBlock completionBlock;
        completionBlock = ^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"%@",[error localizedDescription]);
            }
        };
        
        [libraty writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:_moviePath] completionBlock:completionBlock];
        NSLog(@"保存方法");
    }
}

- (void)savePhotoTooAssetsLibrary {
    UIImageWriteToSavedPhotosAlbum(_tookImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark - Screen Orientation
// 获取视频旋转矩阵
- (CGAffineTransform)transformFromCurrentVideoOrientationToOrientation:(AVCaptureVideoOrientation)orientation{
    CGFloat orientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:orientation];
    CGFloat videoOrientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:AVCaptureVideoOrientationPortrait];
    CGFloat angleOffset;
    if ([_videoDeviceInput device].position == AVCaptureDevicePositionBack) {
        angleOffset = orientationAngleOffset - videoOrientationAngleOffset;
    } else {
        angleOffset = videoOrientationAngleOffset - orientationAngleOffset + M_PI_2;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleOffset);
    return transform;
}

// 获取视频旋转角度
- (CGFloat)angleOffsetFromPortraitOrientationToOrientation:(AVCaptureVideoOrientation)orientation {
    CGFloat angle = 0.0;
    switch (orientation){
        case AVCaptureVideoOrientationPortrait:
            angle = 0.0;
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case AVCaptureVideoOrientationLandscapeRight:
            angle = -M_PI_2;
            break;
        case AVCaptureVideoOrientationLandscapeLeft:
            angle = M_PI_2;
            break;
        default:
            break;
    }
    return angle;
}

#pragma mark - Capture Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    NSLog(@"-------------------------sample capturing!!!!!");
    NSError *error = nil;
    CFRetain(sampleBuffer);
    @synchronized(self) {
        if (_isRecording) {
            if (!_assetWriter && connection == _audioConnection) {
                [self initAssetWriter:error];
            }
            if (_assetWriter) {
                if (_currentRecordTime >= _maximunDuration) {
                    [ZZHUD showTastInfoErrorWithString:[NSString stringWithFormat:@"视频最多录制%lu秒",(unsigned long)_maximunDuration]];
                        [self stopRecording];
                    return;
                }
                
                // monitor times
                [self configureRecordingTime:sampleBuffer];
                
                // write audio&video Data
                if (connection == _videoConnection) {
                    if (!_videoWriter) {
                        [self initVideoWrite:CMSampleBufferGetFormatDescription(sampleBuffer)];
                    }
                    if (_videoWriter) {
                        [self encodeFrame:sampleBuffer isVideo:YES];
                    }
                }
                else if (connection == _audioConnection) {
                    if (!_audioWriter) {
                        [self initAudioWrite:CMSampleBufferGetFormatDescription(sampleBuffer)];
                    }
                    
                    if (_audioWriter) {
                        [self encodeFrame:sampleBuffer isVideo:NO];
                    }
                }
            }
        }
    }
    CFRelease(sampleBuffer);
}

@end
