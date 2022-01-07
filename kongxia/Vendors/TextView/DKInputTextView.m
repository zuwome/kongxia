//
//  DKInputTextView.m
//  Cosmetic
//
//  Created by 余天龙 on 16/6/24.
//  Copyright © 2016年 YuTianLong. All rights reserved.
//

#import "DKInputTextView.h"
#import "TLTextView.h"
#import "Masonry.h"

#define TEXT_MAX            (255)

@interface DKInputTextView () <UITextViewDelegate>

@property (nonatomic, strong) TLTextView *textView;
@property (nonatomic, strong) UILabel *lenghtLabel;

@end

@implementation DKInputTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(DKInputTextView);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(DKInputTextView);
    }
    return self;
}

commonInitImplementationSafe(DKInputTextView) {
    
    self.textMaxLenght = 255;

    self.textView = [[TLTextView alloc] init];
    self.textView.delegate = self;
    
    self.lenghtLabel = [[UILabel alloc] init];
    self.lenghtLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.textMaxLenght];
    self.lenghtLabel.textColor = RGBCOLOR(173, 173, 173);
    self.lenghtLabel.textAlignment = NSTextAlignmentRight;
    self.lenghtLabel.font = [UIFont systemFontOfSize:10];
    
    [self addSubview:self.lenghtLabel];
    [self.lenghtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.leading.equalTo(@0);
        make.bottom.equalTo(@0);
        make.trailing.equalTo(@(-8));
    }];
    
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@(-12));
    }];
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.textView.placeholder = placeholder;
}

- (void)setTextMaxLenght:(NSUInteger)textMaxLenght {
    _textMaxLenght = textMaxLenght;
    
    self.lenghtLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.textMaxLenght];
}

- (NSString *)text {
    return self.textView.text;
}

#pragma mark - UITextViewDelegate methods

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > self.textMaxLenght) {
        textView.text = [textView.text substringToIndex:self.textMaxLenght];
    }
    self.lenghtLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)(self.textMaxLenght - textView.text.length)];
    self.textView.isHiddenPlaceholder = self.textView.hasText;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        [textView resignFirstResponder];
    }
    return YES;
}

@end
