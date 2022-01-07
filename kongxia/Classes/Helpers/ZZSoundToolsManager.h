//
//  ZZSoundToolsManager.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/14.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "WBBaseManager.h"

#define GetSoundToolsManager()       ([ZZSoundToolsManager sharedInstance])

@interface ZZSoundToolsManager : WBBaseManager

@property (nonatomic, assign, readonly) BOOL isVibrate; //是否正在震动

// 开始震动
- (void)starAlertSound;

// 停止震动
- (void)stopAlertSound;

@end
