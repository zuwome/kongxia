//
//  ZZSkillEditCellFooter.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SkillEditStageIdentifier @"SkillEditStageIdentifier"
#define SkillEditCellFooterHeight (SCREEN_WIDTH / 375 * 75 + 20)

@interface ZZSkillEditCellFooter : UIView

@property (nonatomic, assign) NSInteger stage;  //技能主题编写阶段 2 | 3

@end
