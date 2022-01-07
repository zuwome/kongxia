//
//  ZZRecordEditViewController.h
//  zuwome
//
//  Created by angBiu on 2016/12/13.
//  Copyright © 2016年 zz. All rights reserved.
//

typedef NS_ENUM(NSUInteger,RecordType) {
    RecordTypeSK            = 0,    //时刻
    RecordTypeMemeda        = 1,    //么么答
    RecordTypeUpdateMemeda  = 2,    //重新录制么么答
    RecordTypeChatSight     = 3,    // 视频聊天小视频
};

#import "ZZViewController.h"
#import "ZZMemedaModel.h"
#import "ZZTopicModel.h"

@class ZZRecordEditViewController;

/**
 视频编辑界面
 */
@interface ZZRecordEditViewController : ZZViewController

@property (nonatomic, strong) NSURL *exportURL;
@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, strong) ZZMMDModel *model;
@property (nonatomic, assign) RecordType type;
@property (nonatomic, strong) ZZTopicGroupModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, assign) BOOL is_base_sk;

@property (nonatomic, copy) dispatch_block_t callBack;
@property (nonatomic, copy) dispatch_block_t touchLeft;
@property (nonatomic, copy) dispatch_block_t  leftCallBack;//左边按钮点击返回,用于处理重复视频写入失败

@property (nonatomic, assign) BOOL isRecordVideo;//是否是录制视频，YES:是 NO:是相册选视频
// 视频 W、H
@property (nonatomic, assign) NSUInteger pixelWidth;
@property (nonatomic, assign) NSUInteger pixelHeight;

@property (nonatomic, assign) BOOL isIntroduceVideo;//是否是录制达人介绍视频
@property (nonatomic, assign) BOOL isShowTopUploadStatus;// 是否在状态栏显示上传进度
@property (nonatomic, assign) BOOL isUploadAfterCompleted;//是否在上传完达人视频之后直接更新到User，再更新到服务器。（YES:在闪租录制成为达人，需要直接更新。 NO：表示在编辑资料上传视频，不需要直接更新，主动点保存才更新）
@property (nonatomic, assign) BOOL isFastChat;//是否是录制闪聊视频
@property (nonatomic, assign) ShowHUDType showType;//出租流程优化开通闪聊
@property (nonatomic,assign) BOOL selectAlbumsDirectly;//直接选的是相册

@end
