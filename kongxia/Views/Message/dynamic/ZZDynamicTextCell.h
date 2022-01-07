//
//  ZZDynamicTextCell.h
//  zuwome
//
//  Created by angBiu on 2017/2/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMessageAttentDynamicModel.h"
#import "ZZDynamicRecomendView.h"

/**
 消息 ---- 动态 --- 文本内容
 */
@interface ZZDynamicTextCell : UITableViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UIImageView *typeImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) ZZDynamicRecomendView *recommendView;

@property (nonatomic, copy) dispatch_block_t touchHead;

- (void)setData:(ZZMessageAttentDynamicModel *)model;

@end
