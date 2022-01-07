//
//  ZZScheduleEditViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZTopic.h"

typedef NS_ENUM(NSInteger, ScheduleEditType) {
    ScheduleEditTypeAddSystemTheme,         //新增系统主题
    ScheduleEditTypeAddCustomTheme,         //新增自定义主题
    ScheduleEditTypeEditTheme,              //编辑已有主题
};

/**
 *  设置档期
 */
@interface ZZScheduleEditViewController : ZZViewController

@property (nonatomic, strong) ZZTopic *currentTopicModel;
@property (nonatomic, assign) ScheduleEditType scheduleEditType;

@property (nonatomic, copy) void(^chooseScheduleCallback)(NSString *time);

@end
