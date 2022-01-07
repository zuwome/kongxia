//
//  UIAlertController+ConveniencePresent.m
//  Whistle
//
//  Created by ZhangAo on 15/11/5.
//  Copyright © 2015年 BookSir. All rights reserved.
//

#import "UIAlertController+ConveniencePresent.h"

@implementation UIAlertController (ConveniencePresent)

+ (UIViewController *)findAppreciatedRootVC {
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ([rootVC presentedViewController] != nil) {
        rootVC = rootVC.presentedViewController;
    }
    return rootVC;
}

+ (void)presentAlertController:(UIAlertController *)alertController {
	UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
	if ([rootVC presentedViewController] != nil) {
		rootVC = [UIAlertController findAppreciatedRootVC];
	}
	[rootVC presentViewController:alertController animated:YES completion:nil];
}

+ (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message doneBlock:(void (^)(void))block {
	[self presentAlertControllerWithTitle:title message:message doneTitle:@"确定" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
		if (isCancelled) {
		} else {
			BLOCK_SAFE_CALLS(block);
		}
	}];
}

+ (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message doneBlock:(void (^)(void))block cancelBlock:(void (^)(void))cancelBlock {
	[self presentAlertControllerWithTitle:title message:message doneTitle:@"确定" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
		if (isCancelled) {
			BLOCK_SAFE_CALLS(cancelBlock);
		} else {
			BLOCK_SAFE_CALLS(block);
		}
	}];
}

+ (void)presentAlertControllerWithTitle:(NSString *)title
								message:(NSString *)message
			   withTextFieldPlaceholder:(NSString *)placeholder
							  doneBlock:(void (^)(NSString *))block
                            cancelBlock:(void (^)(void))cancelBlock {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

	__block UITextField *_textField;
	[alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		textField.placeholder = placeholder;
		
		_textField = textField;
	}];
	
	UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		block(_textField.text);
	}];
	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
		cancelBlock();
	}];
	
	[alertController addAction:doneAction];
	[alertController addAction:cancelAction];
	
	[self presentAlertController:alertController];
}

+ (void)presentAlertControllerWithTitle:(NSString *)title
								message:(NSString *)message
							  doneTitle:(NSString *)doneTitle
							cancelTitle:(NSString *)cancelTitle
						  completeBlock:(void (^)(BOOL))completeBlock {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *doneAction = [UIAlertAction actionWithTitle:doneTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		BLOCK_SAFE_CALLS(completeBlock, NO);
	}];
	
	if (cancelTitle.length > 0) {
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
			BLOCK_SAFE_CALLS(completeBlock, YES);
		}];
		[alertController addAction:cancelAction];
	}
	
	[alertController addAction:doneAction];
	
	[self presentAlertController:alertController];
}
+ (void)presentAlertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                              doneTitle:(NSString *)doneTitle
                            cancelTitle:(NSString *)cancelTitle
                      showViewController:(UIViewController *)showViewController
                          completeBlock:(void (^)(BOOL))completeBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:doneTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        BLOCK_SAFE_CALLS(completeBlock, NO);
    }];
    
    if (cancelTitle.length > 0) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            BLOCK_SAFE_CALLS(completeBlock, YES);
        }];
        [alertController addAction:cancelAction];
    }
    
    [alertController addAction:doneAction];
    if (showViewController) {
        [showViewController presentViewController:alertController animated:YES completion:nil];
    }else{
    [self presentAlertController:alertController];
    }
}

+ (void)presentActionControllerWithTitle:(NSString *)title
								 actions:(NSArray<UIAlertAction *> *)actions {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
																			 message:nil
																	  preferredStyle:UIAlertControllerStyleActionSheet];
	for (UIAlertAction *action in actions) {
		[alertController addAction:action];
	}
	[[self findAppreciatedRootVC] presentViewController:alertController animated:YES completion:nil];
}

@end
