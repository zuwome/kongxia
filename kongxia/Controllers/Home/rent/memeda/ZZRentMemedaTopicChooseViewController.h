//
//  ZZRentMemedaTopicChooseViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
@class ZZMemedaTopicModel;
/**
 *  他人么么答页 选择标签
 */
@interface ZZRentMemedaTopicChooseViewController : ZZViewController

@property (nonatomic, copy) void(^selectCallBack)(ZZMemedaTopicModel *topic);

@end
