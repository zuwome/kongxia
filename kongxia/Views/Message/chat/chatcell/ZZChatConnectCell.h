//
//  ZZChatConnectCell.h
//  zuwome
//
//  Created by angBiu on 2017/7/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChatBaseModel.h"

@interface ZZChatConnectCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) ZZChatBaseModel *model;

@property (nonatomic, copy) dispatch_block_t touchVideo;
@property (nonatomic, copy) dispatch_block_t touchWX;
@property (nonatomic, copy) dispatch_block_t touchWallet;

- (void)setData:(ZZChatBaseModel *)model;

@end
