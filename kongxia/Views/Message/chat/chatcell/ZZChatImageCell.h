//
//  ZZChatImageCell.h
//  zuwome
//
//  Created by angBiu on 16/10/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBaseCell.h"
#import "ZZCustomChatImage.h"
/**
 *  聊天--- 图片
 */
@interface ZZChatImageCell : ZZChatBaseCell

@property (nonatomic, strong) ZZCustomChatImage *imgView;

@property (nonatomic, assign) int process;

@end
