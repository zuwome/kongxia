//
//  ZZSkillCameraViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillCameraViewController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

#define BottomBarHeight 115

@interface ZZSkillCameraViewController ()

@property (nonatomic) UIButton *shutter;
@property (nonatomic) UIButton *cancelBtn;
@property (nonatomic) UIButton *rotationBtn;
@property (nonatomic) CMMotionManager *manager;

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;
//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;
//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;
//照片输出流
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;
//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;
//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ZZSkillCameraViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self createCustomCamera];      //创建相机渲染层
    [self createInteractionView];   //创建交互层
    [self configMotionManager];     //初始化陀螺仪
}

- (void)createCustomCamera {
    //初始化设备，输入输出。。
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    //结合输入输出，生成会话
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    //初始化预览层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 115);  //115 底部交互栏的高度
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    //运行
    [self.session startRunning];
    
    if ([self.device lockForConfiguration:nil]) {
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {    //开启自动闪光灯
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {  //开启自动白平衡
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [self.device unlockForConfiguration];
    }
}

- (void)createInteractionView {
    UIView *bgView  = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.height.equalTo(@(BottomBarHeight));
    }];
    UILabel *title = [[UILabel alloc] init];
    title.text = @"照片要与技能相关哦";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
    [bgView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.centerX.equalTo(bgView);
        make.height.equalTo(@20);
    }];
    _shutter = [[UIButton alloc] init];
    [_shutter setImage:[UIImage imageNamed:@"icShutter"] forState:UIControlStateNormal];
    [_shutter addTarget:self action:@selector(shutterClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_shutter];
    [_shutter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(52, 52));
        make.top.equalTo(title.mas_bottom).offset(10);
        make.centerX.equalTo(bgView);
    }];
    _cancelBtn = [[UIButton alloc] init];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17 weight:(UIFontWeightBold)]];
    [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@30);
        make.centerY.equalTo(_shutter);
        make.height.equalTo(@25);
    }];
    _rotationBtn = [[UIButton alloc] init];
    [_rotationBtn setImage:[UIImage imageNamed:@"icCameraRotation"] forState:UIControlStateNormal];
    [_rotationBtn addTarget:self action:@selector(rotationClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_rotationBtn];
    [_rotationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shutter);
        make.trailing.equalTo(@-30);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)configMotionManager {
    self.manager = [[CMMotionManager alloc] init];
    if ([self.manager isDeviceMotionAvailable]) {
//        [self.manager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
//            CMAcceleration acceleration = accelerometerData.acceleration;
//            NSLog(@"x: %.2lf, y: %.2lf, z: %.2lf", acceleration.x, acceleration.y, acceleration.z);
//        }];
    }
}

- (void)btnEnabled:(BOOL)enable {
    _shutter.userInteractionEnabled = enable;
    _cancelBtn.userInteractionEnabled = enable;
    _rotationBtn.userInteractionEnabled = enable;
}

- (void)shutterClick {
    [self btnEnabled:NO];
    AVCaptureConnection *videoConnenction = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnenction == nil) {
        [self btnEnabled:YES];
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnenction completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if (imageDataSampleBuffer == nil) {
            [self btnEnabled:YES];
            return;
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
//        UIImage *tempImage = [self changeImageOrientation:image];
//        //crop image
//        CGRect cropFrame = self.view.frame;
//        cropFrame.size.height -= BottomBarHeight;
//        cropFrame.size.height = (tempImage.size.width / cropFrame.size.width) * cropFrame.size.height;
//        cropFrame.size.width = tempImage.size.width;
//        cropFrame.origin.y = (tempImage.size.height - cropFrame.size.height) / 2;
//
//        CGImageRef cropImageRef = CGImageCreateWithImageInRect(tempImage.CGImage, cropFrame);
//        UIImage *cropImage = [UIImage imageWithCGImage:cropImageRef];
        
        WeakSelf
        [self dismissViewControllerAnimated:YES completion:^{
            !weakSelf.photoCallback ? : weakSelf.photoCallback(image);
        }];
    }];
}

//相机拍摄的图片方向调整
- (UIImage *)changeImageOrientation:(UIImage *)image {
    // No-op if the orientation is already cor
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.height,image.size.width), image.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rotationClick {
    NSUInteger cameraCount = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count;
    if (cameraCount <= 1)   //摄像头少于2不切换
        return;
    
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    AVCaptureDevicePosition position = [[self.input device] position];
    //转场动画
//    CATransition *animation = [CATransition animation];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.duration = 0.5;
//    animation.type = @"oglFlip";
    
    if (position == AVCaptureDevicePositionFront) {
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
//        animation.subtype = kCATransitionFromLeft;
    } else {
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
//        animation.subtype = kCATransitionFromRight;
    }
//    [self.previewLayer addAnimation:animation forKey:nil];
    
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    if (newInput != nil) {
        [self.session beginConfiguration];
        [self.session removeInput:self.input];  //先移除旧输入源，否则不能添加新输入源
        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.input = newInput;
        } else {
            [self.session addInput:self.input];
        }
        [self.session commitConfiguration];
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
