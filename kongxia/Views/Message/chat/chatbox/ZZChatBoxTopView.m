//
//  ZZChatBoxTopView.m
//  zuwome
//
//  Created by angBiu on 16/10/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBoxTopView.h"
#import "ZZChatBoxTypeCell.h"
#import "ZZCollectionConstantSpaceLayout.h"
#import "ZZUserOnlineStateManage.h"
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>

@interface ZZChatBoxTopView ()

@property (nonatomic, strong) FLAnimatedImageView *earnedCoineGifImageView;

@end

@implementation ZZChatBoxTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
        self.isBurnAfterRead = NO;
        _status = ChatBoxStatusNormal;
        _lastStatus = ChatBoxStatusNormal;

    }
    return self;
}

#pragma mark - public Method
- (void)showGiftAnimations {
    if (!_earnedCoineGifImageView) {
        _earnedCoineGifImageView = [[FLAnimatedImageView alloc] init];
        NSURL *gifLocalUrl = [[NSBundle mainBundle] URLForResource:@"GiftAni" withExtension:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfURL:gifLocalUrl];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
        _earnedCoineGifImageView.animatedImage = image;
        _earnedCoineGifImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImmediately)];
        [_earnedCoineGifImageView addGestureRecognizer:tap];
        
        [self addSubview:_earnedCoineGifImageView];
        _earnedCoineGifImageView.frame = _giftBtn.frame;
    }

    _giftBtn.hidden = YES;
    [_earnedCoineGifImageView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _giftBtn.hidden = NO;
        [_earnedCoineGifImageView stopAnimating];
        [_earnedCoineGifImageView removeFromSuperview];
        _earnedCoineGifImageView = nil;
    });
}


- (void)switchToBurnMode {
    _isBurnAfterRead = YES;
    _status = ChatBoxStatusBurn;
    _textView.placeholderColor = RGBCOLOR(255, 119, 70);
    _moreBtn.normalImage = [UIImage imageNamed:@"icGuanbiYhjf"];
    _emojiBtn.normalImage = [UIImage imageNamed:@"icTupianYhjf"];
}

- (void)switchToMessageBoxMode {
    _moreBtn.hidden = YES;
    [_greetingBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
    }];
}

- (void)normalType {
    if (_moreBtn.isHidden) {
        _moreBtn.hidden = NO;
        _emojiBtn.frame = CGRectMake(_moreBtn.left - 12.0 - 22.0, self.height * 0.5 - 22.0 * 0.5, 22.0, 22.0);
    }
    
    _status = ChatBoxStatusNormal;
    [_textView textDidChange];
    [self statusChanged];
}

- (void)swtcihToNormalMode {
    dispatch_async(dispatch_get_main_queue(), ^{
        _status = ChatBoxStatusNormal;
        _textView.placeholderColor = HEXCOLOR(0xC4C4C4);
        _moreBtn.normalImage = [UIImage imageNamed:@"icTianjia"];
        _moreBtn.selectedImage = [UIImage imageNamed:@"icTianjia"];
        _emojiBtn.normalImage = [UIImage imageNamed:@"icBiaoqing"];
    });
}

#pragma mark - response method
- (void)showMore {
    if (_isBurnAfterRead) {
        _isBurnAfterRead = NO;
        [self swtcihToNormalMode];
        return;
    }
    
    if (_isMessageBox) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(topView:showActionsStatue:)]) {
               [self.delegate topView:self showActionsStatue:ChatBoxStatusGift];
        }
        return;
    }
    
    if (_status == ChatBoxStatusShowMore) {
        _status = ChatBoxStatusNormal;
        [_textView textDidChange];
    }
    else {
        _status = ChatBoxStatusShowMore;
        _selectedType = ChatBoxTypeEmoji;
        self.greetingBtn.selected = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(topView:showActionsStatue:)]) {
        [self.delegate topView:self showActionsStatue:ChatBoxStatusShowMore];
    }
}

- (void)showEmoji {
    if (_status == ChatBoxStatusBurn) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(topView:showActionsStatue:)]) {
            [self.delegate topView:self showActionsStatue:ChatBoxStatusShowEmoji];
        }
        return;
    }
    
    if (_status == ChatBoxStatusShowEmoji) {
        _status = ChatBoxStatusNormal;
        [_textView textDidChange];
        _emojiBtn.selected = NO;
    }
    else {
        _status = ChatBoxStatusShowEmoji;
        _selectedType = ChatBoxTypeEmoji;
        _emojiBtn.selected = YES;
        self.greetingBtn.selected = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topView:showActionsStatue:)]) {
        [self.delegate topView:self showActionsStatue:ChatBoxStatusShowEmoji];
    }
    
}

- (void)showGreetings {
    if (_status == ChatBoxStatusShowGreeting) {
        _status = ChatBoxStatusNormal;
        [_textView textDidChange];
        self.greetingBtn.selected = NO;
    }
    else {
        _status = ChatBoxStatusShowGreeting;
        _selectedType = ChatBoxTypeGreeting;
        self.greetingBtn.selected = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topView:showActionsStatue:)]) {
        [self.delegate topView:self showActionsStatue:ChatBoxStatusShowGreeting];
    }
}

- (void)showGift {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topView:showActionsStatue:)]) {
        [self.delegate topView:self showActionsStatue:ChatBoxStatusGift];
    }
}

- (void)showImmediately {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topView:showActionsStatue:)]) {
        [self.delegate topView:self showActionsStatue:ChatBoxStatusGift];
    }
}

- (void)setStatusModel:(ZZChatStatusModel *)statusModel {
    _statusModel = statusModel;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (_textValueChange) {
        _textValueChange();
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
        self.emojiBtn.selected = NO;
        _status = ChatBoxStatusShowKeyboard;
        _selectedType = 0;
        //点击输入框同时将常用语置为未选中状态
        self.greetingBtn.selected = NO;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _status = ChatBoxStatusShowKeyboard;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(didSendText)]) {
            [_delegate didSendText];
        }
        return NO;
    }
    return YES;
}

- (void)statusChanged {
    if (_status == ChatBoxStatusShowKeyboard) {
        [_textView becomeFirstResponder];
    }
    else {
        [_textView resignFirstResponder];
        _status = ChatBoxStatusNormal;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxTopView:status:lastStatus:)]) {
        [_delegate chatBoxTopView:self status:_status lastStatus:_lastStatus];
    }
    _lastStatus = _status;
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = HEXCOLOR(0xF8F8F8);
    
    _inputView = [[UIView alloc] init];
    _inputView.backgroundColor = UIColor.whiteColor;
    _inputView.layer.cornerRadius = 3.0;
    
    [self addSubview:_inputView];
    
    [self addSubview:self.giftBtn];
    [self addSubview:self.greetingBtn];
    [self addSubview:self.moreBtn];
    [_inputView addSubview:self.emojiBtn];
    [_inputView addSubview:self.textView];
    
    
    [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_inputView);
        make.left.equalTo(self).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_inputView);
        make.right.equalTo(self).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_greetingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_inputView);
        make.right.equalTo(_moreBtn.mas_left).offset(-15);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(@36);
        make.left.equalTo(_giftBtn.mas_right).offset(9);
        make.right.equalTo(_greetingBtn.mas_left).offset(-9);
    }];
    
    [_emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_inputView);
        make.right.equalTo(_inputView).offset(-7);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.bottom.left.equalTo(_inputView);
        make.right.equalTo(_emojiBtn.mas_left).offset(-7.0);
    }];
}



#pragma mark - lazyload
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.normalImage = [UIImage imageNamed:@"icTianjia"];
        [_moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIButton *)emojiBtn {
    if (!_emojiBtn) {
        _emojiBtn = [[UIButton alloc] init];
        [_emojiBtn setImage:[UIImage imageNamed:@"icBiaoqing"] forState:UIControlStateNormal];
        [_emojiBtn setImage:[UIImage imageNamed:@"icBiaoqingXuanzhong"] forState:UIControlStateSelected];
        [_emojiBtn addTarget:self action:@selector(showEmoji) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiBtn;
}

- (NSMutableArray *)normalArray
{
    if (!_normalArray) {
        _normalArray = [NSMutableArray arrayWithArray:@[@(ChatBoxTypeRecord),@(ChatBoxTypeImage),@(ChatBoxTypeVideo),@(ChatBoxTypePacket),@(ChatBoxTypeLocation),@(ChatBoxTypeEmoji),@(ChatBoxTypeBurn)]];
    }
    return _normalArray;
}

- (UIButton *)greetingBtn {
    if (nil == _greetingBtn) {
        _greetingBtn = [[UIButton alloc] init];
        [_greetingBtn setImage:[UIImage imageNamed:@"icJianpan"] forState:(UIControlStateSelected)];
        [_greetingBtn setImage:[UIImage imageNamed:@"icChangyongyu"] forState:(UIControlStateNormal)];
        [_greetingBtn addTarget:self action:@selector(showGreetings) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _greetingBtn;
}

- (UIButton *)giftBtn {
    if (!_giftBtn) {
        _giftBtn = [[UIButton alloc] init];
        [_giftBtn setImage:[UIImage imageNamed:@"icLiwu_keyBoard"] forState:UIControlStateNormal];
        [_giftBtn addTarget:self
                     action:@selector(showGift)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftBtn;
}

- (YZInputView *)textView {
    if (!_textView) {
        _textView = [[YZInputView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES;//设置没内容不可发送
        _textView.maxNumberOfLines = 2;
        _textView.layer.borderWidth = 0.0;
        _textView.placeholder = @"请输入消息...";
        _textView.backgroundColor = [UIColor whiteColor];
    }
    return _textView;
}
@end
