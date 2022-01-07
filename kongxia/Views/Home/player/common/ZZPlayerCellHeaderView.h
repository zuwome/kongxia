//
//  ZZPlayerCellHeaderView.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSKModel.h"
#import "TTTAttributedLabel.h"

//播放的顶部view
@interface ZZPlayerCellHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong) UILabel *readLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) ZZSKModel *skModel;
@property (nonatomic, strong) ZZMMDModel *mmdModel;
@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, copy) dispatch_block_t touchHead;
@property (nonatomic,strong) id topicModel;//话题model;
- (void)setReadLabtitle:(NSString *)readTitleLab andTimeLab:(NSString *)timeLab;

@end
