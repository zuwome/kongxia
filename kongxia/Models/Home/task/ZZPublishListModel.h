//
//  ZZPublishListModel.h
//  zuwome
//
//  Created by angBiu on 2017/7/25.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZPublishModel.h"

@interface ZZPublishListModel : JSONModel

@property (nonatomic, copy) NSString *distance;
@property (nonatomic, strong) ZZPublishModel *pd_graber;//抢单者

@end
