//
//  ZZRecordInputView.m
//  zuwome
//
//  Created by angBiu on 2016/12/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRecordInputView.h"
@interface ZZRecordInputView ()
@property (nonatomic,strong) UILabel *countLab;
@end
@implementation ZZRecordInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.countLab];
        [self setConstraints];
        self.inputTV.placeholder = @"说点什么吧？";
        self.inputTV.placeholderColor = RGBACOLOR(0, 0, 0, 0.5);
    }
    
    return self;
}



#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 140) {
        textView.text = [textView.text substringToIndex:140];
        self.countLab.text = [NSString stringWithFormat:@"%lu/140",(unsigned long)textView.text.length];
    }else{
        self.countLab.text = [NSString stringWithFormat:@"%lu/140",(unsigned long)textView.text.length];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
        return NO;
    }
    return YES;
}

- (UITextView *)inputTV
{
    if (!_inputTV) {
        _inputTV = [[UITextView alloc] initWithFrame:CGRectZero];
        _inputTV.backgroundColor = [UIColor clearColor];
        _inputTV.textColor = [UIColor blackColor];
        _inputTV.font = [UIFont systemFontOfSize:15];
        _inputTV.placeholder = @"形容一下此刻的心情";
        _inputTV.delegate = self;
        _inputTV.returnKeyType = UIReturnKeyDone;
        [self addSubview:_inputTV];
        _inputTV.textAlignment = NSTextAlignmentLeft;
     
        [_inputTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(10);
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(self);
        }];
    }
    return _inputTV;
}
- (UILabel *)countLab {
    if (!_countLab) {
        _countLab = [[UILabel alloc]init];
        _countLab.textColor = RGBACOLOR(0, 0, 0, 0.5);
        _countLab.text = @"0/140";
        _countLab.font = [UIFont systemFontOfSize:12];
        _countLab.textAlignment = NSTextAlignmentRight;
    }
    return _countLab;
}

- (void)setConstraints {
    [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-8);
        make.bottom.offset(-5);
    }];
}
@end
