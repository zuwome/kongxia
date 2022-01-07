//
//  ZZCommissionDetailCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ZZCommissionUserModel;

@interface ZZCommissionDetailCell : ZZTableViewCell

- (void)configureUserModel:(ZZCommissionUserModel *)model;

@end

NS_ASSUME_NONNULL_END
