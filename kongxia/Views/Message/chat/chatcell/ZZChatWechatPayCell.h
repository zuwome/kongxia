//
//  ZZChatWechatPayCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIResponder+ZZRouter.h"
#import "ZZChatConst.h"
#import "ZZChatTimeView.h"
#import "ZZChatBaseModel.h"
/**
 聊天 --- 微信号评价
 */
@interface ZZChatWechatPayCell : UITableViewCell

@property (nonatomic, strong) ZZChatTimeView *timeView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleCustomLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) UIImageView *iconImageView;

- (void)setData:(ZZChatBaseModel *)model;
@end
