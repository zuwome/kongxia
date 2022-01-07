//
//  ZZChooseTagViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/9/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

/**
 *  选择主题标签
 */
@interface ZZChooseTagViewController : ZZViewController

@property (nonatomic, strong) NSArray *tagsArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, copy) NSString *catalogId;

@property (nonatomic, copy) void(^chooseTagCallback)(NSArray *tags);

@end
