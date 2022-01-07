//
//  ZZRecordTopicTitleView.h
//  zuwome
//
//  Created by angBiu on 2017/5/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTopicModel.h"

@interface ZZRecordTopicTitleView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *labelRedPointView;
@property (nonatomic, strong) ZZTopicGroupModel *selectedModel;

@property (nonatomic, copy) dispatch_block_t tapSelf;
@property (nonatomic,assign) float currentWidth;
@property (nonatomic,assign) BOOL isNoTop;//表示当前没有话题
/**
 删除回调
 */
@property (nonatomic, copy) dispatch_block_t delegateButtionCallback;
@property (nonatomic, strong) UIButton *deleteButton;//删除重选
@property (nonatomic, assign) BOOL isIntroduceVideo;//是否是录制达人介绍视频
@property (nonatomic,assign) BOOL isRecordTypeMemeda;//录制么么哒回答问题视频--YES 带话题No不带话题
@end
