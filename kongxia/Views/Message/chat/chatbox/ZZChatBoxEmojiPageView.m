//
//  ZZChatBoxEmojiPageView.m
//  zuwome
//
//  Created by angBiu on 2016/11/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBoxEmojiPageView.h"

#import "ZZChatHelper.h"

@interface ZZChatBoxEmojiPageView ()

@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation ZZChatBoxEmojiPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.deleteBtn];
    }
    
    return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    NSUInteger count = emotions.count;
    for (int i = 0; i < count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        [self addSubview:button];
        [button setTitle:emotions[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:32];
        [button addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnWidth = 50;
    NSInteger column = SCREEN_WIDTH / btnWidth;
    CGFloat space = (SCREEN_WIDTH - column*btnWidth)/2;
    NSUInteger count = self.emotions.count;
    CGFloat btnH = (self.height - 2*space)/3;
    for (int i = 0; i < count; i ++) {
        UIButton *btn = self.subviews[i + 1];//因为已经加了一个deleteBtn了
        btn.frame = CGRectMake(space + (i % column)*btnWidth, space + (i/column)*btnH, btnWidth, btnH);
    }
    
    self.deleteBtn.frame = CGRectMake(space + (count % column)*btnWidth, space + (count/column)*btnH, btnWidth, btnH);
}

#pragma mark - UIButtonMethod

- (void)emojiBtnClick:(UIButton *)sender
{
    if (_touchEmoji) {
        _touchEmoji(sender.titleLabel.text);
    }
}

- (void)deleteBtnClick
{
    if (_touchDelete) {
        _touchDelete();
    }
}

#pragma mark - lazyload

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:IMAGENAME(@"emoji_btn_delete@2x") forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _deleteBtn;
}

@end
