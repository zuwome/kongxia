//
//  ZZWeiChatEvaluationManager.m
//  zuwome
//
//  Created by 潘杨 on 2018/2/26.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZWeiChatEvaluationManager.h"

#import "ZZNotBuyWeiChatAlertView.h"
#import "ZZNotPingJiaWeiChatAlertView.h"
#import "ZZUserDefaultsHelper.h"
#import "ZZWeiChatBadEvaluationReasonModel.h"//测试数据等待服务器给接口
@implementation ZZWeiChatEvaluationManager




/**
 查看微信号
 
 @param model 传入的微信评价的model
 @param viewController 当前的控制器
 注 *用于显示弹窗的根视图 nil默认为window

 @param goToBuyCallBlack 购买成功后的回调
 @param rechargeCallBack 充值成功后的回调
 @param touchChangePhoneCallBlack 更换手机号的回调
 */
+ (void)LookWeiChatWithModel:(ZZWeiChatEvaluationModel *)model
         watchViewController:(UIViewController *)viewController
                     goToBuy:(void(^)(BOOL isSuccess,NSString *payType))goToBuyCallBlack
                    recharge:(void(^)(BOOL isRechargeSuccess))rechargeCallBack
            touchChangePhone:(void(^)(void))touchChangePhoneCallBlack
                  evaluation:(void (^)(BOOL))evaluationCallBlack {
    
    
    
    if (viewController==nil) {
        viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    if (model.type == PaymentTypeIDPhoto) {
        [MobClick event:Event_click_userpage_IDPhoto_check];
    }
    else if (model.type == PaymentTypeWX) {
        [MobClick event:Event_click_userpage_wx_check];
    }
    
    /*没有购买的弹窗*/
    if (model.isBuy==NO) {
        [self viewClicked];
        //正在电话中不允许其他消费
        if ([ZZUtils isConnecting]) {
            return;
        }
        [ZZHUD showWithStatus:@"获取支付信息..."];

        [ZZNotBuyWeiChatAlertView ShowNotBuyWeiChatAlertView:viewController model:model goToBuy:^(BOOL isBuySuccess,NSString *buyType){
           NSLog(@"PY_购买微信号%d",isBuySuccess);
            if (goToBuyCallBlack) {
                goToBuyCallBlack(isBuySuccess,buyType);
            }
        } recharge:^(BOOL isRechargeSuccess) {
            //这个内部已经更新过了就不用再更新了
            NSLog(@"PY_购买微信号充值%d",isRechargeSuccess);
            if (rechargeCallBack) {
                rechargeCallBack(isRechargeSuccess);
            }

        } touchChangePhone:^{
            NSLog(@"PY_购买微信号切换手机号");
            if (touchChangePhoneCallBlack) {
                touchChangePhoneCallBlack();
            }
        }];
    }
     /*购买后的弹窗*/
    else  {
        
        if (model.type == PaymentTypeWX) {
            NSDictionary *dic =  [ZZUserDefaultsHelper objectForDestKey:@"WeiXinPingJia"];
            NSArray *array = dic[@"comment_content"];
            //        NSArray *array = @[@"无法添加",@"不回消息",@"不是本人",@"诈骗",@"微商广告",@"言语粗俗"];
            NSMutableArray *inputArray = [NSMutableArray array];
            for (NSString *str in array) {
                ZZWeiChatBadEvaluationReasonModel *model = [ZZWeiChatBadEvaluationReasonModel new];
                model.reason = str;
                [inputArray addObject:model];
            }
            [ZZNotPingJiaWeiChatAlertView showNotPingJiaWeiChatAlertViewWithViewController:viewController model:model array:inputArray evaluation:evaluationCallBlack];
        }
    }
}

/**
 *  进入页面就要去发送点击进来的请求
 */
+ (void)viewClicked {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!(version && [version isEqualToString:@"3.7.5"])) {
        [ZZRequest method:@"GET" path:@"/api/user/mcoin/recharge/click" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            NSLog(@"224234234");
        }];
    }
}

@end
