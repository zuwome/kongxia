//
//  ZZSkillDetailBaseCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillDetailBaseCell.h"

@implementation ZZSkillDetailBaseCell

+ (instancetype)dequeueReusableCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = SkillDetailBaseCellId;
    SkillDetaillCellType cellType = SkillDetaillCellTypeBase;
    switch (indexPath.section) {
        case 0:
            cellType = SkillDetaillCellTypeUser;
            cellIdentifier = SkillDetailUserCellId;
            break;
        case 1:
            cellType = SkillDetaillCellTypePrice;
            cellIdentifier = SkillDetailPriceCellId;
            break;
        case 2:
            cellType = SkillDetaillCellTypeContent;
            cellIdentifier = SkillDetailContentCellId;
            break;
        case 3:
            cellType = SkillDetaillCellTypeSchedule;
            cellIdentifier = SkillDetailScheduleCellId;
            break;
        case 4:
            cellType = SkillDetaillCellTypeFlow;
            cellIdentifier = SkillDetailFlowCellId;
            break;
        case 5:
            cellType = SkillDetaillCellTypeEnsure;
            cellIdentifier = SkillDetailEnsureCellId;
            break;
        case 6:
            cellType = SkillDetaillCellTypeTip;
            cellIdentifier = SkillDetailTipCellId;
            break;
    }
    ZZSkillDetailBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.cellType = cellType;
    cell.indexPath = indexPath;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
