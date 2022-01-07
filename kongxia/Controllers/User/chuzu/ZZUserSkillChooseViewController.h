//
//  ZZUserSkillChooseViewController.h
//  zuwome
//
//  Created by angBiu on 2016/10/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZTopic.h"

/**
 选择出租技能
 */
@interface ZZUserSkillChooseViewController : ZZViewController

@property (strong, nonatomic) ZZTopic *topic;
@property (strong, nonatomic) NSMutableArray *extSkills;
@property (strong, nonatomic) NSMutableArray *extPirces;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, copy) dispatch_block_t callBack;
@property (nonatomic, copy) void(^addCallBack)(ZZTopic *toupic);

@end
