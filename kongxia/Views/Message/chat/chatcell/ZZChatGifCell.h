//
//  ZZChatGifCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/4/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChatBaseCell.h"
#import "ZZCustomChatImage.h"

/**
 用于展示Gif的cell
 */
@interface ZZChatGifCell : ZZChatBaseCell
@property (nonatomic, strong) ZZCustomChatImage *imgView;

@property (nonatomic, strong) UIImageView *imgGifView;

@property (nonatomic, strong) ZZChatBaseModel *imgChatModel;
/**
 定时器结束刷新最后的结果
 */
- (void)updateGifGame:(ZZChatBaseModel *)updateModel;
@end
