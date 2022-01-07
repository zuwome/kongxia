//
//  ZZRentOrderInfoViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"


typedef NS_ENUM(NSInteger, OrderCellType) {
    CellTypeContent   = 0,
    CellTypeStartTime,
    CellTypeDuration,
    CellTypeLocation,
    
    CellTypePayWallet,
    CellTypePayWechat,
    CellTypePayAliPay,
    
    CellTypeCheckWechat,
};

@interface ZZRentOrderInfoViewController : ZZViewController

@property (strong, nonatomic) ZZOrder *order;

@property (strong, nonatomic) ZZUser *user;

@property (assign, nonatomic) BOOL isEdit;

@property (assign, nonatomic) BOOL fromChat;

@property (nonatomic, assign) BOOL isFromTask;

@property (nonatomic, assign) TaskType taskType;

@property (nonatomic, strong) ZZTaskModel *taskModel;

@property (copy, nonatomic) dispatch_block_t callBack;

@end

