//
//  ZZSendVideoManager.h
//  zuwome
//
//  Created by YuTianLong on 2017/11/16.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "WBBaseManager.h"
@class ZZSKModel;
@class ZZVideoUploadStatusView;

@protocol WBSendVideoManagerObserver <NSObject>

@optional

// 视频开始发送, 点小飞机以后
- (void)videoStartSendingVideoUploadStatus:(ZZVideoUploadStatusView *)model;

// 视频发送进度
- (void)videoSendProgress:(NSString *)progress;

// 视频发送完成
- (void)videoSendSuccessWithVideoId:(ZZSKModel *)sk;

// 视频发送失败
- (void)videoSendFailWithError:(NSDictionary *)error;

@end

//////////////////////////////////////////////////////////////////////

#define GetSendVideoManager()       ([ZZSendVideoManager sharedInstance])

@interface ZZSendVideoManager : WBBaseManager

// 发送视频
- (void)asyncVideoStartSendingVideo:(ZZVideoUploadStatusView *)model;

// 发送进度
- (void)asyncVideoSendProgress:(NSString *)progress;

// 视频发送成功
- (void)asyncSendVideoWithVideoId:(ZZSKModel *)sk;

// 视频发送失败
- (void)asyncSendVideoFailWithError:(NSDictionary *)error;

@end
