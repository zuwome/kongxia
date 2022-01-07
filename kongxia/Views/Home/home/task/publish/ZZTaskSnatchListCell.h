//
//  ZZTaskSnatchListCell.h
//  zuwome
//
//  Created by angBiu on 2017/8/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPublishListModel.h"
#import "ZZColorCycleView.h"

static NSString *SnatcherListNotification = @"SnatcherListNotification";

@interface ZZTaskSnatchListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) ZZColorCycleView *cycleView;
@property (nonatomic, strong) ZZPublishModel *model;
@property (nonatomic, copy) dispatch_block_t touchHead;
@property (nonatomic, copy) dispatch_block_t touchCancel;

- (void)setData:(ZZPublishListModel *)model during:(NSInteger)during;

@property (nonatomic, copy) void (^longPressGestureRecognizerBlock)(void);//长按手势
@property (nonatomic, copy) void (^clickRemoveViewBlock)(void);

- (void)longPressShowView;//长按显示View

- (void)removeView;//删除长按显示的View

@end
