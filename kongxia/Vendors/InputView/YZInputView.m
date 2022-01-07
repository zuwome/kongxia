//
//  YZInputView.m
//  YZInputView
//
//  Created by yz on 16/8/1.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZInputView.h"

@interface YZInputView ()

/**
 *  文字高度
 */
@property (nonatomic, assign) NSInteger textH;

/**
 *  文字最大高度
 */
@property (nonatomic, assign) NSInteger maxTextH;

@end

@implementation YZInputView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    _maxNumberOfLines = maxNumberOfLines;
    
    // 计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
    
}
- (CGFloat)setInputViewHeightWhenHaveDraftStringWithString:(NSString *)draftString {
    
    self.text = draftString;
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)].height);
    if (height>_maxTextH && (_maxTextH>=0)) {
        height = _maxTextH;
    }

    return height;
}


- (void)setCornerRadius:(NSUInteger)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setYz_textHeightChangeBlock:(void (^)(NSString *, CGFloat))yz_textChangeBlock
{
    _yz_textHeightChangeBlock = yz_textChangeBlock;
    
    [self textDidChange];
}

- (void)textDidChange
{
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(size.width, MAXFLOAT)].height);
    
    if (_textH != height || _shouldCallBack) { // 高度不一样，就改变了高度
        
        // 最大高度，可以滚动
        self.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        
        _textH = height;
        
        if (_yz_textHeightChangeBlock && self.scrollEnabled == NO) {
            _yz_textHeightChangeBlock(self.text,height);
            [self.superview layoutIfNeeded];
        }
    }
}

- (void)insertText:(NSString *)text
{
    [super insertText:text];
    
    [self scrollRectToVisible:CGRectMake(0, self.contentSize.height-15, self.contentSize.width, 10) animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
