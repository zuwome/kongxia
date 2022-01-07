//
//  ZZSignInView.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZIntegralModel.h"
/**
 积分签到
 */
@interface ZZSignInView : UIView
@property (nonatomic,strong) ZZIntegralModel *model;
@property (nonatomic,strong) UIImageView *imageView;

/**
 签到的点击事件
 */
@property (nonatomic,strong) dispatch_block_t signInBlock;
- (void)flipAnimation ;
@end
