//
//  ZZChatBoxEmojiTypeView.h
//  zuwome
//
//  Created by angBiu on 2016/11/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZGifMessageModel.h"

/**
 *  表情类型
 */
typedef NS_ENUM(NSUInteger, ZZChatInputExpandEmojiType) {
    /**
     *  简单表情
     */
    ZZChatInputExpandEmojiTypeSimple = 0,
    /**
     *  GIF表情
     */
    ZZChatInputExpandEmojiTypeGIF = 1,
    /**
     *  收藏的表情
     */
    ZZChatInputExpandEmojiTypeMyFavorit = 2,
    
};
/**
 *  聊天 ---- 表情 一个表情类别view
 */
@interface ZZChatBoxEmojiTypeView : UIView

@property (nonatomic, strong) NSArray *emotions;
@property (nonatomic,assign) ZZChatInputExpandEmojiType emojiType;
@property (nonatomic, copy) void(^sendMessage)(ZZGifMessageModel *model);
@property (nonatomic,strong) NSArray *gifArray;
@property (nonatomic, copy) dispatch_block_t touchDelete;
@property (nonatomic, copy) void(^changeSelectScroller)(NSInteger index);

@property (nonatomic, copy) void(^touchEmoji)(NSString *emoji);
- (void)selectIndex:(NSInteger )index;
@end
