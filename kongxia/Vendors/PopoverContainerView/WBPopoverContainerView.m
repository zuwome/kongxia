//
//  WBPopoverContainerView.m
//  Whistle
//
//  Created by ZhangAo on 15/11/30.
//  Copyright © 2015年 BookSir. All rights reserved.
//

#import "WBPopoverContainerView.h"

#define MASK_ALPHA				(0.8)

@interface WBPopoverContainerView ()

@property (nonatomic, weak) UIControl *maskView;
@property (nonatomic, assign, readwrite) BOOL isPresenting;

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIViewController *customViewController;

@end

@implementation WBPopoverContainerView

static __weak WBPopoverContainerView *popoverView = nil;
+ (UIView *)popoveredView {
    return popoverView;
}

- (instancetype)initWithView:(UIView *)view {
	self = [super init];
	if (self) {
		self.customView = view;
	}
	
	return self;
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
	self = [self initWithView:viewController.view];
	if (self) {
		self.customViewController = viewController;
	}
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self awakeFromNib];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	UIView *container = [UIApplication sharedApplication].keyWindow;
	UIControl *maskView = [[UIControl alloc] initWithFrame:container.bounds];
	maskView.backgroundColor = RGBCOLOR(0, 0, 0);
	self.maskView = maskView;
    
    self.maskViewClickEnable = YES;
	
	self.frame = container.bounds;
	[self addSubview:self.maskView];
}

- (void)updateFrame {
	if (self.isPresenting) {
		[UIView animateWithDuration:[self animationDuration]
						 animations:^{
							 self.customView.frame = [self popoverPresentationShowFrame];
						 }];		
	}
}

- (void)present {
	if (self.isPresenting) {
		return;
	}
	[self prepareForBeginPresent];
	
	[UIView animateWithDuration:[self animationDuration]
					 animations:^{
						 self.maskView.alpha = MASK_ALPHA;
						 self.customView.frame = [self popoverPresentationShowFrame];
						 self.isPresenting = YES;
						 
						 [self.customViewController viewDidAppear:YES];
					 }];
    
    popoverView = self;
}

- (void)dismiss {
	BLOCK_SAFE_CALLS(self.didDismissBlock);
	
	[self.customViewController viewWillDisappear:YES];
	
	[UIView animateWithDuration:[self animationDuration]
					 animations:^{
						 self.maskView.alpha = 0;
						 
						 self.customView.frame = [self popoverPresentationHiddenFrame];
					 } completion:^(BOOL finished) {
						 [self.customView removeFromSuperview];
						 [self.customViewController removeFromParentViewController];
						 [self removeFromSuperview];
						 self.isPresenting = NO;
						 
						 [self.customViewController viewDidDisappear:YES];
					 }];
    
    popoverView = nil;
}

- (CGFloat)animationDuration {
	return 0.3;
}

- (void)beginInteractionPresenting {
	if (!self.isPresenting) {
		[self prepareForBeginPresent];
	}
}

- (void)updateInteractionWithProgress:(CGFloat)progress {
	if (progress > 1.0000) {
		return;
	}
	
	CGRect showFrame = [self popoverPresentationShowFrame];
	CGRect hiddenFrame = [self popoverPresentationHiddenFrame];
	
	CGRect destFrame;
	destFrame.origin = CGPointMake(hiddenFrame.origin.x - (hiddenFrame.origin.x - showFrame.origin.x) * progress,
								   hiddenFrame.origin.y - (hiddenFrame.origin.y - showFrame.origin.y) * progress);
	
	destFrame.size = showFrame.size;
	
	self.customView.frame = destFrame;
	self.maskView.alpha = MASK_ALPHA * progress;
}

- (void)endInteractionWithProgress:(CGFloat)progress {
	if (progress > 0.5) {
		[self present];
	} else {
        [self dismiss];
	}
}

#pragma mark - Private methods

- (void)prepareForBeginPresent {
	if (self.superview == nil) {
		UIViewController *containerVC = [UIApplication sharedApplication].keyWindow.rootViewController;
		if (containerVC.presentedViewController != nil) {
			containerVC = containerVC.presentedViewController;
		}
        if (self.customViewController) {
            [containerVC addChildViewController:self.customViewController];
        }
		[self addSubview:self.customView];
		[containerVC.view addSubview:self];
		
		[self.customViewController viewWillAppear:YES];
		
		self.maskView.alpha = 0;
		self.customView.frame = [self popoverPresentationHiddenFrame];
		
		BLOCK_SAFE_CALLS(self.shouldPresentBlock);
	}
}

#pragma mark - WBPopoverAnimationProtocol methods

- (CGRect)popoverPresentationShowFrame {
	return CGRectMake(0, self.height - self.customView.height, self.customView.width, self.customView.height);
}

- (CGRect)popoverPresentationHiddenFrame {
	return CGRectMake(0, self.height, self.customView.width, self.customView.height);
}

#pragma mark - Getter, Setter methods

- (void)setMaskViewClickEnable:(BOOL)maskViewClickEnable {
    _maskViewClickEnable = maskViewClickEnable;
    
    if (maskViewClickEnable) {
        [self.maskView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.maskView removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
