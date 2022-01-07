//
//  ZZPlayerCommentBottomView.m
//  zuwome
//
//  Created by angBiu on 2016/12/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPlayerCommentBottomView.h"

@interface ZZPlayerCommentBottomView () <UITextViewDelegate>

@end

@implementation ZZPlayerCommentBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXCOLOR(0x202020);
        
        self.sendBtn.hidden = NO;
        self.inputTF.placeholder = @"评论一发";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        WeakSelf;
        _inputTF.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight) {
            CGFloat height = 0;
            if (textHeight + 20 < 55) {
                height = 55;
            } else {
                height = textHeight + 20;
            }
            CGFloat offset = weakSelf.height - height;
            weakSelf.height = height;
            weakSelf.top = weakSelf.top + offset;
        };
        
        [self disabledStatus];
    }
    
    return self;
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setCommentNameString:(NSString *)commentNameString
{
    _commentNameString = commentNameString;
    _inputTF.text = commentNameString;
}

#pragma mark - private

- (void)disabledStatus
{
    _sendBtn.layer.borderWidth = 1;
    _sendBtn.backgroundColor = [UIColor clearColor];
    [_sendBtn setTitleColor:HEXCOLOR(0xADADB1) forState:UIControlStateNormal];
    _sendBtn.userInteractionEnabled = NO;
}

- (void)normalStatus
{
    _sendBtn.layer.borderWidth = 0;
    _sendBtn.backgroundColor = kYellowColor;
    [_sendBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    _sendBtn.userInteractionEnabled = YES;
}

#pragma mark - UIButtonMethod

- (void)sendBtnClick
{
    NSString *comment = @"";
    NSString *replayId = nil;
    if (isNullString(_commentNameString)) {
        comment = _inputTF.text;
    } else {
        NSRange range = [_inputTF.text rangeOfString:_commentNameString];
        if (range.location == 0) {
            comment = [_inputTF.text stringByReplacingOccurrencesOfString:_commentNameString withString:@""];
            replayId = _replyId;
        } else {
            comment = _inputTF.text;
        }
    }
    if (_sendComment) {
        _sendComment(comment,replayId);
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSUInteger during = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    [UIView animateWithDuration:during animations:^{
        self.top = SCREEN_HEIGHT - rect.size.height - self.height;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSUInteger during = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    [UIView animateWithDuration:during animations:^{
        self.top = SCREEN_HEIGHT - self.height;
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 140) {
        textView.text = [textView.text substringToIndex:140];
    }
    
    BOOL normal = YES;
    if (isNullString(textView.text)) {
        normal = NO;
    } else if (!isNullString(_commentNameString)) {
        NSRange range = [textView.text rangeOfString:_commentNameString];
        if (range.location == 0) {
            NSString *string = [textView.text stringByReplacingOccurrencesOfString:_commentNameString withString:@""];
            if (isNullString(string)) {
                normal = NO;
            }
        }
    }
    
    if (normal) {
        [self normalStatus];
    } else {
        [self disabledStatus];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - lazyload

- (YZInputView *)inputTF
{
    if (!_inputTF) {
        _inputTF = [[YZInputView alloc] init];
        _inputTF.backgroundColor = HEXCOLOR(0x202020);
        _inputTF.textColor = [UIColor whiteColor];
        _inputTF.placeholderColor = HEXACOLOR(0xffffff, 0.5);
        _inputTF.font = [UIFont systemFontOfSize:15];
        _inputTF.returnKeyType = UIReturnKeyDone;
        _inputTF.delegate = self;
        _inputTF.maxNumberOfLines = 3;
        _inputTF.layer.borderWidth = 1;
        _inputTF.layer.borderColor = HEXCOLOR(0x3F3A3A).CGColor;
        _inputTF.enablesReturnKeyAutomatically = NO;
        [self addSubview:_inputTF];
        
        [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(12);
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
            make.right.mas_equalTo(self.sendBtn.mas_left).offset(-10);
        }];
    }
    
    return _inputTF;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:HEXCOLOR(0xADADB1) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.layer.cornerRadius = 4;
        _sendBtn.layer.borderWidth = 1;
        _sendBtn.layer.borderColor = HEXCOLOR(0x4A4A4A).CGColor;
        [self addSubview:_sendBtn];
        
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(44, 35));
        }];
    }
    return _sendBtn;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
