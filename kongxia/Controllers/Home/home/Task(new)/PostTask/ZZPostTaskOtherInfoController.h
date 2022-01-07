//
//  ZZPostTaskOtherInfoController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

@class ZZPostTaskViewModel;

@interface ZZPostTaskOtherInfoController : ZZViewController

@property (nonatomic, strong) ZZPostTaskViewModel *viewModel;

- (instancetype)initWithViewModel:(ZZPostTaskViewModel *)viewModel;

@end

