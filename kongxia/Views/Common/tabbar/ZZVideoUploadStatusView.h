//
//  ZZVideoUploadStatusView.h
//  zuwome
//
//  Created by angBiu on 2017/3/29.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZRecordEditViewController.h"

@interface ZZVideoUploadStatusView : UIView

@property (nonatomic, assign) RecordType type;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *labelId;//时刻话题id
@property (nonatomic, strong) NSString *content;//时刻内容
@property (nonatomic, strong) NSString *tagId;//给每个视频打一个标签
@property (nonatomic, strong) NSURL *exportURL;
@property (nonatomic, strong) NSString *expiredTime;
@property (nonatomic, strong) NSString *loc_name;//发布视频的地点
@property (nonatomic, assign) BOOL viewShow;
@property (nonatomic, assign) BOOL is_base_sk;
@property (nonatomic, assign) BOOL isRecordVideo;//是否是录制视频，YES:是 NO:是相册选视频
@property (nonatomic, assign) BOOL isIntroduceVideo;//是否是录制达人介绍视频
@property (nonatomic, assign) BOOL isShowTopUploadStatus;// 是否在状态栏显示上传进度
@property (nonatomic, assign) BOOL isUploadAfterCompleted;//是否在上传完达人视频之后直接更新到User，再更新到服务器。（YES:在闪租录制成为达人，需要直接更新。 NO：表示在编辑资料上传视频，不需要直接更新，主动点保存才更新）
@property (nonatomic, assign) BOOL isFastChat;//是否是录制闪聊视频

// 视频 W、H
@property (nonatomic, assign) NSUInteger pixelWidth;
@property (nonatomic, assign) NSUInteger pixelHeight;

@property (nonatomic, strong) NSDictionary *videoDict;

+ (id)sharedInstance;
- (void)showBeginStatusView;
- (void)showSuccessStatusView;
- (void)showView;
- (void)hideView;

@end
