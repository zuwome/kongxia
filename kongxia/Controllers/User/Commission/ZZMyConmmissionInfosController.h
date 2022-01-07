//
//  ZZMyConmmissionInfosController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/4.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "CommissionConfig.h"

@class ZZMyConmmissionInfosController;
@class ZZCommissionListModel;
@class ZZCommissionInviteUserModel;
@protocol ZZMyConmmissionInfosControllerDelegate<NSObject>

- (void)controller:(ZZMyConmmissionInfosController *)controller showIncoms:(ZZCommissionListModel *)listModel;

- (void)controller:(ZZMyConmmissionInfosController *)controller showUserInfo:(ZZUser *)userInfo;

- (void)controllerShowRules:(ZZMyConmmissionInfosController *)controller;

@end


@interface ZZMyConmmissionInfosController : ZZViewController

@property (nonatomic, weak) id<ZZMyConmmissionInfosControllerDelegate> delegate;

@property (nonatomic, assign) CommissionDetailsType type;

- (instancetype)initWithCommissionDetailsType:(CommissionDetailsType)type;

- (void)configureDatas:(id)data isRefreshing:(BOOL)isRefreshing;

@end


