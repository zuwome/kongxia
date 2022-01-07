//
//  ZZCreateSingingTaskController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

@class ZZCreateSingingTaskController;
@protocol ZZCreateSingingTaskControllerDelegate <NSObject>

- (void)controllerCreateSuccess:(ZZCreateSingingTaskController *)controller;

@end

@interface ZZCreateSingingTaskController : ZZViewController

@property (nonatomic, weak) id<ZZCreateSingingTaskControllerDelegate> delegate;

@end


