//
//  ZZPostTaskBasicInfoCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZPostTaskCellModel;
@class ZZPostTaskBasicInfoCell;
@protocol ZZPostTaskBasicInfoCellDelegate <NSObject>

- (void)basicInfoCellChooseLocation:(ZZPostTaskBasicInfoCell *)cell;

- (void)basicInfoCellChooseTime:(ZZPostTaskBasicInfoCell *)cell;

- (void)basicInfoCellChooseDuration:(ZZPostTaskBasicInfoCell *)cell;

@end

@interface ZZPostTaskBasicInfoCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZPostTaskBasicInfoCellDelegate> delegate;

@property (nonatomic, strong) ZZPostTaskCellModel *cellModel;

@end

