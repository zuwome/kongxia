//
//  ZZRentOrderPayCompleteViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

@class ZZRentDropdownModel;

@interface ZZRentOrderPayCompleteViewController : UIViewController

@property (nonatomic, strong) ZZUser *user;

@property (nonatomic, strong) ZZOrder *order;

@property (nonatomic, strong) ZZRentDropdownModel *addressModel;

@property (copy, nonatomic) dispatch_block_t callBack;

@property (assign, nonatomic) BOOL fromChat;

@end


