//
//  ZZPlayerTopicView.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/8.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//播放界面用于显示么么哒话题提问的

#import <UIKit/UIKit.h>
#import "ZZSKModel.h"
#import "TTTAttributedLabel.h"

@interface ZZPlayerTopicView : UIView
@property (nonatomic, strong) ZZMMDModel *mmdModel;
@property (nonatomic, copy) dispatch_block_t touchHead;//点击头像的方法

@end
