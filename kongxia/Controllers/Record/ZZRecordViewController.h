//
//  ZZRecordViewController.h
//  zuwome
//
//  Created by angBiu on 2016/12/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZRecordEditViewController.h"

#import "ZZMemedaModel.h"
#import "ZZRecordLabelModel.h"
#import "ZZTopicModel.h"

/**
 录制界面
 */
@interface ZZRecordViewController : ZZViewController

@property (nonatomic, assign) RecordType type;
@property (nonatomic, strong) ZZMMDModel *model;
@property (nonatomic, copy) dispatch_block_t callBack;
@property (nonatomic, copy) dispatch_block_t viewDismiss;
@property (nonatomic, strong) NSString *labelId;
@property (nonatomic, strong) ZZTopicGroupModel *groupModel;
@property (nonatomic, assign) BOOL is_base_sk;

@property (nonatomic, assign) BOOL isHidePhoto;//是否隐藏相册按钮，默认NO
@property (nonatomic, assign) BOOL isIntroduceVideo;//是否是录制达人介绍视频
@property (nonatomic, assign) BOOL isShowTopUploadStatus;// 是否在状态栏显示上传进度
@property (nonatomic, assign) BOOL isUploadAfterCompleted;//是否在上传完达人视频之后直接更新到User，再更新到服务器。（YES:在闪租录制成为达人，需要直接更新。 NO：表示在编辑资料上传视频，不需要直接更新，主动点保存才更新）
@property (nonatomic, assign) BOOL isFastChat;//是否是录制闪聊视频（也是达人视频）
@property (nonatomic, assign) ShowHUDType showType;

- (void)dismissView;
@end
