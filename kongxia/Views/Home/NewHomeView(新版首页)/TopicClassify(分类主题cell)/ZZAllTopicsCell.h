//
//  ZZAllTopicsCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/10/10.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHomeModel.h"

#define AllTopicsCellId @"AllTopicsCellId"

NS_ASSUME_NONNULL_BEGIN

@interface ZZAllTopicsCell : UITableViewCell

@property (nonatomic) ZZHomeCatalogModel *catalog;

- (void)configureData:(ZZSkill *)skill;

@end

NS_ASSUME_NONNULL_END
