//
//  ZZNotPingJiaWeiChatAlertView.h
//  zuwome
//
//  Created by 潘杨 on 2018/2/26.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//购买微信号   没有评价  和已经评价过的

#import "ZZWeiChatBaseEvaluation.h"

@interface ZZNotPingJiaWeiChatAlertView : ZZWeiChatBaseEvaluation


/**
 购买微信号后的弹窗
 @param viewController 要弹出的界面
 @param curentLookModel 微信号评价的model
 @param badEvaluationReasonArray 微信号差评的原因
 @param evaluationCallBlack  评价成功的回调
 */
+ (void)showNotPingJiaWeiChatAlertViewWithViewController:(UIViewController *)viewController model:(ZZWeiChatEvaluationModel*)curentLookModel array:(NSMutableArray *)badEvaluationReasonArray evaluation:(void(^)(BOOL goChat))evaluationCallBlack;


@end
