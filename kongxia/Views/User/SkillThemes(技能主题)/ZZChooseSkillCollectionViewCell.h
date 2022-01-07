//
//  ZZChooseSkillCollectionViewCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/7/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTopic.h"

/**
 *  技能展示Cell
 */
@interface ZZChooseSkillCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ZZTopic *topicData;
- (void)configureData:(ZZSkill *)skill;

@end
