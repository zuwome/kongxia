//
//  ZZNewTiXianFootView.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/12.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 提现
 */
@interface ZZNewTiXianFootView : UIView

@property(nonatomic,strong) NSString *userName;


/**
 去提现
 */
@property(nonatomic,copy) void (^goToTixian)(UIButton *sender);


/**
 提现规则
 */
@property(nonatomic,copy) dispatch_block_t goToTixianRule;
/**
 当前提现按钮是否可以点击
 
 @param isEnable <#isEnable description#>
 */
- (void)changeTiXianButtonStateIsEnable:(BOOL) isEnable;
/**
 当前提现按钮是否是微信
 */
- (void)changeTiXianButtonIsWeiXianTiXianType:(BOOL)isWeiXianTiXianType;
@end
