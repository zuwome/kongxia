//
//  ZZKTVTaskPrePayView.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/9.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZKTVModel;
@class ZZKTVTaskPrePayView;

@protocol ZZKTVTaskPrePayViewDelegate <NSObject>

- (void)viewCreateTask:(ZZKTVTaskPrePayView *)view;

@end


@interface ZZKTVTaskPrePayView : UIView

@property (nonatomic, weak) id<ZZKTVTaskPrePayViewDelegate> delegate;

@property (nonatomic, weak) UIViewController *parentVC;

@property (nonatomic, strong) ZZKTVModel *taskModel;

- (void)show;

- (void)hide;

@end


