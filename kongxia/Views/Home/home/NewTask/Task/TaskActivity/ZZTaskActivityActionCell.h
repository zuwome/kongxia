//
//  ZZTaskActivityActionCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/24.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZTaksListViewModel.h"

@class ZZTaskActivityActionCell;
@protocol ZZTaskActivityActionCellDelegate <NSObject>

- (void)cell:(ZZTaskActivityActionCell *)cell chat:(TaskActivityActionsItem *)item;

- (void)cell:(ZZTaskActivityActionCell *)cell rent:(TaskActivityActionsItem *)item;

- (void)cell:(ZZTaskActivityActionCell *)cell checkWechat:(TaskActivityActionsItem *)item;

@end

@interface ZZTaskActivityActionCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZTaskActivityActionCellDelegate> delegate;

@property (nonatomic, strong) TaskActivityActionsItem *item;

@end

