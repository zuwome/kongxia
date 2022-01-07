//
//  ZZChatBoxEmojiPageView.h
//  zuwome
//
//  Created by angBiu on 2016/11/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  聊天  ---- 表情 翻滚的每一页view
 */
@interface ZZChatBoxEmojiPageView : UIView

@property (nonatomic, strong) NSArray *emotions;
@property (nonatomic, copy) dispatch_block_t touchDelete;
@property (nonatomic, copy) void(^touchEmoji)(NSString *emoji);

@end
