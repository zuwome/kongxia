//
//  ZZChatGiftCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZChatBaseCell.h"
@class ZZChatGiftCell;
@class ZZChatGiftModel;
@protocol ZZChatGiftCellDelegate <NSObject>

- (void)cell:(ZZChatGiftCell *)cell didSelectGift:(ZZChatGiftModel *)giftModel;

@end

@interface ZZChatGiftCell : ZZChatBaseCell

@property (nonatomic, weak) id<ZZChatGiftCellDelegate> delegate;

@end

