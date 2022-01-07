//
//  ZZFalsePhoneAlertView.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//虚假电话

#import "ZZWeiChatBaseEvaluation.h"

@interface ZZFalsePhoneAlertViewGuide : ZZWeiChatBaseEvaluation


/**
 当第一次点击虚假进行拨打的时候弹出
 */

+ (void)showAlertViewGuideViewWhenFirstIntoSureBack:(void(^)(void))sureButtonCallBack;
@end
