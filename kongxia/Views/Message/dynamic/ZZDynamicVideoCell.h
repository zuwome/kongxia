//
//  ZZDynamicVideoCell.h
//  zuwome
//
//  Created by angBiu on 2017/2/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFindVideoTimeView.h"
#import "ZZMessageAttentDynamicModel.h"
#import "ZZDynamicVideoCountView.h"

/**
 消息 --- 动态 -- 发布时刻或者回答么么答
 */
@interface ZZDynamicVideoCell : UITableViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UIImageView *typeImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *coverImgView;//封面
@property (nonatomic, strong) ZZFindVideoTimeView *videoTimeView;
@property (nonatomic, strong) UILabel *videoContentLabel;
@property (nonatomic, strong) ZZDynamicVideoCountView *readCountView;
@property (nonatomic, strong) ZZDynamicVideoCountView *commentCountView;
@property (nonatomic, strong) ZZDynamicVideoCountView *zanCountView;

@property (nonatomic, copy) dispatch_block_t touchHead;

- (void)setData:(ZZMessageAttentDynamicModel *)model;

@end
