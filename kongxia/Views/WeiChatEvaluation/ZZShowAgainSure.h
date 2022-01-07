//
//  ZZShowAgainSure.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZWeiChatBaseEvaluation.h"

@interface ZZShowAgainSure : ZZWeiChatBaseEvaluation


/**
确认


@param sureButtonCallBlack 确认的回调
@param immediatelyButtonCallBlack 立刻联系的回调
@param cancelButtonCallBlack 取消的回调
*/
+(void)showAgainSureAlertViewSureButton:(void(^)(void))sureButtonCallBlack immediatelyButton:(void(^)(void))immediatelyButtonCallBlack  cancelButton:(void(^)(void))cancelButtonCallBlack;
@end
