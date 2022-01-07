//
//  ZZChatBoxView.h
//  zuwome
//
//  Created by angBiu on 16/10/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChatHelper.h"
#import "ZZChatBoxTopView.h"
#import "ZZChatBoxEmojiView.h"
#import "ZZChatBoxRecordView.h"
#import "ZZChatBoxRecordStatusView.h"
#import "ZZChatBoxGreetingView.h"
#import "ZZChatBoxMoreActionView.h"
#import "ZZChatGiftTipsView.h"

@class ZZChatBoxView;

@protocol ZZChatBoxViewDelegate <NSObject>

- (void)chatView:(ZZChatBoxView *)boxView heightChanged:(CGFloat)height toBottom:(BOOL)toBottom;

- (void)chatView:(ZZChatBoxView *)boxView sendTextMessage:(NSString *)messageStr;

- (void)chatView:(ZZChatBoxView *)boxView sendVoiceMessage:(NSData *)voiceData during:(long)during;

- (void)voiceDidStartRecording;

- (void)voiceDidEndRecording;

- (void)chatView:(ZZChatBoxView *)boxView selectedType:(ChatBoxType)selectedType;

- (void)startRecordVoiceShouldChangeHeight:(ZZChatBoxView *)boxView;

- (void)endRecordVoiceShouldChangeHeight:(ZZChatBoxView *)boxView;

@end
/**
 *  聊天 ---- 工具栏
 */
@interface ZZChatBoxView : UIView <ZZChatBoxTopViewDelegate>
@property (nonatomic, copy) void(^sendMessage)(ZZGifMessageModel *model);

@property (nonatomic, strong) ZZChatBoxTopView *topView;

@property (nonatomic,   copy) ZZChatBoxMoreActionView *actionView;

@property (nonatomic, strong) ZZChatBoxEmojiView *emojiView;

@property (nonatomic, strong) ZZChatBoxRecordView *recordView;

@property (nonatomic, strong) ZZChatBoxRecordStatusView *recordStatusView;

@property (nonatomic, strong) ZZChatBoxGreetingView *greetingView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) BOOL viewDisappear;

@property (nonatomic, weak) id<ZZChatBoxViewDelegate>delegate;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) BOOL isMessageBox;

@property (nonatomic, assign) BOOL isBurnAfterRead;

@property (nonatomic, assign) BOOL canMakeVideoCall;

@property (nonatomic, assign) BOOL canMakeVoiceCall;

@property (nonatomic, strong) ZZChatStatusModel *statusModel;

- (void)endEditing;

- (void)changeChatToolHeightWithDraftHeight:(CGFloat)height;

- (void)hideActionsView;

- (void)showGiftTipView;

- (void)hideGiftTipView;

@end
