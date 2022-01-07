//
//  UIAlertController+ConveniencePresent.h
//  Whistle
//
//  Created by ZhangAo on 15/11/5.
//  Copyright © 2015年 BookSir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (ConveniencePresent)

+ (UIViewController *)findAppreciatedRootVC;

// Alert 样式

+ (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message doneBlock:(void (^)(void))block;

+ (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message doneBlock:(void (^)(void))block cancelBlock:(void (^)(void))cancelBlock;

+ (void)presentAlertControllerWithTitle:(NSString *)title
								message:(NSString *)message
			   withTextFieldPlaceholder:(NSString *)placeholder
							  doneBlock:(void (^)(NSString *result))block
                            cancelBlock:(void (^)(void))cancelBlock;

+ (void)presentAlertControllerWithTitle:(NSString *)title
								message:(NSString *)message
							  doneTitle:(NSString *)doneTitle
							cancelTitle:(NSString *)cancelTitle
						  completeBlock:(void (^)(BOOL isCancelled))completeBlock;

// Action 样式

+ (void)presentActionControllerWithTitle:(NSString *)title
								 actions:(NSArray<UIAlertAction *> *)actions;

/**
 可传入带控制器的弹窗

 */
+ (void)presentAlertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                              doneTitle:(NSString *)doneTitle
                            cancelTitle:(NSString *)cancelTitle
                     showViewController:(UIViewController *)showViewController
                          completeBlock:(void (^)(BOOL))completeBlock;
@end
