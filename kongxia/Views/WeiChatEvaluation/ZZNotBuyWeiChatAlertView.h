//
//  ZZNotBuyWeiChatAlertView.h
//  zuwome
//
//  Created by 潘杨 on 2018/2/26.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//没有购买微信号的弹窗

#import "ZZWeiChatBaseEvaluation.h"

@interface ZZNotBuyWeiChatAlertView : ZZWeiChatBaseEvaluation


/**
 购买微信号的弹窗

 @param view 在展示弹窗的view
 @param curentmodel 微信号评价专用model
 @param goToBuyCallBlack 购买微信号的弹窗 yes 购买成功
 @param rechargeCallBack 充值的回调 yes
 @param touchChangePhoneCallBlack 更改手机号的回调
 */
+ (void)ShowNotBuyWeiChatAlertView:(UIViewController *)viewController  model:(ZZWeiChatEvaluationModel*)curentmodel goToBuy:(void(^)(BOOL isSuccess,NSString *payType))goToBuyCallBlack recharge:(void(^)(BOOL isRechargeSuccess))rechargeCallBack touchChangePhone:(void(^)(void))touchChangePhoneCallBlack;
@end

@interface ShowAssistanceView: UIView


@end
