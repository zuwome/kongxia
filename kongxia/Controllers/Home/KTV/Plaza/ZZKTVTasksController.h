//
//  ZZKTVTasksController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZKTVTasksController : ZZViewController

@property (nonatomic, assign) BOOL isTheFirstTime;

@property (nonatomic, weak) UIViewController *parentController;

- (void)fresh;

@end

