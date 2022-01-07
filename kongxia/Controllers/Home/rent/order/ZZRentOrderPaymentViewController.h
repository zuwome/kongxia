//
//  ZZRentOrderPaymentViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
@class ZZRentDropdownModel;
@class ZZOrder;

@interface ZZRentOrderPaymentViewController : ZZViewController

@property (nonatomic, assign) TaskType taskType;

@property (assign, nonatomic) BOOL isEdit;

@property (assign, nonatomic) BOOL fromChat;

@property (nonatomic, assign) BOOL isFromTask;

@property (nonatomic, strong) ZZOrder *order;

@property (nonatomic, strong) ZZTaskModel *taskModel;

@property (nonatomic, strong) ZZRentDropdownModel *addressModel;

@property (nonatomic, strong) ZZUser *user;

@property (copy, nonatomic) dispatch_block_t callBack;

- (void)payComplete;

@end
