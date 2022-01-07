//
//  ZZCommisssionIncomCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/2.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZCommissionIncomModel;

@class ZZCommisssionIncomCell;
@protocol ZZCommisssionIncomCellDelegate<NSObject>

- (void)incomeCell:(ZZCommisssionIncomCell *)cell showUserInfo:(ZZUser *)user;

@end

@interface ZZCommisssionIncomCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZCommisssionIncomCellDelegate> delegate;

@property (nonatomic, strong) ZZCommissionIncomModel *incomeModel;

@end

