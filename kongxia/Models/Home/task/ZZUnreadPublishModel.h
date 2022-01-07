//
//  ZZUnreadPublishModel.h
//  zuwome
//
//  Created by angBiu on 2017/7/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZPublishModel.h"

@interface ZZUnreadPublishModel : JSONModel

@property (nonatomic, assign) BOOL *have_ongoing_pd;
@property (nonatomic, strong) ZZPublishModel *pd;

@end
