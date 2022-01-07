//
//  ZZChatBoxEmojiView.m
//  zuwome
//
//  Created by angBiu on 16/10/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBoxEmojiView.h"


#import <RongIMKit/RongIMKit.h>

@interface ZZChatBoxEmojiView ()

@property (nonatomic, strong) ZZChatBoxEmojiTypeView *typeView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *seconButton;

@end

@implementation ZZChatBoxEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.typeView];
        
        [self addSubview:self.sendBtn];
        
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height - 35, 50, 35)];
        _leftBtn.backgroundColor = HEXCOLOR(0xF8F8F8);
        [_leftBtn setTitle:@"😃" forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(expressions:) forControlEvents:UIControlEventTouchUpInside];
    
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_leftBtn];
        
        _seconButton = [[UIButton alloc] initWithFrame:CGRectMake(50, self.height - 35, 50, 35)];
        _seconButton.backgroundColor = [UIColor whiteColor];
        [_seconButton addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
        [_seconButton setImage:[UIImage imageNamed:@"emoji_collect"] forState:UIControlStateNormal];
        [self addSubview:_seconButton];

        
    }
    
    return self;
}
#pragma mark - 普通表情的点击事件
- (void)expressions:(UIButton *)sender {
    _leftBtn.backgroundColor = HEXCOLOR(0xF8F8F8);
    _seconButton.backgroundColor = [UIColor whiteColor];
    [self.typeView  selectIndex:0];
    _sendBtn.hidden = NO;
}

#pragma mark - Gif的面板
- (void)collectClick:(UIButton *)sender {
    _seconButton.backgroundColor = HEXCOLOR(0xF8F8F8);
     _leftBtn.backgroundColor = [UIColor whiteColor];

    [self.typeView  selectIndex:1];
    _sendBtn.hidden = YES;
}
#pragma mark - UIButtonMethod

- (void)sendBtnClick
{
    if (_touchSend) {
        _touchSend();
    }
}

#pragma mark - Lazyload

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, self.height - 35, 50, 35)];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateDisabled];
        [_sendBtn setTitleColor:kGrayTextColor forState:UIControlStateDisabled];
        _sendBtn.backgroundColor = HEXCOLOR(0xF8F8F8);
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sendBtn.enabled = NO;
        [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sendBtn;
}

- (ZZChatBoxEmojiTypeView *)typeView
{
    if (!_typeView) {
        _typeView = [[ZZChatBoxEmojiTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height - 35)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Emoji.plist" ofType:nil];
        _typeView.emotions = [NSArray arrayWithContentsOfFile:path];
        [_typeView selectIndex:0];
        WeakSelf;
        _typeView.touchDelete = ^{
            if (weakSelf.touchDelete) {
                weakSelf.touchDelete();
            }
        };
        _typeView.touchEmoji = ^(NSString *emoji){
            if (weakSelf.touchEmoji) {
                weakSelf.touchEmoji(emoji);
            }
        };
        ZZGifMessageModel *model = [[ZZGifMessageModel alloc]init];
        model.type = @"game";
        model.messageDigest = @"[动画表情]";
        model.localPath = @"emojiGifMora";
        model.allResultsCount = 3;
        model.gifWidth = 120;
        model.gifHeight = 120;
        ZZGifMessageModel *model2 = [[ZZGifMessageModel alloc]init];
        model2.type = @"game";
        model2.messageDigest = @"[动画表情]";
        model2.localPath = @"emojiGifSieve";
        model2.allResultsCount = 6;

        model2.gifWidth = 120;
        model2.gifHeight = 120;
        _typeView.gifArray = @[model,model2];
        
        
        _typeView.changeSelectScroller = ^(NSInteger index) {

            [weakSelf.typeView  selectIndex:index];
            switch (index) {
                case 0:
                {
                    weakSelf.leftBtn.backgroundColor = HEXCOLOR(0xF8F8F8);
                    weakSelf.seconButton.backgroundColor = [UIColor whiteColor];
                    weakSelf.sendBtn.hidden = NO;
                }
                    break;
                    
                default:
                {
                    weakSelf.seconButton.backgroundColor = HEXCOLOR(0xF8F8F8);
                    weakSelf.leftBtn.backgroundColor = [UIColor whiteColor];
                    weakSelf.sendBtn.hidden = YES;
                }
                    break;
            };
          
        };
        
        
        _typeView.sendMessage = ^(ZZGifMessageModel *model) {
            if (weakSelf.sendMessage) {
                weakSelf.sendMessage(model);
            }
        };
    }
    
    return _typeView;
}

@end
