//
//  ZZCommisstionInfoCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZCommissionUserModel;
@class ZZCommissionInfoHeaderView;

@protocol ZZCommisstionInfoCellDelegate<NSObject>

- (void)view:(ZZCommissionInfoHeaderView *)cell showUserInfo:(ZZUser *)user;

- (void)viewShouldShowDetails:(ZZCommissionInfoHeaderView *)view;

@end

@interface ZZCommissionInfoHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<ZZCommisstionInfoCellDelegate> delegate;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) ZZCommissionUserModel *userCommissionModel;

@end

