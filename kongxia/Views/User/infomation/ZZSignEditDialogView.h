//
//  ZZSignEditDialogView.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/3.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZSignEditViewController;
#import "ZZSignEditViewController.h"

/**
 *  自我介绍-优秀介绍、技能浮窗
 */
#define dialogWidth (SCREEN_WIDTH - 30)
#define dialogHeight 155
@interface ZZSignEditDialogView : UIView

@property (nonatomic, assign) SignEditType signEditType;

@property (nonatomic, copy) NSString *sid;  //获取技能示例时需要

- (void)dialogShow;
- (void)dialogHide;
- (void)setDialogLocation:(CGPoint)location;

@end
