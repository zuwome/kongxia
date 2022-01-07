//
//  ZZGenericGuide.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//通用的h5的引导

#import "ZZWeiChatBaseEvaluation.h"
#import "ZZActivityUrlModel.h"
@interface ZZGenericGuide : ZZWeiChatBaseEvaluation
@property (nonatomic,strong)ZZActivityUrlModel *model;
/**

 */
+ (void)showAlertH5ActiveViewWithModel:(ZZActivityUrlModel *)model viewController:(UIViewController *)viewController;
@end
