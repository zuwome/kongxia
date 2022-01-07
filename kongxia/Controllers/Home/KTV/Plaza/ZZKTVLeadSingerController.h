//
//  ZZLeadSingerController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

@class ZZKTVLeadSingerController;
@protocol ZZKTVLeadSingerControllerDelegate<NSObject>

- (void)switchToTasks:(ZZKTVLeadSingerController *)controller;

@end

@interface ZZKTVLeadSingerController : ZZViewController

@property (nonatomic, weak) id<ZZKTVLeadSingerControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isTheFirstTime;

@property (nonatomic, weak) UIViewController *parentController;

- (void)fresh;

@end

