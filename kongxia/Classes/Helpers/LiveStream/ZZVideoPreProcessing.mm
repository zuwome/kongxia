//
//  ZZVideoPreProcessing.m
//  zuwome
//
//  Created by angBiu on 2017/8/30.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZVideoPreProcessing.h"
#import "ZZLiveStreamHelper.h"

#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import <AgoraRtcKit/IAgoraRtcEngine.h>
#import <AgoraRtcKit/IAgoraMediaEngine.h>

#import "libyuv.h"

class AgoraAudioFrameObserver : public agora::media::IAudioFrameObserver
{
public:
    virtual bool onRecordAudioFrame(AudioFrame& audioFrame) override
    {
        return true;
    }
    virtual bool onPlaybackAudioFrame(AudioFrame& audioFrame) override
    {
        return true;
    }
    virtual bool onPlaybackAudioFrameBeforeMixing(unsigned int uid, AudioFrame& audioFrame) override
    {
        return true;
    }
};

NSTimeInterval _lastTime;
NSUInteger _count;

CFDictionaryRef empty; // empty value for attr value.
CFMutableDictionaryRef attrs;

class AgoraVideoFrameObserver : public agora::media::IVideoFrameObserver
{
public:
    virtual bool onCaptureVideoFrame(VideoFrame& videoFrame) override
    {
        UIDeviceOrientation iDeviceOrientation = [[UIDevice currentDevice] orientation];
//        BOOL mirrored = YES;
//        cv_rotate_type cvMobileRotate;
        switch (iDeviceOrientation) {
            case UIDeviceOrientationPortrait:
//                cvMobileRotate = CV_CLOCKWISE_ROTATE_90;
                break;
                
            case UIDeviceOrientationLandscapeLeft:
//                cvMobileRotate = mirrored ?  CV_CLOCKWISE_ROTATE_180: CV_CLOCKWISE_ROTATE_0;
                break;
                
            case UIDeviceOrientationLandscapeRight:
//                cvMobileRotate = mirrored ?  CV_CLOCKWISE_ROTATE_0 : CV_CLOCKWISE_ROTATE_180;
                break;
                
            case UIDeviceOrientationPortraitUpsideDown:
//                cvMobileRotate = CV_CLOCKWISE_ROTATE_270;
                break;
                
            default:
//                cvMobileRotate = CV_CLOCKWISE_ROTATE_0;
                break;
        }
        
        VideoFrame frame;
        
        frame.type = (VIDEO_FRAME_TYPE)videoFrame.type;
        
        frame.width = videoFrame.width;
        
        frame.height = videoFrame.height;
        
        frame.yBuffer = videoFrame.yBuffer;
        
        frame.uBuffer = videoFrame.uBuffer;
        
        frame.vBuffer = videoFrame.vBuffer;
        
        frame.yStride = videoFrame.yStride;
        
        frame.uStride = videoFrame.uStride;
        
        frame.vStride = videoFrame.vStride;
        
        
        uint8_t *argb = (uint8_t *)malloc(frame.width * frame.height * 4 * sizeof(uint8_t));
        
        libyuv::I420ToBGRA((uint8_t *)frame.yBuffer,
                           frame.yStride,
                           (uint8_t *)frame.uBuffer,
                           frame.uStride,
                           (uint8_t *)frame.vBuffer,
                           frame.vStride,
                           argb,
                           frame.width * 4,
                           frame.width,
                           frame.height);
        
        CVReturn err = 0;
        CVPixelBufferRef renderTarget;
        
        
        
        err = CVPixelBufferCreate(kCFAllocatorDefault, (int)videoFrame.width, (int)videoFrame.height, kCVPixelFormatType_32BGRA, attrs, &renderTarget);
        if (err)
        {
            NSLog(@"FBO size: %d, %d", videoFrame.width, videoFrame.height);
            //            NSAssert(err, @"Error at CVPixelBufferCreate %d", err);
        }
        
        
        CVPixelBufferLockBaseAddress(renderTarget, 0);
        unsigned char *baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(renderTarget);
        
        libyuv::ARGBToBGRA(argb,
                           videoFrame.width * 4,
                           baseAddress,
                           videoFrame.width * 4,
                           videoFrame.width,
                           videoFrame.height);
        
        CVPixelBufferUnlockBaseAddress(renderTarget, 0);
        
        free(argb);
        
        CVPixelBufferLockBaseAddress(renderTarget, 0);
        baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(renderTarget);
        
        libyuv::ARGBToI420(baseAddress,
                           (int)CVPixelBufferGetBytesPerRow(renderTarget),
                           (uint8 *)videoFrame.yBuffer,
                           videoFrame.yStride,
                           (uint8 *)videoFrame.uBuffer,
                           videoFrame.uStride,
                           (uint8 *)videoFrame.vBuffer,
                           videoFrame.vStride,
                           videoFrame.width,
                           videoFrame.height);
        
        CVPixelBufferUnlockBaseAddress(renderTarget, 0);
        
        CFRelease(renderTarget);
        
        return true;
    }
    virtual bool onRenderVideoFrame(unsigned int uid, VideoFrame& videoFrame) override
    {
        return true;
    }
};

@interface ZZVideoPreProcessing ()

@end

static AgoraVideoFrameObserver s_videoFrameObserver;

@implementation ZZVideoPreProcessing

+ (int) registerVideoPreprocessing: (AgoraRtcEngineKit*) kit
{
    if (!kit) {
        return -1;
    }
    
    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine*)kit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    mediaEngine.queryInterface(rtc_engine, agora::AGORA_IID_MEDIA_ENGINE);
    if (mediaEngine)
    {
        //mediaEngine->registerAudioFrameObserver(&s_audioFrameObserver);
        mediaEngine->registerVideoFrameObserver(&s_videoFrameObserver);
        
        empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks); // our empty IOSurface properties dictionary
        attrs = CFDictionaryCreateMutable(kCFAllocatorDefault, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(attrs, kCVPixelBufferIOSurfacePropertiesKey, empty);
        
    }
    return 0;
}

+ (int) deregisterVideoPreprocessing: (AgoraRtcEngineKit*) kit
{
    if (!kit) {
        return -1;
    }
    
    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine*)kit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    mediaEngine.queryInterface(rtc_engine, agora::AGORA_IID_MEDIA_ENGINE);
    if (mediaEngine)
    {
        //mediaEngine->registerAudioFrameObserver(NULL);
        mediaEngine->registerVideoFrameObserver(NULL);
    }
    return 0;
}
@end
