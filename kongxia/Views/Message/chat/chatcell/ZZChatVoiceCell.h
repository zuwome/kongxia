//
//  ZZChatVoiceCell.h
//  zuwome
//
//  Created by angBiu on 16/10/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBaseCell.h"
/**
 *  聊天 ---- 语音
 */
@interface ZZChatVoiceCell : ZZChatBaseCell

@property (nonatomic, strong) UIImageView *voiceImgView;
@property (nonatomic, strong) UILabel *durationLabel;

- (void)voiceClick;

@end
