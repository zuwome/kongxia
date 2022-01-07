//
//  ZZChatBoxMoreActionView.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChatHelper.h"

@class ZZChatBoxMoreActionView;

@protocol ZZChatBoxMoreActionViewDelegate <NSObject>

- (void)actionView:(ZZChatBoxMoreActionView *)view action:(ChatBoxType)boxType;

@end

@interface ZZChatBoxMoreActionView : UIView

@property (nonatomic, weak) id<ZZChatBoxMoreActionViewDelegate> delegate;

- (void)canMakeVoiceCall:(BOOL)canMakeVoiceCall;

- (void)canMakeVideoCall:(BOOL)canMakeVideoCall;

@end

