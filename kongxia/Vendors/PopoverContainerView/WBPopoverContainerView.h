//
//  WBPopoverContainerView.h
//  Whistle
//
//  Created by ZhangAo on 15/11/30.
//  Copyright © 2015年 BookSir. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBPopoverPresentationProtocol <NSObject>

- (CGRect)popoverPresentationShowFrame;

- (CGRect)popoverPresentationHiddenFrame;

@optional

- (CGFloat)animationDuration;

@end

@interface WBPopoverContainerView : UIView <WBPopoverPresentationProtocol>

+ (WBPopoverContainerView *)popoveredView;

// Designated initializer.
- (instancetype)initWithView:(UIView *)view;

- (instancetype)initWithViewController:(UIViewController *)viewController;

@property (nonatomic, strong, readonly) UIView *customView;

@property (nonatomic, strong, readonly) UIViewController *customViewController;

@property (nonatomic, assign, readonly) BOOL isPresenting;

@property (nonatomic, assign) BOOL maskViewClickEnable;

@property (nonatomic, copy) void (^didDismissBlock)(void);

@property (nonatomic, copy) void (^shouldPresentBlock)(void);

- (void)updateFrame;

- (void)present;

- (void)dismiss;

// 交互式动画相关

- (void)beginInteractionPresenting;

- (void)updateInteractionWithProgress:(CGFloat)progress;

- (void)endInteractionWithProgress:(CGFloat)progress;

@end
