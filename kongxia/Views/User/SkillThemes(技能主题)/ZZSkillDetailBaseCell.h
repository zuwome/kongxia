//
//  ZZSkillDetailBaseCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTopic.h"
#import "ZZUser.h"

#define SkillDetailBaseCellId @"SkillDetailBaseCellId"
#define SkillDetailUserCellId @"SkillDetailUserCellId"
#define SkillDetailPriceCellId @"SkillDetailPriceCellId"
#define SkillDetailContentCellId @"SkillDetailContentCellId"
#define SkillDetailScheduleCellId @"SkillDetailScheduleCellId"
#define SkillDetailFlowCellId @"SkillDetailFlowCellId"
#define SkillDetailEnsureCellId @"SkillDetailEnsureCellId"
#define SkillDetailTipCellId @"SkillDetailEnsureCellId"

typedef NS_ENUM(NSInteger, SkillDetaillCellType) {
    SkillDetaillCellTypeBase = 0,
    SkillDetaillCellTypeUser,       //用户信息
    SkillDetaillCellTypePrice,      //技能
    SkillDetaillCellTypeContent,    //介绍
    SkillDetaillCellTypeSchedule,   //档期
    SkillDetaillCellTypeFlow,       //邀约流程
    SkillDetaillCellTypeEnsure,     //平台保障
    SkillDetaillCellTypeTip,        //温馨提示
};

@interface ZZSkillDetailBaseCell : UITableViewCell

@property (nonatomic, assign) SkillDetaillCellType cellType;
@property (nonatomic, weak) ZZUser *user;
@property (nonatomic, weak) ZZTopic *topicModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

//usercell
@property (nonatomic, copy) void(^gotoAttent)(void);

+ (instancetype)dequeueReusableCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end
