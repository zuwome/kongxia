//
//  ZZPostTaskBasicInfoController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/4.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"


@interface ZZPostTaskBasicInfoController : ZZViewController

/**
 * 普通的
 */
- (instancetype)initWithSkill:(ZZSkill *)skill taskType:(TaskType)taskType;

- (instancetype)initTaskType:(TaskType)taskType taskInfo:(NSDictionary *)taskInfo;

@end
