//
//  ZZPostFreeTaskViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/9/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTaskConfig.h"

@class ZZPostTaskViewModel;

@interface ZZPostFreeTaskTaskInfoViewController : ZZViewController

- (instancetype)initWithSkill:(ZZSkill *)skill taskType:(TaskType)taskType;

@end
