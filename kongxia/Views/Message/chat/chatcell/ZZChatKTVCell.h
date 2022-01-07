//
//  ZZChatKTVCell.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/16.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZChatBaseCell.h"

@class ZZChatKTVCell;
@class ZZChatKTVModel;
@protocol ZZChatKTVCellDelegate <NSObject>

- (void)cell:(ZZChatKTVCell *)cell playSong:(ZZChatKTVModel *)ktvModel;

@end

@interface ZZChatKTVCell : ZZChatBaseCell

@property (nonatomic, weak) id<ZZChatKTVCellDelegate> delegate;

@end

