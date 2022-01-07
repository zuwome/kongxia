//
//  ZZMyCommissionsController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/4.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "MyTableView.h"
#import "CommissionConfig.h"


@interface ZZMyCommissionsController : ZZViewController

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL shouldJump;

@property (nonatomic, assign) CommissionDetailsType jumpType;

- (void)jumpTo:(CommissionDetailsType)type;

@end


