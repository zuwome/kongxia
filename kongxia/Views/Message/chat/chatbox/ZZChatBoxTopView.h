//
//  ZZChatBoxTopView.h
//  zuwome
//
//  Created by angBiu on 16/10/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZChatBoxTopView;
#import "ZZChatHelper.h"
#import "YZInputView.h"
#import "ZZChatStatusModel.h"
#import "ZZChatBurnVersionView.h"
#import "ZZChatBurnAttentView.h"
#import <Lottie/Lottie.h>

@protocol ZZChatBoxTopViewDelegate <NSObject>
/**
 *  输入栏目选择变化
 *
 *  @param topView    <#topView description#>
 *  @param status     当前状态
 *  @param lastStatus 上一次显示的状态
 */
- (void)chatBoxTopView:(ZZChatBoxTopView *)topView status:(ChatBoxStatus)status lastStatus:(ChatBoxStatus)lastStatus;

- (void)topView:(ZZChatBoxTopView *)topView showActionsStatue:(ChatBoxStatus)status;

/**
 *  键盘的return发送事件
 */
- (void)didSendText;

@end

/**
 *  聊天 ---- 工具栏 顶部输入框
 */
@interface ZZChatBoxTopView : UIView <UITextViewDelegate>
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) YZInputView *textView;//输入框
@property (nonatomic, strong) UIButton *emojiBtn;//消息盒子时得表情
@property (nonatomic, strong) UIButton *greetingBtn;//常用语按钮
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *giftBtn;
@property (nonatomic, assign) CGFloat viewHeight;//view 高度
@property (nonatomic, copy) dispatch_block_t textValueChange;
@property (nonatomic, assign) ChatBoxStatus status;//状态
@property (nonatomic, assign) ChatBoxStatus lastStatus;
@property (nonatomic, assign) BOOL isMessageBox;//消息盒子
@property (nonatomic, assign) BOOL isBurnAfterRead;//阅后即焚
@property (nonatomic, strong) ZZChatStatusModel *statusModel;
@property (nonatomic, strong) NSMutableArray *normalArray;//正常状态的功能按钮

@property (nonatomic, strong) ZZChatBurnVersionView *versionView;//版本原因不能阅后即焚
@property (nonatomic, strong) ZZChatBurnAttentView *attentView;//没有互相关注原因不能阅后即焚
@property (nonatomic, assign) ChatBoxType selectedType;
@property (nonatomic, weak) id<ZZChatBoxTopViewDelegate>delegate;
@property (nonatomic, copy) void(^typeChange)(ChatBoxType type);
@property (nonatomic, copy) NSString *uid;

- (void)statusChanged;

/*
 切换到阅后即焚模式
 */
- (void)switchToBurnMode;

- (void)switchToMessageBoxMode;

- (void)swtcihToNormalMode;

- (void)showGiftAnimations;

@end


@interface ZZChatBoxTopGiftView:  LOTAnimationView


@end
