//
//  ZZFastRentManager.h
//  zuwome
//
//  Created by YuTianLong on 2017/10/12.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "WBBaseManager.h"


@protocol WBFastRentManagerObserver <NSObject>

@optional

//  闪租发布任务发生变化: 1: 发布中  0: 取消发布
- (void)missionDidChangeWithUnderway:(NSString *)isUnderway;

// 当前发布任务所剩时间变化
- (void)remainingTimeDidChangeWithTime:(NSString *)time;

@end

//////////////////////////////////////////////////////////////////////

/*
 *  闪租 Manager
 */

#define GetFastRentManager()       ([ZZFastRentManager sharedInstance])

@interface ZZFastRentManager : WBBaseManager

/* 
 *  发布闪租任务 与 取消操作
 *  YES: 发布任务    NO:取消发布
 */
- (void)syncUpdateMissionStatus:(BOOL)isUnderway;


// 倒计时更新
- (void)syncUpdateRemainingTimeWithTime:(NSString *)time;

@end
