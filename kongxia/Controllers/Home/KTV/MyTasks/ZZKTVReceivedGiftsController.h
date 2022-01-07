//
//  ZZRecivedGiftsController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

@class ZZKTVReceivedGiftsController;
@protocol ZZKTVReceivedGiftsControllerDelegate<NSObject>

- (void)switchToTasks:(ZZKTVReceivedGiftsController *)controller;

@end

@interface ZZKTVReceivedGiftsController : ZZViewController

@property (nonatomic, weak) id<ZZKTVReceivedGiftsControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isTheFirstTime;

@property (nonatomic, weak) UIViewController *parentController;

- (void)fresh;

@end

