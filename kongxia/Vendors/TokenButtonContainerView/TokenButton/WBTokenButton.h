//
//  WBTokenButton.h
//  Whistle
//
//  Created by SharkCome on 9/11/15.
//  Copyright (c) 2015 BookSir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBTokenButton : UIControl

@property (nonatomic, strong) NSString *contentTitle;
@property (nonatomic, strong) UIFont *contentFont;
@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, strong) UIButton *contentButton;

- (CGSize)preferredSize;

- (void)deleteButtonTarget:(id)target action:(SEL)action;

- (void)addContentTarget:(id)target action:(SEL)action;

@end
