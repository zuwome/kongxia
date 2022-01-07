//
//  ZZNewRentContainerCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/10/9.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

/**
 *  个人资料页（重构）容器cell
 */
#import <UIKit/UIKit.h>
#import "ZZRentInfoViewController.h"
#import "ZZRentDynamicViewController.h"

#define RentContainCellId @"RentContainCellId"

NS_ASSUME_NONNULL_BEGIN

@interface ZZNewRentContainerCell : UITableViewCell

@property (nonatomic) ZZScrollView *scrollView;
@property (nonatomic, assign) CGFloat marginBottom;
@property (nonatomic, weak) ZZRentInfoViewController *infoCtrl;
@property (nonatomic, weak) ZZRentDynamicViewController *dynamicCtrl;
@property (nonatomic, copy) void(^didScroll)(CGFloat offsetX);

@end

NS_ASSUME_NONNULL_END
