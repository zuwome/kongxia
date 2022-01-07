//
//  ZZCommissionEmptyCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "CommissionConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class ZZCommissionEmptyCell;
@protocol ZZCommissionEmptyCellDelegate<NSObject>

- (void)cell:(ZZCommissionEmptyCell *)cell btnAction:(CommissionDetailsType)type;

@end

@interface ZZCommissionEmptyCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZCommissionEmptyCellDelegate> delegate;

@property (nonatomic, assign) CommissionDetailsType type;

@end

NS_ASSUME_NONNULL_END
