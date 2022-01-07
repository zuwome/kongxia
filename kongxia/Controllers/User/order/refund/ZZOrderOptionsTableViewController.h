//
//  ZZOrderOptionsTableViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/30.
//  Copyright © 2016年 zz. All rights reserved.
//

typedef NS_ENUM(NSInteger,OptionType) {
    OptionTypeRefuse = 0,           //拒绝
    OptionTypeCancel               //取消
};

#import "ZZViewController.h"
#import "ZZOrder.h"

@interface ZZOrderOptionsTableViewController : ZZViewController

@property (strong, nonatomic) ZZOrder *order;
@property (assign, nonatomic) OptionType type;
@property (assign, nonatomic) BOOL isFrom;
@property (nonatomic, copy) void(^callBack)(NSString *status);

@end
