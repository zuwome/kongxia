//
//  ZZMessageListCell.h
//  zuwome
//
//  Created by angBiu on 16/7/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZUserInfoModel.h"

@class ZZMessageListCellLocationView;
@class RCConversation;
@class ZZMessageListCellLocationView;
@class ZZUserInfoModel;
/**
 *  聊天列表 cell
 */
@interface ZZMessageListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic,strong)  UIImageView *imagePivChatView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *unreadCountLabel;//未读
@property (nonatomic, strong) ZZMessageListCellLocationView *locationView;

- (void)setData:(RCConversation *)model userInfo:(ZZUserInfoModel *)userInfo;

@end

