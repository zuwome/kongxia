//
//  ZZChatTaskView.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/26.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZTaskModel.h"

NS_ASSUME_NONNULL_BEGIN
@class ZZTask;
@interface ZZChatTaskView : UIView

@property (nonatomic, copy) NSDictionary *task;

- (instancetype)initWithTaskDic:(NSDictionary *)task;

@end

NS_ASSUME_NONNULL_END
