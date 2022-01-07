//
//  ZZTaskCancelConfirmAlert.h
//  zuwome
//
//  Created by angBiu on 2017/8/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 发布任务取消 --- 确认弹窗
 */
@interface ZZTaskCancelConfirmAlert : UIView

@property (nonatomic, copy) dispatch_block_t touchCancel;

@end
