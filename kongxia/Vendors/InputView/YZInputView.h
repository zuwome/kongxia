//
//  YZInputView.h
//  YZInputView
//
//  Created by yz on 16/8/1.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZInputView : UITextView

/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, strong) void(^yz_textHeightChangeBlock)(NSString *text,CGFloat textHeight);

/**
 *  设置圆角
 */
@property (nonatomic, assign) NSUInteger cornerRadius;

@property (nonatomic, assign) BOOL shouldCallBack;

- (void)textDidChange;

/**
 根据外界传入的草稿返回输入框的高度

 @param draftString 草稿
 */
- (CGFloat)setInputViewHeightWhenHaveDraftStringWithString:(NSString *)draftString;
@end
