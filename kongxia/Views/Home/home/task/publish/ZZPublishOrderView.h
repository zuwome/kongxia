//
//  ZZPublishOrderView.h
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPublishOrderPublishView.h"

#import "ZZTaskTimeView.h"
#import "ZZTaskMoneyInputView.h"
#import "ZZRentDropdownModel.h"

/**
 发任务
 */
@interface ZZPublishOrderView : UIView

@property (nonatomic, strong) ZZPublishOrderPublishView *publishView;
@property (nonatomic, strong) NSMutableDictionary *param;

@property (nonatomic, strong) ZZTaskTimeView *timeView;
@property (nonatomic, strong) ZZTaskMoneyInputView *inputView;

@property (nonatomic, strong) ZZSkill *skill;
@property (nonatomic, strong) ZZRentDropdownModel *locationModel;

@property (nonatomic, copy) dispatch_block_t touchPublish;
@property (nonatomic, copy) dispatch_block_t touchRule;
@property (nonatomic, copy) dispatch_block_t touchTaskChoose;
@property (nonatomic, copy) dispatch_block_t touchLocation;
@property (nonatomic, copy) dispatch_block_t touchTime;
@property (nonatomic, copy) dispatch_block_t touchMoney;

@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, copy) void (^presentBlock)(void);

- (void)showTaskChooseIsAllDismiss:(BOOL)dismiss;//选择任务 dismiss 是否需要dismiss全部窗口

@end
