//
//  ZZVideoAppraiseVC.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/25.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

/*
 *  1V1 视频评价
 */

@interface ZZVideoAppraiseVC : ZZViewController

@property (nonatomic, copy) NSString *roomId;//评价需要房间id(必传)
@property (nonatomic, copy) NSString *oid;//从订单列表评价，需要传orderId
@property (nonatomic, copy) void (^cancelBlock)(void);//取消返回
@property (nonatomic, copy) void (^commentsSuccessBlock)(void);//评价成功

@end
