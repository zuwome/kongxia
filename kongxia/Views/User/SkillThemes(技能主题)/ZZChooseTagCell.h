//
//  ZZChooseTagCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/9/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ChooseTagCellId @"ChooseTagCellId"

@interface ZZChooseTagCell : UICollectionViewCell

@property (nonatomic, strong) ZZSkillTag *tags;     //跟UIView.tag冲突，改为tags
@property (nonatomic ,assign) BOOL cellSelected;

@end
