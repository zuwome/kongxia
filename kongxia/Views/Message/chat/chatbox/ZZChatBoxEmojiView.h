//
//  ZZChatBoxEmojiView.h
//  zuwome
//
//  Created by angBiu on 16/10/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChatBoxEmojiTypeView.h"

/**
 *  聊天 ---- 工具栏 --- 表情
 */
@interface ZZChatBoxEmojiView : UIView

@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, copy) dispatch_block_t touchSend;
@property (nonatomic, copy) dispatch_block_t touchDelete;
@property (nonatomic, copy) void(^touchEmoji)(NSString *emoji);
@property (nonatomic, copy) void(^sendMessage)(ZZGifMessageModel *model);

@end
