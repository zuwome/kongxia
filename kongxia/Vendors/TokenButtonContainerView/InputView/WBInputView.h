//
//  WBInputView.h
//  Whistle
//
//  Created by SharkCome on 8/28/15.
//  Copyright (c) 2015 BookSir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTokenTextView.h"

@class WBInputView;

@protocol WBInputViewDelegate <NSObject>

- (void)inputViewDidBeginEditing:(WBInputView *)inputView;

- (void)inputViewDidEndEditing:(WBInputView *)inputView;

@end

@interface WBInputView : UIView

@property (nonatomic, weak) id<WBInputViewDelegate> delegate;

@property (nonatomic, strong) WBTokenTextView *textView;
@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, copy) void (^heightChangedBlock)(CGFloat preferedHeihgt);

@property (nonatomic, copy) void (^tokenButtonTouchBlock)(NSString *uid);

@property (nonatomic, copy) void (^tokenButtonDidRemoveBlock)(void);

@property (nonatomic, copy) void (^textChangedBlock)(NSString *text);

@property (nonatomic, copy) NSString *leftViewCaption;

@property (nonatomic, assign) BOOL autoRecognizeToken;

@property (nonatomic, assign) BOOL isEditable;

- (void)addMailOwner:(NSString *)mailOwner;

- (void)addMailOwners:(NSArray<NSString *> *)mailOwners;

- (void)removeAllTokenButton;

- (void)addTitle:(NSString *)title;

- (CGFloat)preferedHeight;

- (NSArray<NSString *> *)contents;

@end
