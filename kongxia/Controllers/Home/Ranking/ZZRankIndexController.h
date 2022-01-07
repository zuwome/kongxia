//
//  ZZRankIndexController.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZRankIndexController : ZZViewController

@end



@class ZZRankIndexHeaderView;
@protocol ZZRankIndexHeaderViewDelegate <NSObject>

- (void)header:(ZZRankIndexHeaderView *)header select:(NSInteger)index;

@end

@interface ZZRankIndexHeaderView : UIView

@property (nonatomic, weak) id<ZZRankIndexHeaderViewDelegate> delegate;

- (void)offetSet:(CGFloat)offsetX;

@end
