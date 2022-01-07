//
//  TLTextView.m
//  Cosmetic
//
//  Created by 余天龙 on 16/6/24.
//  Copyright © 2016年 YuTianLong. All rights reserved.
//

#import "TLTextView.h"

#define PLACEHOLDER_FONT        (13)

@interface TLTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation TLTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(TLTextView);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(TLTextView);
    }
    return self;
}

commonInitImplementationSafe(TLTextView) {
    
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.font = [UIFont systemFontOfSize:PLACEHOLDER_FONT];
    self.textColor = kBlackColor;
    self.scrollEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.returnKeyType = UIReturnKeyDone;
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.textColor = RGBCOLOR(173, 173, 177);
    self.placeholderLabel.font = [UIFont systemFontOfSize:PLACEHOLDER_FONT];
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.placeholderLabel];
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = getTextSize([UIFont systemFontOfSize:PLACEHOLDER_FONT], self.placeholderLabel.text, self.width - 10).height;
    self.placeholderLabel.frame = CGRectMake(5, 8, self.width - 10, height);
}

- (void)setIsHiddenPlaceholder:(BOOL)isHiddenPlaceholder {
    self.placeholderLabel.hidden = isHiddenPlaceholder;
}

@end
