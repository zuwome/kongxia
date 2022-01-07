//
//  ZZNewHomeBaseCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeBaseCell.h"

@implementation ZZNewHomeBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tableView andCellIdentifier:(NSString *)cellIdentifier forIndexPath:(NSIndexPath *)indexPath {
    ZZNewHomeBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

//baseCell
- (void)setCtlsArray:(NSArray *)ctlsArray {
    _ctlsArray = ctlsArray;
}

@end
