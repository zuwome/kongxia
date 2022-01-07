//
//  ZZAlertNotNetEmptyView.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/15.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 加载更多,无网络的弹窗
 */
@interface ZZAlertNotNetEmptyView : UIView

/**
 用于展示的
 @param showViewController 当前是基于哪一个试图控制器展示的
 */
- (void)alertShowViewController:(UIViewController *)showViewController;
- (void)showView:(UIViewController *)viewController;
@end
