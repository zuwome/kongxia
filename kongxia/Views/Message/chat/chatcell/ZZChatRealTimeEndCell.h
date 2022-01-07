//
//  ZZChatRealTimeEndCell.h
//  zuwome
//
//  Created by angBiu on 2016/11/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBaseCell.h"
#import "ZZChatTimeView.h"
#import "ZZChatBaseModel.h"
/**
 *  聊天------实时定位结束cell
 */
@interface ZZChatRealTimeEndCell : UITableViewCell

@property (nonatomic, strong) ZZChatTimeView *timeView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setData:(ZZChatBaseModel *)model;

@end
