//
//  ZZOrderLiveStreamDetailVC.h
//  zuwome
//
//  Created by YuTianLong on 2017/9/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

// 1V1 视频订单详情

@interface ZZOrderLiveStreamDetailVC : ZZViewController

@property (nonatomic, copy) NSString *orderId;
@property (assign, nonatomic) BOOL isFromChat;//是否从聊天界面过来
@property (nonatomic, copy) void (^updateListBlock)(void);

@end
