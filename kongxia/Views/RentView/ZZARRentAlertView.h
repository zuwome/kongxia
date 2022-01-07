//
//  ZZARRentAlertView.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZWeiChatBaseEvaluation.h"

@interface ZZARRentAlertView : ZZWeiChatBaseEvaluation
- (void)showAlertView ;
/**
 确认退款
 */
@property(nonatomic,copy) dispatch_block_t sureBlock;
/**
 联系看看
 */
@property(nonatomic,strong) UIButton *seeButton;
/**
 sure
 */
@property(nonatomic,strong) UIButton *sureButton;
/**
 联系看看
 */
@property(nonatomic,copy) dispatch_block_t seeBlock;

/**
 detailTitle
 */
@property(nonatomic,strong) UILabel *detailTitleLab;
@end
