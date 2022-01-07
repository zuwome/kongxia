//
//  ZZFindGroupsView.h
//  zuwome
//
//  Created by YuTianLong on 2018/2/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZFindGroupModel;

@interface ZZFindGroupsView : UIView

@property (nonatomic, readonly) ZZFindGroupModel *currentSelectGropus;//获取当前选中的类别(只读)

@property (nonatomic, copy) void (^fetchGroupsSuccessBlock)(ZZFindGroupModel *model);//内部获取类别成功，返回默认
@property (nonatomic, copy) void (^fetchGroupsFailBlock)(ZZError *error,NSMutableArray *array);//内部获取类别数据失败
@property (nonatomic, copy) void (^didSelectGroupsBlock)(ZZFindGroupModel *model);//每次选中类别的回调
@property (nonatomic, strong) UIViewController *viewController;
- (void)againReloadGropusIfNeeded;//重新加载类别数据，内部自动判别是否需要重新加载。一般用于第一次加载失败能重新加载

@property (nonatomic, copy) void (^didEndScroll)(void);
@property (nonatomic, copy) void (^didStartScroll)(void);

@end
