//
//  ZZChatLocationCell.h
//  zuwome
//
//  Created by angBiu on 2016/11/16.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBaseCell.h"
#import "ZZCustomChatImage.h"

/**
 *  聊天 ------ 发送位置 cell
 */
@interface ZZChatLocationCell : ZZChatBaseCell

@property (nonatomic, strong) ZZCustomChatImage *imgView;
@property (nonatomic, strong) UIView *titleBgView;
@property (nonatomic, strong) UILabel *localLabel;
@end
