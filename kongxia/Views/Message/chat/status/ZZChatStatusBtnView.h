//
//  ZZChatStatusBtnView.h
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZOrder.h"
/**
 *  聊天顶部状态 ---- 提示动作的按钮（eg：再次提醒）
 */
@interface ZZChatStatusBtnView : UIView

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) dispatch_block_t touchStatusBtn;

- (void)setData:(ZZOrder *)order detaiType:(OrderDetailType)type;

@end
