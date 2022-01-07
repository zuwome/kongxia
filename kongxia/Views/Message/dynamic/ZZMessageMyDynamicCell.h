//
//  ZZMessageMyDynamicCell.h
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
@class ZZMessageDynamicModel;
/**
 *  我的动态cell
 */
@interface ZZMessageMyDynamicCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imgView;//红包或者么么答
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) dispatch_block_t touchHead;
@property (nonatomic, copy) dispatch_block_t touchLinkUrl;

- (void)setData:(ZZMessageDynamicModel *)model;

@end
