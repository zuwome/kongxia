//
//  ZZCommissionPopulationCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/11.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ZZCommissionPopulationCell;
@class ZZCommissionModel;

@protocol ZZCommissionPopulationCellDelegate <NSObject>

- (void)cellshowInvitedView:(ZZCommissionPopulationCell *)cell;

@end


@interface ZZCommissionPopulationCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZCommissionPopulationCellDelegate> delegate;

@property (nonatomic, strong) ZZCommissionModel *commissionModel;

@end

NS_ASSUME_NONNULL_END
