//
//  WBInputView.m
//  Whistle
//
//  Created by SharkCome on 8/28/15.
//  Copyright (c) 2015 BookSir. All rights reserved.
//

#import "WBInputView.h"
#import "Masonry.h"
#import "WBTokenButton.h"

#define FONT_SIZE					(13) //button字体大小
#define LEFT_VIEW_TEXT_SIZE	    (10) //左边text字体大小
#define TOKEN_BUTTON_INTERVAL		(15) //tokenButton 列间距
#define TOKEN_MIN_HEIGHT			(30)
#define LEFT_TITLE_WIDTH			(15)
#define TEXT_CONTAINER_INSET		(15)

@interface WBInputView () <UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray<WBTokenButton *> *tokenButtonArray;
@property (nonatomic, strong) NSMutableArray<NSString *> *mailOwnerArray;
@property (nonatomic, assign) CGRect textViewPreviousRect; // 记录文本变化前的textView
@property (nonatomic, strong) WBTokenButton *selectTokenButton;
@property (nonatomic, strong) UILabel *leftViewLabel;
@property (nonatomic, assign) BOOL isBottonSelect;

@property (nonatomic, assign) NSUInteger tokenButtonCount;

@end

@implementation WBInputView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		commonInitSafe(WBInputView);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		commonInitSafe(WBInputView);
    }
    return self;
}


commonInitImplementationSafe(WBInputView) {
	self.clipsToBounds = YES;
	self.autoRecognizeToken = true;
	
	self.textView = [[WBTokenTextView alloc] init];
	self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
	self.textView.font = [UIFont systemFontOfSize:FONT_SIZE];
	self.textView.delegate = self;
	self.textView.scrollEnabled = NO;
	[self addSubview:self.textView];
	
    self.tokenButtonArray = [NSMutableArray array];
    self.mailOwnerArray = [NSMutableArray array];
    self.textViewPreviousRect = CGRectZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
	if (!CGSizeEqualToSize(self.textView.size, self.size)) {
		self.textView.frame = self.bounds;
		[self layoutAllButtonContainers];
		[self updateTextContainerInset];
		[self notifyHeightBlockIfNeeded];
	}
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];

    self.textView.backgroundColor = backgroundColor;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view != nil) {
//        [self.tokenButtonArray enumerateObjectsUsingBlock:^(WBTokenButton *obj, NSUInteger idx, BOOL *stop) {
//            if (obj != view) {
//                obj.selected = NO;
//            }
//        }];
//    }
//    return [super hitTest:point withEvent:event];
//}

- (void)setIsEditable:(BOOL)isEditable {
    self.isBottonSelect = isEditable;
    self.textView.editable = isEditable;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if (self.autoRecognizeToken && [text containsString:@" "]) { // 拒绝空格
		return NO;
	}
	
	if ([text isEqualToString:@"\n"]) {
		if (self.autoRecognizeToken) {
			if (textView.text.length > 0) {
				[self addMailOwner:textView.text];
			}
		} else {
			[textView resignFirstResponder];
		}
		return NO;
	}
	
	
	if (self.autoRecognizeToken && textView.text.length == 0 && text.length == 0) { // 删除最后一个 token
		if (self.selectTokenButton != nil) {
			[self removeTokenButton:self.selectTokenButton];
		} else {
			if (self.tokenButtonArray.count != 0) {
				WBTokenButton *lastTokenButton = [self.tokenButtonArray lastObject];
				if (lastTokenButton.selected == NO) {
					self.selectTokenButton = lastTokenButton;
					self.selectTokenButton.selected = YES;
				}
			}
		}
	}
	
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
	BLOCK_SAFE_CALLS(self.textChangedBlock, textView.text);
    [self notifyHeightBlockIfNeeded];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.selectTokenButton != nil) {
        //失去焦点时取消button状态及置空selectTokenButton
        WBInputView *inputView = (WBInputView *) [(WBTokenTextView *) textView superview];
        inputView.selectTokenButton.selected = NO;
        self.selectTokenButton = nil;
    }
    if (self.autoRecognizeToken && textView.text.length != 0) {
        [self addMailOwner:textView.text];
    }
    //结束编辑
    [self.delegate inputViewDidEndEditing:self];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.delegate inputViewDidBeginEditing:self];
}

#pragma mark - Public methods

- (void)setRightView:(UIView *)rightView {
	[_rightView removeFromSuperview];
	_rightView = rightView;
	
	[self addSubview:rightView];
	
	[_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@(_rightView.width));
		make.height.equalTo(@(_rightView.height));
		make.top.equalTo(@0);
		make.trailing.equalTo(@(-10));
	}];
	
	[self layoutAllButtonContainers];
	[self notifyHeightBlockIfNeeded];
}

- (void)setLeftViewCaption:(NSString *)leftViewCaption {
	CGSize leftViewSize = getTextSize([UIFont systemFontOfSize:LEFT_VIEW_TEXT_SIZE], leftViewCaption, MAXFLOAT);
	CGFloat leftViewHeigth = leftViewSize.height;
	CGFloat leftViewWidth = leftViewSize.width;
	
	if (_leftViewLabel == nil) {
		self.leftViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 0, 0)];
		self.leftViewLabel.textColor = kBlackColor;
		self.leftViewLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
		[self addSubview:self.leftViewLabel];
	}
	self.leftViewLabel.size = CGSizeMake(leftViewWidth + 10, leftViewHeigth);
	self.leftViewLabel.text = leftViewCaption;
}

- (void)addMailOwner:(NSString *)mailOwner {
	self.textView.text = @""; // 清除当前的输入
	    
	NSString *displayName = mailOwner;
	
	WBTokenButton *newTokenButton = [WBTokenButton new];
	newTokenButton.contentTitle = displayName;
	newTokenButton.contentFont = [UIFont systemFontOfSize:FONT_SIZE];
	newTokenButton.isEditable = self.textView.editable;
	[newTokenButton addTarget:self action:@selector(selectToken:) forControlEvents:UIControlEventTouchUpInside];
	[newTokenButton deleteButtonTarget:self action:@selector(deleteTokenButton:)];
	
	WBTokenButton *previousButtonContainer = [self.tokenButtonArray lastObject];
	
	[self updateFrameForToken:newTokenButton previousTokenButton:previousButtonContainer];
	
	[self addSubview:newTokenButton];
	self.textView.height = newTokenButton.frame.origin.y + newTokenButton.frame.size.height + 7;
	[self.tokenButtonArray addObject:newTokenButton];
	[self.mailOwnerArray addObject:mailOwner];
    self.tokenButtonCount = self.tokenButtonArray.count;
    
	[self updateTextContainerInset];
	[self notifyHeightBlockIfNeeded];
}

- (void)addMailOwners:(NSArray<NSString *> *)mailOwners {
    [mailOwners enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addMailOwner:obj];
    }];
}

- (void)removeAllTokenButton {
    if (self.tokenButtonCount <= 0)
        return;
    
    for (int i = 0; i < self.tokenButtonCount; i++ ) {
        [self removeTokenButton:self.tokenButtonArray[0]];
    }
    self.tokenButtonCount = self.tokenButtonArray.count;
}

- (void)addTitle:(NSString *)title {
	self.textView.text = title;
	
	[self updateTextContainerInset];
}

- (CGFloat)preferedHeight {
	CGFloat height = [self.textView sizeThatFits:CGSizeMake(self.textView.width, CGFLOAT_MAX)].height + TEXT_CONTAINER_INSET;
	if ([NSString isBlank:self.textView.text]) {
		UIView *lastView = self.subviews.lastObject;
		if (lastView) {
			height = lastView.bottom ;
			if ([lastView isKindOfClass:[WBTokenButton class]]) {
				height = lastView.bottom + 7;
			}
		}
	}
	return MAX(height, TOKEN_MIN_HEIGHT);
}

- (NSArray<NSString *> *)contents {
	return self.mailOwnerArray;
}

#pragma mark - Private methods

- (void)updateFrameForToken:(WBTokenButton *)tokenButton previousTokenButton:(WBTokenButton *)previousTokenButton {
	CGSize textSize = [tokenButton preferredSize];
	CGFloat textWidth = textSize.width;
	CGFloat textHeight = textSize.height;
	
	CGFloat containerMaxWidth = self.width - (self.rightView ? self.width - self.rightView.left : 0) - TOKEN_BUTTON_INTERVAL;
	
	if (previousTokenButton == nil) {
		tokenButton.frame = CGRectMake(LEFT_TITLE_WIDTH, 0, textWidth, textHeight);
		if (tokenButton.right > containerMaxWidth - TOKEN_BUTTON_INTERVAL) {
			textWidth = containerMaxWidth - tokenButton.left - TOKEN_BUTTON_INTERVAL;
			tokenButton.frame = CGRectMake(LEFT_TITLE_WIDTH, 0, textWidth, textHeight);
		}
	} else {
		CGFloat newTokenButtonContainerX = previousTokenButton.right + TOKEN_BUTTON_INTERVAL;
		CGFloat newTokenButtonContainerY = previousTokenButton.mj_y;
		
		tokenButton.frame = CGRectMake(newTokenButtonContainerX, newTokenButtonContainerY, textWidth, textHeight);
		if (tokenButton.right > containerMaxWidth - TOKEN_BUTTON_INTERVAL) {
			CGFloat top = previousTokenButton.bottom;
			
			tokenButton.frame = CGRectMake(TOKEN_BUTTON_INTERVAL, top + 3, textWidth, textHeight);
			if (tokenButton.right > containerMaxWidth - TOKEN_BUTTON_INTERVAL) {
				textWidth = containerMaxWidth - tokenButton.left - TOKEN_BUTTON_INTERVAL;
				tokenButton.frame = CGRectMake(TOKEN_BUTTON_INTERVAL, top + 3, textWidth, textHeight);
			}
		}
	}
}

- (void)layoutAllButtonContainers {
    [self.tokenButtonArray enumerateObjectsUsingBlock:^(WBTokenButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

        WBTokenButton *previousTokenButton = nil;
        if (idx > 0) {
            previousTokenButton = self.tokenButtonArray[idx - 1];
        }

        [self updateFrameForToken:obj previousTokenButton:previousTokenButton];
    }];
}

- (void)selectToken:(WBTokenButton *)sender {
    if (self.isBottonSelect) {
        self.selectTokenButton = sender;
        sender.selected = YES;
        WBInputView *inpView = (WBInputView *) [sender superview];
        WBTokenTextView *textView = inpView.textView;
        [textView becomeFirstResponder];
    } else {
        NSUInteger index = NSNotFound;
        for (WBTokenButton *tokenButton in self.tokenButtonArray) {
            if ([tokenButton isEqual:sender]) {
                index = [self.tokenButtonArray indexOfObject:tokenButton];
            }
        }
//        DKAssert(index != NSNotFound);
        if (self.tokenButtonTouchBlock) {
            sender.selected = sender.contentButton.isSelected ? NO : YES;
            self.tokenButtonTouchBlock(self.mailOwnerArray[index]);
        }
    }
}

- (IBAction)deleteTokenButton:(UIButton *)sender {
	WBTokenButton *tokenButton = (WBTokenButton *)sender.superview;
	[self removeTokenButton:tokenButton];
}

- (void)notifyHeightBlockIfNeeded {
	CGFloat height = [self preferedHeight];
	
	if (height != self.height) {
		BLOCK_SAFE_CALLS(self.heightChangedBlock, height);
	}
}

- (void)removeTokenButton:(WBTokenButton *)tokenButton {
	NSUInteger index = [self.tokenButtonArray indexOfObject:tokenButton];
//    DKAssert(index != NSNotFound);
	
    [self.tokenButtonArray removeObject:tokenButton];
	[self.mailOwnerArray removeObjectAtIndex:index];
	
    [tokenButton removeFromSuperview];
	self.selectTokenButton = nil;

    BLOCK_SAFE_CALLS(self.tokenButtonDidRemoveBlock);
	
	[self layoutAllButtonContainers];
	[self updateTextContainerInset];
	[self notifyHeightBlockIfNeeded];
}

- (void)updateTextContainerInset {
	NSString *text = self.textView.text;
	UITextView *textView = self.textView;
	WBTokenButton *lastTokenButton = [self.tokenButtonArray lastObject];
	
	CGFloat rightInset = self.rightView == nil ? 0 : self.rightView.width + 10;
	
	if ([NSString isNotBlank:text]) {
		CGFloat width = getTextSize([UIFont systemFontOfSize:FONT_SIZE], textView.text, MAXFLOAT).width;
		WBTokenButton *tokenButton = self.tokenButtonArray.lastObject;
		CGFloat right = tokenButton == nil ? LEFT_TITLE_WIDTH : tokenButton.frame.size.width + tokenButton.frame.origin.x;
		CGFloat top = tokenButton.frame.size.height + tokenButton.frame.origin.y;
		CGFloat superViewWidth = self.superview.frame.size.width;
		if (width >= superViewWidth - right - 20) {
			if (tokenButton == nil) {
				textView.textContainerInset = UIEdgeInsetsMake(TEXT_CONTAINER_INSET, LEFT_TITLE_WIDTH, 0, rightInset);
			} else {
				textView.textContainerInset = UIEdgeInsetsMake(top, 5, 0, rightInset);
			}
		}
	} else if (lastTokenButton != nil) {
		WBTokenButton *lastButton = self.tokenButtonArray.lastObject;
		CGFloat top = lastButton.frame.origin.y;
		CGFloat left = lastButton.frame.origin.x + lastButton.frame.size.width;
		
		textView.textContainerInset = UIEdgeInsetsMake(10 + top, left, 0, 0);
	} else {
		textView.textContainerInset = UIEdgeInsetsMake(TEXT_CONTAINER_INSET, LEFT_TITLE_WIDTH, 0, rightInset);
	}
}

@end
