//
//  ZZCommissionInviteCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/2.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZCommissionUserModel;
@class ZZCommissionInviteUserInfoModel;

@class ZZCommissionInviteCell;
@protocol ZZCommissionInviteCellDelegate<NSObject>

- (void)inviteCell:(ZZCommissionInviteCell *)cell showUserInfo:(ZZCommissionInviteUserInfoModel *)userModel;

- (void)inviteCell:(ZZCommissionInviteCell *)cell reminder:(ZZCommissionInviteUserInfoModel *)userModel action:(NSInteger)action;

@end

@interface ZZCommissionInviteCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZCommissionInviteCellDelegate> delegate;

@property (nonatomic, strong) ZZCommissionInviteUserInfoModel *userModel;

@end


