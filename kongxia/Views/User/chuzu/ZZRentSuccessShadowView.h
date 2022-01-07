//
//  ZZRentSuccessShadowView.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/7.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 出租成功的投影view
 */
@interface ZZRentSuccessShadowView : UIView
/**
 更多提示,要缓存的如果服务器没有返回的话是要有显示的数据的
 */
@property (nonatomic,strong) UILabel *morePromptLab;

/**
 闪租说明
 */
@property (nonatomic,strong) UILabel *instructionsLab;

/**
 抢任务开关
 */
@property (nonatomic, strong) UISwitch *openSwitch;


/**
 提交申请
 */
@property(nonatomic,copy) dispatch_block_t sureCallBlock;

@end
