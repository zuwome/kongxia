//
//  ZZLiveStreamViewController.h
//  zuwome
//
//  Created by angBiu on 2017/7/3.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  首页 - 闪租页
 */

@interface ZZLiveStreamViewController : ZZViewController

- (void)receiveNewPublishOrder;

@property (nonatomic, copy) void (^noFaceBlock)(void);//没有人脸数据
@property (nonatomic, copy) void (^noRealPictureBlock)(void);//没有真实头像数据

@property (nonatomic, copy) void (^genderAbnormalBlock)(void);//性别异常，需要验证身份证回调
@property (nonatomic, copy) void (^rentStatusNone)(void);//还没有上架出租 回调
@property (nonatomic, copy) void (^rentStatusInvisible)(void);//已上架了，但是隐身中 回调

- (void)defaultSelectVideo;//默认选中线上视频

@end
