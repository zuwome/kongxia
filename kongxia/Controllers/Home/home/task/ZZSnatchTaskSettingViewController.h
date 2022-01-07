//
//  ZZSnatchTaskSettingViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/9/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

typedef NS_ENUM(NSInteger, NotificationSettingType) {
    settingSnatch,
    settingTaskFree,
};



/**
 *  抢任务中心 -- 通知设置
 */
@interface ZZSnatchTaskSettingViewController : ZZViewController

@property (nonatomic, assign) NotificationSettingType settingType;

@end
