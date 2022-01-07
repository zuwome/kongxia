//
//  ZZCompleteIntegralTopView.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 完成任务的 提示
 */
@interface ZZCompleteIntegralTopView : UIView

/**
 查看详情
 */
@property (nonatomic, copy) void (^lookDetail)(void);

/**
 任务详情
 */
@property (nonatomic,strong)  NSString *taskString;
/**
 消失
 */
- (void)dissMiss;
@end
