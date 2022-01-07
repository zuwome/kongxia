//
//  ZZOrderCheckWeChatCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/1/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class ZZOrderCheckWeChatCell;

@protocol ZZOrderCheckWeChatCellDelegate <NSObject>

- (void)selectService:(ZZOrderCheckWeChatCell *)cell;

@end

@interface ZZOrderCheckWeChatCell : ZZTableViewCell

@property (nonatomic,   weak) id<ZZOrderCheckWeChatCellDelegate> delegate;

- (void)checkWechat:(BOOL)check price:(double)price;

@end

NS_ASSUME_NONNULL_END
