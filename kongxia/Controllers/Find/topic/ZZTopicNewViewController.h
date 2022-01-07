//
//  ZZTopicNewViewController.h
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRentTypeBaseViewController.h"
#import "ZZTopicModel.h"

@interface ZZTopicNewViewController : ZZRentTypeBaseViewController

@property (nonatomic, strong) ZZTopicGroupModel *groupModel;

- (void)updateHeadHeight;

@end
