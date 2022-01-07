//
//  ZZPostFreeTaskLocTimeViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/9/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTaskConfig.h"

@class ZZPostTaskViewModel;
@class ZZPostFreeTaskLocTimeViewController;
@class ZZRentDropdownModel;

@protocol ZZPostFreeTaskLocTimeViewControllerDelegate <NSObject>

- (void)controller:(ZZPostFreeTaskLocTimeViewController *)controller didSelectedLocation:(ZZRentDropdownModel *)location startTime:(NSString *)startTime startTimeDescript:(NSString *)startTimeDescript durationDes:(NSString *)durationDes didAgreed:(BOOL)didAgreed;

@end

@interface ZZPostFreeTaskLocTimeViewController : ZZViewController

@property (nonatomic, weak) id<ZZPostFreeTaskLocTimeViewControllerDelegate> delegate;

@property (nonatomic, strong) ZZPostTaskViewModel *viewModel;

- (instancetype)initWithViewModel:(ZZPostTaskViewModel *)viewModel;

@end

