//
//  ZZSnatchOrderView.h
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 抢任务
 */
@interface ZZSnatchOrderView : UIView

@property (nonatomic, copy) void(^gotoUserPage)(NSString *uid);
@property (nonatomic, copy) void(^gotoLocationDetail)(CLLocation *location,NSString *address);
@property (nonatomic, copy) void (^noFaceBlock)(void);//抢任务没有人脸数据
@property (nonatomic, copy) void (^noRealPictureBlock)(void);//抢任务没有真实头像数据

@property (nonatomic, copy) void (^becomeTalentNoFaceBlock)(BOOL isShowWindow);//成为闪租达人没有人脸数据、没有真实头像
@property (nonatomic, copy) void (^genderAbnormalBlock)(void);//性别异常，需要验证身份证回调
@property (nonatomic, copy) void (^rentStatusNone)(void);//还没有上架出租 回调
@property (nonatomic, copy) void (^rentStatusInvisible)(void);//已上架了，但是隐身中 回调

@property (nonatomic, copy) void (^isShowCongratulationsBlock)(void);


- (void)detectNotification;

@end
