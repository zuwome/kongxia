//
//  WBTokenButton.m
//  Whistle
//
//  Created by SharkCome on 9/11/15.
//  Copyright (c) 2015 BookSir. All rights reserved.
//

#import "Masonry.h"
#import "WBTokenButton.h"

#define DELETE_BUTTON_RADIU     (10)

@interface WBTokenButton ()

@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation WBTokenButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.isEditable = NO;
    self.contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.contentButton];
    [self addSubview:self.deleteButton];
    
    self.contentButton.layer.masksToBounds = YES;
    self.contentButton.layer.cornerRadius = 4.0f;
    self.contentButton.layer.borderWidth = 0.5f;
    self.contentButton.layer.borderColor = RGBCOLOR(63, 58, 58).CGColor;
    
    //Button中titleLabel的偏移
    [self.contentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 9, 0, 9)];
    //Normal
    [self.contentButton setTitleColor:kBlackColor forState:UIControlStateNormal];
//    [self.contentButton setBackgroundImage:stretchImgFromMiddle([UIImage imageNamed:@"SearchKey"]) forState:UIControlStateNormal];
    //Selected
    self.contentButton.backgroundColor = [UIColor whiteColor];
    
    [self.contentButton setTitleColor:kBlackColor forState:UIControlStateSelected];
//    [self.contentButton setBackgroundImage:stretchImgFromMiddle([UIImage imageNamed:@"SearchKey_HL"]) forState:UIControlStateSelected];
    //Highlight
//    [self.contentButton setTitleColor:COMMON_FONT_BLACK forState:UIControlStateHighlighted];
//    [self.contentButton setBackgroundImage:stretchImgFromMiddle([UIImage imageNamed:@"SearchKey_HL"]) forState:UIControlStateHighlighted];
    [self.contentButton addTarget:self action:@selector(defaultTouchAction) forControlEvents:UIControlEventTouchUpInside];

    [self.deleteButton setImage:[UIImage imageNamed:@"MailDeleteSender"] forState:UIControlStateNormal];
    self.deleteButton.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
	if (!self.isEditable) {
		self.contentButton.frame = CGRectMake(0, DELETE_BUTTON_RADIU, self.width, self.height - DELETE_BUTTON_RADIU);
	} else {
		self.contentButton.frame = CGRectMake(0, DELETE_BUTTON_RADIU, self.width - DELETE_BUTTON_RADIU, self.height - DELETE_BUTTON_RADIU);
		self.deleteButton.frame = CGRectMake(self.width - DELETE_BUTTON_RADIU * 2, 2, DELETE_BUTTON_RADIU * 2, DELETE_BUTTON_RADIU * 2);
	}
    self.deleteButton.hidden = !self.isEditable;
}

#pragma mark - Setter & Getter

- (void)setContentFont:(UIFont *)contentFont {
    _contentFont = contentFont;

    self.contentButton.titleLabel.font = contentFont;
    [self setNeedsLayout];
}

- (void)setContentTitle:(NSString *)contentTitle {
    _contentTitle = contentTitle;

    [self.contentButton setTitle:contentTitle forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (CGSize)preferredSize {
//    DKAssert(self.contentTitle.length);
	CGSize size = [self.contentButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
	size.width += self.contentButton.titleEdgeInsets.left + self.contentButton.titleEdgeInsets.right;
	size.height += DELETE_BUTTON_RADIU;
	
	if (self.isEditable) {
		size.width += DELETE_BUTTON_RADIU;
	}
	return size;
}

- (void)setSelected:(BOOL)selected {
    self.contentButton.selected = selected;
    
    self.contentButton.backgroundColor = selected ? RGBCOLOR(244, 203, 7) : [UIColor whiteColor];
}

#pragma mark - Public Mehtods

- (void)deleteButtonTarget:(id)target action:(SEL)action {
    [self.deleteButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addContentTarget:(id)target action:(SEL)action {
    [self.contentButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Private Methods

- (void)defaultTouchAction {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
