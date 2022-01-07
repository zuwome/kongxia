//
//  ZZLiveStreamPublishingViewController.h
//  zuwome
//
//  Created by angBiu on 2017/7/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZViewController.h"

/**
 *  线上1v1视频，选择达人列表
 */
@interface ZZLiveStreamPublishingViewController : ZZViewController

@property (nonatomic, copy) NSString *pId;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) NSInteger timeoutCount;

@property (nonatomic, assign) NSInteger remainingTime;    // 任务剩余时间，用于倒计时显示

@end
