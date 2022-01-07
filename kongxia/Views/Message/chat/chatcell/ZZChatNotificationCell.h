//
//  ZZChatNotificationCell.h
//  zuwome
//
//  Created by angBiu on 16/10/9.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChatTimeView.h"
#import "ZZChatBaseModel.h"
#import "TTTAttributedLabel.h"
/**
 *  聊天 --- 系统通知 cell
 */
@interface ZZChatNotificationCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (nonatomic, strong) ZZChatTimeView *timeView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) ZZChatBaseModel *dataModel;

// 举报
@property (nonatomic, copy) dispatch_block_t touchReport;

// 黑名单？？
@property (nonatomic, copy) dispatch_block_t touchAddBlack;

// 微信第三方举报
@property (nonatomic, copy) dispatch_block_t touchThirdReport;

// 红包
@property (nonatomic, copy) dispatch_block_t touchSendPacket;

// 联系客服
@property (nonatomic, copy) dispatch_block_t touchChatServer;

// 添加微信
@property (nonatomic, copy) dispatch_block_t touchGoAddWeiChat;

// 查看微信
@property (nonatomic, copy) dispatch_block_t touchGoCheckWeChat;

// 查看微信
@property (nonatomic, copy) dispatch_block_t touchGoCheckIncome;

- (void)setData:(ZZChatBaseModel *)model name:(NSString *)name;

@end
