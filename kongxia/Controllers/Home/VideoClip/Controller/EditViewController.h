//
//  EditViewController.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/4/11.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZZVideoUploadStatusView.h"
@class PLSFileSection;

//编辑页面 - 滤镜、背景等合成
@interface EditViewController : UIViewController

@property (strong, nonatomic) NSDictionary *settings;

@property (nonatomic, assign) NSUInteger pixelWidth;
@property (nonatomic, assign) NSUInteger pixelHeight;

@property (nonatomic, strong) NSURL *exportURL;//相册视频最后要到处的路径
@property (nonatomic, assign) RecordType type;
@property (nonatomic, assign) BOOL is_base_sk;
@property (nonatomic, assign) ShowHUDType showType;
@property (nonatomic, assign) BOOL isShowTopUploadStatus;// 是否在状态栏显示上传进度
@property (nonatomic, strong) ZZTopicGroupModel *selectedModel;
@property (nonatomic, assign) BOOL isFastChat;//是否是录制闪聊视频
@property (nonatomic,assign) BOOL isDaRen;//是达人

@property (nonatomic, assign) BOOL isUploadAfterCompleted;//是否在上传完达人视频之后直接更新到User，再更新到服务器。（YES:在闪租录制成为达人，需要直接更新。 NO：表示在编辑资料上传视频，不需要直接更新，主动点保存才更新）
@end
