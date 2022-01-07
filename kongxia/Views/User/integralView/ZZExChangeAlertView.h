//
//  ZZExChangeAlertView.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/22.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZWeiChatBaseEvaluation.h"
#import "ZZIntegralExChangeModel.h"
/**
 积分兑换么币的确认弹窗
 */
@interface ZZExChangeAlertView : ZZWeiChatBaseEvaluation



@property (nonatomic,copy)   void(^exChangeBlock)(int exChangeNumber,UIButton *sender);

- (void)showAlerViewwithModel:(ZZIntegralExChangeModel *)model;
@end
