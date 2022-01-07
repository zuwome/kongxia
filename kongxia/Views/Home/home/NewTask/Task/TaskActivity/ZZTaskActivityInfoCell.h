//
//  ZZTaskActivityInfoCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/24.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZTaksListViewModel.h"

@class ZZTaskActivityInfoCell;
@protocol ZZTaskActivityInfoCellDelegate <NSObject>

- (void)cell:(ZZTaskActivityInfoCell *)cell activityShowLocations:(ZZTaskModel *)task;

- (void)cell:(ZZTaskActivityInfoCell *)cell activityShowPriceDetails:(ZZTaskModel *)task;

- (void)cell:(ZZTaskActivityInfoCell *)cell activityShowMoreAction:(TaskActivityInfoItem *)item;

@end

@interface ZZTaskActivityInfoCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZTaskActivityInfoCellDelegate> delegate;

@property (nonatomic, strong) TaskActivityInfoItem *item;

@property (nonatomic, strong) UIButton *moreBtn;

@end

