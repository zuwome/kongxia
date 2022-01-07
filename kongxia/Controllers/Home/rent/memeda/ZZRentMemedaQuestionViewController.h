//
//  ZZRentMemedaQuestionViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
@class ZZMemedaQuestionModel;
/**
 *  他人页 随机选择问题
 */
@interface ZZRentMemedaQuestionViewController : ZZViewController

@property (nonatomic, copy) void(^selectCallBack)(ZZMemedaQuestionModel *question);
@property (nonatomic, assign) BOOL isPrivate;

@end
