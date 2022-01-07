//
//  ZZWeiChatEvaluationManager.h
//  zuwome
//
//  Created by 潘杨 on 2018/2/26.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//微信号评价管理类

#import <Foundation/Foundation.h>
#import "ZZWeiChatEvaluationModel.h"


@interface ZZWeiChatEvaluationManager : NSObject


/**
 查看微信号，用于购买，评价
 
 @param model 传入的微信评价的model
 @param viewController 当前的控制器
 注 *用于显示弹窗的根视图 nil默认为window
 
 @param goToBuyCallBlack 购买成功后的回调
 @param rechargeCallBack 充值成功后的回调
 @param touchChangePhoneCallBlack 更换手机号的回调
 注*以上3个只有购买微信的时候才会回调，评价微信号不会回调
 @param evaluationCallBlack 评价的回调
 注*只有购买过且刚刚评价成功的才有

 */
+ (void)LookWeiChatWithModel:(ZZWeiChatEvaluationModel *)model
         watchViewController:(UIViewController *)viewController
                     goToBuy:(void(^)(BOOL isSuccess,NSString *payType))goToBuyCallBlack
                    recharge:(void(^)(BOOL isRechargeSuccess))rechargeCallBack
            touchChangePhone:(void(^)(void))touchChangePhoneCallBlack
                  evaluation:(void(^)(BOOL goChat))evaluationCallBlack;

@end
