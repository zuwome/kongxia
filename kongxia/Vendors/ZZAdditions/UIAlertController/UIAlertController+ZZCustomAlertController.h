//
//  UIAlertController+ZZCustomAlertController.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^UIActionControllerSheetCompletionBlock) (UIActionSheet * __nonnull actionSheet, NSInteger buttonIndex);
@interface UIAlertController (ZZCustomAlertController)
+ (void)presentActionControllerWithTitle:(NSString *_Nullable)title
                                 actions:(NSArray<UIAlertAction *> *_Nullable)actions;
@end
