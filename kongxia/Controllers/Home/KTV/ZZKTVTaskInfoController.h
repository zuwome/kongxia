//
//  ZZKTVTaskInfoController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
@class ZZKTVDetailsModel;
@class ZZKTVModel;
@interface ZZKTVTaskInfoController : ZZViewController

@property (nonatomic, strong) ZZKTVDetailsModel *taskDetailsModel;

- (instancetype)initWithTaskModel:(ZZKTVModel *)model;


@end

