//
//  ZZLivenessHelper.h
//  kongxia
//
//  Created by qiming xiao on 2020/10/22.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZLivenessHelper : NSObject

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

@property (nonatomic, copy) void(^checkSuccessBlock)(NSString *photo);

- (instancetype)initWithType:(NavigationType)type inController:(UIViewController *)controller;

- (void)start;


@end

NS_ASSUME_NONNULL_END
