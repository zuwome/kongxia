//
//  ZZNewTasksView.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/1.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZNewTasksView : UIView

//+ (ZZNewTasksView *)shared;

+ (void)showWithCounts:(NSInteger)counts in:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
