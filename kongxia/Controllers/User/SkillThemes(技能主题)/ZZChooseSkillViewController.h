//
//  ZZChooseSkillViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/7/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZTaskConfig.h"

@class ZZChooseSkillViewController;
@class ZZSkill;

@protocol ZZChooseSkillViewControllerDelegate <NSObject>

- (void)controller:(ZZChooseSkillViewController *)controller didChooseSkill:(ZZSkill *)skill;

@end

/**
 *  选择主题
 */
@interface ZZChooseSkillViewController : ZZViewController

@property (nonatomic, weak) id<ZZChooseSkillViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isFromSkillSelectView;

@property (nonatomic, assign) TaskType taskType;

@property (nonatomic, strong) NSArray *choosenArray;    //用户已经添加过的主题

@property (nonatomic, assign) BOOL shouldPopBack;


@end
