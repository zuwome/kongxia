//
//  ZZPerfectPictureViewController.h
//  zuwome
//
//  Created by YuTianLong on 2017/10/16.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

/*
 *  完善头像页(用于已经完成了人脸验证，需要上传真实头像使用页面)
 */


@interface ZZPerfectPictureViewController : ZZViewController

@property (nonatomic, assign) BOOL isFaceVC;    //是否是从人脸识别页面跳转过来的(可能直接从聊天、出租、我的微信过来)
@property (nonatomic, strong) NSArray<NSString *> *faces;   //人脸验证数据url
@property (nonatomic, strong) ZZUser *user; //自己
@property (nonatomic, strong) ZZUser *from; //他人
@property (nonatomic, assign) BOOL isShowTopUploadStatus;// 是否在状态栏显示上传进度

@property (assign, nonatomic) NavigationType type;  //从哪个页面过来

@property (nonatomic, assign) NSString *mainTitle;
@property (nonatomic, assign) NSString *successMessage;

- (instancetype)initWithTitle:(NSString *)title successMessage:(NSString *)successMessage;

@end
