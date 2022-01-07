//
//  ZZSchduleEditCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScheduleCellIdentifier @"ScheduleCellIdentifier"

@interface ZZSchduleEditCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL cellSelected;

@end
