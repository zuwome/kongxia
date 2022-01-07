//
//  ZZWeiChatEvaluationHeaderCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//微信号评价的底部立即评价

#import <UIKit/UIKit.h>

@interface ZZWeiChatEvaluationHeaderCell : UICollectionReusableView
@property (nonatomic,strong) UIButton *immediateEvaluation;//立即评价
@property (nonatomic, copy) dispatch_block_t immediateEvaluationWXNumber;//微信号评价的点击事件

/**
 举报微信号
 */
@property (nonatomic, copy) dispatch_block_t reportWXNumber;
@end
