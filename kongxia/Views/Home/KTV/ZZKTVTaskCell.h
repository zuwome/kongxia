//
//  ZZKTVTaskCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZKTVTaskCell;
@protocol ZZKTVTaskCellDelegate<NSObject>

- (void)cell:(ZZKTVTaskCell *)cell showDetails:(ZZKTVModel *)songModel;

- (void)cell:(ZZKTVTaskCell *)cell showUserInfo:(ZZUser *)userInfo;

@end

@interface ZZKTVTaskCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZKTVTaskCellDelegate> delegate;

@property (nonatomic, strong) ZZKTVModel *model;

@end

