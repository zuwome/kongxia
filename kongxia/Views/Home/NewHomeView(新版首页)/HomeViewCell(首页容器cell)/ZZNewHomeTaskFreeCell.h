//
//  ZZNewHomeTaskFreeCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZNewHomeTaskFreeCell;

@protocol ZZNewHomeTaskFreeCellDelegate <NSObject>

- (void)cellTaskFree:(ZZNewHomeTaskFreeCell *)cell;

- (void)cellGoPostTaskFree:(ZZNewHomeTaskFreeCell *)cell;

@end

@interface ZZNewHomeTaskFreeCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZNewHomeTaskFreeCellDelegate> delegate;

@property (nonatomic, copy) NSDictionary *activitityDic;

@end
