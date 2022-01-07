//
//  ZZTopicClassifyCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHomeModel.h"

#define TopicClassifyCellId @"TopicClassifyCellId"

@interface ZZTopicClassifyCell : UITableViewCell

@property (nonatomic, strong) ZZUserUnderSkillModel *model;

@property (nonatomic, copy) void(^gotoUserInfo)(ZZUser *user);
@property (nonatomic, copy) void(^gotoSkillDetail)(ZZUser *user, ZZTopic *topic);

@end
