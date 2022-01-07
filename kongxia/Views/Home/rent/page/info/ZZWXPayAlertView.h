//
//  ZZWXPayAlertView.h
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZWXPayAlertView : UIView

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, weak) UIViewController *ctl;
@property (nonatomic, copy) dispatch_block_t touchChangePhone;
@property (nonatomic, copy) void(^paySuccess)(NSString *channel);
@property (nonatomic, copy) dispatch_block_t rechargeCallBack;//充值

@end
