//
//  ZZKTVAnonymousCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZKTVAnonymousCell;
@class ZZKTVModel;

@protocol ZZKTVAnonymousCellDelegate <NSObject>

- (void)cell:(ZZKTVAnonymousCell *)cell anonymous:(BOOL)anonymous;

@end

@interface ZZKTVAnonymousCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZKTVAnonymousCellDelegate> delegate;

- (void)configureKTVModel:(ZZKTVModel *)model;

@end


