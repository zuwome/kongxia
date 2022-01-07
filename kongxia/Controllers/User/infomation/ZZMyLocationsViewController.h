//
//  ZZMyLocationsViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
@class MyLocationView;
@class ZZMyLocationsViewController;

@protocol ZZMyLocationsViewControllerDelegate <NSObject>

- (void)controllerDidEdited:(ZZMyLocationsViewController *)controller;

@end

@interface ZZMyLocationsViewController : ZZViewController

@property (nonatomic, weak) id<ZZMyLocationsViewControllerDelegate> delegate;

@end

@protocol MyLocationViewDelegate <NSObject>

- (void)view:(MyLocationView *)view delete:(NSInteger)deleteIdx;

@end

@interface MyLocationView : UIView

@property (nonatomic, weak) id<MyLocationViewDelegate> delegate;

@property (nonatomic, assign) double totalWidth;

- (instancetype)initWithTitle:(NSString *)title distance:(double)distance;

- (void)configureTitle:(NSString *)title distance:(double)distance;

@end
