//
//  ZZSkillEditBaseCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/7/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillEditBaseCell.h"
#import "ZZSkillEditInputCell.h"
#import "ZZSkillEditPressCell.h"
#import "ZZSkillEditIntroduceCell.h"
#import "ZZSkillEditScheduleCell.h"

@implementation ZZSkillEditBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//For SkillEditViewController
+ (instancetype)dequeueReusableCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withEditType:(SkillEditType)editType topicModel:(ZZTopic *)topicModel  {
    NSString *cellIdentifier = SkillEditBaseCellId;
    SkillEditCellType cellType = BaseCellType;
    if (indexPath.section == 0 || indexPath.section == 1) {
        cellIdentifier = SkillEditInputCellId;
        if (indexPath.section == 0) {
            cellType = editType != SkillEditTypeAddCustomTheme ? InputCellTypeSystemTheme : InputCellTypeCustomTheme;
        } else {
            cellType = InputCellTypePrice;
        }
    } else {
        if (editType == SkillEditTypeEditTheme) {
            if (indexPath.row == 0) {
                cellIdentifier = SkillEditTagCellId;
            } else if (indexPath.row == 1) {
                cellIdentifier = SkillEditIntroduceCellId;
            } else {
                cellIdentifier = SkillEditPictureCellId;
            }
        } else {
            if (indexPath.row == 0) {
                cellIdentifier = SkillEditTagCellId;
            } else {
                ZZSkill *skill = topicModel.skills[0];
                if (indexPath.row == 1) {
                    cellType = PressCellTypeText;
                    if (skill.detail.content.length == 0) {
                        cellIdentifier = SkillEditPressCellId;
                    } else {
                        cellIdentifier = SkillEditIntroduceCellId;
                    }
                } else if (indexPath.row == 2) {
                    cellType = PressCellTypeImage;
                    if (skill.photo.count == 0) {
                        cellIdentifier = SkillEditPressCellId;
                    } else {
                        cellIdentifier = SkillEditPictureCellId;
                    }
                }
            }
        }
    }
    ZZSkillEditBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.cellType = cellType;
    [cell setTopicModel:topicModel];
    return cell;
}
//For SkillOptionViewController
+ (instancetype)dequeueReusableCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath topicModel:(ZZTopic *)topicModel {
    NSString *cellIdentifier = SkillEditBaseCellId;
    SkillEditCellType cellType = BaseCellType;
    switch (indexPath.section) {
        case 0: {   //技能名称
            cellIdentifier = SkillEditInputCellId;
            cellType = InputCellTypeSystemTheme;
        } break;
        case 1: {   //价格
            cellIdentifier = SkillEditInputCellId;
            cellType = InputCellTypePrice;
        } break;
        case 2: {   //档期
            cellIdentifier = SkillEditScheduleId;
        } break;
        case 3: {   //标签
            cellIdentifier = SkillEditTagCellId;
        } break;
        case 4: {   //介绍
            cellIdentifier = SkillEditPressCellId;
            cellType = PressCellTypeText;
        } break;
        default: break;
    }
    ZZSkillEditBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.cellType = cellType;
    [cell setTopicModel:topicModel];
    if (indexPath.section == 0) {   //技能名称
        cell.inputTextColor = kBlackColor;
        cell.inputTextFont = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
        cell.showEditIcon = YES;
    }
    if (indexPath.section == 1) {   //价格
        cell.showEditIcon = YES;
        cell.inputTextColor = kGoldenRod;
        cell.inputTextFont = [UIFont systemFontOfSize:15 weight:(UIFontWeightBold)];
    }
    return cell;
}


- (void)addToParentViewController:(UIViewController *)viewController {
    //rewrite on subClass if need
}

#pragma mark -- setter
- (void)setIsUpdated:(BOOL)isUpdated {
    _isUpdated = isUpdated;
    !_updateBlock ? : _updateBlock(isUpdated);
}

@end
