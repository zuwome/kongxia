//
//  ZZMessageCommentCell.h
//  zuwome
//
//  Created by angBiu on 16/9/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
@class ZZMessageCommentModel;

@interface ZZMessageCommentCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) TTTAttributedLabel *commentLabel;
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, copy) dispatch_block_t touchHead;
@property (nonatomic, copy) dispatch_block_t touchNickname;
@property (nonatomic, copy) dispatch_block_t touchComment;

- (void)setData:(ZZMessageCommentModel *)model;

@end
