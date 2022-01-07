//
//  ZZPublishOrderChooseCell.h
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPublishListModel.h"

static NSString *PublishOrderChooseNotification = @"PublishOrderChooseNotification";

@interface ZZPublishOrderChooseCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) ZZPublishModel *model;
@property (nonatomic, copy) dispatch_block_t touchHead;
@property (nonatomic, copy) dispatch_block_t touchConnect;
@property (nonatomic, copy) dispatch_block_t touchCancel;

- (void)setData:(ZZPublishListModel *)model;

@property (nonatomic, copy) void (^longPressGestureRecognizerBlock)(void);//长按手势
@property (nonatomic, copy) void (^clickRemoveViewBlock)(void);

- (void)longPressShowView;//长按显示View

- (void)removeView;//删除长按显示的View

@end
