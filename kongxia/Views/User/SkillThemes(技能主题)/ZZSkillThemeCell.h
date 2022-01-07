//
//  ZZSkillThemeCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SkillThemeCellIdentifier @"SkillThemeCellIdentifier"

typedef NS_ENUM(NSInteger, SkillThemeType) {
    SkillThemeTypeSystemTheme = 0,      //系统主题
    SkillThemeTypeCustomTheme,          //自定义主题（有审核状态）
    SkillThemeTypeAddTheme,             //添加主题
};

/**
 *  主题管理cell
 */
@interface ZZSkillThemeCell : UITableViewCell

@property (nonatomic, assign) SkillThemeType cellType;
@property (nonatomic, copy) void(^editTheme)(void);
@property (nonatomic, copy) void(^addTheme)(void);
@property (nonatomic, strong) ZZTopic *topicModel;

@end
