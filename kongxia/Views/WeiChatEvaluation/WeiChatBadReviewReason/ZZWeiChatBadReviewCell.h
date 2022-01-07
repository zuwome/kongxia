//
//  ZZWeiChatBadReviewCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
// 微信号差评理由的cell

#import <UIKit/UIKit.h>
#import "ZZWeiChatBadEvaluationReasonModel.h"
@interface ZZWeiChatBadReviewCell : UICollectionViewCell
@property (nonatomic,strong) ZZWeiChatBadEvaluationReasonModel *model;
@property (nonatomic,assign) BOOL isSelectEvaluation;//当前评价是否选中
@end
