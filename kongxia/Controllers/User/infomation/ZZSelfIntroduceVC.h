//
//  ZZSelfIntroduceVC.h
//  zuwome
//
//  Created by YuTianLong on 2017/11/16.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZSKModel.h"

typedef NS_ENUM(NSUInteger, ZZVideoReviewStatus) {
    
    ZZVideoReviewStatusNoRecord,   //未录制视频
    ZZVideoReviewStatusSuccess,    //审核通过
    ZZVideoReviewStatusFail,       //审核失败
    ZZVideoReviewing,              //审核中
};

@interface ZZSelfIntroduceVC : ZZViewController

@property (nonatomic, assign) ZZVideoReviewStatus reviewStatus;

@property (nonatomic, strong) ZZUser *loginer;

@property (nonatomic, assign) BOOL isShowTopUploadStatus;// 是否在状态栏显示上传进度

@property (nonatomic, assign) BOOL isUploadAfterCompleted;//是否在上传完达人视频之后直接更新到User，再更新到服务器。（YES:在闪租录制成为达人，需要直接更新。 NO：表示在编辑资料上传视频，不需要直接更新，主动点保存才更新）

@property (nonatomic, assign) BOOL isShanzuAndFirst;//是否是从闪租页面，并且第一次录制达人视频

@property (nonatomic, assign) BOOL isFastChat;//是否是录制闪聊视频
//@property (nonatomic, strong) ZZSKModel *sk;
@property (nonatomic, assign) ShowHUDType showType;

@end
