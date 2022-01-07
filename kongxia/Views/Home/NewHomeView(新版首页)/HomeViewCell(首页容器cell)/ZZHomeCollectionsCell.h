//
//  ZZHomeCollectionsCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/5/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZNewHomeBaseCell.h"
#import "kongxia-Swift.h"

@protocol ZZHomeCollectionsCellDelegate <NSObject>

- (void)showVideoChat;

- (void)showTasks;

- (void)showRanks;

@end

@interface ZZHomeCollectionsCell : ZZNewHomeBaseCell

@property (nonatomic, weak) id<ZZHomeCollectionsCellDelegate> delegate;

- (void)configureTopThree:(ZZRankResponeModel *)rankResponeModel;

@end

