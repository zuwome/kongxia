//
//  ZZMessageBoxCell.h
//  zuwome
//
//  Created by angBiu on 2017/6/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMessageBoxModel.h"
#import <RongIMLib/RongIMLib.h>
#import <MGSwipeTableCell.h>

@class ZZMessageListCellLocationView;

@interface ZZMessageBoxCell : MGSwipeTableCell <MGSwipeTableCellDelegate>

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *unreadCountLabel;//未读
@property (nonatomic, strong) ZZMessageListCellLocationView *locationView;
@property (nonatomic, strong) MGSwipeButton *blackBtn;

@property (nonatomic, copy) dispatch_block_t touchAddBlock;
@property (nonatomic, copy) dispatch_block_t touchDelete;

- (void)setData:(ZZMessageBoxModel *)model;

@end
