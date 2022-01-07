//
//  ZZWeiChatBaseEvaluation.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//微信评价的基础类弹窗

#import <UIKit/UIKit.h>
#import "ZZWeiChatEvaluationModel.h"
#import "ZZWeiChatEvaluationNetwork.h"

@interface ZZWeiChatBaseEvaluation : UIView

/**
 要显示

 @param viewController 当前要展示的试图控制器, nil默认为根视图控制器
 */
- (void)showView:(UIViewController *)viewController;
/**
 消失
 */
- (void)dissMiss;

/**
 消失
 */
- (void)dissMissCurrent;
@end
