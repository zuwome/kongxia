//
//  WBSearchHeaderView.h
//  Cosmetic
//
//  Created by 余天龙 on 16/6/22.
//  Copyright © 2016年 YuTianLong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBInputView.h"

@interface WBSearchHeaderView : UIView

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, weak, readonly) WBInputView *currentSelectInputView;

@property (nonatomic, copy) void (^heightChangeBlock)(CGFloat preferedHeight);
@property (nonatomic, copy) void (^contentDidChangeBlock)(WBInputView *inputView, BOOL hasRemoveTokenButton);
@property (nonatomic, copy) void (^tokenDidTouchBlock)(NSString *uid);

- (WBInputView *)insertInputViewWithTitle:(NSString *)title
                needsToAutoRecognizeToken:(BOOL)needsToAutoRecognizeToken
                                      tag:(NSUInteger)tag;

- (WBInputView *)inputViewWithTag:(NSUInteger)tag;

- (void)notifyHeightChangeBlockIfNeeded;

@end
