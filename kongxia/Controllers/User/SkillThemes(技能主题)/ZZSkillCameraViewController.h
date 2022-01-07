//
//  ZZSkillCameraViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZSkillCameraViewController : ZZViewController

@property (nonatomic, copy) void(^photoCallback)(UIImage *image);

@end
