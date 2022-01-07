//
//  ZZSnatchReceiveModel.h
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ZZSnatchModel.h"

@interface ZZSnatchReceiveModel : JSONModel

@property (nonatomic, strong) ZZSnatchModel *pd_receive;
@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, copy) NSString *distance;//线下单距离

+ (void)getMySantchReceiveList:(NSDictionary *)param next:(requestCallback)next;

@end
