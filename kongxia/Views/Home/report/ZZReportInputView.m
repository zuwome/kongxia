//
//  ZZReportInputView.m
//  zuwome
//
//  Created by angBiu on 2016/12/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZReportInputView.h"

@implementation ZZReportInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(15);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.right.mas_equalTo(self);
        }];
         
        _textView = [[UITextView alloc] init];
        _textView.placeholder = @"请输入举报原因";
        _textView.textColor = kBlackTextColor;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
        [self addSubview:_textView];
        
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(15);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
        }];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = kBlackTextColor;
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.text = @"0/100";
        [self addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.bottom.mas_equalTo(self);
        }];
    }
    
    return self;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%ld/100",textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
        return NO;
    }
    return YES;
}

@end
