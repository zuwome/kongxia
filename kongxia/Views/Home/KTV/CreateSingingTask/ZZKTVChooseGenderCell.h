//
//  ZZKTVChooseGenderCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
@class ZZKTVModel;
@class ZZKTVChooseGenderCell;
@protocol ZZKTVChooseGenderCellDelegate <NSObject>

- (void)cell:(ZZKTVChooseGenderCell *)cell chooseGender:(NSInteger)gender;

@end

@interface ZZKTVChooseGenderCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZKTVChooseGenderCellDelegate> delegate;

- (void)configureKTVModel:(ZZKTVModel *)model;

@end

