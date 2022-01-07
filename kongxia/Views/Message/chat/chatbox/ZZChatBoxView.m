//
//  ZZChatBoxView.m
//  zuwome
//
//  Created by angBiu on 16/10/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBoxView.h"

@interface ZZChatBoxView () <ZZChatBoxRecordViewDelegate, ZZChatBoxMoreActionViewDelegate>

@property (nonatomic, strong) NSString *recordName;//录音文件名
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL chatBoxEmojiview;//是否是表情键盘

@property (nonatomic, assign) ChatBoxStatus currentAction;

@property (nonatomic, strong) ZZChatGiftTipsView *giftTipsView;

@end

@implementation ZZChatBoxView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _canMakeVideoCall = YES;
        _canMakeVoiceCall = YES;
        [self layout];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, myPoint)) {
                [self showGiftsView];
                return self;
            }
        }
    }
    return view;
}

- (void)changeChatToolHeightWithDraftHeight:(CGFloat)height {
    CGFloat currentHeight = height  + 16;
    if (self.isMessageBox) {
        if (currentHeight + 16 < 50) {
            currentHeight = 50;
        }
        else {
            currentHeight = currentHeight + 16;
        }
    }
    [self.topView.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    self.topView.height = currentHeight ;
    CGFloat offset = self.height - CHATBOX_CONTENT_HEIGHT - currentHeight;
    self.height = CHATBOX_CONTENT_HEIGHT + currentHeight;
    self.top = self.top + offset;
    [self viewHeightChanged:YES];
}

- (void)typeChange:(ChatBoxType)type {
    if (_delegate && [_delegate respondsToSelector:@selector(chatView:selectedType:)]) {
        [_delegate chatView:self selectedType:type];
    }
}

- (void)timerEvent {
    _count++;
    if (_count >= 6000) {
        _count = 6000;
        [self.recordView endAnimation];
        [self recordViewDidEndRecord];
    }
    self.recordStatusView.duration = _count/100;
    self.recordView.progress = _count/6000.0;
}

#pragma mark - public Method
- (void)endEditing {
    if (self.top != SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - self.topView.height - SafeAreaBottomHeight ) {
        [self changeBottomViewsActionsStatue:ChatBoxStatusNormal];
        if (self.topView.greetingBtn.selected) {
            self.topView.greetingBtn.selected = NO;
            [self.topView statusChanged];
        }
        if ([_topView.textView isFirstResponder]) {
            [_topView.textView resignFirstResponder];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.top = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - self.topView.height - SafeAreaBottomHeight;
            [self viewHeightChanged:YES];
        }];
    }
}

- (void)hideActionsView {
    [self changeBottomViewsActionsStatue:ChatBoxStatusNormal];
}

- (void)showGiftTipView {
    if (!_giftTipsView) {
        _giftTipsView = [[ZZChatGiftTipsView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 57,  -100.0, 114, 44)];
        [self addSubview:_giftTipsView];
    }
}

- (void)hideGiftTipView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_giftTipsView) {
            return;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            _giftTipsView.top = 10.0;
        } completion:^(BOOL finished) {
            [_giftTipsView removeFromSuperview];
            _giftTipsView = nil;
        }];
    });
}

#pragma mark - private method
- (void)changeBottomViewsActionsStatue:(ChatBoxStatus)status {
    UIView *view = nil;
    if (status == ChatBoxStatusShowMore) {
        if (!_actionView) {
            [_bottomView addSubview:self.actionView];
        }
        view = _actionView;
    }
    else if (status == ChatBoxStatusShowGreeting) {
        if (!_greetingView) {
            [_bottomView addSubview:self.greetingView];
        }
        view = _greetingView;
    }
    else if (status == ChatBoxStatusShowEmoji) {
        if (!_emojiView) {
            [_bottomView addSubview:self.emojiView];
        }
        view = _emojiView;
    }
    else if (status == ChatBoxStatusShowRecord) {
        if (!_recordView) {
            [_bottomView addSubview:self.recordView];
        }
        view = _recordView;
    }
    else if (status == ChatBoxStatusRedPacket) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatView:selectedType:)]) {
            [_delegate chatView:self selectedType:ChatBoxTypePacket];
        }
        return;
    }
    else if (status == ChatBoxStatusGift) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatView:selectedType:)]) {
            [_delegate chatView:self selectedType:ChatBoxTypeGift];
        }
        return;
    }
    
    UIView *currentView = nil;
    if (_currentAction == ChatBoxStatusShowMore) {
        currentView = _actionView;
    }
    else if (_currentAction == ChatBoxStatusShowEmoji) {
        currentView = _emojiView;
    }
    else if (_currentAction == ChatBoxStatusShowGreeting) {
        currentView = _greetingView;
    }
    else if (_currentAction == ChatBoxStatusShowRecord) {
        currentView = _recordView;
    }
    
    if (_currentAction == status || status == ChatBoxStatusBurn || status == ChatBoxStatusNormal) {
        if (status == ChatBoxStatusBurn) {
            _currentAction = status;
        }
        else {
            _currentAction = ChatBoxStatusNormal;
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            currentView.top = CHATBOX_CONTENT_HEIGHT;
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.top = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - _topView.height - SafeAreaBottomHeight;
            [self viewHeightChanged:YES];
        }];
    }
    else {
        [UIView animateWithDuration:0.1 animations:^{
            currentView.top = CHATBOX_CONTENT_HEIGHT;
            view.top = 0.0;
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.top = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - _topView.height - CHATBOX_CONTENT_HEIGHT - SafeAreaBottomHeight;
            [self viewHeightChanged:YES];
        }];
        _currentAction = status;
    }
}

- (void)showGiftsView {
    [self changeBottomViewsActionsStatue:ChatBoxStatusNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(chatView:selectedType:)]) {
        [_delegate chatView:self selectedType:ChatBoxTypeGift];
    }
}

#pragma mark - ZZChatBoxMoreActionViewDelegate
- (void)actionView:(ZZChatBoxMoreActionView *)view action:(ChatBoxType)boxType {
    switch (boxType) {
        case ChatBoxTypeRecord: {
            [self changeBottomViewsActionsStatue:ChatBoxStatusShowRecord];
            break;
        }
        case ChatBoxTypeBurn: {
            if (_statusModel.can_disappear_after_reading != 1) {
                [ZZHUD showInfoWithStatus:_statusModel.disappear_after_reading_error_msg];
                return;
            }
            _isBurnAfterRead = YES;
            _topView.isBurnAfterRead = YES;
            [_topView switchToBurnMode];
            [self changeBottomViewsActionsStatue:ChatBoxStatusBurn];
            break;
        }
        case ChatBoxTypeImage:
        case ChatBoxTypeShot:
        case ChatBoxTypePacket:
        case ChatBoxTypeVideo:
        case ChatBoxTypeLocation:
        case ChatBoxTypeGift: {
            if (_delegate && [_delegate respondsToSelector:@selector(chatView:selectedType:)]) {
                [self changeBottomViewsActionsStatue:ChatBoxStatusNormal];
                [_delegate chatView:self selectedType:boxType];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - ZZChatBoxTopViewDelegate
- (void)topView:(ZZChatBoxTopView *)topView showActionsStatue:(ChatBoxStatus)status {
    [self endEditing:YES];
    [self changeBottomViewsActionsStatue:status];
}

- (void)chatBoxTopView:(ZZChatBoxTopView *)topView status:(ChatBoxStatus)status lastStatus:(ChatBoxStatus)lastStatus {
    
}

- (void)didSendText {
    if (isNullString(_topView.textView.text)) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatView:sendTextMessage:)]) {
        [_delegate chatView:self sendTextMessage:_topView.textView.text];
        _topView.textView.text = @"";
        [_topView.textView textDidChange];
        CGFloat offset = self.height - CHATBOX_CONTENT_HEIGHT - _topView.height;
        self.height = CHATBOX_CONTENT_HEIGHT + _topView.height;
        self.top = self.top + offset;
        [self viewHeightChanged:NO];
        [self textValueChange];
    }
}

#pragma mark - ZZChatBoxRecordViewDelegate
- (void)recordViewDidBeginRecord {
    self.recordStatusView.hidden = NO;
    self.topView.hidden = YES;
    self.height = CHATBOX_CONTENT_HEIGHT + 44;
    self.top = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - self.height-SafeAreaBottomHeight;
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    self.recordName = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    
    [self.timer fire];
    [[ZZRecordManager shareManager] startRecordingWithFileName:self.recordName completion:^(NSError *error) {
        if (error) {   // 加了录音权限的判断
            [self responseEndRecord];
        }
        else {
            self.recordStatusView.duration = 0;
            self.recordView.progress = 0;
            if ([_delegate respondsToSelector:@selector(voiceDidStartRecording)]) {
                [_delegate voiceDidStartRecording];
            }
        }
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRecordVoiceShouldChangeHeight:)]) {
        [self.delegate startRecordVoiceShouldChangeHeight:self];
    }
}

- (void)recordViewDidEndRecord {
    WeakSelf;
    [[ZZRecordManager shareManager] stopRecordingWithCompletion:^(NSString *recordPath) {
        if ([recordPath isEqualToString:shortRecord]) {
            
        }
        else {    // send voice message
            NSData *data = [NSData dataWithContentsOfFile:recordPath];
            long during = [[ZZRecordManager shareManager] durationWithVideo:[NSURL fileURLWithPath:recordPath]];
            NSLog(@"record ====== %lu,   %ld",(unsigned long)data.length,during);
            if (_delegate && [_delegate respondsToSelector:@selector(chatView:sendVoiceMessage:during:)]) {
                [_delegate chatView:weakSelf sendVoiceMessage:data during:during];
            }
        }
        [weakSelf responseEndRecord];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(endRecordVoiceShouldChangeHeight:)]) {
        [self.delegate endRecordVoiceShouldChangeHeight:self];
    }
}

- (void)recordViewDidCancelRecord {
    [self responseEndRecord];
    if (self.delegate && [self.delegate respondsToSelector:@selector(endRecordVoiceShouldChangeHeight:)]) {
        [self.delegate endRecordVoiceShouldChangeHeight:self];
    }
}

- (void)recordView:(ZZChatBoxRecordView *)recordView insideView:(BOOL)inside {
    if (inside) {
        [self.recordStatusView insideStatus];
    }
    else {
        [self.recordStatusView outsideStatus];
    }
}

- (void)responseEndRecord {
    _count = 0;
    self.recordView.progress = 0;
    [self.timer invalidate];
    self.timer = nil;
    self.height = CHATBOX_CONTENT_HEIGHT + self.topView.height;
    self.top = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - self.height;
    self.topView.hidden = NO;
    self.recordStatusView.hidden = YES;
    
    [[ZZRecordManager shareManager] removeCurrentRecordFile:self.recordName];
    if (_delegate && [_delegate respondsToSelector:@selector(voiceDidEndRecording)]) {
        [_delegate voiceDidEndRecording];
    }
}

#pragma mark -
- (void)viewHeightChanged:(BOOL)toBottom {
    if (_delegate && [_delegate respondsToSelector:@selector(chatView:heightChanged:toBottom:)]) {
        [_delegate chatView:self heightChanged:(self.top) toBottom:toBottom];
    }
}

- (void)textValueChange {
    if (isNullString(_topView.textView.text)) {
        _emojiView.sendBtn.enabled = NO;
        _emojiView.sendBtn.backgroundColor = HEXCOLOR(0xF8F8F8);
    }
    else {
        _emojiView.sendBtn.enabled = YES;
        _emojiView.sendBtn.backgroundColor = HEXCOLOR(0x0099FE);
    }
}

#pragma mark - Layout
- (void)layout {
    WeakSelf;
    _topView = [[ZZChatBoxTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    _topView.delegate = self;
    _topView.typeChange = ^(ChatBoxType type) {
        [weakSelf typeChange:type];
    };
    [self addSubview:_topView];
    
    _topView.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
    _topView.layer.shadowOffset = CGSizeMake(0, -1);
    _topView.layer.shadowOpacity = 0.9;
    _topView.layer.shadowRadius = 1;
    
    _bottomView = [[UIView alloc] init];
    _bottomView.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.top.equalTo(_topView.mas_bottom);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineViewColor;
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(_bottomView.mas_top).offset(0.5);
        make.height.mas_equalTo(@0.5);
    }];
    
    _topView.textView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight) {
        CGFloat height = textHeight + 16;
        if (height > 54) {
            height = textHeight + 16;
        }
        weakSelf.topView.height = height ;
        [weakSelf.topView.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(textHeight));
        }];
        CGFloat offset = weakSelf.height - CHATBOX_CONTENT_HEIGHT - height;
        weakSelf.height = CHATBOX_CONTENT_HEIGHT + height;
        weakSelf.top = weakSelf.top + offset;
        [weakSelf viewHeightChanged:YES];
    };
    
    _topView.textValueChange = ^{
        [weakSelf textValueChange];
    };
}

#pragma mark - Lazyload
- (ZZChatBoxMoreActionView *)actionView {
    if (!_actionView) {
        _actionView = [[ZZChatBoxMoreActionView alloc] initWithFrame:CGRectMake(0.0, CHATBOX_CONTENT_HEIGHT, SCREEN_WIDTH, CHATBOX_CONTENT_HEIGHT)];
        _actionView.delegate = self;
        
        [_actionView canMakeVoiceCall:_canMakeVoiceCall];
        [_actionView canMakeVideoCall:_canMakeVideoCall];
    }
    return _actionView;
}

- (ZZChatBoxEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[ZZChatBoxEmojiView alloc] initWithFrame:CGRectMake(0, CHATBOX_CONTENT_HEIGHT, SCREEN_WIDTH, CHATBOX_CONTENT_HEIGHT)];
        WeakSelf;
        _emojiView.touchSend = ^{
            [weakSelf didSendText];
        };
        _emojiView.touchEmoji = ^(NSString *emoji) {
            [weakSelf.topView.textView insertText:emoji];
        };
        _emojiView.touchDelete = ^{
            [weakSelf.topView.textView deleteBackward];
        };
        _emojiView.sendMessage = ^(ZZGifMessageModel *model) {
            if (weakSelf.sendMessage) {
                weakSelf.sendMessage(model);
            }
        };
    }
    
    return _emojiView;
}
- (ZZChatBoxRecordView *)recordView {
    if (!_recordView) {
        _recordView = [[ZZChatBoxRecordView alloc] initWithFrame:CGRectMake(0, CHATBOX_CONTENT_HEIGHT, SCREEN_WIDTH, CHATBOX_CONTENT_HEIGHT)];
        _recordView.delegate = self;
    }
    return _recordView;
}

- (ZZChatBoxRecordStatusView *)recordStatusView {
    if (!_recordStatusView) {
        _recordStatusView = [[ZZChatBoxRecordStatusView alloc] init];
        [self addSubview:_recordStatusView];
        
        [_recordStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(_bottomView.mas_top);
            make.height.mas_equalTo(@44);
        }];
    }
    return _recordStatusView;
}

- (ZZChatBoxGreetingView *)greetingView {
    if (nil == _greetingView) {
        WeakSelf
        _greetingView = [[ZZChatBoxGreetingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CHATBOX_CONTENT_HEIGHT)];
        [_greetingView setSelectGreeting:^(NSString *greeting) {
            //选中常用语
            //1.切换到键盘输入
            //2.取消常用语选中状态
            weakSelf.topView.greetingBtn.selected = NO;
            weakSelf.topView.textView.text = @"";
            [weakSelf.topView.textView insertText:greeting];
            weakSelf.topView.status = ChatBoxStatusShowKeyboard;
            [weakSelf.topView statusChanged];
        }];
        [_greetingView setSendGreeting:^(NSString *greeting) {
            weakSelf.topView.textView.text = @"";
            [weakSelf.topView.textView insertText:greeting];
            [weakSelf didSendText];
        }];
    }
    return _greetingView;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [ZZWeakTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)setIsMessageBox:(BOOL)isMessageBox {
    _isMessageBox = isMessageBox;
    if (_isMessageBox) {
        [self.topView switchToMessageBoxMode];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
