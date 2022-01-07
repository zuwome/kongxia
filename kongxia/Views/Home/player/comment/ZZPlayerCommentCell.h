//
//  ZZPlayerCommentCell.h
//  zuwome
//
//  Created by angBiu on 2016/12/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZCommentModel.h"

@interface ZZPlayerCommentCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ZZCommentModel *dataModel;

@property (nonatomic, copy) dispatch_block_t touchHead;
@property (nonatomic, copy) void(^cellLongPress)(UIView *targetView);

- (void)setData:(ZZCommentModel *)model;

@end
