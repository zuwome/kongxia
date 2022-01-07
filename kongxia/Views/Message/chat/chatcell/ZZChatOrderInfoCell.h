//
//  ZZChatOrderInfoCell.h
//  zuwome
//
//  Created by angBiu on 2016/11/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIResponder+ZZRouter.h"
#import "ZZChatConst.h"
#import "ZZChatTimeView.h"
#import "ZZChatBaseModel.h"

/**
 *  聊天----订单状态cell
 */
@interface ZZChatOrderInfoCell : UITableViewCell

@property (nonatomic, strong) ZZChatTimeView *timeView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setData:(ZZChatBaseModel *)model;

@end
