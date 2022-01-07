//
//  ZZLivenessCheckViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/29.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
typedef NS_ENUM(NSInteger, LivenessWarningStatus) {
    WarningCommonStatus,
    WarningPoseStatus,
    WarningocclusionStatus
};

typedef NS_ENUM(NSInteger, LivenessCheckType) {
    LivenessTypeCommon,
    LivenessTypeRegist,
};

@class LivenessCircleLayer;

@interface ZZLivenessCheckViewController : ZZViewController

@property (strong, nonatomic) NSString *action;

// 自己
@property (strong, nonatomic) ZZUser *user;

// 他人
@property (strong, nonatomic) ZZUser *from;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *countryCode;
@property (assign, nonatomic) NavigationType type;

@property (assign, nonatomic) BOOL isQuickLogin;//快速登录过来
@property (strong, nonatomic) NSString *quickLoginToken;

// 是否是公众号手机更新接口
@property (assign, nonatomic) BOOL isUpdatePhone;

// 是否在状态栏显示上传进度
@property (nonatomic, assign) BOOL isShowTopUploadStatus;

@property (copy, nonatomic) dispatch_block_t callBack;

// 注销、修改手机号、提现等 检测为本人成功回调
@property (copy, nonatomic) dispatch_block_t checkSuccess;

@property (nonatomic, copy) void(^withdrawCompleBlock)(NSString *photo, NSInteger faceStatus);

@property (nonatomic, copy) void(^newDeviceLoginBlock)(BOOL isSuccess, NSString *url, NSString *message);

@property (nonatomic,   copy) void(^checkSuccessBlock)(NSString *photo);

- (void)livenesswithList:(NSArray *)livenessArray
                   order:(BOOL)order
        numberOfLiveness:(NSInteger)numberOfLiveness;

@end

@interface LivenessCircleView : UIView

@property (nonatomic, strong) LivenessCircleLayer *circleLayer;


@end

@interface LivenessCircleLayer : CALayer

@property (nonatomic, assign) CGFloat progress;

@end
